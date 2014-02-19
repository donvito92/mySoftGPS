function [deltaN deltaE] = myPosError(CC, north, east, stepN, stepE)

% This function calculates the error of position calculated. It is 
% assumed that the centre of search space is the correct position 
% solution.

% Indices of the centre of search space:
refN = (size(CC, 1) + 1) / 2;
refE = (size(CC, 2) + 1) / 2;

% Difference between centre of search space and maxima:
deltaN = refN - north;
deltaE = refE - east;

% Distance as measured in metres:
deltaN = abs(deltaN) * stepN;
deltaE = abs(deltaE) * stepE;
