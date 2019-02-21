function fNoise = compute_freq_noise(scen)
%   COMPUTE_TIME_NOISE:     Time noise computation
%
%       Time noise computation following a Gaussian distributuion with
%       mean=0 and variance=CRB: N(0, CRB)
%
%   Input:      SNR:    Signal-to-Noise Ratio of the received signal
%               Ns:     Number of samples
%
%   Output:     fNoise: Additive noise in frequency
    
    if scen.freqNoiseVar == 0
        fNoise = normrnd(0, sqrt(get_freq_CRB(scen.snr, scen.ns)));
    else
        fNoise = normrnd(0, sqrt(scen.freqNoiseVar));
    end

end