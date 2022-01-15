% zeroOrderMarkovSim.m
% Simulates a "zero-order" Markov chain one time step ahead, given the
% raw/measured random data and the CDF representing the Markov chain. Also
% computes the residual of this fit. 
% Last edit: HKF, 10.14.2011

function [markovFit,residual]=zeroOrderMarkovSim(rawData,CDFCenterPoints, CDF)

% Begin by creating zero vectors for the Markov fit and the residuals
markovFit = zeros(length(rawData),1);
residual = zeros(length(rawData),1);

% Now perform one step-ahead simulation
for i=1:length(rawData)
    uniformRandomNumber = rand(1);
    CDFIndex = nearestNeighbor(CDF,uniformRandomNumber);
    markovFit(i) = CDFCenterPoints(CDFIndex);
    residual(i) = markovFit(i)-rawData(i);
end;