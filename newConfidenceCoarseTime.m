function [confidenceMetric] = newConfidenceCoarseTime(CC, north, east, up, bias, coarseTime, X)

% This function calculates the confidence with which the position
% information is asserted. We first calculate the magnitude of maxima, then
% ascertain the distance at which all correlators are less than X% of the 
% maxima.

% The NE search domain:
NEDomain = reshape(CC(:, :, up, bias, coarseTime), size(CC, 1), size(CC, 2));

% Find the magnitude of maxima, store it:
maxima = NEDomain(north, east);
% Find the cutoff:
cutoff = (X / 100) * maxima;
% Initialize the cutoff step:
bound = (size(CC, 1) - 1);

% Loop over all possible step values:
for step = 1 : (size(CC, 1) - 1)
    flag = 0;
    for i = north - step : north + step
        for j = east - step : east + step
            % Make sure that the point is within the domain:
            if i < size(CC, 1) && j < size(CC, 2) && i > 1 && j > 1
                % Check that it is exactly "step" number of steps away from
                % the maxima point:
                if (abs(north - i) == step) || (abs(east - j) == step)
                    % If cutoff violated, set the flag:
                    if NEDomain(i, j) > cutoff
                        flag = 1;
                    end
                end
            end
        end
    end
    % If flag not set, then no cutoff violated, so this 'may be' the bound:
    if bound > step && flag == 0
        bound = step;
    end
    % If erroneous bound was set, reset the bound:
    if bound < step && flag == 1
        bound = (size(CC, 1) - 1);
    end
end

% Confidence Metric decreases with increasing uncertainty in the solution:
confidenceMetric = (size(CC, 1) - 1) - bound;