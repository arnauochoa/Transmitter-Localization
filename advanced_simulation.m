clearvars; close all; clc;
addpath 'Estimation';
addpath 'Observables';
addpath 'Scenario';

%% --- PARAMETERS DEFINITION ---
%- Simulation parameters
showScenario    =   true;           % Shows position over 3D space
N               =   1000;           % Number of realizations

%- Transmitter parameters
%-- Variable parameter values, 'r' - radius, 'a' - azimuth, 'e' - elevation
var.id      =   'r';                % Parameter that will change
var.start   =   1000;                % Start value of the variable parameter [m] or [deg]
var.end     =   5000;                 % End value of the variable parameter [m] or [deg]
var.steps   =   15;                  % Number of steps for the variable parameter
%-- Constant parameters, value of changin parameter will be ignored
const.rad   =   3000;               % Value for when radius is constant [m]
const.azim  =   45;                 % Value for when azimuth is constant [deg]
const.elev  =   45;                 % Value for when elevation is constant [deg]
const.angW  =   0.01;               % Angular velocity [rad/s]

%- Receiver parameters
numRx       =   6;                  % Number of receivers
dim         =   3;                  % Dimensions
rx(1).pos   =   [0, 0, 0];          % Rx1 position
rx(1).vel   =   [0, 0, 0];          % Rx1 velocity
rx(2).pos   =   [400, 0, 0];        % Rx2 position
rx(2).vel   =   [0, 0, 0];          % Rx2 velocity
rx(3).pos   =   [-400, 0, 0];       % Rx3 position
rx(3).vel   =   [0, 0, 0];          % Rx3 velocity
rx(4).pos   =   [0, 400, 0];        % Rx4 position
rx(4).vel   =   [0, 0, 0];          % Rx4 velocity
rx(5).pos   =   [0, 0, 400];        % Rx5 position
rx(5).vel   =   [0, 0, 0];          % Rx5 velocity
rx(6).pos   =   [0, 0, -400];       % Rx6 position
rx(6).vel   =   [0, 0, 0];          % Rx6 velocity

%- Scenario parameters
txFreq      =   1575.42;            % Transmission frequency [MHz]
SNR_dB      =   10;                 % Signal-to-Noise Ratio [dB]
Ns          =   2;                  % Number of samples 
scen        =   struct('freq', txFreq * 1e6, 'snr', db2pow(SNR_dB), 'ns', Ns);

%- Vectors of movement of the transmitter
[radius, azim, elev, plotOpt] = build_tx_movement(var, const);

%% --- SIMULATION ---

aux.pos =   zeros(1,3);
aux.vel =   zeros(1,3);
est     =   repmat(aux, 1, var.steps);
biasPos    =   zeros(1, var.steps);
stdPos   =   zeros(1, var.steps);
for i = 1:var.steps
    tx = obtain_tx_info(radius(i), azim(i), elev(i), const.angW);
    [~, ~, txEstPos, txEstVel] = simulate_scenario(N, scen, tx, rx);
    meanEstPos = mean(txEstPos, 1);
    
    biasPos(i) = sqrt(sum((meanEstPos - tx.pos).^2));
    stdPos(i) = std(sqrt(sum((meanEstPos).^2)));
end

%% --- RESULTS ---


fprintf("\n ========= Results =========\n");



if (var.id == 'r' || var.id == 'a' ||var.id == 'e')
    figure;
    plot(plotOpt.xVect, biasPos, '-o');
    ylabel("Error (m)");
    xlabel(plotOpt.label);
    title(sprintf("Bias in estimation, %s %s", plotOpt.c1, plotOpt.c2));
end

