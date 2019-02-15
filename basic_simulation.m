clearvars; close all; clc;
addpath 'Estimation';
addpath 'Observables';
addpath 'Scenario';

%% --- PARAMETERS DEFINITION ---
%- Simulation parameters
showScenario    =   true;              % Shows position over 3D space
N               =   5000;               % Number of realizations
nbins           =   50;

%- Transmitter parameters
tx.pos       =   [2121, 2121, 2298];            % Position X-Y-Z [m]
tx.vel       =   [10, 10, 7];            % Velocity X-Y-Z [m/s]

%- Receiver parameters
numRx       =   6;                      % Number of receivers
dim         =   3;                      % Dimensions
rx(1).pos   =   [0, 0, 0];             % Rx1 position
rx(1).vel   =   [0, 0, 0];              % Rx1 velocity
rx(2).pos   =   [400, 0, 0];            % Rx2 position
rx(2).vel   =   [0, 0, 0];              % Rx2 velocity
rx(3).pos   =   [-400, 0, 0];             % Rx3 position
rx(3).vel   =   [0, 0, 0];             % Rx3 velocity
rx(4).pos   =   [0, 400, 0];             % Rx4 position
rx(4).vel   =   [0, 0, 0];              % Rx4 velocity
rx(5).pos   =   [0, 0, 400];             % Rx5 position
rx(5).vel   =   [0, 0, 0];              % Rx5 velocity
rx(6).pos   =   [0, 0, -400];             % Rx6 position
rx(6).vel   =   [0, 0, 0];              % Rx6 velocity

%- Scenario parameters
txFreq      =   1575.42;                % Transmission frequency [MHz]
SNR_dB      =   10;                      % Signal-to-Noise Ratio [dB]
Ns          =   2;                       % Number of samples 
scen        =   struct('freq', txFreq * 1e6, 'snr', db2pow(SNR_dB), 'ns', Ns);


%% --- SIMULATION ---
[rxTimes, rxFreqs, txEstPos, txEstVel] = simulate_scenario(N, scen, tx, rx);


%% --- RESULTS ---

%-- Results computations
%- Mean
meanEstPos      =   mean(txEstPos, 1);
meanEstVel      =   mean(txEstVel, 1);
%- Bias
biasEstPos      =   meanEstPos - tx.pos;
biasEstVel      =   meanEstVel - tx.vel;
%- Standard deviation
stdEstPos       =   std(txEstPos, 0, 1);
stdEstVel       =   std(txEstVel, 0, 1);
%- Error evolution
errEstPos       =   sqrt(sum(txEstPos - tx.pos, 2).^2);
errEstVel       =   sqrt(sum(txEstVel - tx.vel, 2).^2);


fprintf("\n ========= Observables =========\n");
for r = 1:numRx
    fprintf(" --- Receiver %d ---\n", r);
    fprintf(" Reception time: %f seconds \n", rxTimes(r));
    fprintf(" Received signal frequency: %f MHz \n", rxFreqs(r)/1e6);
end
fprintf(" ------------------\n");
fprintf(" Std of received times: %f s\n", std(rxTimes));
fprintf(" Std of received frequencies: %f Hz\n", std(rxFreqs));

fprintf("\n ========= Results =========\n");
fprintf("\n Actual position: X = %f m; Y = %f m; Z = %f m\n", tx.pos);
fprintf(" Estimated position mean: X = %f m; Y = %f m; Z = %f m \n", meanEstPos);
fprintf("\n Actual velocity: X = %f m/s; Y = %f m/s; Z = %f m/s\n", tx.vel);
fprintf(" Estimated velocity mean: X = %f m/s; Y = %f m/s; Z = %f m/s\n", meanEstVel);
fprintf("\n Position bias: X = %f m; Y = %f m; Z = %f m\n", biasEstPos);
fprintf(" Velocity bias: X = %f m/s; Y = %f m/s; Z = %f m/s\n", biasEstVel);
fprintf("\n Estimated position std: X = %f m; Y = %f m; Z = %f m\n", stdEstVel);
fprintf(" Estimated velocity std: X = %f m/s; Y = %f m/s; Z = %f m/s\n", stdEstVel);

figure;
histogram(errEstPos, nbins);
xlabel("Error [m]");
title("Distribution of error in estimated distance");

figure;
histogram(errEstVel, nbins);
xlabel("Error [m/s]");
title("Distribution of error in estimated velocity");

if showScenario
    scale = 50;
    figure; set(gcf, 'Position',  [100, 100, 1200, 800]);
    legend;
    scatter3(tx.pos(1), tx.pos(2), tx.pos(3), 'r', 'x', 'DisplayName', 'Source'); hold on;
    scatter3(txEstPos(1), txEstPos(2), txEstPos(3), 'g', 'x', 'DisplayName', 'Estimated position'); hold on;
    quiver3(tx.pos(1), tx.pos(2), tx.pos(3), tx.vel(1)*scale, tx.vel(2)*scale, tx.vel(3)*scale, 'r'); hold on;
    quiver3(txEstPos(1), txEstPos(2), txEstPos(3), ...
        txEstVel(1)*scale, txEstVel(2)*scale, txEstVel(3)*scale, 'g'); hold on;
    for i = 1:numRx
        scatter3(rx(i).pos(1), rx(i).pos(2), rx(i).pos(3), 'b', 'x', 'DisplayName', 'Receivers'); hold on;
        quiver3(rx(i).pos(1), rx(i).pos(2), rx(i).pos(3), ...
            rx(i).vel(1)*scale, rx(i).vel(2)*scale, rx(i).vel(3)*scale, 'b'); hold on;
    end
end


