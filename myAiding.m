function [roughEstimate] = myAiding()

% This function returns a struct with information provided apriori.

% Latitude:
roughEstimate.lat = 51.005011445;

% Longitude:
roughEstimate.long = -113.991569502;

% Height:
roughEstimate.ht = 1160.224;

% Convert to northing, easting and up:
[roughEstimate.E roughEstimate.N] = deg2utm(roughEstimate.lat, roughEstimate.long);
roughEstimate.U = roughEstimate.ht;

% Clock bias estimate should be zero initially, because we have no idea about it:
roughEstimate.clockBias = 0;

% Uncertainty in rough estimate:
roughEstimate.uncertaintyU = 0;
roughEstimate.uncertaintyE = 10000;
roughEstimate.uncertaintyN = roughEstimate.uncertaintyE;
roughEstimate.uncertaintyClockBias = 150000;

% Step size in all four dimensions:
roughEstimate.stepN = roughEstimate.uncertaintyE/10;
roughEstimate.stepE = roughEstimate.uncertaintyE/10;
roughEstimate.stepU = 1;
roughEstimate.stepB = 150;
roughEstimate.stepT = 0.25;

% Rough estimate of the transmit time:
roughEstimate.T = 259243.0;
roughEstimate.uncertaintyT = 1.0;

roughEstimate.correlatorThreshold = 0.5e6;