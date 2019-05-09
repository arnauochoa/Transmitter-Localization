% 
% POWER_TEST: Script used for test purposes related with the received power.
%

power1  =   -10; % dBW
power2  =   -5;
gamma   =   2;
c0      =   1;
freq    =   1575.42 * 1e6; % Hz
range   =   800; % m


%% Cabric method
aux     =   (range^gamma);
if aux < 1
    aux = 1;
end
rxPow1   =   db2pow(power1) .* c0 / aux;

%% Free space
c       =   physconst('LightSpeed');    % Speed of light [m/s]

Lbf     =   (4 * pi * range .* freq./c).^2;   % Propagation losses

rxPow2  =   db2pow(power2)./Lbf;

rxPow1  =  rxPow1 * ones(size(rxPow2));

% figure;
% plot(power2, rxPow1);
% legend('Cabric');
% figure;
% plot(power2, rxPow2);
% legend('Free space');
% 
% figure;
% plot(power2, pow2db(rxPow1)); hold on;
% plot(power2, pow2db(rxPow2));
% legend('Cabric', 'Free space');

%% SNR 1
scen.bw             =   15.345 * 1e6;   %   [Hz]        Transmitted signal bandwidth 
                                        %                   TODO: define it as BW at -3dB
scen.nFig           =   5;              %     [dB]      Receiver's noise figure
scen.temp           =   5000;            %     [K]       Ambient temperature

No1     =   get_noise_power(scen);

SNR1    =   rxPow1/No1;

%% SNR 2
scen.bw             =   10.23 * 1e6;   %   [Hz]        Transmitted signal bandwidth 
                                        %                   TODO: define it as BW at -3dB
scen.nFig           =   2;              %     [dB]      Receiver's noise figure
scen.temp           =   290:500;            %     [K]       Ambient temperature

No2     =   get_noise_power(scen);
SNR2 =   rxPow2./No2;

SNR1  =  SNR1 * ones(size(SNR2));
figure;
plot(scen.temp, pow2db(SNR1)); hold on;
plot(scen.temp, pow2db(SNR2));
legend('Cabric', 'Free space');