function fNoise = compute_freq_noise(scen, rxPow)
%   COMPUTE_TIME_NOISE:     Time noise computation
%
%       Time noise computation following a Gaussian distributuion with
%       mean=0 and variance=CRB: N(0, CRB)
%
%   Input:      scen:       Struct. Values describing the scenario
%               rxPow:      Double. Received signal's power in Watts
%
%   Output:     fNoise:     Double. Additive noise in frequency
    
    if scen.freqNoiseVar == 0
        fNoise = normrnd(0, sqrt(get_freq_CRB(scen, rxPow)));
    else
        fNoise = normrnd(0, sqrt(scen.freqNoiseVar));
    end

end