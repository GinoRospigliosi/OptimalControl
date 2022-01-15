% autoCorrelation.m
% Computes the auto-correlation function for a given scalar random process,
% and for an integer number of delays not exceeding maxDelay. 
% Last edit: HKF, 10.10.2011

function [delay,correlation] = autoCorrelation(randomProcess,maxDelay)

% Sanity check 

if maxDelay<=0
    maxDelay = 1;
end;

% Generation of delay vector

delay = 0:1:maxDelay;

% Generation of auto-correlation function

for i=1:length(delay)
    correlation(i) = 0;
    for j=1:(length(randomProcess)-delay(i))
        correlation(i) = correlation(i)+((randomProcess(j))*(randomProcess(j+delay(i))));
    end;
    correlation(i) = correlation(i)/(length(randomProcess)-delay(i));
end;