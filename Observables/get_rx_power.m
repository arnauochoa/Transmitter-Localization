function [rxPow] = get_rx_power(scen, range)
%   GET_RX_POWER:   Computes the received signal's power
%   	
%       Computes the received signal's power from given scenario parameters and
%       range between transmitte and rreceiver
%
%   Input:      scen:   Struct. Information of the scenario
%               range:  Double. Distance between Tx and Rx in metres
%
%   Output:     rxPow:  Double. Received signal's power in Watts

    %- Obtain shadowing variable
%     shadVar =   db2pow(scen.sigmaS)^2 * exp(-range / scen.corrDist);
%     s       =   lognrnd(0, shadVar);
%     rxPow   =   scen.power * (scen.c0 * (1/s)) / (range^scen.gamma);
    
%     aux     =   (range^scen.gamma);
%     if aux < 1
%         aux = 1;
%     end
%     rxPow   =   db2pow(scen.power) * scen.c0 / aux;
    
    c       =   physconst('LightSpeed');    % Speed of light [m/s]
    
    Lbf     =   (4 * pi * range * scen.freq/scen.v)^2;   % Propagation losses
    
    rxPow   =   db2pow(scen.power)/Lbf;
end

