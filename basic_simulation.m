clearvars; close all; clc;
addpath 'Estimation';
addpath 'Misc';
addpath 'Observables';
addpath 'Scenario';

%% --- PARAMETERS DEFINITION ---
global N nDim;
%- Simulation parameters
showScenario        =   true;           %                   Shows position over 3D space
c                   =   299792458;      %       [m/s]       Speed of light
n                   =   1.000293;       %                   Refractive index
N                   =   100;            %                   Number of realizations
nDim                =   2;              %                   Number of dimensions (now only 2)
nbins               =   100;            %                   Number of bins for the histogram

%- Transmitter parameters
tx.pos              =   [0, 900];     %    [m]      Position X-Y [m]
tx.vel              =   [10, 10];       %  [m/s]  Velocity X-Y [m/s]

%- Receiver parameters
rx(1).pos           =   [0, 0];         %     [m]     Rx1 position
rx(1).vel           =   [0, 0];      %      [m/s]  Rx1 velocity
rx(1).orientation   =   pi/4;              %       [rad]       Orientation of the ULA wrt. the X axis
rx(2).pos           =   [400, 0];    %     [m]     Rx2 position
rx(2).vel           =   [0, 0];      %  [m/s, m/s, m/s]  Rx2 velocity
rx(2).orientation   =   pi/6;              %       [rad]       Orientation of the ULA wrt. the X axis
rx(3).pos           =   [-400, 0];   %     [m, m, m]     Rx3 position
rx(3).vel           =   [0, 0];      %  [m/s, m/s, m/s]  Rx3 velocity
rx(3).orientation   =   2*pi;              %       [rad]       Orientation of the ULA wrt. the X axis
rx(4).pos           =   [0, 400];    %     [m, m, m]     Rx4 position
rx(4).vel           =   [0, 0];      %  [m/s, m/s, m/s]  Rx4 velocity
rx(4).orientation   =   0;              %       [rad]       Orientation of the ULA wrt. the X axis
% rx(5).pos           =   [0, 0];    %     [m, m, m]     Rx5 position
% rx(5).vel           =   [0, 0];      %  [m/s, m/s, m/s]  Rx5 velocity
% rx(5).orientation   =   0;              %       [rad]       Orientation of the ULA wrt. the X axis
% rx(6).pos           =   [0, 0];   %     [m, m, m]     Rx6 position
% rx(6).vel           =   [0, 0];      %  [m/s, m/s, m/s]  Rx6 velocity
% rx(6).orientation   =   0;              %       [rad]       Orientation of the ULA wrt. the X axis

%- Scenario parameters
scen.showBand       =   false;          %                   When enabled, PSD and "Square-PSD" will be plotted
scen.bw             =   15.345 * 1e6;    %       [Hz]        Transmitted signal bandwidth TODO: define it as BW at -3dB
scen.shape          =   's';            %                   Signal band shape: 
                                        %                       'r' -> rectangular, 's' -> sinc, 't' -> triangle
scen.freq           =   1575.42 * 1e6;  %       [Hz]        Transmitted signal frequency
scen.power          =   -10;            %       [dBW]       Transmitted signal power
scen.nFig           =   5;              %       [dB]        Receiver's noise figure
scen.ns             =   4;              %                   Number of samples
scen.temp           =   600;           %       [K]         Ambient temperature
scen.tdoaVar        =   0;              %                   Time noise variance. When 0, CRB is used
scen.fdoaVar        =   0;              %                   Frequency noise variance. When 0, CRB is used
scen.doaVar         =   0;              %                   DoA error variance. When 0, CRB is used
scen.weighting      =   'Q';            %                   Weigting matrix used on LS. I for identity, Q for covariance
scen.numRx          =   length(rx);     %                   Number of receivers
scen.refIndex       =   1;              %                   Reference receiver index
scen.c0             =   1;              %                   Average multiplicative gain
scen.gamma          =   2;              %                   Path loss exponent
scen.sigmaS         =   6;              %       [dB]        Shadowing standard deviation
scen.corrDist       =   5;              %       [m]         Correlation distance within which the shadowing effects 
                                        %                       among nodes are correlated.                      
scen.spacing        =   0;              %       [m]         Spacing between array elements. If 0, set to lambda/2
scen.nAnt           =   2;              %                   Number of antennas of the array
scen.v              =   c/n;            %       [m/s]       Propagation speed
scen.MSBW           =   get_MS_BW(scen);%                   Mean Square Bandwidth


%% --- SIMULATION ---
tic     % Start measuring execution time
[rxPows, rxTimes, rxFreqs, txEstPosA, txEstVelA, txEstPosB] = simulate_scenario(scen, tx, rx);
toc     % Stop measuring execution time


%% --- RESULTS ---

%-- Results computations
%- Mean
meanEstPosA     =   mean(txEstPosA, 1);   % TDOA/FDOA
meanEstPosB     =   mean(txEstPosB, 1);   % RSS/DOA
meanEstVel      =   mean(txEstVelA, 1);
%- Bias
biasEstPosA     =   meanEstPosA - tx.pos;
biasEstPosB     =   meanEstPosB - tx.pos;
biasEstVel      =   meanEstVel - tx.vel;
%- Standard deviation
stdEstPosA      =   std(txEstPosA, 0, 1);
stdEstPosB      =   std(txEstPosB, 0, 1);
stdEstVel       =   std(txEstVelA, 0, 1);
%- Error evolution
errEstPosA      =   sqrt(sum(txEstPosA - tx.pos, 2).^2);
errEstPosB      =   sqrt(sum(txEstPosB - tx.pos, 2).^2);
errEstVel       =   sqrt(sum(txEstVelA - tx.vel, 2).^2);


fprintf("\n ========= Observables =========\n");
for r = 1:scen.numRx
    fprintf(" --- Receiver %d ---\n", r);
    fprintf(" Received signal power: %f dB \n", pow2db(mean(rxPows(r, :))));
    fprintf(" Reception time: %e seconds \n", mean(rxTimes(r, :)));
    fprintf(" Received signal frequency: %f MHz \n", mean(rxFreqs(r, :))/1e6);
    
    fprintf(" ------------------\n");
    fprintf(" Std of received powers: %f s\n", pow2db(std(rxPows(r, :))));
    fprintf(" Std of received times: %e s\n", std(rxTimes(r, :)));
    fprintf(" Std of received frequencies: %e Hz\n", std(rxFreqs(r, :)));
end

fprintf("\n ========= Results TDoA/FDoA =========\n");
fprintf("\n Actual position: X = %f m; Y = %f m\n", tx.pos);
fprintf(" Estimated position mean: X = %f m; Y = %f m\n", meanEstPosA);
fprintf("\n Actual velocity: X = %f m/s; Y = %f m/s\n", tx.vel);
fprintf(" Estimated velocity mean: X = %f m/s; Y = %f m/s\n", meanEstVel);
fprintf("\n Position bias: X = %f m; Y = %f m\n", biasEstPosA);
fprintf(" Velocity bias: X = %f m/s; Y = %f m/s\n", biasEstVel);
fprintf("\n Estimated position std: X = %f m; Y = %f m\n", stdEstPosA);
fprintf(" Estimated velocity std: X = %f m/s; Y = %f m/s\n", stdEstVel);

fprintf("\n ========= Results RSS/DoA =========\n");
fprintf("\n Actual position: X = %f m; Y = %f m\n", tx.pos);
fprintf(" Estimated position mean: X = %f m; Y = %f m\n", meanEstPosB);
% fprintf("\n Actual velocity: X = %f m/s; Y = %f m/s; Z = %f m/s\n", tx.vel);
% fprintf(" Estimated velocity mean: X = %f m/s; Y = %f m/s; Z = %f m/s\n", meanEstVelB);
fprintf("\n Position bias: X = %f m; Y = %f m\n", biasEstPosB);
% fprintf(" Velocity bias: X = %f m/s; Y = %f m/s; Z = %f m/s\n", biasEstVel);
fprintf("\n Estimated position std: X = %f m; Y = %f m\n", stdEstPosB);
% fprintf(" Estimated velocity std: X = %f m/s; Y = %f m/s; Z = %f m/s\n", stdEstVel);

% %- TDOA/FDOA
% figure;
% histogram(errEstPosA, nbins);
% xlabel("Error [m]");
% title("Distribution of error in estimated position for TDoA/FDoA method");
% 
% figure;
% cdfplot(errEstPosA);
% xlabel("Error [m]");
% ylabel("CDF");
% title("CDF of error in estimated position for TDoA/FDoA method");
% 
% figure;
% histogram(errEstVel, nbins);
% xlabel("Error [m/s]");
% title("Distribution of error in estimated velocity");
% 
% figure;
% cdfplot(errEstVel);
% xlabel("Error [m/s]");
% ylabel("CDF");
% title("CDF of error in estimated velocity");
% 
% %- RSS/DOA
% figure;
% histogram(errEstPosB, nbins);
% xlabel("Error [m]");
% title("Distribution of error in estimated position for RSS/DoA method");
% 
% figure;
% cdfplot(errEstPosB);
% xlabel("Error [m]");
% ylabel("CDF");
% title("CDF of error in estimated position for RSS/DoA method");

figure;
cdfplot(errEstPosA); hold on;
cdfplot(errEstPosB);
xlabel("Error [m]");
ylabel("CDF");
title("CDF of error in estimated position");
legend('TDoA/FDoA', 'RSS/DoA');

%- 2D
% if showScenario
%     scale = 50;
%     figure; set(gcf, 'Position',  [100, 100, 1200, 800]);
%     legend;
%     scatter(tx.pos(1), tx.pos(2), 'r', 'x', 'DisplayName', 'Source'); hold on;
%     scatter(meanEstPosA(1), meanEstPosA(2), 'g', 'x', 'DisplayName', 'Estimated position (TDoA/FDoA method)'); hold on;
%     scatter(meanEstPosB(1), meanEstPosB(2), 'm', 'x', 'DisplayName', 'Estimated position (RSS/DoA method)'); hold on;
%     quiver(tx.pos(1), tx.pos(2), tx.vel(1)*scale, tx.vel(2)*scale, 'r'); hold on;
%     quiver(meanEstPosA(1), meanEstPosA(2), ...
%         meanEstVel(1)*scale, meanEstVel(2)*scale, 'g'); hold on;
%     for i = 1:scen.numRx
%         scatter(rx(i).pos(1), rx(i).pos(2), 'b', 'x', 'DisplayName', 'Receivers'); hold on;
%         quiver(rx(i).pos(1), rx(i).pos(2), ...
%             rx(i).vel(1)*scale, rx(i).vel(2)*scale, 'b'); hold on;
%     end
% end


%- 3D
% if showScenario
%     scale = 50;
%     figure; set(gcf, 'Position',  [100, 100, 1200, 800]);
%     legend;
%     scatter3(tx.pos(1), tx.pos(2), tx.pos(3), 'r', 'x', 'DisplayName', 'Source'); hold on;
%     scatter3(meanEstPosA(1), meanEstPosA(2), meanEstPosA(3), 'g', 'x', 'DisplayName', ...
%               'Estimated position (TDoA/FDoA method)'); hold on;
%     scatter3(meanEstPosB(1), meanEstPosB(2), 0, 'm', 'x', 'DisplayName', 'Estimated position (RSS/DoA method)'); hold on;
%     quiver3(tx.pos(1), tx.pos(2), tx.pos(3), tx.vel(1)*scale, tx.vel(2)*scale, tx.vel(3)*scale, 'r'); hold on;
%     quiver3(meanEstPosA(1), meanEstPosA(2), meanEstPosA(3), ...
%         meanEstVel(1)*scale, meanEstVel(2)*scale, meanEstVel(3)*scale, 'g'); hold on;
%     for i = 1:scen.numRx
%         scatter3(rx(i).pos(1), rx(i).pos(2), rx(i).pos(3), 'b', 'x', 'DisplayName', 'Receivers'); hold on;
%         quiver3(rx(i).pos(1), rx(i).pos(2), rx(i).pos(3), ...
%             rx(i).vel(1)*scale, rx(i).vel(2)*scale, rx(i).vel(3)*scale, 'b'); hold on;
%     end
% end


