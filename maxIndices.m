function [north east up bias] = maxIndices(CC)

% This function returns the indices of the maxima in the 4-D correlogram.

% Size of collective correlogram:
s = size(CC);

% Find the maximum:
m = max(CC(:));

% Find the index of maxima:
p = find(CC(:) == m);

% Convert this index to index in matrix:
[north east up bias] = ind2sub(s, p);
