function [satPositions, satClkCorr] = mySatPos(eph, transmitTime) 
%SATPOS Calculation of X,Y,Z satellites coordinates at transmitTime for
%given ephemeris EPH. Coordinates are calculated for each satellite in the
%list PRNLIST.
%[satPositions, satClkCorr] = satpos(eph, settings);
%
%   Inputs:
%       eph           - ephemeridies of satellites
%       settings      - receiver settings
%
%   Outputs:
%       satPositions  - positions of satellites (in ECEF system [X; Y; Z;])
%       satClkCorr    - correction of satellites clocks

%--------------------------------------------------------------------------
%                           SoftGNSS v3.0
%--------------------------------------------------------------------------
%Based on Kai Borre 04-09-96
%Copyright (c) by Kai Borre
%Updated by Darius Plausinaitis, Peter Rinder and Nicolaj Bertelsen
%
% CVS record:
% $Id: satpos.m,v 1.1.2.15 2006/08/22 13:45:59 dpl Exp $

%% Initialize constants ===================================================
numOfSatellites = sum(eph.PRN ~= 0);

% GPS constatns

gpsPi          = 3.1415926535898;  % Pi used in the GPS coordinate 
                                   % system

%--- Constants for satellite position calculation -------------------------
Omegae_dot     = 7.2921151467e-5;  % Earth rotation rate, [rad/s]
GM             = 3.986005e14;      % Earth's universal
                                   % gravitational parameter,
                                   % [m^3/s^2]
F              = -4.442807633e-10; % Constant, [sec/(meter)^(1/2)]

%% Initialize results =====================================================
satClkCorr   = zeros(1, numOfSatellites);
satPositions = zeros(3, numOfSatellites);

%% Process each satellite =================================================

for satNr = 1 : numOfSatellites
    
    prn = eph.PRN(satNr);
    
%% Find initial satellite clock correction --------------------------------

    %--- Find time difference ---------------------------------------------
    dt = check_t(transmitTime - eph.t_oe(satNr));

    %--- Calculate clock correction ---------------------------------------
    satClkCorr(satNr) = (eph.a_f2(satNr) * dt + eph.a_f1(satNr)) * dt + ...
                         eph.a_f0(satNr) - ...
                         eph.TGD(satNr);

    time = transmitTime - satClkCorr(satNr);

%% Find satellite's position ----------------------------------------------

    %Restore semi-major axis
    a   = eph.sqrtA(satNr) * eph.sqrtA(satNr);

    %Time correction
    tk  = check_t(time - eph.t_oe(satNr));

    %Initial mean motion
    n0  = sqrt(GM / a^3);
    %Mean motion
    n   = n0 + eph.deltan(satNr);

    %Mean anomaly
    M   = eph.M_0(satNr) + n * tk;
    %Reduce mean anomaly to between 0 and 360 deg
    M   = rem(M + 2*gpsPi, 2*gpsPi);

    %Initial guess of eccentric anomaly
    E   = M;

    %--- Iteratively compute eccentric anomaly ----------------------------
    for ii = 1:10
        E_old   = E;
        E       = M + eph.e(satNr) * sin(E);
        dE      = rem(E - E_old, 2*gpsPi);

        if abs(dE) < 1.e-12
            % Necessary precision is reached, exit from the loop
            break;
        end
    end

    %Reduce eccentric anomaly to between 0 and 360 deg
    E   = rem(E + 2*gpsPi, 2*gpsPi);

    %Compute relativistic correction term
    dtr = F * eph.e(satNr) * eph.sqrtA(satNr) * sin(E);

    %Calculate the true anomaly
    nu   = atan2(sqrt(1 - (eph.e(satNr))^2) * sin(E), cos(E)-eph.e(satNr));

    %Compute angle phi
    phi = nu + eph.omega(satNr);
    %Reduce phi to between 0 and 360 deg
    phi = rem(phi, 2*gpsPi);

    %Correct argument of latitude
    u = phi + ...
        eph.C_uc(satNr) * cos(2*phi) + ...
        eph.C_us(satNr) * sin(2*phi);
    %Correct radius
    r = a * (1 - (eph.e(satNr))*cos(E)) + ...
        (eph.C_rc(satNr)) * cos(2*phi) + ...
        (eph.C_rs(satNr)) * sin(2*phi);
    %Correct inclination
    i = eph.i_0(satNr) + eph.iDot(satNr) * tk + ...
        eph.C_ic(satNr) * cos(2*phi) + ...
        eph.C_is(satNr) * sin(2*phi);

    %Compute the angle between the ascending node and the Greenwich meridian
    Omega = eph.OMEGA(satNr) + (eph.OMEGADot(satNr) - Omegae_dot)*tk - ...
            Omegae_dot * eph.t_oe(satNr);
    %Reduce to between 0 and 360 deg
    Omega = rem(Omega + 2*gpsPi, 2*gpsPi);

    %--- Compute satellite coordinates ------------------------------------
    satPositions(1, satNr) = cos(u)*r * cos(Omega) - sin(u)*r * cos(i)*sin(Omega);
    satPositions(2, satNr) = cos(u)*r * sin(Omega) + sin(u)*r * cos(i)*cos(Omega);
    satPositions(3, satNr) = sin(u)*r * sin(i);


%% Include relativistic correction in clock correction --------------------
    satClkCorr(satNr) = (eph.a_f2(satNr) * dt + eph.a_f1(satNr)) * dt + ...
                         eph.a_f0(satNr) - ...
                         eph.TGD(satNr) + dtr;
                     
end % for satNr = 1 : numOfSatellites
