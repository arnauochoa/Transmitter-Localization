function tNoise = compute_time_noise(scen, rxFreq)
%   COMPUTE_TIME_NOISE:     Time noise computation
%
%       Time noise computation following a Gaussian distributuion with
%       mean=0 and variance=CRB: N(0, CRB)
%
%   Input:      scen:       Struct. Values describing the scenario
%
%   Output:     tNoise:     Double. Additive noise in time
   
    if scen.timeNoiseVar == 0
        tNoise = normrnd(0, sqrt(get_time_CRB(scen.snr, scen.ns, rxFreq)));
    else
        tNoise = normrnd(0, sqrt(scen.timeNoiseVar));
    end
end