clearvars;
close all;
clc;

scen.showBand       =   true;               % When enabled, PSD and "Square-PSD" will be plotted
scen.bw             =   1.023 * 1e6;        % Transmitted signal bandwidth at -3dB[Hz]
scen.shape          =   's';                % Signal band shape: 'r' -> rectangular, 's' -> sinc, 't' -> triangle
scen.freq           =   0;      % Transmitted signal frequency [Hz]
scen.power          =   15;                 % Transmitted signal power [dBW]
scen.nFig           =   2;                  % Receiver's noise figure [dB]
scen.ns             =   2;                  % Number of samples
scen.n              =   1.000293;           % Refractive index
scen.timeNoiseVar   =   0;                  % Time noise variance. When 0, CRB is used
scen.freqNoiseVar   =   0;                  % Frequency noise variance. When 0, CRB is used
scen.weighting      =   'Q';                % Weigting matrix used on LS. I for identity, Q for covariance
scen.MSBW           =   get_MS_BW(scen);    % Mean Square Bandwidth