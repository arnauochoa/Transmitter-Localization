clear all; close all; clc; %#ok<CLALL>

%- Transmitter parameters
txPos   =   [50; 50; 0].*1e3;       % Position X-Y-Z [m]
txVel   =   [10; 100; 0];           % Velocity X-Y-Z [m/s]
txTime  =   0;                      % Transmission time [s]
txFreq  =   1575.42;                % Transmission frequency [MHz]

%- Receiver parameters
rxPos   =   [0; 0; 0].*1e3;         % Position X-Y-Z [m]
rxVel   =   [0; 0; 0];              % Velocity X-Y-Z [m/s]

%- CRB parameters
SNR_dB  =  40;                     % Signal-to-Noise Ratio [dB]
Ns      =  15;                     % Number of samples []

SNR     =   db2pow(SNR_dB);
txFreq  =   txFreq * 1e6;
[rxTime, rxFreq] = observables_generation(rxPos, rxVel, txPos, txVel, txTime, txFreq, SNR, Ns);




% -------------------------------------------------------------------------
fprintf("\n ------ Results ------\n");
fprintf(" Reception time: %f seconds \n", rxTime);
fprintf(" Received signal frequency: %f MHz \n", rxFreq/1e6);
