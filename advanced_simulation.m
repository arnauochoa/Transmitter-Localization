clearvars; close all; clc;
addpath 'Estimation';
addpath 'Observables';
addpath 'Scenario';

%% --- PARAMETERS DEFINITION ---
%- Simulation parameters
showScenario    =   true;           % Shows position over 3D space
N               =   500;           % Number of realizations

%- Transmitter parameters
%-- Variable parameter values, 'r' - radius, 'a' - azimuth, 'e' - elevation
var.id      =   'e';                % Parameter that will change
var.start   =   -40;               % Start value of the variable parameter [m] or [deg]
var.end     =   40;               % End value of the variable parameter [m] or [deg]
var.steps   =   9;                 % Number of steps for the variable parameter
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

aux.pos     =   zeros(1,3);
aux.vel     =   zeros(1,3);
est         =   repmat(aux, 1, var.steps);

pos.x.bias  =   zeros(1, var.steps);
pos.x.std   =   zeros(1, var.steps);
pos.y.bias  =   zeros(1, var.steps);
pos.y.std   =   zeros(1, var.steps);
pos.z.bias  =   zeros(1, var.steps);
pos.z.std   =   zeros(1, var.steps);

vel.x.bias  =   zeros(1, var.steps);
vel.x.std   =   zeros(1, var.steps);
vel.y.bias  =   zeros(1, var.steps);
vel.y.std   =   zeros(1, var.steps);
vel.z.bias  =   zeros(1, var.steps);
vel.z.std   =   zeros(1, var.steps);

for i = 1:var.steps
    tx = obtain_tx_info(radius(i), azim(i), elev(i), const.angW);
    [~, ~, txEstPos, txEstVel] = simulate_scenario(N, scen, tx, rx);
    
    %-- Position and velocity averages
    meanEstPos      =   mean(txEstPos, 1);
    meanEstVel      =   mean(txEstVel, 1);
    %-- Bias and standard deviation in Position
    pos.x.bias(i)   =   meanEstPos(1) - tx.pos(1);
    pos.x.std(i)    =   std(txEstPos(:, 1));
    pos.y.bias(i)   =   meanEstPos(2) - tx.pos(2);
    pos.y.std(i)    =   std(txEstPos(:, 2));
    pos.z.bias(i)   =   meanEstPos(3) - tx.pos(3);
    pos.z.std(i)    =   std(txEstPos(:, 3));
    %-- Bias and standard deviation in Velocity
    vel.x.bias(i)   =   meanEstVel(1) - tx.vel(1);
    vel.x.std(i)    =   std(txEstVel(:, 1));
    vel.y.bias(i)   =   meanEstVel(2) - tx.vel(2);
    vel.y.std(i)    =   std(txEstVel(:, 2));
    vel.z.bias(i)   =   meanEstVel(3) - tx.vel(3);
    vel.z.std(i)    =   std(txEstVel(:, 3));
end

%% --- RESULTS ---


fprintf("\n ========= Results =========\n");



if (var.id == 'r' || var.id == 'a' ||var.id == 'e')
    %- Bias of the position
    f1 = figure; set(f1, 'Position', [10, 600, 400, 500]);
    subplot(3,1,1);
    plot(plotOpt.xVect, pos.x.bias, '-o');
    title("Position bias");
    ylabel("Bias of position (X) (m)");
    xlabel(plotOpt.label);
    subplot(3,1,2);
    plot(plotOpt.xVect, pos.y.bias, '-o');
    ylabel("Bias of position (Y) (m)");
    xlabel(plotOpt.label);
    subplot(3,1,3);
    plot(plotOpt.xVect, pos.z.bias, '-o');
    ylabel("Bias of position (Z) (m)");
    xlabel(plotOpt.label);
    
    %- Standard deviation of the position
    f2 = figure; set(f2, 'Position',  [420, 600, 400, 500]);
    subplot(3,1,1);
    plot(plotOpt.xVect, pos.x.std, '-o');
    title("Position standard deviation");
    ylabel("STD of position (X) (m)");
    xlabel(plotOpt.label);
    subplot(3,1,2);
    plot(plotOpt.xVect, pos.y.std, '-o');
    ylabel("STD of position (Y) (m)");
    xlabel(plotOpt.label);
    subplot(3,1,3);
    plot(plotOpt.xVect, pos.z.std, '-o');
    ylabel("STD of position (Z) (m)");
    xlabel(plotOpt.label);
    
    %- Bias of the velocity
    f3 = figure;  set(f3, 'Position',  [830, 600, 400, 500]);
    subplot(3,1,1);
    plot(plotOpt.xVect, vel.x.bias, '-o');
    title("Velocity bias");
    ylabel("Bias of velocity (X) (m/s)");
    xlabel(plotOpt.label);
    subplot(3,1,2);
    plot(plotOpt.xVect, vel.y.bias, '-o');
    ylabel("Bias of velocity (Y) (m/s)");
    xlabel(plotOpt.label);
    subplot(3,1,3);
    plot(plotOpt.xVect, vel.z.bias, '-o');
    ylabel("Bias of velocity (Z) (m/s)");
    xlabel(plotOpt.label);
    
    %- Standard deviation of the velocity
    f4 = figure;  set(f4, 'Position',  [1240, 600, 400, 500]);
    subplot(3,1,1);
    plot(plotOpt.xVect, vel.x.std, '-o');
    title("Velocity standard deviation");
    ylabel("STD of velocity (X) (m/s)");
    xlabel(plotOpt.label);
    subplot(3,1,2);
    plot(plotOpt.xVect, vel.y.std, '-o');
    ylabel("STD of velocity (Y) (m/s)");
    xlabel(plotOpt.label);
    subplot(3,1,3);
    plot(plotOpt.xVect, vel.z.std, '-o');
    ylabel("STD of velocity (Z) (m/s)");
    xlabel(plotOpt.label);
end

