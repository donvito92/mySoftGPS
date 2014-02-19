function [confidenceMetric] = myConfidence(CC, north, east, up, bias)

% This function calculates the confidence with which the position
% information is asserted. We first calculate the magnitude of maxima,
% and then calculate the average of all other points in the search space.
% The maxima/average is an estimate of how confident the solution is.

% The NE search domain:
NEDomain = reshape(CC(:, :, up, bias), size(CC, 1), size(CC, 2));

% Find the magnitude of maxima, store it, set it to zero:
maxima = NEDomain(north, east);
NEDomain(north, east) = 0;

% Initialize total:
total = 0;
count = 0;

% Calculate sum of all other values:
for i = 1 : size(NEDomain, 1)
    for j = 1 : size(NEDomain, 2)
        if NEDomain(i, j) == 0
            count = count + 1;
        end
        total = total + NEDomain(i, j);
    end
end

% Calculate average:
avg = total / ((i * j) - count - 1);

% Calculate confidence metric:
confidenceMetric = maxima / avg;
