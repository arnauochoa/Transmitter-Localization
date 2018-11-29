function tNoise = compute_time_noise(SNR, Ns, rxFreq)
%   COMPUTE_TIME_NOISE:     Time noise computation
%
%       Time noise computation following a Gaussian distributuion with
%       mean=0 and variance=CRB: N(0, CRB)
%
%   Input:      SNR:    Signal-to-Noise Ratio of the received signal
%               Ns:     Number of samples
%
%   Output:     tNoise: Additive noise in time
    
    % Phase CRB computation: Kay vol. 1, p. 57
    phaseCRB    =   2 * (2 * Ns - 1) / (SNR * Ns * (Ns + 1));
    
    % Time delay CRB computation
    timeCRB     =   phaseCRB / (2 * pi * rxFreq)^2;

    % Gaussian time noise computation using CRB as variance
    tNoise      =   timeCRB * randn;
end