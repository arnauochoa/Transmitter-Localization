% 
% TEST_MS_BW: Script used for test purposes related with the Mean Square Bandwidth.
%

clearvars;
close all;
clc;

addpath 'Misc';

scen.showBand       =   true;               % When enabled, PSD and "Square-PSD" will be plotted
scen.bw             =   10.23 * 1e6;        % Transmitted signal bandwidth at -3dB[Hz]
scen.shape          =   's2';               % Signal band shape: 
                                            %   'r' -> rectangular, 
                                            %   's' -> sinc, 
                                            %   's2' -> squared sinc,
                                            %   't' -> triangle
scen.freq           =   1575.42 * 1e6;      % Transmitted signal frequency [Hz]
scen.power          =   -5;                 % Transmitted signal power [dBW]
scen.nFig           =   2;                  % Receiver's noise figure [dB]
scen.ns             =   2;                  % Number of samples
scen.n              =   1.000293;           % Refractive index
scen.timeNoiseVar   =   0;                  % Time noise variance. When 0, CRB is used
scen.freqNoiseVar   =   0;                  % Frequency noise variance. When 0, CRB is used
scen.weighting      =   'Q';                % Weigting matrix used on LS. 
                                            %   I for identity, 
                                            %   Q for covariance
scen.MSBW           =   get_MS_BW(scen);    % Mean Square Bandwidth

fprintf("Resulting MS-BW -> %d \n", scen.MSBW); 