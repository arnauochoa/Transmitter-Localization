function freqCRB = get_freq_CRB(scen, rxPow)
%   GET_TIME_CRB:     Frequency CRB computation
%
%       Frequency CRB computation as described by Kay in "Fundamentals of 
%       Statistical Signal Processing: Estimation Theory", p. 57
%
%   Input:      scen:       Struct. Information of the scenario
%               rxPow:      Double. Received signal's power in Watts
%
%   Output:     freqCRB:    CRB of the received frequency
    
    %- Compute SNR
    SNR     =   rxPow/scen.No;
    
    %- Frequency CRB computation: Kay vol. 1, p. 57
    freqCRB     =   6 / ((2 * pi)^2 * SNR * scen.ns * (scen.ns^2 - 1));
end