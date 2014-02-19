function [eph] = GSNRxEphemeris(filename, acquiredSvs)

% Use this function for returning a struct "eph" which contains all the
% ephemeris data extracted from the file that GSNRx returns. File is 
% mentioned by the 'filename'.

eph.PRN = zeros(1, length(acquiredSvs));
eph.GPSWeek = zeros(1, length(acquiredSvs));
eph.t_oe = zeros(1, length(acquiredSvs));
eph.t_oc = zeros(1, length(acquiredSvs));
eph.sqrtA = zeros(1, length(acquiredSvs));
eph.e = zeros(1, length(acquiredSvs));
eph.deltan = zeros(1, length(acquiredSvs));
eph.M_0 = zeros(1, length(acquiredSvs));
eph.omega = zeros(1, length(acquiredSvs));
eph.C_uc = zeros(1, length(acquiredSvs));
eph.C_us = zeros(1, length(acquiredSvs));
eph.C_rc = zeros(1, length(acquiredSvs));
eph.C_rs = zeros(1, length(acquiredSvs));
eph.C_ic = zeros(1, length(acquiredSvs));
eph.C_is = zeros(1, length(acquiredSvs));
eph.iDot = zeros(1, length(acquiredSvs));
eph.i_0 = zeros(1, length(acquiredSvs));
eph.OMEGA = zeros(1, length(acquiredSvs));
eph.OMEGADot = zeros(1, length(acquiredSvs));
eph.TGD = zeros(1, length(acquiredSvs));
eph.a_f0 = zeros(1, length(acquiredSvs));
eph.a_f1 = zeros(1, length(acquiredSvs));
eph.a_f2 = zeros(1, length(acquiredSvs)); 
eph.IODE = zeros(1, length(acquiredSvs));
eph.IODC = zeros(1, length(acquiredSvs));

% Open the output file:
fid = fopen(filename, 'r');

% Loop over for all acquired satellites:
for i = 1 : length(acquiredSvs)
    
    % The first 16 bytes are not useful, so skip:
    dummy = fread(fid, 16);
    
    % Extract useful information:
    eph.PRN(i) = fread(fid, 1, 'uint16');
    eph.GPSWeek(i) = fread(fid, 1, 'uint32') + 1024;
    eph.TGD(i) = fread(fid, 1, 'double');
    eph.IODC(i) = fread(fid, 1, 'int16');
    eph.t_oc(i) = fread(fid, 1, 'double');
    eph.a_f2(i) = fread(fid, 1, 'double');
    eph.a_f1(i) = fread(fid, 1, 'double');
    eph.a_f0(i) = fread(fid, 1, 'double');
    eph.IODE(i) = fread(fid, 1, 'schar');
    eph.C_rs(i) = fread(fid, 1, 'double');
    eph.deltan(i) = fread(fid, 1, 'double');
    eph.M_0(i) = fread(fid, 1, 'double');
    eph.C_uc(i) = fread(fid, 1, 'double');
    eph.e(i) = fread(fid, 1, 'double');
    eph.C_us(i) = fread(fid, 1, 'double');
    eph.sqrtA(i) = fread(fid, 1, 'double');
    eph.t_oe(i) = fread(fid, 1, 'double');
    eph.C_ic(i) = fread(fid, 1, 'double');
    eph.OMEGA(i) = fread(fid, 1, 'double');
    eph.C_is(i) = fread(fid, 1, 'double');
    eph.i_0(i) = fread(fid, 1, 'double');
    eph.C_rc(i) = fread(fid, 1, 'double');
    eph.omega(i) = fread(fid, 1, 'double');
    eph.OMEGADot(i) = fread(fid, 1, 'double');
    eph.iDot(i) = fread(fid, 1, 'double');
    
    % The last 6 bytes are also useless:
    dummy = fread(fid, 6);
    
end
