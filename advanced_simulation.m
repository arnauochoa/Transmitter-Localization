clearvars; close all; clc;
addpath 'Estimation';
addpath 'Misc';
addpath 'Observables';
addpath 'Scenario';

%% --- PARAMETERS DEFINITION ---
global v N nDim scen;

%- Simulation parameters
showScenario        =   true;           %                   Shows position over 3D space
c                   =   299792458;      %       [m/s]       Speed of light
n                   =   1.000293;       %                   Refractive index
v                   =   c/n;            %       [m/s]       Propagation speed
N                   =   10;             %                   Number of realizations
nDim                =   2;              %                   Number of dimensions (now only 2)

%- Transmitter parameters
%-- Variable parameter values, 'r' - radius, 'a' - azimuth
var.id              =   'a';            %                   Parameter that will change
var.start           =   0;              %   [m] or [deg]    Start value of the variable parameter
var.end             =   360;            %   [m] or [deg]    End value of the variable parameter 
var.steps           =   10;             %                   Number of steps for the variable parameter
var.dir             =   sign(var.end - var.start); %        Gets direction of movement
%-- Constant parameters, value of changin parameter will be ignored
const.rad           =   500;            %       [m]         Value for when radius is constant
const.azim          =   45;             %      [deg]        Value for when azimuth is constant
% const.elev          =   45;           %      [deg]        Value for when elevation is constant
const.vel           =   0.01;           % [rad/s] or [m/s]  Angular velocity (for 'a' and 'e') or linear velocity (for 'r')

%- Receiver parameters
rx(1).pos           =   [0, 0];         %    [m]        Rx1 position
rx(1).vel           =   [0, 0];         %   [m/s]       Rx1 velocity
rx(1).orientation   =   0;              %   [rad]       Orientation of the ULA wrt. the X axis
rx(2).pos           =   [400, 0];       %    [m]        Rx2 position
rx(2).vel           =   [0, 0];         %   [m/s]       Rx2 velocity
rx(2).orientation   =   0;              %   [rad]       Orientation of the ULA wrt. the X axis
rx(3).pos           =   [-400, 0];      %    [m]        Rx3 position
rx(3).vel           =   [0, 0];         %   [m/s]       Rx3 velocity
rx(3).orientation   =   0;              %   [rad]       Orientation of the ULA wrt. the X axis
rx(4).pos           =   [0, 400];       %    [m]        Rx4 position
rx(4).vel           =   [0, 0];         %   [m/s]       Rx4 velocity
rx(4).orientation   =   0;              %   [rad]       Orientation of the ULA wrt. the X axis
% rx(5).pos           =   [0, 0];         %    [m]        Rx5 position
% rx(5).vel           =   [0, 0];         %   [m/s]       Rx5 velocity
% rx(5).orientation   =   0;              %   [rad]       Orientation of the ULA wrt. the X axis
% rx(6).pos           =   [0, 0];         %    [m]        Rx6 position
% rx(6).vel           =   [0, 0];         %   [m/s]       Rx6 velocity
% rx(6).orientation   =   0;              %   [rad]       Orientation of the ULA wrt. the X axis

%- Scenario parameters
scen.showBand       =   false;          %               When enabled, PSD and "Square-PSD" will be plotted
scen.bw             =   1.023 * 1e6;    %   [Hz]        Transmitted signal bandwidth TODO: define it as BW at -3dB
scen.shape          =   'r';            %               Signal band shape: 
                                        %                   'r' -> rectangular, 's' -> sinc, 't' -> triangle
scen.freq           =   1575.42 * 1e6;  %   [Hz]        Transmitted signal frequency
scen.power          =   17;             %   [dBW]       Transmitted signal power
scen.nFig           =   2;              %   [dB]        Receiver's noise figure
scen.ns             =   50;             %               Number of samples
scen.temp           =   290;            %   [K]         Ambient temperature
scen.tdoaVar        =   0.0025/(c^2);   %               Time noise variance. When 0, CRB is used
scen.fdoaVar        =   0.00025/(c^2);  %               Frequency noise variance. When 0, CRB is used
scen.doaVar         =   0;              %               DoA error variance. When 0, CRB is used
scen.weighting      =   'Q';            %               Weigting matrix used on LS. I for identity, Q for covariance
scen.numRx          =   length(rx);     %               Number of receivers
scen.refIndex       =   1;              %               Reference receiver index
scen.c0             =   1;              %               Average multiplicative gain
scen.gamma          =   2;              %               Path loss exponent
scen.sigmaS         =   6;              %   [dB]        Shadowing standard deviation
scen.corrDist       =   5;              %   [m]         Correlation distance within which 
                                        %                   the shadowing effects among nodes are correlated
scen.spacing        =   0;              %   [m]         Spacing between array elements. If 0, set to lambda/2
scen.nAnt           =   2;              %                   Number of antennas of the array
scen.MSBW           =   get_MS_BW();    %               Mean Square Bandwidth

%- Vectors of movement of the transmitter
[radius, azim, plotOpt] = build_tx_movement(var, const);

%% --- SIMULATION ---
tic
% Vectors definition
%- TDOA/FDOA
pos.x.biasA  =   zeros(1, var.steps);
pos.x.stdA   =   zeros(1, var.steps);
pos.y.biasA  =   zeros(1, var.steps);
pos.y.stdA   =   zeros(1, var.steps);
%- RSS/DOA
pos.x.biasB  =   zeros(1, var.steps);
pos.x.stdB   =   zeros(1, var.steps);
pos.y.biasB  =   zeros(1, var.steps);
pos.y.stdB   =   zeros(1, var.steps);

%- TDOA/FDOA
vel.x.biasA  =   zeros(1, var.steps);
vel.x.stdA   =   zeros(1, var.steps);
vel.y.biasA  =   zeros(1, var.steps);
vel.y.stdA   =   zeros(1, var.steps);
%- RSS/DOA
vel.x.biasB  =   zeros(1, var.steps);
vel.x.stdB   =   zeros(1, var.steps);
vel.y.biasB  =   zeros(1, var.steps);
vel.y.stdB   =   zeros(1, var.steps);

s.pos       =   nan(1, 2);
s.vel       =   nan(1, 2);
tx          =   repmat(s, var.steps, 1);
estA        =   repmat(s, var.steps, 1);
estB        =   repmat(s, var.steps, 1);
for i = 1:var.steps
    fprintf("Step %i\n", i);
    tx(i)   =   obtain_tx_info(radius(i), azim(i), const.vel, var);
    [~, ~, ~, txEstPosA, txEstVelA, txEstPosB]   =   simulate_scenario(tx(i), rx);
    
    %-- Position and velocity averages
    estA(i).pos          =   mean(txEstPosA, 1);
    estA(i).vel          =   mean(txEstVelA, 1);
    estB(i).pos          =   mean(txEstPosB, 1);
    %-- Bias and standard deviation in Position
    pos.x.biasA(i)       =   estA(i).pos(1) - tx(i).pos(1);
    pos.x.stdA(i)        =   std(txEstPosA(:, 1));
    pos.y.biasA(i)       =   estA(i).pos(2) - tx(i).pos(2);
    pos.y.stdA(i)        =   std(txEstPosA(:, 2));
    
    pos.x.biasB(i)       =   estB(i).pos(1) - tx(i).pos(1);
    pos.x.stdB(i)        =   std(txEstPosB(:, 1));
    pos.y.biasB(i)       =   estB(i).pos(2) - tx(i).pos(2);
    pos.y.stdB(i)        =   std(txEstPosB(:, 2));
    %-- Bias and standard deviation in Velocity
    vel.x.biasA(i)       =   estA(i).vel(1) - tx(i).vel(1);
    vel.x.stdA(i)        =   std(txEstVelA(:, 1));
    vel.y.biasA(i)       =   estA(i).vel(2) - tx(i).vel(2);
    vel.y.stdA(i)        =   std(txEstVelA(:, 2));
end
toc

%% --- RESULTS ---

if (var.id == 'r' || var.id == 'a')
    %- Bias of the position
    %-- TDoA/FDoA
    f1 = figure; set(f1, 'Position', [10, 600, 400, 500]);
    subplot(2,1,1);
    plot(plotOpt.xVect, pos.x.biasA, '-o');
    title("Position bias (TDoA/FDoA)");
    ylabel("Bias of position (X) (m)");
    xlabel(plotOpt.label);
    subplot(2,1,2);
    plot(plotOpt.xVect, pos.y.biasA, '-o');
    ylabel("Bias of position (Y) (m)");
    xlabel(plotOpt.label);
    %-- RSS/DoA
    f1 = figure; set(f1, 'Position', [10, 0, 400, 500]);
    subplot(2,1,1);
    plot(plotOpt.xVect, pos.x.biasB, '-o');
    title("Position bias (RSS/DoA)");
    ylabel("Bias of position (X) (m)");
    xlabel(plotOpt.label);
    subplot(2,1,2);
    plot(plotOpt.xVect, pos.y.biasB, '-o');
    ylabel("Bias of position (Y) (m)");
    xlabel(plotOpt.label);
    
    %- Standard deviation of the position
    %-- TDoA/FDoA
    f2 = figure; set(f2, 'Position',  [420, 600, 400, 500]);
    subplot(2,1,1);
    plot(plotOpt.xVect, pos.x.stdA, '-o');
    title("Position standard deviation (TDoA/FDoA)");
    ylabel("STD of position (X) (m)");
    xlabel(plotOpt.label);
    subplot(2,1,2);
    plot(plotOpt.xVect, pos.y.stdA, '-o');
    ylabel("STD of position (Y) (m)");
    xlabel(plotOpt.label);
    %-- RSS/DoA
    f2 = figure; set(f2, 'Position',  [420, 0, 400, 500]);
    subplot(2,1,1);
    plot(plotOpt.xVect, pos.x.stdB, '-o');
    title("Position standard deviation (RSS/DoA)");
    ylabel("STD of position (X) (m)");
    xlabel(plotOpt.label);
    subplot(2,1,2);
    plot(plotOpt.xVect, pos.y.stdB, '-o');
    ylabel("STD of position (Y) (m)");
    xlabel(plotOpt.label);
    
    %- Bias of the velocity
    f3 = figure;  set(f3, 'Position',  [850, 600, 400, 500]);
    subplot(2,1,1);
    plot(plotOpt.xVect, vel.x.biasA, '-o');
    title("Velocity bias (TDoA/FDoA)");
    ylabel("Bias of velocity (X) (m/s)");
    xlabel(plotOpt.label);
    subplot(2,1,2);
    plot(plotOpt.xVect, vel.y.biasA, '-o');
    ylabel("Bias of velocity (Y) (m/s)");
    xlabel(plotOpt.label);
    
    %- Standard deviation of the velocity
    f4 = figure;  set(f4, 'Position',  [1240, 600, 400, 500]);
    subplot(2,1,1);
    plot(plotOpt.xVect, vel.x.stdA, '-o');
    title("Velocity standard deviation (TDoA/FDoA)");
    ylabel("STD of velocity (X) (m/s)");
    xlabel(plotOpt.label);
    subplot(2,1,2);
    plot(plotOpt.xVect, vel.y.stdA, '-o');
    ylabel("STD of velocity (Y) (m/s)");
    xlabel(plotOpt.label);
end

if showScenario
    scale = 10;
    figure; set(gcf, 'Position',  [400, 50, 950, 900]);
    legend;
    for i = 1:var.steps
        %- Actual positions
        name    =   sprintf("Receiver at t=%d", i);
        scatter(tx(i).pos(1), tx(i).pos(2), 'g', 'x', 'DisplayName', name); hold on;
        quiver(tx(i).pos(1), tx(i).pos(2), ...
            tx(i).vel(1)*scale, tx(i).vel(2)*scale, 'g'); hold on;
        %- Estimated positions
        name    =   sprintf("(TDoA/FDoA) Estimation at t=%d", i);
        scatter(estA(i).pos(1), estA(i).pos(2), 'r', 'x', 'DisplayName', name); hold on;
        quiver(estA(i).pos(1), estA(i).pos(2), ...
            estA(i).vel(1)*scale, estA(i).vel(2)*scale, 'r'); hold on;
        
        name    =   sprintf("(RSS/DoA) Estimation at t=%d", i);
        scatter(estB(i).pos(1), estB(i).pos(2), 'm', 'x', 'DisplayName', name); hold on;
    end
    for i = 1:scen.numRx
        scatter(rx(i).pos(1), rx(i).pos(2), 'b', 'x', 'DisplayName', 'Receivers'); hold on;
        quiver(rx(i).pos(1), rx(i).pos(2), ...
            rx(i).vel(1)*scale, rx(i).vel(2)*scale, 'b'); hold on;
    end
    xlabel('x'); ylabel('y');
end

