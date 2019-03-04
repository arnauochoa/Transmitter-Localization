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
%   Output:     rxTimes:    numRx x1 vector. Reception times (scenario)
%               rxFreqs:    numRx x1 vector. Received frequencies (scenario)
%               txEstPos:   Nx3 matrix. Estimated positions (X-Y-Z) for the
%                           different realizations.
%               txEstVel:   Nx3 matrix. Estimated velocities (X-Y-Z) for the
%                           different realizations.

    numRx       =   length(rx);
        
    txEstPos    =   zeros(N, 3);
    txEstVel    =   zeros(N, 3);
    refRange    =   zeros(N, 3);
    refRrate    =   zeros(N, 3);
    for i = 1:N
        rxPows     =   zeros(numRx, 1);
        rxTimes     =   zeros(numRx, 1);
        rxFreqs     =   zeros(numRx, 1);
        for r = 1:numRx
            [rxPows(r), rxTimes(r), rxFreqs(r)] = observables_generation(rx(r), tx, scen);
        end

        [txEstPos(i, :), txEstVel(i, :), refRange(i, :), refRrate(i, :)] = ...
            first_stage(scen, rx, rxPows, rxTimes, rxFreqs);
    end
end

