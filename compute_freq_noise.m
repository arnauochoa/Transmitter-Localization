function fNoise = compute_freq_noise(SNR, Ns)
%   COMPUTE_TIME_NOISE:     Time noise computation
%
%       Time noise computation following a Gaussian distributuion with
%       mean=0 and variance=CRB: N(0, CRB)
%
%   Input:      SNR:    Signal-to-Noise Ratio of the received signal
%               Ns:     Number of samples
%
%   Output:     fNoise: Additive noise in frequency
    
    % Frequency CRB computation: Kay vol. 1, p. 57
    CRB     =   12 / ((2 * pi)^2 * SNR * Ns * (Ns^2 - 1));
    
    % Gaussian frequency noise computation using CRB as variance
    fNoise  =   sqrt(CRB) * randn;    % ~N(0, CRB)

end