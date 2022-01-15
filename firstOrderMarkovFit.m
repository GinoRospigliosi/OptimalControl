% firstOrderMarkovFit.m
% Provides a first-order fit to random data by just creating a Markov
% transition probability table from the data, for defined center points of
% the rows and columns of this table. 
% Last edit: HKF, 10.14.2011

function [markovTransitionTable,markovCumulativeTransitionTable] = firstOrderMarkovFit(randomData,markovTableCenterPoints)

% Initialize both tables to zero
markovTransitionTable = zeros(length(markovTableCenterPoints),length(markovTableCenterPoints));
markovCumulativeTransitionTable = zeros(length(markovTableCenterPoints),length(markovTableCenterPoints));

% Begin by parsing through the data and filling up the Markov transition
% table

for i=1:(length(randomData)-1)
    currentDataIndex = nearestNeighbor(markovTableCenterPoints,randomData(i));
    nextDataIndex = nearestNeighbor(markovTableCenterPoints,randomData(i+1));
    markovTransitionTable(currentDataIndex,nextDataIndex) = markovTransitionTable(currentDataIndex,nextDataIndex)+1;
end;

% Now normalize each column of the Markov transition table

for i=1:length(markovTableCenterPoints)
    markovTransitionTable(i,:) = markovTransitionTable(i,:)/sum(markovTransitionTable(i,:));
end;

% Finally, create the cumulative Marjov transition table
markovCumulativeTransitionTable(:,1) = markovTransitionTable(:,1);
for currentDataIndex = 1:length(markovTableCenterPoints)
    for nextDataIndex = 2:length(markovTableCenterPoints)
        markovCumulativeTransitionTable(currentDataIndex,nextDataIndex) = markovCumulativeTransitionTable(currentDataIndex,nextDataIndex-1)+markovTransitionTable(currentDataIndex,nextDataIndex);
    end;
end;