function No = get_noise_power(scen)
%   GET_NOISE_POWER:   Computes the received noise's power
%   	
%       Computes the received noise's power from given scenario parameters and
%       range between transmitte and rreceiver
%
%   Input:      scen:       Struct. Information of the scenario
%
%   Output:     No:      Double. Received noise's power in Watts

    k       =   physconst('Boltzmann');     % Boltzmann constant [J/K]
    To      =   290;                        % Ambient temperature [K]
    
    No      =   k * To * scen.bw * db2pow(scen.nFig);
end

