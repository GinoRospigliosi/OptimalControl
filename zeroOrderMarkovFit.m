% zeroOrderMarkovFit.m
% Provides a zero-order fit to random (in this case, white) data by just
% obtaining a histogram of the data for defined center points of the
% histogram bars. 
% Last edit: HKF, 10.12.2011

function [histogram,CDF] = zeroOrderMarkovFit(randomData,histogramCenterPoints)

% Initialize the histogram to zeros, and initialize the number of data
% points
histogram = zeros(length(histogramCenterPoints),1);
nData = length(randomData);

% Now create the histogram
for i=1:length(randomData)
    histogramIndex = nearestNeighbor(histogramCenterPoints,randomData(i));
    histogram(histogramIndex) = histogram(histogramIndex)+1;
end;

% Finally, scale the histogram to get a probability density function, and
% apply a cumulative sum to the histogram to get a CDF
histogram = histogram/nData;
CDF = histogram;
for i=2:length(CDF)
    CDF(i) = CDF(i-1)+histogram(i);
end;