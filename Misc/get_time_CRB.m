function timeCRB = get_time_CRB(SNR, Ns, rxFreq)
%   GET_TIME_CRB:     Time CRB computation
%
%       Time CRB computation as described by Kay in "Fundamentals of 
%       Statistical Signal Processing: Estimation Theory"
%
%   Input:      SNR:        Signal-to-Noise Ratio of the received signal
%               Ns:         Number of samples
%               rxFreq:     Received frequency
%
%   Output:     timeCRB:    CRB of the reception time

% TODO: change CRB method

    % Phase CRB computation: Kay vol. 1, p. 57
    phaseCRB    =   2 * (2 * Ns - 1) / (SNR * Ns * (Ns + 1));
    
    % Time delay CRB computation
    timeCRB     =   phaseCRB / (2 * pi * rxFreq)^2;
    
end
