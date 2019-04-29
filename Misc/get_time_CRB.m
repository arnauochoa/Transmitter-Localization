function timeCRB = get_time_CRB(rxPow)
%   GET_TIME_CRB:     Time CRB computation
%
%       Time CRB computation as described by Kay in "Fundamentals of 
%       Statistical Signal Processing: Estimation Theory", p. 53
%
%   Input:      rxPow:      Double. Received signal's power in Watts
%
%   Output:     timeCRB:    CRB of the reception time
    
    %- Compute SNR
    No      =   get_noise_power();
    SNR     =   rxPow/No;
    
    %- Obtain Mean Square Bandwidth
    MSBW    =   get_MS_BW();
    
    %- Time CRB computation: Kay vol. 1, p. 53
    timeCRB =   1 / (SNR * MSBW);
end
