clear all; close all; clc; %#ok<CLALL>

%- Transmitter parameters
txPos       =   [50, 50];               % Position X-Y-Z [km]
txVel       =   [10, 10];               % Velocity X-Y-Z [m/s]
txTime      =   0;                      % Transmission time [s]
txFreq      =   1575.42;                % Transmission frequency [MHz]

%- Receiver parameters
numRx       =   3;                      % Number of receivers
dim         =   2;                      % Dimensions
rxPos       =   zeros(numRx, dim);      % Position matrix [km]
rxVel       =   zeros(numRx, dim);      % Velocity matrix [m/s]
rxPos(1, :) =   [10, 5];                % Rx1 position
rxVel(1, :) =   [0, 0];                 % Rx1 velocity
rxPos(2, :) =   [10, 60];               % Rx2 position
rxVel(2, :) =   [0, 0];                 % Rx2 velocity
rxPos(3, :) =   [7, 45];                % Rx3 position
rxVel(3, :) =   [6, -4];                % Rx3 velocity
rxPos(4, :) =   [35, 6];                % Rx4 position
rxVel(4, :) =   [9, 2];                 % Rx4 velocity

%- CRB parameters
SNR_dB      =  -20;                     % Signal-to-Noise Ratio [dB]
Ns          =  2;                       % Number of samples []

%- Parameters adaptation
SNR     =   db2pow(SNR_dB);
txFreq  =   txFreq * 1e6;
txPos   =   txPos.*1e3;
rxPos   =   rxPos.*1e3;

rxTime  =   zeros(numRx, 1);
rxFreq  =   zeros(numRx, 1);
for rx = 1:numRx
    [rxTime(rx), rxFreq(rx)] = observables_generation(rxPos(rx,:), rxVel(rx,:),...
        txPos(), txVel(), txTime, txFreq, SNR, Ns);
end



% -------------------------------------------------------------------------
fprintf("\n ========= Results =========\n");
for rx = 1:numRx
    fprintf(" --- Receiver %d ---\n", rx);
    fprintf(" Reception time: %f seconds \n", rxTime(rx));
    fprintf(" Received signal frequency: %f MHz \n", rxFreq(rx)/1e6);
end

scale = 1e3;
figure;
scatter(txPos(1), txPos(2), 'r', 'x'); hold on;
scatter(rxPos(:, 1), rxPos(:, 2), 'b', 'x'); hold on;
quiver(txPos(:, 1), txPos(:, 2), txVel(:, 1)*scale, txVel(:, 2)*scale); hold on;
quiver(rxPos(:, 1), rxPos(:, 2), rxVel(:, 1)*scale, rxVel(:, 2)*scale);
[maxPosX, i] = max(txPos(:,1));
[maxPosY, j] = max(txPos(:,2));
xlim([0 maxPosX+txVel(i, 1)*scale+10e3]);
ylim([0 maxPosY+txVel(j, 2)*scale+10e3]);

