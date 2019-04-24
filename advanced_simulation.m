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
var.dir             =   sign(var.end - var.start); %        Gets direction of movement
%-- Constant parameters, value of changin parameter will be ignored
const.rad           =   3000;           %       [m]         Value for when radius is constant
const.azim          =   45;             %      [deg]        Value for when azimuth is constant
const.elev          =   45;             %      [deg]        Value for when elevation is constant
const.vel           =   0.01;           % [rad/s] or [m/s]  Angular velocity (for 'a' and 'e') or linear velocity (for 'r')

%- Receiver parameters
rx(1).pos           =   [0, 0, 0];      %     [m, m, m]     Rx1 position
rx(1).vel           =   [0, 0, 0];      %  [m/s, m/s, m/s]  Rx1 velocity
rx(1).orientation   =   0;              %       [rad]       Orientation of the ULA wrt. the X axis
rx(2).pos           =   [400, 0, 0];    %     [m, m, m]     Rx2 position
rx(2).vel           =   [0, 0, 0];      %  [m/s, m/s, m/s]  Rx2 velocity
rx(2).orientation   =   0;              %       [rad]       Orientation of the ULA wrt. the X axis
rx(3).pos           =   [-400, 0, 0];   %     [m, m, m]     Rx3 position
rx(3).vel           =   [0, 0, 0];      %  [m/s, m/s, m/s]  Rx3 velocity
rx(3).orientation   =   0;              %       [rad]       Orientation of the ULA wrt. the X axis
rx(4).pos           =   [0, 400, 0];    %     [m, m, m]     Rx4 position
rx(4).vel           =   [0, 0, 0];      %  [m/s, m/s, m/s]  Rx4 velocity
rx(4).orientation   =   0;              %       [rad]       Orientation of the ULA wrt. the X axis
rx(5).pos           =   [0, 0, 400];    %     [m, m, m]     Rx5 position
rx(5).vel           =   [0, 0, 0];      %  [m/s, m/s, m/s]  Rx5 velocity
rx(5).orientation   =   0;              %       [rad]       Orientation of the ULA wrt. the X axis
rx(6).pos           =   [0, 0, -400];   %     [m, m, m]     Rx6 position
rx(6).vel           =   [0, 0, 0];      %  [m/s, m/s, m/s]  Rx6 velocity
rx(6).orientation   =   0;              %       [rad]       Orientation of the ULA wrt. the X axis

%- Scenario parameters
scen.showBand       =   false;          %                   When enabled, PSD and "Square-PSD" will be plotted
scen.bw             =   1.023 * 1e6;    %       [Hz]        Transmitted signal bandwidth TODO: define it as BW at -3dB
scen.shape          =   'r';            %                   Signal band shape: 'r' -> rectangular, 's' -> sinc, 't' -> triangle
scen.freq           =   1575.42 * 1e6;  %       [Hz]        Transmitted signal frequency
scen.power          =   17;             %       [dBW]       Transmitted signal power
scen.nFig           =   2;              %       [dB]        Receiver's noise figure
scen.ns             =   50;              %                   Number of samples
scen.n              =   1.000293;       %                   Refractive index
scen.tdoaVar        =   0.0025/(c^2);   %                   Time noise variance. When 0, CRB is used
scen.fdoaVar        =   0.00025/(c^2);  %                   Frequency noise variance. When 0, CRB is used
scen.doaVar         =   0;              %                   DoA error variance. When 0, CRB is used
scen.weighting      =   'Q';            %                   Weigting matrix used on LS. I for identity, Q for covariance
scen.numRx          =   length(rx);     %                   Number of receivers
scen.refIndex       =   1;              %                   Reference receiver index
scen.MSBW           =   get_MS_BW(scen);%                   Mean Square Bandwidth
scen.c0             =   1;              %                   Average multiplicative gain
scen.gamma          =   5;              %                   Path loss exponent
scen.sigmaS         =   6;              %       [dB]        Shadowing standard deviation
scen.corrDist       =   5;              %       [m]         Correlation distance within which the shadowing effects among nodes are correlated
scen.spacing        =   0;              %       [m]         Spacing between array elements. If 0, set to lambda/2
scen.nAnt           =   2;              %                   Number of antennas of the array

%- Vectors of movement of the transmitter
[radius, azim, elev, plotOpt] = build_tx_movement(var, const);

%% --- SIMULATION ---
tic
% Vectors definition
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

s.pos       =   nan(1, 3);
s.vel       =   nan(1, 3);
tx          =   repmat(s, var.steps, 1);
est         =   repmat(s, var.steps, 1);
for i = 1:var.steps
    fprintf("Step %i\n", i);
    tx(i)   =   obtain_tx_info(radius(i), azim(i), elev(i), const.vel, var);
    [~, ~, ~, txEstPos, txEstVel, txEstPosB]   =   simulate_scenario(N, scen, tx(i), rx);
    
    %-- Position and velocity averages
    est(i).pos          =   mean(txEstPos, 1);
    est(i).vel          =   mean(txEstVel, 1);
    %-- Bias and standard deviation in Position
    pos.x.bias(i)       =   est(i).pos(1) - tx(i).pos(1);
    pos.x.std(i)        =   std(txEstPos(:, 1));
    pos.y.bias(i)       =   est(i).pos(2) - tx(i).pos(2);
    pos.y.std(i)        =   std(txEstPos(:, 2));
    pos.z.bias(i)       =   est(i).pos(3) - tx(i).pos(3);
    pos.z.std(i)        =   std(txEstPos(:, 3));
    %-- Bias and standard deviation in Velocity
    vel.x.bias(i)       =   est(i).vel(1) - tx(i).vel(1);
    vel.x.std(i)        =   std(txEstVel(:, 1));
    vel.y.bias(i)       =   est(i).vel(2) - tx(i).vel(2);
    vel.y.std(i)        =   std(txEstVel(:, 2));
    vel.z.bias(i)       =   est(i).vel(3) - tx(i).vel(3);
    vel.z.std(i)        =   std(txEstVel(:, 3));
end
toc

%% --- RESULTS ---

% fprintf("\n ========= Results =========\n")

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

if showScenario
    scale = 10;
    figure; set(gcf, 'Position',  [100, 100, 1200, 800]);
    legend;
    for i = 1:var.steps
        %- Actual positions
        name    =   sprintf("Receiver at t=%d", i);
        scatter3(tx(i).pos(1), tx(i).pos(2), tx(i).pos(3), 'g', 'x', 'DisplayName', name); hold on;
        quiver3(tx(i).pos(1), tx(i).pos(2), tx(i).pos(3), ...
            tx(i).vel(1)*scale, tx(i).vel(2)*scale, tx(i).vel(3)*scale, 'g'); hold on;
        %- Estimated positions
        name    =   sprintf("Estimation at t=%d", i);
        scatter3(est(i).pos(1), est(i).pos(2), est(i).pos(3), 'r', 'x', 'DisplayName', name); hold on;
        quiver3(est(i).pos(1), est(i).pos(2), est(i).pos(3), ...
            est(i).vel(1)*scale, est(i).vel(2)*scale, est(i).vel(3)*scale, 'r'); hold on;
    end
    for i = 1:scen.numRx
        scatter3(rx(i).pos(1), rx(i).pos(2), rx(i).pos(3), 'b', 'x', 'DisplayName', 'Receivers'); hold on;
        quiver3(rx(i).pos(1), rx(i).pos(2), rx(i).pos(3), ...
            rx(i).vel(1)*scale, rx(i).vel(2)*scale, rx(i).vel(3)*scale, 'b'); hold on;
    end
    xlabel('x'); ylabel('y'); zlabel('z');
end

