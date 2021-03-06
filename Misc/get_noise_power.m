function No = get_noise_power(scen)
%   GET_NOISE_POWER:   Computes the received noise's power
%   	
%       Computes the received noise's power from given scenario parameters 
%       and range between transmitter and receiver
%
%   Input:      scen:   Struct. Information of the scenario
%
%   Output:     No:     Double. Received noise's power in Watts

    k       =   physconst('Boltzmann');     % Boltzmann constant [J/K]
    T0      =   290;                        % Standard noise temperature [K]
    
    No      =   k .* T0 .* scen.bw .* scen.nFig;
end

