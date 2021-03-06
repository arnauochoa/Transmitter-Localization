function [rxPows, rxTimes, rxFreqs, estDoas, txEstPosA, txEstVelA, txEstPosB, txEstVelB, oldTx] ...
            =   simulate_scenario(scen, tx, rx, oldTx)
%   SIMULATE_SCENARIO Estimates the transmitter's position and velocity
%
%       Builds the scenario and estimates the transmitter's position and 
%       velocity for the given scenario. 
%
%   Input:      scen:       Struct. Information of the scenario
%               tx:         Struct. Information of the transmitter
%               rx:         1xM struct. Information of the receivers            
%
%   Output:     rxPows:     numRx x N matrix. Received powers
%               rxTimes:    numRx x N matrix. Reception times
%               rxFreqs:    numRx x N matrix. Received frequencies
%               estDoas:    numRx x N matrix. Estimated DoAs
%               txEstPosA:  Nx3 matrix. Positions [X, Y] with the TDoA/FDoA
%                           method
%               txEstPosA:  Nx3 matrix. Velocities [X, Y] with the TDoA/FDoA
%                           method
%               txEstPosB:  Nx3 matrix. Positions [X, Y] with the RSS/DoA
%                           method

    global N;
    
    numRx       =   length(rx);
    nDim        =   2;
        
    txEstPosA   =   zeros(N, nDim);
    txEstVelA   =   zeros(N, nDim);
    
    txEstPosB   =   zeros(N, nDim);
    txEstVelB   =   zeros(N, nDim);
    
    rxPows      =   zeros(numRx, N);
    rxTimes     =   zeros(numRx, N);
    rxFreqs     =   zeros(numRx, N);
    estDoas     =   zeros(numRx, N);
    
    %refTime     =   zeros(numRx, N);
    for i = 1:N
        parfor r = 1:numRx
            [rxPows(r, i), rxTimes(r, i), rxFreqs(r, i), estDoas(r, i)] = ...
                observables_generation(scen, rx(r), tx);
        end
    end
    
    refTime     =   tx.time + rxTimes;
    tau         =   zeros(numRx, N);
    
    parfor i = 1:N
        [txEstPosA(i, :), txEstVelA(i, :), ~, ~] = ...
            tdoa_fdoa_method(scen, rx, rxPows(:,i), rxTimes(:,i), rxFreqs(:,i));
        
        txEstPosB(i, :)     =   rss_doa_method(scen, rx, rxPows(:, i), estDoas(:, i));
        
        if (~isempty(oldTx.time))
            tau(:,i)    =   refTime(:, i) - oldTx.time;
            avgTau      =   mean(tau(:, i));
            txEstVelB(i, :)     =   (oldTx.pos - txEstPosB(i, :)) ./ avgTau;
        end
    end
    
    oldTx.pos   =   mean(txEstPosB, 1);
    oldTx.time  =   mean(refTime, 2);
end

