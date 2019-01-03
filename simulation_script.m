clear all; close all; clc; %#ok<CLALL>

showScenario = false;

%- Transmitter parameters
txPos       =   [10, 50, 3];            % Position X-Y-Z [km]
txVel       =   [10, 10, 5];            % Velocity X-Y-Z [m/s]
txTime      =   0;                      % Transmission time [s]
txFreq      =   1575.42;                % Transmission frequency [MHz]

%- Receiver parameters
numRx       =   4;                      % Number of receivers
dim         =   3;                      % Dimensions
rxPos       =   zeros(numRx, dim);      % Position matrix [km]
rxVel       =   zeros(numRx, dim);      % Velocity matrix [m/s]
rxPos(1, :) =   [10, 5, 3];             % Rx1 position
rxVel(1, :) =   [0, 0, 0];              % Rx1 velocity
rxPos(2, :) =   [10, 60, 5];            % Rx2 position
rxVel(2, :) =   [0, 0, 0];              % Rx2 velocity
rxPos(3, :) =   [7, 45, 7];             % Rx3 position
rxVel(3, :) =   [6, -4, 0];             % Rx3 velocity
rxPos(4, :) =   [35, 6, 0];             % Rx4 position
rxVel(4, :) =   [9, 2, 4];              % Rx4 velocity

%- CRB parameters
SNR_dB      =  10;                      % Signal-to-Noise Ratio [dB]
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
        txPos, txVel, txTime, txFreq, SNR, Ns);
end



% -------------------------------------------------------------------------
fprintf("\n ========= Results =========\n");
for rx = 1:numRx
    fprintf(" --- Receiver %d ---\n", rx);
    fprintf(" Reception time: %f seconds \n", rxTime(rx));
    fprintf(" Received signal frequency: %f MHz \n", rxFreq(rx)/1e6);
end

if showScenario
    scale = 5e2;
    figure;
    scatter3(txPos(1), txPos(2), txPos(3), 'r', 'x'); hold on;
    scatter3(rxPos(:, 1), rxPos(:, 2), rxPos(:, 3), 'b', 'x'); hold on;
    quiver3(txPos(1), txPos(2), txPos(3), txVel(1)*scale, txVel(2)*scale, txVel(3)*scale, 'r'); hold on;
    for i = 1:numRx
        quiver3(rxPos(i, 1), rxPos(i, 2), rxPos(i, 3), rxVel(i, 1)*scale, rxVel(i, 2)*scale, rxVel(i, 3)*scale, 'b'); hold on;
    end
%     [maxPosX, i] = max(rxPos(:,1));
%     [maxPosY, j] = max(rxPos(:,2));
%     [maxPosZ, k] = max(rxPos(:,3));
%     xlim([0 maxPosX+rxVel(i, 1)*scale+10e3]);
%     ylim([0 maxPosY+rxVel(j, 2)*scale+10e3]);
%     zlim([0 maxPosZ+rxVel(k, 3)*scale+10e3]);
end

