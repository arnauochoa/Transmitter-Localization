clearvars; close all; clc;
addpath 'Estimation';
addpath 'Misc';
addpath 'Observables';
addpath 'Scenario';
addpath 'Tests';
addpath 'Lib/error_ellipse';

%% --- PARAMETERS DEFINITION ---
global v N nDim scen;
%- Simulation parameters
doSave              =   true;
testName            =   input('Name for this test: ', 's');
if isempty(testName), error('A name must be set for this test'); end
showScenario        =   true;           %               Shows position over 2D space
c                   =   299792458;      %    [m/s]      Speed of light
n                   =   1.000293;       %             	Refractive index
v                   =   c/n;            %    [m/s]      Propagation speed
N                   =   500;            %               Number of realizations
nDim                =   2;              %               Number of dimensions (now only 2)

%% - Transmitter parameters
%-- Variable parameter values, 'r' - radius, 'a' - azimuth
azim.start          =   315;            %     [deg]     First value of azimuth
azim.end            =   0;              %     [deg]     Last value of azimuth
azim.steps          =   8;              %               Steps of increment in azimuth

rad.start           =   200;            %     [m]       First value of radius
rad.end             =   600;            %     [m]       Last value of radius
rad.steps           =   3;              %               Steps of increment in radius

mov.vel             =   0.01;           %   [rad/s]     Angular velocity

%% - Receiver parameters
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
rx(5).pos           =   [0, -400];      %    [m]        Rx5 position
rx(5).vel           =   [0, 0];         %   [m/s]       Rx5 velocity
rx(5).orientation   =   0;              %   [rad]       Orientation of the ULA wrt. the X axis

%% - Scenario parameters
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
scen.gamma          =   5;              %               Path loss exponent
scen.sigmaS         =   6;              %   [dB]        Shadowing standard deviation
scen.corrDist       =   5;              %   [m]         Correlation distance within which 
                                        %                   the shadowing effects among nodes are correlated
scen.spacing        =   0;              %   [m]         Spacing between array elements. If 0, set to lambda/2
scen.nAnt           =   2;              %                   Number of antennas of the array
scen.MSBW           =   get_MS_BW();    %               Mean Square Bandwidth

%% - Vectors of movement of the transmitter
mov.dir             =   sign(azim.end - azim.start); %        Gets direction of movement
mov.azimVals        =   linspace(azim.start, azim.end, azim.steps);
mov.radVals         =   linspace(rad.start, rad.end, rad.steps);


tic
%% Vectors definition
%- TDOA/FDOA
pos.x.biasA  =   zeros(rad.steps, azim.steps);
pos.x.stdA   =   zeros(rad.steps, azim.steps);
pos.y.biasA  =   zeros(rad.steps, azim.steps);
pos.y.stdA   =   zeros(rad.steps, azim.steps);
%- RSS/DOA
pos.x.biasB  =   zeros(rad.steps, azim.steps);
pos.x.stdB   =   zeros(rad.steps, azim.steps);
pos.y.biasB  =   zeros(rad.steps, azim.steps);
pos.y.stdB   =   zeros(rad.steps, azim.steps);

%- TDOA/FDOA
vel.x.biasA  =   zeros(rad.steps, azim.steps);
vel.x.stdA   =   zeros(rad.steps, azim.steps);
vel.y.biasA  =   zeros(rad.steps, azim.steps);
vel.y.stdA   =   zeros(rad.steps, azim.steps);
%- RSS/DOA
vel.x.biasB  =   zeros(rad.steps, azim.steps);
vel.x.stdB   =   zeros(rad.steps, azim.steps);
vel.y.biasB  =   zeros(rad.steps, azim.steps);
vel.y.stdB   =   zeros(rad.steps, azim.steps);

s.pos       =   nan(1, 2);
s.vel       =   nan(1, 2);
tx          =   repmat(s, rad.steps, azim.steps);
estA        =   repmat(s, rad.steps, azim.steps);
estB        =   repmat(s, rad.steps, azim.steps);

txEstPosA   =   zeros(N, nDim, rad.steps, azim.steps);
txEstPosB   =   zeros(N, nDim, rad.steps, azim.steps);

%% --- SIMULATION ---

for r = 1:rad.steps
    fprintf("RadStep %i\n", r);
    for a = 1:azim.steps
        fprintf("Step %i\n", a);
        tx(r, a)   =   obtain_tx_info(mov.radVals(r), mov.azimVals(a), mov.vel, mov.dir);
        [~, ~, ~, txEstPosA(:, :, r, a), txEstVelA, txEstPosB(:, :, r, a)] ...
            =   simulate_scenario(tx(r, a), rx);

        %-- Position and velocity averages
        estA(r, a).pos          =   mean(txEstPosA(:, :, r, a), 1);
        estA(r, a).vel          =   mean(txEstVelA, 1);
        estB(r, a).pos          =   mean(txEstPosB(:, :, r, a), 1);
        %-- Bias and standard deviation in Position
        pos.x.biasA(r, a)       =   estA(r, a).pos(1) - tx(r, a).pos(1);
        pos.x.stdA(r, a)        =   std(txEstPosA(:, 1, r, a));
        pos.y.biasA(r, a)       =   estA(r, a).pos(2) - tx(r, a).pos(2);
        pos.y.stdA(r, a)        =   std(txEstPosA(:, 2, r, a));

        pos.x.biasB(r, a)       =   estB(r, a).pos(1) - tx(r, a).pos(1);
        pos.x.stdB(r, a)        =   std(txEstPosB(:, 1, r, a));
        pos.y.biasB(r, a)       =   estB(r, a).pos(2) - tx(r, a).pos(2);
        pos.y.stdB(r, a)        =   std(txEstPosB(:, 2, r, a));
        %-- Bias and standard deviation in Velocity
        vel.x.biasA(r, a)       =   estA(r, a).vel(1) - tx(r, a).vel(1);
        vel.x.stdA(r, a)        =   std(txEstVelA(:, 1));
        vel.y.biasA(r, a)       =   estA(r, a).vel(2) - tx(r, a).vel(2);
        vel.y.stdA(r, a)        =   std(txEstVelA(:, 2));
    end
end
toc

%% --- RESULTS ---

if showScenario
    scale = 10;
    fig(1) = figure; set(fig(1), 'Position',  [400, 50, 950, 900]);
    legend;
    for r = 1:rad.steps
        for a = 1:azim.steps
            %- Actual positions
            name    =   sprintf("Receiver at t=%d", a);
            scatter(tx(r, a).pos(1), tx(r, a).pos(2), 'g', 'x', 'DisplayName', name); 
            hold on;
            quiver(tx(r, a).pos(1), tx(r, a).pos(2), ...
                tx(r, a).vel(1)*scale, tx(r, a).vel(2)*scale, 'g'); hold on;
            %- Estimated positions
            name    =   sprintf("(TDoA/FDoA) Estimation at t=%d", a);
            scatter(estA(r, a).pos(1), estA(r, a).pos(2), 'r', 'x', 'DisplayName', name); 
            hold on;
            quiver(estA(r, a).pos(1), estA(r, a).pos(2), ...
                estA(r, a).vel(1)*scale, estA(r, a).vel(2)*scale, 'r'); hold on;

            name    =   sprintf("(RSS/DoA) Estimation at t=%d", a);
            scatter(estB(r, a).pos(1), estB(r, a).pos(2), 'm', 'x', 'DisplayName', name); 
            hold on;
        end
    end
    for i = 1:scen.numRx
        scatter(rx(i).pos(1), rx(i).pos(2), 'b', 'x', 'DisplayName', 'Receivers'); 
        hold on;
        quiver(rx(i).pos(1), rx(i).pos(2), ...
            rx(i).vel(1)*scale, rx(i).vel(2)*scale, 'b'); hold on;
    end
    xlabel('x'); ylabel('y');
end

if doSave
    directory = sprintf('Results/%s/', testName);
    if ~exist(directory, 'dir')
        mkdir(directory);
    end
    dataFile = strcat(directory, 'data');
    save(dataFile, 'mov', 'scen', 'rad', 'azim', 'rx', 'tx', 'pos', 'vel', 'estA', ...
        'estB', 'txEstPosA', 'txEstPosB', 'txEstVelA', 'nDim');

    for a = 1:length(fig)
        saveas(figure(a), sprintf('%sfig_%d.fig', directory, a));
    end

    close all;
end

