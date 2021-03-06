function [rxPow, rxTime, rxFreq, estTheta] = observables_generation(scen, rx, tx)
%   OBSERVABLES_GENERATION:     Calculation of the observables
%
%       Reception time and reception frequency generation from the given
%       positions and velocities of the transmitter and receiver. Gaussian
%       noise is added following the form N(0, CRB).
%
%   Input:      scen:           Struct. Information of the scenario
%               rx:         Struct. Receiver information
%               tx:         Struct. Transmitter information
%
%   Output:     rxPow:      Double. Received signal's power
%               rxTime:     Double. Reception time in seconds
%               rxFreq:     Double. Received signal frequency in Hz
    
    %- Computation of range and relative velocity between Tx and Rx
    [range, radVel]   =   compute_range_and_rad_vel(rx, tx);
    
    %- Actual propagation time and frequency drift computation
    tProp       =   range/scen.v;                 % Propagation time
    fDop        =   scen.freq * (radVel/scen.v);  % Doppler frequency drift
    
    %- Received power computation
    rxPow       =   get_rx_power(scen, range);
    
    %- Estimated DoA computation
    estTheta    =   get_est_theta(scen, rx, tx, rxPow);
    
    %- Observed frequency computation
    fNoise      =   compute_freq_noise(scen, rxPow);
    rxFreq      =   scen.freq + fDop + fNoise;
    
    %- Observed reception time compution
    tNoise      =   compute_time_noise(scen, rxPow);
    rxTime      =   tProp + tNoise; 
end

