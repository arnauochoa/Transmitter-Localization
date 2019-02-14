function [rxTime, rxFreq] = observables_generation(rx, tx, scen)
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
%               txFreq: Double. Transmitted signal's frequency
%               SNR:    Double. Signal-to-Noise Ratio of the received signal
%               Ns:     Double. Number of samples
%
%   Output:     rxTime: Double. Reception time in seconds
%               rxFreq: Double. Received signal frequency in Hz

    %- Parameters initialization
%    n       =   1;                      % Refractive index
    c       =   299792458;              % Speed of light (m/s)
    
    %- Relative distance and range rate computation
    [rRate, dRel]   =   compute_range_rate(rx, tx);
    
    %- Actual propagation time and frequency drift computation
    tProp   =   dRel/c;                 % Propagation time
    fDop    =   scen.freq * (rRate/c);     % Doppler frequency drift
    
    %- Observed frequency computation
    fNoise  =   compute_freq_noise(scen.snr, scen.ns);
    rxFreq  =   scen.freq + fDop + fNoise;
    
    %- Observed reception time compution
    tNoise  =   compute_time_noise(scen.snr, scen.ns, rxFreq);
    rxTime  =   tProp + tNoise; 

end

