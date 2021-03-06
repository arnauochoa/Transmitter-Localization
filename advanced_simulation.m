% 
% ADVANCED_SIMULATION:  Script used for launching an advanced simulation. In
%                       this simulation the distributions of the receivers
%                       can be defined in rx_distributions and the
%                       positions and velocities of the transmitter can be 
%                       defined with a radius and an angle with respect to 
%                       the position [0, 0]. With the scen struct, the different
%                       parameters describing the scenario can be defined.
%

clearvars; close all; clc;

%% --- PARAMETERS DEFINITION ---
global N nDim ;
%- Simulation parameters
doSave              =   true;
testName            =   input('Name for this test: ', 's');
if isempty(testName), error('A name must be set for this test'); end
showScenario        =   true;           %               Shows position over 2D space
c                   =   299792458;      %    [m/s]      Speed of light
n                   =   1.000293;       %             	Refractive index
N                   =   1000;            %               Number of realizations
nDim                =   2;              %               Number of dimensions (now only 2)

%% - Receiver parameters --> Defined on rx_distributions
selectedRxDist      =   1:4;

%% - Transmitter parameters
%-- Variable parameter values (positive angle -> anti-clockwise)
azim.start          =   0;              %     [deg]     First value of azimuth
azim.end            =   180;             %     [deg]     Last value of azimuth
azim.steps          =   7;              %               Steps of increment in azimuth

rad.start           =   300;            %     [m]       First value of radius
rad.end             =   1500;            %     [m]       Last value of radius
rad.steps           =   2;              %               Steps of increment in radius

mov.vel             =   0.01;           %   [rad/s]     Angular velocity

%% - Scenario parameters
scen.showBand       =   false;          %               When enabled, PSD and "Square-PSD"
                                        %                   will be plotted
scen.bw             =   10.23 * 1e6;    %   [Hz]        Transmitted signal bandwidth 
                                        %                   TODO: define it as BW at -3dB
scen.shape          =   's2';           %               Signal band shape: 
                                        %                   'r' -> rectangular, 
                                        %                   's' -> sinc, 
                                        %                   't' -> triangle
scen.freq           =   1575.42 * 1e6;  %     [Hz]      Transmitted signal frequency
scen.power          =   -10;              %    [dBW]      Transmitted signal power
scen.ns             =   10;             %               Number of samples
scen.nFig           =   5;              %               Noise figure of the system
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
scen.spacing        =   0;              %     [m]       Spacing between array elements. 
                                        %                   If 0, set to lambda/2
scen.nAnt           =   2;              %               Number of antennas of the array
scen.v              =   c/n;            %    [m/s]      Propagation speed
scen.MSBW           =   get_MS_BW(scen);%               Mean Square Bandwidth
scen.No             =   get_noise_power(scen);% [W]     Noise Power

%% - Vectors of movement of the transmitter
mov.dir             =   sign(azim.end - azim.start); %  Gets direction of movement
mov.azimVals        =   linspace(azim.start, azim.end, azim.steps);
mov.radVals         =   linspace(rad.start, rad.end, rad.steps);

distributions       =   rx_distributions();
for s = selectedRxDist
    tic
    fullTestName    =   sprintf('%s/scheme_%d', testName, s);
    rx              =   distributions{s};
    scen.numRx      =   length(rx);
    %% Vectors definition
    %- TDOA/FDOA
    pos.x.biasA     =   zeros(rad.steps, azim.steps);
    pos.x.stdA      =   zeros(rad.steps, azim.steps);
    pos.y.biasA     =   zeros(rad.steps, azim.steps);
    pos.y.stdA      =   zeros(rad.steps, azim.steps);
    %- RSS/DOA
    pos.x.biasB     =   zeros(rad.steps, azim.steps);
    pos.x.stdB      =   zeros(rad.steps, azim.steps);
    pos.y.biasB     =   zeros(rad.steps, azim.steps);
    pos.y.stdB      =   zeros(rad.steps, azim.steps);

    %- TDOA/FDOA
    vel.x.biasA     =   zeros(rad.steps, azim.steps);
    vel.x.stdA      =   zeros(rad.steps, azim.steps);
    vel.y.biasA     =   zeros(rad.steps, azim.steps);
    vel.y.stdA      =   zeros(rad.steps, azim.steps);
    %- RSS/DOA
    vel.x.biasB     =   zeros(rad.steps, azim.steps);
    vel.x.stdB      =   zeros(rad.steps, azim.steps);
    vel.y.biasB     =   zeros(rad.steps, azim.steps);
    vel.y.stdB      =   zeros(rad.steps, azim.steps);

    aux.pos         =   nan(1, 2);
    aux.vel         =   nan(1, 2);
    aux.time        =   0;
    tx              =   repmat(aux, rad.steps, azim.steps);
    estA            =   repmat(aux, rad.steps, azim.steps);
    estB            =   repmat(aux, rad.steps, azim.steps);

    txEstPosA       =   zeros(N, nDim, rad.steps, azim.steps);
    txEstPosB       =   zeros(N, nDim, rad.steps, azim.steps);
    txEstVelA       =   zeros(N, nDim, rad.steps, azim.steps);
    txEstVelB       =   zeros(N, nDim, rad.steps, azim.steps);
    
    rxPows          =   zeros(scen.numRx, N, rad.steps, azim.steps);
    rxTimes         =   zeros(scen.numRx, N, rad.steps, azim.steps);
    rxFreqs         =   zeros(scen.numRx, N, rad.steps, azim.steps);
    estDoas         =   zeros(scen.numRx, N, rad.steps, azim.steps);

    %% --- SIMULATION ---

    for r = 1:rad.steps
        fprintf(" Radius = %d m\n", mov.radVals(r));
        oldTx.pos = [0, 0];
        oldTx.time = [];
        for a = 1:azim.steps
            fprintf("  Azimuth = %i º\n", mov.azimVals(a));
            tx(r, a)        =   obtain_tx_info(mov.radVals(r), mov.azimVals(a), mov.vel, mov.dir);
            tx(r, a).time   =   obtain_tx_time(tx(r, :), a, mov.radVals(r), mov.azimVals);
            [rxPows(:, :, r, a), ...
                rxTimes(:, :, r, a), ...
                rxFreqs(:, :, r, a), ...
                estDoas(:, :, r, a), ...
                txEstPosA(:, :, r, a), ...
                txEstVelA(:, :, r, a), ...
                txEstPosB(:, :, r, a), ...
                txEstVelB(:, :, r, a), ...
                oldTx]...
                    =   simulate_scenario(scen, tx(r, a), rx, oldTx);

            %-- Position and velocity averages
            estA(r, a).pos          =   mean(txEstPosA(:, :, r, a), 1);
            estA(r, a).vel          =   mean(txEstVelA(:, :, r, a), 1);
            estB(r, a).pos          =   mean(txEstPosB(:, :, r, a), 1);
            estB(r, a).vel          =   mean(txEstVelB(:, :, r, a), 1);
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
            vel.x.stdA(r, a)        =   std(txEstVelA(:, 1, r, a));
            vel.y.biasA(r, a)       =   estA(r, a).vel(2) - tx(r, a).vel(2);
            vel.y.stdA(r, a)        =   std(txEstVelA(:, 2, r, a));
            
            vel.x.biasB(r, a)       =   estB(r, a).vel(1) - tx(r, a).vel(1);
            vel.x.stdB(r, a)        =   std(txEstVelB(:, 1, r, a));
            vel.y.biasB(r, a)       =   estB(r, a).vel(2) - tx(r, a).vel(2);
            vel.y.stdB(r, a)        =   std(txEstVelB(:, 2, r, a));
        end
    end
    fprintf("End of scheme %i. ", s);
    toc

    %% --- RESULTS ---

    if doSave
        directory = sprintf('Results/%s/', fullTestName);
        if ~exist(directory, 'dir')
            mkdir(directory);
        end
        dataFile = strcat(directory, 'data');
        save(dataFile,'N', 'mov', 'scen', 'rad', 'azim', 'rx', 'tx', 'pos', 'vel', ...
            'estA', 'estB', 'txEstPosA', 'txEstPosB', 'txEstVelA','txEstVelB', 'nDim', ...
            'rxPows', 'rxTimes', 'rxFreqs', 'estDoas');
 
        close all;
    end
end
fprintf("End of simulations. \n");
