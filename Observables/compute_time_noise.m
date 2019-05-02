function tNoise = compute_time_noise(scen, rxPow)
%   COMPUTE_TIME_NOISE:     Time noise computation
%
%       Time noise computation following a Gaussian distributuion with
%       mean=0 and variance=CRB: N(0, CRB)
%
%   Input:      rxPow:      Double. Received signal's power in Watts
%
%   Output:     tNoise:     Double. Additive noise in time

    if scen.tdoaVar == 0
        tNoise  =   normrnd(0, sqrt(get_time_CRB(scen, rxPow)));
    else
        timeVar =   scen.tdoaVar/(2*scen.v^2);
        tNoise  =   normrnd(0, sqrt(timeVar));
    end
end