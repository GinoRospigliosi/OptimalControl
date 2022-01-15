% nearestNeighbor.m
%
% Given a vector of real numbers and a scalar, this function outputs the
% index of that vector element that is closest in value to the scalar. 
%
% HKF, 9.16.2011

function neighborIndex = nearestNeighbor(xVector,xValue)

distanceValues = zeros(length(xVector),1);

for i=1:length(xVector)
    distanceValues(i) = (xVector(i)-xValue)^2;
end;
[nearestDistance neighborIndex] = min(distanceValues);