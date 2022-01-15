% GeneratePowerDemandHistory.m
% Generates power demand history for SDP example. 
% Last edit: HKAF, 10.26.2012

clear all
clc

demandHistory = zeros(1,1000);
demandHistory(1) = 1;

for i=2:1000
    if demandHistory(i-1)<0.5
        selector = rand(1);
        if selector < 0.1
            demandHistory(i) = 0;
        else if selector < 0.9
                demandHistory(i) = 1;
            else if selector <0.95
                    demandHistory(i) = 2;
                else
                    demandHistory(i) = 3;
                end;
            end;
        end;
    else if demandHistory(i-1)<1.5
            selector = rand(1);
            if selector < 0.05
                demandHistory(i) = 0;
            else if selector < 0.85
                    demandHistory(i) = 1;
                else if selector < 0.95
                        demandHistory(i) = 2;
                    else
                        demandHistory(i) = 3;
                    end;
                end;
            end;
        else if demandHistory(i-1)<2.5
                selector = rand(1);
                if selector < 0.05
                    demandHistory(i) = 0;
                else if selector < 0.15
                        demandHistory(i) = 1;
                    else if selector < 0.95
                            demandHistory(i) = 2;
                        else
                            demandHistory(i) = 3;
                        end;
                    end;
                end;
            else
                selector = rand(1);
                if selector < 0.05
                    demandHistory(i) = 0;
                else if selector < 0.1
                        demandHistory(i) = 1;
                    else if selector < 0.9
                            demandHistory(i) = 2;
                        else
                            demandHistory(i) = 3;
                        end;
                    end;
                end;
            end;
        end;
    end;
end;

plot(1:1:1000,demandHistory);

save('powerDemandHistory','demandHistory');