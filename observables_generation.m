function [rxTime, rxFreq] = observables_generation(rxPos, rxVel, txPos, txVel, txTime, txFreq, SNR, Ns)
%   OBSERVABLES_GENERATION:     Calculation of the observables
%
%       Reception time and reception frequency generation from the given
%       positions and velocities of the transmitter and receiver. Gaussian
%       noise is added following the form N(0, CRB).
%
%   Input:      rxPos:  3x1 vector. Receiver position
%               rxVel:  3x1 vector. Receiver velocity
%               txPos:  3x1 vector. Transmitter position
%               txVel:  3x1 vector. Transmitter velocity
%               txTime: Double. Tranmsission time
%               txFreq: Double. Transmitted signal's frequency
%               SNR:    Double. Signal-to-Noise Ratio of the received signal
%               Ns:     Double. Number of samples
%
%   Output:     rxTime: Double. Reception time in seconds
%               rxFreq: Double. Received signal frequency in Hz

    %- Parameters initialization
    c       =   299792458;              % Speed of light (m/s)
    
    %- Relative distance and range rate computation
    [rRate, dRel]   =   compute_range_rate(rxPos, rxVel, txPos, txVel);
    
    %- Actual propagation time and frequency drift computation
    tProp   =   dRel/c;                 % Propagation time
    fDop    =   txFreq * (rRate/c);      % Doppler frequency drift
    
    %- Observed frequency computation
    fNoise  =   compute_freq_noise(SNR, Ns);  % TODO
    rxFreq  =   txFreq + fDop + fNoise;
    
    %- Observed reception time compution
    tNoise  =   compute_time_noise(SNR, Ns, rxFreq);  % TODO
    rxTime  =   txTime + tProp + tNoise; 

end

