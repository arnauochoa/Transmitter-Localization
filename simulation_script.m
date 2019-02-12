clear all; close all; clc; %#ok<CLALL>

%- Simulation parameters
showScenario    = true;                    % Shows position over 3D space
N               =   10;                    % Number of realizations

%- Transmitter parameters
txPos       =   [10, 50, 3];            % Position X-Y-Z [km]
txVel       =   [0, 0, 0];            % Velocity X-Y-Z [m/s]
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
rxVel(2, :) =   [5, -5, -5];              % Rx2 velocity
rxPos(3, :) =   [7, 45, 7];             % Rx3 position
rxVel(3, :) =   [7, 7, 3];             % Rx3 velocity
rxPos(4, :) =   [35, 6, 0];             % Rx4 position
rxVel(4, :) =   [-5, 3, 8];              % Rx4 velocity

%- CRB parameters
SNR_dB      =  10;                      % Signal-to-Noise Ratio [dB]
Ns          =  2;                       % Number of samples []

%- Parameters adaptation
SNR         =   db2pow(SNR_dB);
txFreq      =   txFreq * 1e6;
txPos       =   txPos.*1e3;
rxPos       =   rxPos.*1e3;

txEstPos    =   zeros(N, 3);
txEstVel    =   zeros(N, 3);
refRange    =   zeros(N, 3);
refRrate    =   zeros(N, 3);
for i = 1:N
    rxTime      =   zeros(numRx, 1);
    rxFreq      =   zeros(numRx, 1);
    for rx = 1:numRx
        [rxTime(rx), rxFreq(rx)] = observables_generation(rxPos(rx,:), rxVel(rx,:),...
            txPos, txVel, txTime, txFreq, SNR, Ns);
    end

    [txEstPos(i, :), txEstVel(i, :), refRange(i, :), refRrate(i, :)] = ...
        first_stage(txFreq, rxPos, rxVel, rxTime, rxFreq);
end

%-- Results computations
%- Mean
meanEstPos      =   mean(txEstPos, 1);
meanEstVel      =   mean(txEstVel, 1);
%- Bias
biasEstPos      =   sqrt(sum((txEstPos-txPos).^2));
biasEstVel      =   sqrt(sum((txEstVel-txVel).^2));
%- Standard deviation
stdEstPos       =   std(txEstPos, 0, 1);
stdEstVel       =   std(txEstVel, 0, 1);
%- Root Mean Square Error evolution
% rmseEstPos       =   sqrt(mean((txEstPos - txPos).^2, 1));
% rmseEstVel       =   sqrt(mean((txEstVel - txVel).^2, 1));

% -------------------------------------------------------------------------
fprintf("\n ========= Observables =========\n");
for rx = 1:numRx
    fprintf(" --- Receiver %d ---\n", rx);
    fprintf(" Reception time: %f seconds \n", rxTime(rx));
    fprintf(" Received signal frequency: %f MHz \n", rxFreq(rx)/1e6);
end

fprintf("\n ========= Results =========\n");
fprintf(" Actual position: X = %f m; Y = %f m; Z = %f m\n", txPos);
fprintf(" Estimated position mean: X = %f m; Y = %f m; Z = %f m \n", meanEstPos);
fprintf(" Actual velocity: X = %f m; Y = %f m; Z = %f m\n", txVel);
fprintf(" Estimated velocity mean: X = %f m; Y = %f m; Z = %f m\n", meanEstVel);
fprintf(" Position bias: %f m\n", biasEstPos);
fprintf(" Velocity bias: %f m\n", biasEstVel);
fprintf(" Estimated position std: X = %f m; Y = %f m; Z = %f m\n", stdEstVel);
fprintf(" Estimated velocity std: X = %f m; Y = %f m; Z = %f m\n", stdEstVel);

if showScenario
    scale = 5e2;
    figure;
    scatter3(txPos(1), txPos(2), txPos(3), 'r', 'x'); hold on;
    scatter3(txEstPos(1), txEstPos(2), txEstPos(3), 'g', 'x'); hold on;
    scatter3(rxPos(:, 1), rxPos(:, 2), rxPos(:, 3), 'b', 'x'); hold on;
    quiver3(txEstPos(1), txEstPos(2), txEstPos(3), txEstVel(1)*scale, txEstVel(2)*scale, txEstVel(3)*scale, 'r'); hold on;
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
