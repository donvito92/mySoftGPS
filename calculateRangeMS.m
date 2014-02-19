function rangeMS = calculateRangeMS(N, E, U, satPositions, satClkCorr, settings)

% This function calculates the "actual" range for a satellite with assumed NEU positions provided. 
% Range is returned in milliseconds. Use this function only when trying to "predict" clock bias.

% Convert northing and easting to latitude and longitude:
[lat long] = utm2deg(E, N, '12 U');

% Convert latitude and longitude to ECEF coordinates:
[X Y Z] = lla2ecef(lat * pi / 180, long * pi / 180, U);

% Now it is possible to calculate the range, so do it! :
range = sqrt(((X - satPositions(1))^2) + ((Y - satPositions(2))^2) + ((Z - satPositions(3))^2)) - satClkCorr * (settings.c);

% Convert pseudorange to number of milliseconds:
rangeMS = 1000 * range / settings.c;
