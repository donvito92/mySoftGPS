function [eph] = myEphemeris(filename, acquiredSvs)

% This function extracts the "eph" struct from standard RINEX files.

% Open the "hourly" RINEX file:
fid = fopen(filename, 'r');

% Remove the RINEX Header:
for dummy = 1 : 8
    % rinexHeader is a dummy variable to read the lines into:
    rinexHeader = fgetl(fid);    
end

% Copy the list of satellites acquired successfully:
PRNList = acquiredSvs;

% Initialize the ephemeris struct:
eph.PRN = zeros(1, length(acquiredSvs));
eph.GPSWeek = zeros(1, length(acquiredSvs));
eph.t_oe = zeros(1, length(acquiredSvs));
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
eph.SVHealth = zeros(1, length(acquiredSvs)); 
eph.SVAccuracy = zeros(1, length(acquiredSvs)); 
eph.IODC = zeros(1, length(acquiredSvs)); 
index = 0;

% Extracting ephemeris:
while 1
    % Read the first line
    line1 = fgetl(fid);
    
    % Check if we have not reached the end of file:
    if line1 == -1
        break;
    end
    
    % First number represents the PRN:
    [PRN rem] = strtok(line1);
    PRN = str2num(PRN);
    
    % Check if this PRN is in the list of PRN's to be extracted:
    if sum(PRN == PRNList)
        PRNList(PRN == PRNList) = 0;
        index = index + 1;
    else
        for dummy = 1 : 7
            rinexDummy = fgetl(fid);
        end
        continue;
    end
    
    % -------------------------------------------------------- %
    % ----- Extract the relevant information from line1: -----
    % PRN:
    eph.PRN(index) = PRN;
    
    for dummy = 1 : 6
        [rinexDummy rem] = strtok(rem, ' -');
    end
    
    % SV Clock Bias:
    [a_f0 rem] = strtok(rem, 'ED');
    eph.a_f0(index) = str2num(a_f0);
    exp = str2num(rem(2 : 4));
    rem = rem(5 : end);
    eph.a_f0(index) = eph.a_f0(index)*(10^exp);
    
    % SV Clock Drift:
    [a_f1 rem] = strtok(rem, 'ED');
    eph.a_f1(index) = str2num(a_f1);
    exp = str2num(rem(2 : 4));
    rem = rem(5 : end);
    eph.a_f1(index) = eph.a_f1(index)*(10^exp);
    
    % SV Clock Drift Rate:
    [a_f2 rem] = strtok(rem, 'ED');
    eph.a_f2(index) = str2num(a_f2);
    exp = str2num(rem(2 : 4));
    rem = rem(5 : end);
    eph.a_f2(index) = eph.a_f2(index)*(10^exp);
    
    % -------------------------------------------------------- %
    % ----- Extract the relevant information from line2: -----
    line2 = fgetl(fid);
    rem = line2;
    
    % IODE
    [IODE rem] = strtok(rem, 'ED');
    eph.IODE(index) = str2num(IODE);
    exp = str2num(rem(2 : 4));
    rem = rem(5 : end);
    eph.IODE(index) = eph.IODE(index)*(10^exp);
    
    % C_rs:
    [C_rs rem] = strtok(rem, 'ED');
    eph.C_rs(index) = str2num(C_rs);
    exp = str2num(rem(2 : 4));
    rem = rem(5 : end);
    eph.C_rs(index) = eph.C_rs(index)*(10^exp);
    
    % deltan:
    [deltan rem] = strtok(rem, 'ED');
    eph.deltan(index) = str2num(deltan);
    exp = str2num(rem(2 : 4));
    rem = rem(5 : end);
    eph.deltan(index) = eph.deltan(index)*(10^exp);
    
    % M_0:
    [M_0 rem] = strtok(rem, 'ED');
    eph.M_0(index) = str2num(M_0);
    exp = str2num(rem(2 : 4));
    rem = rem(5 : end);
    eph.M_0(index) = eph.M_0(index)*(10^exp);
    
    % -------------------------------------------------------- %
    % ----- Extract the relevant information from line3: -----
    line3 = fgetl(fid);
    rem = line3;
    
    % C_uc
    [C_uc rem] = strtok(rem, 'ED');
    eph.C_uc(index) = str2num(C_uc);
    exp = str2num(rem(2 : 4));
    rem = rem(5 : end);
    eph.C_uc(index) = eph.C_uc(index)*(10^exp);
    
    % e:
    [e rem] = strtok(rem, 'ED');
    eph.e(index) = str2num(e);
    exp = str2num(rem(2 : 4));
    rem = rem(5 : end);
    eph.e(index) = eph.e(index)*(10^exp);
    
    % C_us:
    [C_us rem] = strtok(rem, 'ED');
    eph.C_us(index) = str2num(C_us);
    exp = str2num(rem(2 : 4));
    rem = rem(5 : end);
    eph.C_us(index) = eph.C_us(index)*(10^exp);
    
    % sqrtA:
    [sqrtA rem] = strtok(rem, 'ED');
    eph.sqrtA(index) = str2num(sqrtA);
    exp = str2num(rem(2 : 4));
    rem = rem(5 : end);
    eph.sqrtA(index) = eph.sqrtA(index)*(10^exp);
    
    % -------------------------------------------------------- %
    % ----- Extract the relevant information from line4: -----
    line4 = fgetl(fid);
    rem = line4;
    
    % t_oe
    [t_oe rem] = strtok(rem, 'ED');
    eph.t_oe(index) = str2num(t_oe);
    exp = str2num(rem(2 : 4));
    rem = rem(5 : end);
    eph.t_oe(index) = eph.t_oe(index)*(10^exp);
    
    % C_ic:
    [C_ic rem] = strtok(rem, 'ED');
    eph.C_ic(index) = str2num(C_ic);
    exp = str2num(rem(2 : 4));
    rem = rem(5 : end);
    eph.C_ic(index) = eph.C_ic(index)*(10^exp);
    
    % OMEGA:
    [OMEGA rem] = strtok(rem, 'ED');
    eph.OMEGA(index) = str2num(OMEGA);
    exp = str2num(rem(2 : 4));
    rem = rem(5 : end);
    eph.OMEGA(index) = eph.OMEGA(index)*(10^exp);
    
    % C_is:
    [C_is rem] = strtok(rem, 'ED');
    eph.C_is(index) = str2num(C_is);
    exp = str2num(rem(2 : 4));
    rem = rem(5 : end);
    eph.C_is(index) = eph.C_is(index)*(10^exp);
    
    % -------------------------------------------------------- %
    % ----- Extract the relevant information from line5: -----
    line5 = fgetl(fid);
    rem = line5;
    
    % i_0
    [i_0 rem] = strtok(rem, 'ED');
    eph.i_0(index) = str2num(i_0);
    exp = str2num(rem(2 : 4));
    rem = rem(5 : end);
    eph.i_0(index) = eph.i_0(index)*(10^exp);
    
    % C_rc:
    [C_rc rem] = strtok(rem, 'ED');
    eph.C_rc(index) = str2num(C_rc);
    exp = str2num(rem(2 : 4));
    rem = rem(5 : end);
    eph.C_rc(index) = eph.C_rc(index)*(10^exp);
    
    % omega:
    [omega rem] = strtok(rem, 'ED');
    eph.omega(index) = str2num(omega);
    exp = str2num(rem(2 : 4));
    rem = rem(5 : end);
    eph.omega(index) = eph.omega(index)*(10^exp);
    
    % OMEGADot:
    [OMEGADot rem] = strtok(rem, 'ED');
    eph.OMEGADot(index) = str2num(OMEGADot);
    exp = str2num(rem(2 : 4));
    rem = rem(5 : end);
    eph.OMEGADot(index) = eph.OMEGADot(index)*(10^exp);
    
    % -------------------------------------------------------- %
    % ----- Extract the relevant information from line6: -----
    line6 = fgetl(fid);
    rem = line6;
    
    % iDot
    [iDot rem] = strtok(rem, 'ED');
    eph.iDot(index) = str2num(iDot);
    exp = str2num(rem(2 : 4));
    rem = rem(5 : end);
    eph.iDot(index) = eph.iDot(index)*(10^exp);
    
    % rinexDummy:
    [rinexDummy rem] = strtok(rem, 'ED');
    rem = rem(5 : end);
    
    % GPSWeek:
    [GPSWeek rem] = strtok(rem, 'ED');
    eph.GPSWeek(index) = str2num(GPSWeek);
    exp = str2num(rem(2 : 4));
    rem = rem(5 : end);
    eph.GPSWeek(index) = eph.GPSWeek(index)*(10^exp);
    
    % -------------------------------------------------------- %
    % ----- Extract the relevant information from line7: -----
    line7 = fgetl(fid);
    rem = line7;
    
    % SVAccuracy
    [SVAccuracy rem] = strtok(rem, 'ED');
    eph.SVAccuracy(index) = str2num(SVAccuracy);
    exp = str2num(rem(2 : 4));
    rem = rem(5 : end);
    eph.SVAccuracy(index) = eph.SVAccuracy(index)*(10^exp);
    
    % SVHealth
    [SVHealth rem] = strtok(rem, 'ED');
    eph.SVHealth(index) = str2num(SVHealth);
    exp = str2num(rem(2 : 4));
    rem = rem(5 : end);
    eph.SVHealth(index) = eph.SVHealth(index)*(10^exp);
    
    % TGD:
    [TGD rem] = strtok(rem, 'ED');
    eph.TGD(index) = str2num(TGD);
    exp = str2num(rem(2 : 4));
    rem = rem(5 : end);
    eph.TGD(index) = eph.TGD(index)*(10^exp);
    
    % IODC:
    [IODC rem] = strtok(rem, 'ED');
    eph.IODC(index) = str2num(IODC);
    exp = str2num(rem(2 : 4));
    rem = rem(5 : end);
    eph.IODC(index) = eph.IODC(index)*(10^exp);
    
    % -------------------------------------------------------- %
    % ----- Extract the relevant information from line8: -----
    line8 = fgetl(fid);
    % Nothing useful here.
    
    if ~sum(PRNList)
        break;
    end
end
