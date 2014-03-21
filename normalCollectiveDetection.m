function [collectiveCorrelogram count] = normalCollectiveDetection(roughEstimate, satPositions, satClkCorr, results, eph, settings, acqResults)

% Most important function. Returns the collective correlogram. Takes in all the things we have calculated
% thus far, puts them together and spits out what we are looking for.

% Initialize important variables:
collectiveCorrelogram = zeros(2 * (roughEstimate.uncertaintyN / roughEstimate.stepN) + 1, 2 * (roughEstimate.uncertaintyE / roughEstimate.stepE) + 1, ...
                                        2 * (roughEstimate.uncertaintyU / roughEstimate.stepU) + 1, 2 * (roughEstimate.uncertaintyClockBias / roughEstimate.stepB) + 1);

% Initialize iterating variables:                              
indexN = 1;
indexE = 1;
indexU = 1;
indexB = 1;
count = 0;
samplesPerCode = round(settings.samplingFreq / (settings.codeFreqBasis / settings.codeLength));

% Loop over all possible northing positions:
for N = roughEstimate.N - roughEstimate.uncertaintyN : roughEstimate.stepN : roughEstimate.N + roughEstimate.uncertaintyN
    progressN = N - roughEstimate.N

    % Loop over all possible easting positions:
    for E = roughEstimate.E - roughEstimate.uncertaintyE : roughEstimate.stepE : roughEstimate.E + roughEstimate.uncertaintyE
        progressE = E - roughEstimate.E

        % Loop over all possible heights:
        for U = roughEstimate.U - roughEstimate.uncertaintyU : roughEstimate.stepU : roughEstimate.U + roughEstimate.uncertaintyU 
           
            % Loop over all possible clock bias values:
            for B = roughEstimate.clockBias - roughEstimate.uncertaintyClockBias : roughEstimate.stepB : roughEstimate.clockBias + roughEstimate.uncertaintyClockBias
                
                % Finally, loop over all satellites which were acquired:
                for CCPRN = 1 : length(eph.PRN)
                    
                    % Increment the variable for keeping a count of the number of iterations, will be useful for comparison:
                    count = count + 1;
                    
                    % Calculate pseudorange in millisecond:
                    pseudoRangeMS = calculatePseudorangeMS(N, E, U, B, satPositions(:, CCPRN), satClkCorr(CCPRN), settings);
                    
                    % Find sub-millisecond range, doing this to pick a value from the acquisition results:
                    codePhase = round(mod(pseudoRangeMS, 1) * samplesPerCode);
                    
                    % Zero index cannot be allowed:
                    if codePhase == 0
                        codePhase = 1;
                    end
                    
                    % Not concerned about the Doppler value, codePhase is all we are concerned about right now.
                    % Pick the value from the acquisition results and add it here, might play around with "max" or "mean":
                    collectiveCorrelogram(indexN, indexE, indexU, indexB) = collectiveCorrelogram(indexN, indexE, indexU, indexB) + ...
                                                                                                 max(results(eph.PRN(CCPRN), :, codePhase));
                    
                end
                
                % Increment clock bias index:
                indexB = indexB + 1;

            end

            % Increment height index and reset clock bias index:
            indexU = indexU + 1;
            indexB = 1;

        end

        % Increment easting index and reset height and clock bias index:
        indexE = indexE + 1;
        indexU = 1;
        indexB = 1;

    end

    % Increment northing index and reset easting, height and clock bias index:
    indexN = indexN + 1;
    indexE = 1;
    indexU = 1;
    indexB = 1;

end
