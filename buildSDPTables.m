% buildSDPTables.m
% Builds the Markov transition tables and transition cost tables for the
% SDP example. 
% Last edit: HKAF, 11.4.2012

function [markovTransitionTables,transitionCostTables] = buildSDPTables(powerTransitionMarkovTable)

% Begin by defining a few relevant constants

eSalePrice = 100;           % Fixed sale price of electricity, $/MWh
eGenerationCost = 50;       % Fixed generation cost, $/MWh
eFailToDeliverPenalty = 10000;% Penalty for failure to deliver, $/MWh
mcRunningCost = 20;         % Machine running cost, $/hour (per machine)
mcStartupCost = 1000;       % Machine startup cost, $
mcRepairCost = 10000;       % Machine repair cost, $

failureLikelihoodTable = [0 0 0 0;1 1 1 99;1 1 1 1]/100;
                            % Likelihood of single-machine failure, as a
                            % function of number of running machines (0, 1,
                            % or 2), and total power demand (0, 1, 2 or
                            % 3MW). Two-machine failures are assumed to
                            % have zero likelihood for simplicity. 
                           
numberOfFailedMachinesList = [zeros(1,12),ones(1,8),2*ones(1,4)]';  
numberOfRunningMachinesList = [zeros(1,4),ones(1,4),2*ones(1,4),zeros(1,4),ones(1,4),zeros(1,4)]';
powerDemandShortList = [0;1;2;3];
powerDemandList = [powerDemandShortList;powerDemandShortList;powerDemandShortList;powerDemandShortList;powerDemandShortList;powerDemandShortList];
stateIndexList = (1:1:24)';

nStates = 24;

controlActionList = [-1;0;1];

markovTransitionTables = zeros(3,24,24);
transitionCostTables = 1e8*ones(3,24,24);

% Next, go through every possible value of the input and every possible
% state and calculate the transition cost table entries and transition
% probability table entries

for controlIndex = 1:3
    controlAction = controlActionList(controlIndex);
    for stateIndex = 1:24
        numberOfFailedMachines = numberOfFailedMachinesList(stateIndex);
        numberOfRunningMachines = numberOfRunningMachinesList(stateIndex);
        powerDemand = powerDemandList(stateIndex);
        if powerDemand<0.5
            powerDemandIndex = 1;
        else if powerDemand<1.5
                powerDemandIndex = 2;
            else if powerDemand<2.5
                    powerDemandIndex = 3;
                else 
                    powerDemandIndex = 4;
                end;
            end;
        end;
        maxPowerDelivery = numberOfRunningMachines * 3; 
        if powerDemand<=maxPowerDelivery
            electricitySales = powerDemand*eSalePrice;
            generationCost = powerDemand*eGenerationCost;
            electricityPenalty = 0;
        else
            electricitySales = maxPowerDelivery*eSalePrice;
            generationCost = maxPowerDelivery*eGenerationCost;
            electricityPenalty = (powerDemand-maxPowerDelivery)*eFailToDeliverPenalty;
        end;
        spinningCost = mcRunningCost*numberOfRunningMachines;
        repairCost = mcRepairCost*numberOfFailedMachines;
        startupCost = 0;
        nominalChangeinRunningMachines = 0;
        if controlAction > 0
            if numberOfRunningMachines < 2
                startupCost = mcStartupCost; 
                nominalChangeinRunningMachines = 1;
            end;
        end;
        if controlAction<0
            if numberOfRunningMachines > 0;
                nominalChangeinRunningMachines = -1;
            end;
        end;
        if numberOfRunningMachines<0.5
            highFailureLimit = 0;
            lowFailureLimit = 0;
            failureProbability = 0;
        else if numberOfRunningMachines<1.5
                highFailureLimit = 1;
                lowFailureLimit = 0;
            else
                highFailureLimit = 1;
                lowFailureLimit = 0;
            end;
        end;
        highFailureLimitProbability = failureLikelihoodTable(numberOfRunningMachines+1,controlIndex);
        nominalNewNumberOfRunningMachines = numberOfRunningMachines+nominalChangeinRunningMachines;
        nominalNewNumberOfFailedMachines = 0;
        for newPowerDemandIndex = 1:4
            newPowerDemand = powerDemandShortList(newPowerDemandIndex);
            newNumberOfRunningMachines = nominalNewNumberOfRunningMachines-lowFailureLimit;
            newNumberOfFailedMachines = lowFailureLimit;
            if newNumberOfRunningMachines < 0.5
                if newPowerDemand < 0.5
                    newStateIndex = 1;
                else if newPowerDemand < 1.5
                        newStateIndex = 2;
                    else if newPowerDemand < 2.5
                            newStateIndex = 3;
                        else 
                            newStateIndex = 4;
                        end;
                    end;
                end;
            else if newNumberOfRunningMachines < 1.5
                    if newPowerDemand < 0.5
                        newStateIndex = 5;
                    else if newPowerDemand < 1.5
                            newStateIndex = 6;
                        else if newPowerDemand < 2.5
                                newStateIndex = 7;
                            else
                                newStateIndex = 8;
                            end;
                        end;
                    end;
                else
                    if newPowerDemand < 0.5
                        newStateIndex = 9;
                    else if newPowerDemand < 1.5
                            newStateIndex = 10;
                        else if newPowerDemand < 2.5
                                newStateIndex = 11;
                            else
                                newStateIndex = 12; 
                            end;
                        end;
                    end;
                end;
            end;
            markovTransitionTables(controlIndex,newStateIndex,stateIndex) = (1-highFailureLimitProbability)*(powerTransitionMarkovTable(newPowerDemandIndex,powerDemandIndex));
            transitionCostTables(controlIndex,newStateIndex,stateIndex) = generationCost+electricityPenalty+spinningCost+repairCost+startupCost-electricitySales;
            if highFailureLimit > 0.5
                newNumberOfRunningMachines = nominalNewNumberOfRunningMachines-highFailureLimit;
                newNumberOfFailedMachines = highFailureLimit;
                if newNumberOfRunningMachines < 0.5
                    if newPowerDemand < 0.5
                        newStateIndex = 13;
                    else if newPowerDemand < 1.5;
                            newStateIndex = 14;
                        else if newPowerDemand < 2.5
                                newStateIndex = 15;
                            else
                                newStateIndex = 16;
                            end;
                        end;
                    end;
                else
                    if newPowerDemand < 0.5
                        newStateIndex = 17;
                    else if newPowerDemand < 1.5
                            newStateIndex = 18;
                        else if newPowerDemand < 2.5
                                newStateIndex = 19;
                            else
                                newStateIndex = 20;
                            end;
                        end;
                    end;
                end;
                markovTransitionTables(controlIndex,newStateIndex,stateIndex) = highFailureLimitProbability*(powerTransitionMarkovTable(newPowerDemandIndex,powerDemandIndex));
                transitionCostTables(controlIndex,newStateIndex,stateIndex) = generationCost+electricityPenalty+spinningCost+repairCost+startupCost-electricitySales;
            end;
        end;
    end;
end;
