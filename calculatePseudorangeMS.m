function pseudoRangeMS = calculatePseudorangeMS(N, E, U, B, satPositions, satClkCorr, settings)

% This function calculates the pseudorange for a satellite with assumed NEU positions and assumed 
% clock bias provided. Pseudorange is returned in milliseconds.

% Convert northing and easting to latitude and longitude:
[lat long] = utm2deg(E, N, '12 U');

% Convert latitude and longitude to ECEF coordinates:
[X Y Z] = lla2ecef(lat * pi / 180, long * pi / 180, U);

% Now it is possible to calculate the pseudorange, so do it! :
pseudoRange = sqrt(((X - satPositions(1))^2) + ((Y - satPositions(2))^2) + ((Z - satPositions(3))^2)) + B - satClkCorr * (settings.c);

% Convert pseudorange to number of milliseconds:
pseudoRangeMS = 1000 * pseudoRange / settings.c;
