clearvars; close all; clc;
addpath 'Estimation';
addpath 'Misc';
addpath 'Observables';
addpath 'Scenario';

%% --- PARAMETERS DEFINITION ---
%- Simulation parameters
showScenario        =   true;           %                   Shows position over 3D space
N                   =   500;            %                   Number of realizations
c                   =   299792458;      %      [m/s]        Speed of light

%- Transmitter parameters
%-- Variable parameter values, 'r' - radius, 'a' - azimuth, 'e' - elevation
var.id              =   'e';            %                   Parameter that will change
var.start           =   -40;            %   [m] or [deg]    Start value of the variable parameter
var.end             =   40;             %   [m] or [deg]    End value of the variable parameter 
var.steps           =   9;              %                   Number of steps for the variable parameter
%-- Constant parameters, value of changin parameter will be ignored
const.rad           =   3000;           %       [m]         Value for when radius is constant
const.azim          =   45;             %      [deg]        Value for when azimuth is constant
const.elev          =   45;             %      [deg]        Value for when elevation is constant
const.angW          =   0.01;           %     [rad/s]       Angular velocity

%- Receiver parameters
rx(1).pos           =   [0, 0, 0];      %     [m, m, m]     Rx1 position
rx(1).vel           =   [0, 0, 0];      %  [m/s, m/s, m/s]  Rx1 velocity
rx(2).pos           =   [400, 0, 0];    %     [m, m, m]     Rx2 position
rx(2).vel           =   [0, 0, 0];      %  [m/s, m/s, m/s]  Rx2 velocity
rx(3).pos           =   [-400, 0, 0];   %     [m, m, m]     Rx3 position
rx(3).vel           =   [0, 0, 0];      %  [m/s, m/s, m/s]  Rx3 velocity
rx(4).pos           =   [0, 400, 0];    %     [m, m, m]     Rx4 position
rx(4).vel           =   [0, 0, 0];      %  [m/s, m/s, m/s]  Rx4 velocity
rx(5).pos           =   [0, 0, 400];    %     [m, m, m]     Rx5 position
rx(5).vel           =   [0, 0, 0];      %  [m/s, m/s, m/s]  Rx5 velocity
rx(6).pos           =   [0, 0, -400];   %     [m, m, m]     Rx6 position
rx(6).vel           =   [0, 0, 0];      %  [m/s, m/s, m/s]  Rx6 velocity

%- Scenario parameters
scen.showBand       =   false;          %                   When enabled, PSD and "Square-PSD" will be plotted
scen.bw             =   1.023 * 1e6;    %                   Transmitted signal bandwidth at -3dB[Hz]
scen.shape          =   'r';            %                   Signal band shape: 'r' -> rectangular, 's' -> sinc, 't' -> triangle
scen.freq           =   1575.42 * 1e6;  %       [Hz]        Transmitted signal frequency
scen.power          =   17;             %       [dBW]       Transmitted signal power
scen.nFig           =   2;              %       [dB]        Receiver's noise figure
scen.ns             =   2;              %                   Number of samples
scen.n              =   1.000293;       %                   Refractive index
scen.timeNoiseVar   =   0.0025/(c^2);   %                   Time noise variance. When 0, CRB is used
scen.freqNoiseVar   =   0.00025/(c^2);  %                   Frequency noise variance. When 0, CRB is used
scen.weighting      =   'Q';            %                   Weigting matrix used on LS. I for identity, Q for covariance
scen.numRx          =   length(rx);     %                   Number of receivers
scen.refIndex       =   1;              %                   Reference receiver index
scen.MSBW           =   get_MS_BW(scen);%                   Mean Square Bandwidth

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

tic
for i = 1:var.steps
    fprintf("Step %i\n", i);
    tx = obtain_tx_info(radius(i), azim(i), elev(i), const.angW);
    [~, ~, ~, txEstPos, txEstVel] = simulate_scenario(N, scen, tx, rx);
    
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
toc

%% --- RESULTS ---

% fprintf("\n ========= Results =========\n");

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

