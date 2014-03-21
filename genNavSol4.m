% Run the all important collective detection algorithm, change the function name for different algorithms:
% Need to set the step size in order N E U B:
[CC count] = medianCollectiveDetection(newEstimate, satPositions, satClkCorr, results, eph, settings, acqResults);
% Display the total number of iterations:
count

% Find the indices of the maxima in the collective correlogram:
[north east up bias] = maxIndices(CC, newEstimate);

if north + east + up + bias ~= 0
    
    txTime = newEstimate.T;
    clkBias = newEstimate.clockBias - newEstimate.uncertaintyClockBias + (bias - 1) * newEstimate.stepB;

    % Calculate the error of the obtained position from correct position:
    [deltaN deltaE] = myPosError(CC, north, east, newEstimate.stepN, newEstimate.stepE);
    % Display the error:
    deltaN
    deltaE

    [Lat Long] = utm2deg(newEstimate.E - deltaE, newEstimate.N - deltaN, '12 U')

    % Calculate the confidence of the solution:
    [confidenceMetric] = newConfidence(CC, north, east, up, bias, 85);
    % Display the confidence:
    confidenceMetric

    % Plot the correlograms for the north and east search domain:
    plotNE;

else

    display('Solution could not be computed');

end