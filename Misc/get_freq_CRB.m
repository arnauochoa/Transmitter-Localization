function freqCRB = get_freq_CRB(SNR, Ns)
%   GET_TIME_CRB:     Frequency CRB computation
%
%       Frequency CRB computation as described by Kay in "Fundamentals of 
%       Statistical Signal Processing: Estimation Theory"
%
%   Input:      SNR:        Signal-to-Noise Ratio of the received signal
%               Ns:         Number of samples
%               rxFreq:     Received frequency
%
%   Output:     timeCRB:    CRB of the reception time

    % Frequency CRB computation: Kay vol. 1, p. 57
    freqCRB     =   12 / ((2 * pi)^2 * SNR * Ns * (Ns^2 - 1));
    
end