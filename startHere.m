% Run this script to get things rolling.
close all
clear
clc
% Initialize all the settings, data and other variables:
% Press 1 if you intend to run the receiver, 0 if you ran this
% script by mistake.
init;

% Extract the ephemeris from file:
[eph] = GSNRxEphemeris('GSNRx.EPH', acquiredSvs);

coarseOption = input('Enter "1" to solve for coarse time, might take a long time : ');

if coarseOption == 1

    % Provide the information required apriori:
    [roughEstimate] = myAiding();

    %goAhead = input('Enter "1" to start collective detection, might take a long time : ');
    goAhead = 1;

    if goAhead == 1
        
        % Set the initial estimate as the current estimate:
        newEstimate = roughEstimate;
        % Run the script for calculating nav solution with coarse time estimation:
        genNavSol5;
        
        % Generate a new rough estimate based on previous results:
        [newEstimate] = genNewEstimate(Lat, Long, roughEstimate.ht, clkBias, txTime, 2000, 0, 15000);
        % Run the script for calculating nav solution with coarse time estimation:
        genNavSol5;
        
        % Generate a new rough estimate based on previous results:
        [newEstimate] = genNewEstimate(Lat, Long, roughEstimate.ht, clkBias, txTime, 1000, 0, 15000);
        % Run the script for calculating nav solution with coarse time estimation:
        genNavSol5;
        
        % Generate a new rough estimate based on previous results:
        [newEstimate] = genNewEstimate(Lat, Long, roughEstimate.ht, clkBias, txTime, 500, 0, 15000);
        % Run the script for calculating nav solution with coarse time estimation:
        genNavSol5;
        
        % Generate a new rough estimate based on previous results:
        [newEstimate] = genNewEstimate(Lat, Long, roughEstimate.ht, clkBias, txTime, 250, 0, 15000);
        % Run the script for calculating nav solution with coarse time estimation:
        genNavSol5;

    end
    
else
    
    % Provide the information required apriori:
    [roughEstimate] = myAiding();
    
    % Calculate the position of all acquired satellites using the
    % ephemeris. Need to set settings.transmitTime in initSettings.m:
    [satPositions, satClkCorr] = mySatPos(eph, roughEstimate.T);

    %goAhead = input('Enter "1" to start collective detection, might take a long time : ');
    goAhead = 1;

    if goAhead == 1

        % Set the initial estimate as the current estimate:
        newEstimate = roughEstimate;
        % Run the script for calculating nav solution with coarse time estimation:
        genNavSol4;
        
        % Generate a new rough estimate based on previous results:
        [newEstimate] = genNewEstimate(Lat, Long, roughEstimate.ht, clkBias, txTime, 2000, 0, 15000);
        % Run the script for calculating nav solution with coarse time estimation:
        genNavSol4;
        
        % Generate a new rough estimate based on previous results:
        [newEstimate] = genNewEstimate(Lat, Long, roughEstimate.ht, clkBias, txTime, 1000, 0, 15000);
        % Run the script for calculating nav solution with coarse time estimation:
        genNavSol4;
        
        % Generate a new rough estimate based on previous results:
        [newEstimate] = genNewEstimate(Lat, Long, roughEstimate.ht, clkBias, txTime, 500, 0, 15000);
        % Run the script for calculating nav solution with coarse time estimation:
        genNavSol4;
        
        % Generate a new rough estimate based on previous results:
        [newEstimate] = genNewEstimate(Lat, Long, roughEstimate.ht, clkBias, txTime, 250, 0, 15000);
        % Run the script for calculating nav solution with coarse time estimation:
        genNavSol4;

    end
        
end