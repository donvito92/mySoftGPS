function [north east up bias coarseTime] = maxIndicesCoarseTime(CC, roughEstimate)

% This function returns the indices of the maxima in the 5-D correlogram.

% Size of collective correlogram:
s = size(CC);

% Find the maximum:
m = max(CC(:));

% Find the index of maxima:
p = find(CC(:) == m);

% Convert this index to index in matrix:
[north east up bias coarseTime] = ind2sub(s, p);

% Threshold the correlator value to avoid false positives:
if m < roughEstimate.correlatorThreshold
    north = 0;
    east = 0;
    up = 0;
    bias = 0;
    coarseTime = 0;
end