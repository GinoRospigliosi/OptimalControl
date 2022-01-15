% postProcess.m
% Post-processes the optimal control policy from the generator dispatch
% problem. 
% Last edit: HKAF, 11.4.2012

function postProcess(optimalPolicy)

clc
fprintf('Optimal Control Policy\n');
fprintf('# Failed Machines\t # Running Machines\t Power Demand\t Control Action\n');
policyIndex = 0;
for nFailedMachines=0:1:2
    for nRunningMachines = 0:1:(2-nFailedMachines)
        for powerDemand = 0:1:3
            outputString = '';
            policyIndex = policyIndex+1;
            if nFailedMachines < 0.5
                outputString = strcat(outputString,'\t\t0\t\t');
            else if nFailedMachines < 1.5
                    outputString = strcat(outputString,'\t\t1\t\t');
                else 
                    outputString = strcat(outputString,'\t\t2\t\t');
                end;
            end;
            if nRunningMachines < 0.5
                outputString = strcat(outputString,'\t\t\t0\t\t');
            else if nRunningMachines < 1.5
                    outputString = strcat(outputString,'\t\t\t1\t\t');
                else 
                    outputString = strcat(outputString,'\t\t\t2\t\t');
                end;
            end;
            if powerDemand < 0.5
                outputString = strcat(outputString,'\t\t\t0MW\t');
            else if powerDemand < 1.5
                    outputString = strcat(outputString,'\t\t\t1MW\t');
                else if powerDemand < 2.5
                        outputString = strcat(outputString,'\t\t\t2MW\t');
                    else
                        outputString = strcat(outputString,'\t\t\t3MW\t');
                    end;
                end;
            end;
            if optimalPolicy(policyIndex) < 1.5
                outputString = strcat(outputString,'\t\t\tshutdown\n');
            else if optimalPolicy(policyIndex) < 2.5
                   outputString = strcat(outputString,'\t\t\tdo nothing\n');
                else 
                   outputString = strcat(outputString,'\t\t\tstartup\n');
                end;
            end;
            fprintf(outputString);
        end;
    end;
end;
