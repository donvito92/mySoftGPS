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
roughEstimate.uncertaintyE = 250;
roughEstimate.uncertaintyN = 250;
roughEstimate.uncertaintyClockBias = 150000;

% Step size in all four dimensions:
roughEstimate.stepN = 25;
roughEstimate.stepE = 25;
roughEstimate.stepU = 1;
roughEstimate.stepB = 150;