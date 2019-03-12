function fNoise = compute_freq_noise(scen, rxPow)
%   COMPUTE_TIME_NOISE:     Time noise computation
%
%       Frequency noise computation following a Gaussian distributuion with
%       mean=0 and variance=CRB: N(0, CRB)
%
%   Input:      scen:       Struct. Values describing the scenario
%               rxPow:      Double. Received signal's power in Watts
%
%   Output:     fNoise:     Double. Additive noise in frequency
    
    c       =   299792458;

    if scen.fdoaVar == 0
        fNoise  =   normrnd(0, sqrt(get_freq_CRB(scen, rxPow)));
    else
        freqVar =   ((scen.freq/c)^2) * (scen.fdoaVar/2);
        fNoise  =   normrnd(0, sqrt(freqVar));
    end

end