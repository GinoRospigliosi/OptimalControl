% firstOrderMarkovSim.m
% Simulates a first-order Markov chain one time step ahead, given the
% raw/measured random data and the Markov transition probability matrix.
% Also computes the residual of this fit. 
% Last edit: HKF, 10.14.2011

function [markovFit,residual]=firstOrderMarkovSim(rawData,MarkovTableCenterPoints,cumulativeMarkovTransitionTable)

% Begin by creating zero vectors for the Markov fit and the residuals.
% Because this is a first-order fit, the first point will match the raw
% data exactly. 
markovFit = zeros(length(rawData),1);
residual = zeros(length(rawData),1);
markovFit(1) = rawData(1);
residual(1) = 0; 

% Now perform one step-ahead simulation
for i=2:length(rawData)
    uniformRandomNumber = rand(1);
    currentDataIndex = nearestNeighbor(MarkovTableCenterPoints,rawData(i-1));
    nextDataIndex = nearestNeighbor(cumulativeMarkovTransitionTable(currentDataIndex,:),uniformRandomNumber);
    markovFit(i) = MarkovTableCenterPoints(nextDataIndex);
    residual(i) = markovFit(i)-rawData(i);
end;