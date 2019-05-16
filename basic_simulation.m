% 
% ADVANCED_SIMULATION:  Script used for launching an basic simulation. In
%                       this simulation the distribution of the receivers
%                       can be defined in rx_distributions and the
%                       position and velocity of the transmitter can be 
%                       defined as vectors. With the scen struct, the different
%                       parameters describing the scenario can be defined.
%

clearvars; close all; clc;

%% --- PARAMETERS DEFINITION ---
global N nDim;
%- Simulation parameters
showScenario        =   true;           %                   Shows position over 3D space
c                   =   299792458;      %       [m/s]       Speed of light
n                   =   1.000293;       %                   Refractive index
N                   =   200;            %                   Number of realizations
nDim                =   2;              %                   Number of dimensions (now only 2)
nbins               =   100;            %                   Number of bins for the histogram

%- Transmitter parameters
tx.pos              =   [400, 400];     %    [m]      Position X-Y [m]
tx.vel              =   [0, 10];       %  [m/s]  Velocity X-Y [m/s]

%% - Receiver parameters --> Defined on rx_distributions
selectedRxDist      =   1;
distributions       =   rx_distributions();
rx                  =   distributions{selectedRxDist};

%% - Scenario parameters
scen.numRx          =   length(rx);     %               Number of receivers
scen.showBand       =   false;          %               When enabled, PSD and "Square-PSD"
                                        %                   will be plotted
scen.bw             =   10.23 * 1e6;    %   [Hz]        Transmitted signal bandwidth 
                                        %                   TODO: define it as BW at -3dB
scen.shape          =   's2';           %               Signal band shape: 
                                        %                   'r' -> rectangular, 
                                        %                   's' -> sinc,
                                        %                   's2'-> sinc squared,
                                        %                   't' -> triangle
scen.freq           =   1575.42 * 1e6;  %     [Hz]      Transmitted signal frequency
scen.power          =   0;              %    [dBW]      Transmitted signal power
scen.ns             =   10;             %               Number of samples
scen.temp           =   400;            %     [K]       Equivalent temperature of system
scen.tdoaVar        =   0;              %               Time noise variance. 
                                        %                   When 0, CRB is used
scen.fdoaVar        =   0;              %               Frequency noise variance. 
                                        %                   When 0, CRB is used
scen.doaVar         =   0;              %               DoA error variance. 
                                        %                   When 0, CRB is used
scen.tdoaWeighting  =   'Q';            %               Weigting matrix used on TDOA/FDOA. 
                                        %                   I for identity, 
                                        %                   Q for covariance
scen.rssWeighting   =   'P';            %               Weigting matrix used on RSS/DOA. 
                                        %                   I for identity, 
                                        %                   P for RSS-based
scen.refIndex       =   1;              %               Reference receiver index
scen.c0             =   1;              %               Average multiplicative gain
scen.gamma          =   2;              %               Path loss exponent
scen.sigmaS         =   6;              %   [dB]        Shadowing standard deviation
scen.corrDist       =   5;              %   [m]         Correlation distance within which 
                                        %                   the shadowing effects among 
                                        %                   nodes are correlated
scen.spacing        =   0;              %   [m]         Spacing between array elements. 
                                        %                   If 0, set to lambda/2
scen.nAnt           =   2;              %               Number of antennas of the array
scen.v              =   c/n;            %    [m/s]      Propagation speed
scen.MSBW           =   get_MS_BW(scen);%               Mean Square Bandwidth
scen.No             =   get_noise_power(scen);% [W]     Noise Power


%% --- SIMULATION ---
tic     % Start measuring execution time
[rxPows, rxTimes, rxFreqs, estDoas, txEstPosA, txEstVelA, txEstPosB] = simulate_scenario(scen, tx, rx);
toc     % Stop measuring execution time


%% --- RESULTS ---

SNR             =   pow2db(mean(rxPows, 2)./scen.No);

%-- Results computations
%- Mean
meanEstPosA     =   mean(txEstPosA, 1);   % TDOA/FDOA
meanEstPosB     =   mean(txEstPosB, 1);   % RSS/DOA
meanEstVel      =   mean(txEstVelA, 1);   % TDOA/FDOA
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
    fprintf(" Received signal power: %f dBW \n", pow2db(mean(rxPows(r, :))));
    fprintf(" Received signal SNR: %f dB \n", SNR(r));
    fprintf(" Reception time: %e seconds \n", mean(rxTimes(r, :)));
    fprintf(" Received signal frequency: %f MHz \n", mean(rxFreqs(r, :))/1e6);
    fprintf(" Estimated signal DoA: %f º \n", rad2deg(mean(estDoas(r, :))));
    
    fprintf(" ------------------\n");
    fprintf(" Std of received powers: %f dB\n", pow2db(std(rxPows(r, :))));
    fprintf(" Std of received times: %e s\n", std(rxTimes(r, :)));
    fprintf(" Std of received frequencies: %e Hz\n", std(rxFreqs(r, :)));
    fprintf(" Std of estimated signal DoA: %f º \n", rad2deg(std(estDoas(r, :))));
end

%- Resulting estimations
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
fprintf("\n Position bias: X = %f m; Y = %f m\n", biasEstPosB);
fprintf("\n Estimated position std: X = %f m; Y = %f m\n", stdEstPosB);

%- CDFs for comparison
figure;
cdfplot(errEstPosA); hold on;
cdfplot(errEstPosB);
xlabel("Error [m]");
ylabel("CDF");
title("CDF of error in estimated position");
legend('TDoA/FDoA', 'RSS/DoA');

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

%% 2D plot
scale   =   10;
figure; set(gcf, 'Position',  [400, 50, 950, 900]);
rxPos   =   cell2mat({rx.pos}.');
rxVel   =   cell2mat({rx.vel}.').*scale;
scatter(rxPos(:, 1), rxPos(:, 2), 'b', 'v'); hold on;
quiver(rxPos(:, 1), rxPos(:, 2), rxVel(:, 1), rxVel(:, 2), 'b'); hold on;


if showScenario
        %- Actual positions
        scatter(tx.pos(1), tx.pos(2), 'g', 'x'); hold on;
        %- Estimated positions
        %-- TDoA/FDoA
        color   =   rand(1, 3);
        scatter(meanEstPosA(1), meanEstPosA(2), [], color, 'o'); 
        hold on;
        C       =   cov(txEstPosA);
        error_ellipse(C, meanEstPosA, 'style', '--', 'Color', color); 
        %-- RSS/DoA
        color   =   rand(1, 3);
        scatter(meanEstPosB(1), meanEstPosB(2), [], color, 's');
        hold on;
        C       =   cov(txEstPosB);
        error_ellipse(C, meanEstPosB, 'style', '--', 'Color', color);
end

xlabel('x'); ylabel('y');
L = legend('a', 'b', 'c', 'd', 'e', 'f', 'Location', 'best');
v = findall(gcf, 'marker', 'v');
set(v, 'DisplayName', 'Rx positions');
x = findall(gcf, 'marker', 'x');
set(x, 'DisplayName', 'Actual Tx position');
o = findall(gcf, 'marker', 'o');
set(o, 'DisplayName', 'TDoA/FDoA estimation');
s = findall(gcf, 'marker', 's');
set(s, 'DisplayName', 'RSS/DoA estimation');
l1 = findall(gcf, 'linestyle', '--');
set(l1, 'DisplayName', '50% error ellipse');
l2 = findall(gcf, 'linestyle', '-');
set(l2, 'DisplayName', 'Rx velocities');


