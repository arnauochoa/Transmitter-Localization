function [rxPow] = get_rx_power(scen, range)
%   GET_RX_POWER:   Computes the received frequency
%   	
%       Computes the received frequency from given scenario parameters and
%       range between transmitte and rreceiver
%
%   Input:      scen:       Struct. Information of the scenario
%               range:      Double. Distance between Tx and Rx in metres
%
%   Output:     rxPow:      Double. Received signal's power in Watts

    c       =   physconst('LightSpeed');    % Speed of light [m/s]
    
    Lbf     =   (4 * pi * range * scen.freq/c)^2;   % Propagation losses
    
    rxPow   =   db2pow(scen.power/Lbf);
end

