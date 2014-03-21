function [newEstimate] = genNewEstimate(Lat, Long, Ht, clkBias, txTime, uncertaintyNE, uncertaintyU, uncertaintyB)

% This function returns a struct with information provided apriori.

% Latitude:
newEstimate.lat = Lat;

% Longitude:
newEstimate.long = Long;

% Height:
newEstimate.ht = Ht;

% Convert to northing, easting and up:
[newEstimate.E newEstimate.N] = deg2utm(newEstimate.lat, newEstimate.long);
newEstimate.U = newEstimate.ht;

% Clock bias estimate should be zero initially, because we have no idea about it:
newEstimate.clockBias = clkBias;

% Uncertainty in rough estimate:
newEstimate.uncertaintyU = uncertaintyU;
newEstimate.uncertaintyE = uncertaintyNE;
newEstimate.uncertaintyN = uncertaintyNE;
newEstimate.uncertaintyClockBias = uncertaintyB;

% Step size in all four dimensions:
newEstimate.stepN = newEstimate.uncertaintyN/10;
newEstimate.stepE = newEstimate.uncertaintyE/10;
newEstimate.stepU = 1;
newEstimate.stepB = 150;
newEstimate.stepT = 0.125;

% Rough estimate of the transmit time:
newEstimate.T = txTime;
newEstimate.uncertaintyT = 0.5;

newEstimate.correlatorThreshold = 0.5e6;