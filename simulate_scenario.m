function [rxTimes, rxFreqs, txEstPos, txEstVel] = simulate_scenario(N, scen, tx, rx)
%   SIMULATE_SCENARIO Estimates the transmitter's position and velocity
%
%       Builds the scenario and estimates the transmitter's position and 
%       velocity for the given scenario. 
%
%   Input:      N:          Double. Number of realizations for every step
%               scen:       Struct. Information of the scenario
%               tx:         Struct. Information of the transmitter
%               rx:         1xM struct. Information of the receivers            
%
%   Output:     errPos:     Kx1 vector. Error in the estimated position for
%                           every step
%               errVel:     Kx1 vector. Error in the estimated velocity for
%                           every step

    numRx       =   length(rx);
        
    txEstPos    =   zeros(N, 3);
    txEstVel    =   zeros(N, 3);
    refRange    =   zeros(N, 3);
    refRrate    =   zeros(N, 3);
    for i = 1:N
        rxTimes     =   zeros(numRx, 1);
        rxFreqs     =   zeros(numRx, 1);
        for r = 1:numRx
            [rxTimes(r), rxFreqs(r)] = observables_generation(rx(r), tx, scen);
        end

        [txEstPos(i, :), txEstVel(i, :), refRange(i, :), refRrate(i, :)] = ...
            first_stage(scen.freq, rx, rxTimes, rxFreqs);
    end
end

