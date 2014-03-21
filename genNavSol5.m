% Run the all important collective detection algorithm, change the function name for different algorithms:
% Need to set the step size in order N E U B:
[CC count] = myCollectiveDetectionCoarseTime(newEstimate, results, eph, settings, acqResults);
% Display the total number of iterations:
count

% Find the indices of the maxima in the collective correlogram:
[north east up bias coarseTime] = maxIndicesCoarseTime(CC, newEstimate);

if north + east + up + bias + coarseTime ~= 0
    
    txTime = newEstimate.T - newEstimate.uncertaintyT + (coarseTime - 1) * newEstimate.stepT;
    clkBias = newEstimate.clockBias - newEstimate.uncertaintyClockBias + (bias - 1) * newEstimate.stepB;

    % Calculate the error of the obtained position from correct position:
    [deltaN deltaE] = myPosError(CC, north, east, newEstimate.stepN, newEstimate.stepE);
    % Display the error:
    deltaN
    deltaE

    [Lat Long] = utm2deg(newEstimate.E - deltaE, newEstimate.N - deltaN, '12 U')

    % Calculate the confidence of the solution:
    [confidenceMetric] = newConfidenceCoarseTime(CC, north, east, up, bias, coarseTime, 85);
    % Display the confidence:
    confidenceMetric

    % Plot the correlograms for the north and east search domain:
    plotNECoarseTime;

else

    display('Solution could not be computed');

end