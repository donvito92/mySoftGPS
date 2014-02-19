% Run this script to get things rolling.
close all
clear
clc
% Initialize all the settings, data and other variables:
% Press 1 if you intend to run the receiver, 0 if you ran this
% script by mistake.
init;

% Extract the ephemeris from file:
[eph] = GSNRxEphemeris('GSNRx.EPH', acquiredSvs);

% Calculate the position of all acquired satellites using the
% ephemeris. Need to set settings.transmitTime in initSettings.m:
[satPositions, satClkCorr] = mySatPos(eph, settings);

% Provide the information required apriori:
[roughEstimate] = myAiding();

goAhead = input('Enter "1" to start collective detection, might take a long time : ');

if goAhead == 1
    
    % Run the all important collective detection algorithm, change the function name for different algorithms:
    % Need to set the step size in order N E U B:
    [CC count] = modeCollectiveDetection(roughEstimate, satPositions, satClkCorr, results, eph, settings, acqResults);
    % Display the total number of iterations:
    count

    % Find the indices of the maxima in the collective correlogram:
    [north east up bias] = maxIndices(CC);

    % Calculate the error of the obtained position from correct position:
    [deltaN deltaE] = myPosError(CC, north, east, roughEstimate.stepN, roughEstimate.stepE);
    % Display the error:
    deltaN
    deltaE

    % Calculate the confidence of the solution:
    [confidenceMetric] = myConfidence(CC, north, east, up, bias);
    % Display the confidence:
    confidenceMetric

    % Plot the correlograms for the north and east search domain:
    plotNE;
    
end
