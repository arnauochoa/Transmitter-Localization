clear all; close all; clc; %#ok<CLALL>

%- Simulation parameters
showScenario    =   true;              % Shows position over 3D space
N               =   5000;               % Number of realizations
nbins           =   50;

%- Transmitter parameters
txPos       =   [2121, 2121, 2298];            % Position X-Y-Z [m]
txVel       =   [10, 10, 7];            % Velocity X-Y-Z [m/s]
txFreq      =   1575.42;                % Transmission frequency [MHz]

%- Receiver parameters
numRx       =   6;                      % Number of receivers
dim         =   3;                      % Dimensions
rxPos       =   zeros(numRx, dim);      % Position matrix [m]
rxVel       =   zeros(numRx, dim);      % Velocity matrix [m/s]
rxPos(1, :) =   [0, 0, 0];             % Rx1 position
rxVel(1, :) =   [0, 0, 0];              % Rx1 velocity
rxPos(2, :) =   [400, 0, 0];            % Rx2 position
rxVel(2, :) =   [0, 0, 0];              % Rx2 velocity
rxPos(3, :) =   [-400, 0, 0];             % Rx3 position
rxVel(3, :) =   [0, 0, 0];             % Rx3 velocity
rxPos(4, :) =   [0, 400, 0];             % Rx4 position
rxVel(4, :) =   [0, 0, 0];              % Rx4 velocity
rxPos(5, :) =   [0, 0, 400];             % Rx5 position
rxVel(5, :) =   [0, 0, 0];              % Rx5 velocity
rxPos(5, :) =   [0, 0, -400];             % Rx6 position
rxVel(5, :) =   [0, 0, 0];              % Rx6 velocity

%- CRB parameters
SNR_dB      =  10;                      % Signal-to-Noise Ratio [dB]
Ns          =  2;                       % Number of samples []

[rxTimes, rxFreqs, txEstPos, txEstVel] = simulate_scenario(N, SNR_dB, Ns,...
    txFreq, txPos, txVel, rxPos, rxVel);

%-- Results computations
%- Mean
meanEstPos      =   mean(txEstPos, 1);
meanEstVel      =   mean(txEstVel, 1);
%- Bias
biasEstPos      =   meanEstPos - txPos;
biasEstVel      =   meanEstVel - txVel;
%- Standard deviation
stdEstPos       =   std(txEstPos, 0, 1);
stdEstVel       =   std(txEstVel, 0, 1);
%- Error evolution
errEstPos       =   sqrt(sum(txEstPos - txPos, 2).^2);
errEstVel       =   sqrt(sum(txEstVel - txVel, 2).^2);
%- Distance from center
center          =   mean(rxPos, 1);
dist            =   sqrt(sum((center-txPos).^2));

% -------------------------------------------------------------------------
fprintf("\n ========= Observables =========\n");
for rx = 1:numRx
    fprintf(" --- Receiver %d ---\n", rx);
    fprintf(" Reception time: %f seconds \n", rxTimes(rx));
    fprintf(" Received signal frequency: %f MHz \n", rxFreqs(rx)/1e6);
end
fprintf(" ------------------\n");
fprintf(" Std of received times: %f s\n", std(rxTimes));
fprintf(" Std of received frequencies: %f Hz\n", std(rxFreqs));

fprintf("\n ========= Results =========\n");
fprintf(" Distance from source to center of Rx group: %f m\n", dist); 
fprintf("\n Actual position: X = %f m; Y = %f m; Z = %f m\n", txPos);
fprintf(" Estimated position mean: X = %f m; Y = %f m; Z = %f m \n", meanEstPos);
fprintf("\n Actual velocity: X = %f m/s; Y = %f m/s; Z = %f m/s\n", txVel);
fprintf(" Estimated velocity mean: X = %f m/s; Y = %f m/s; Z = %f m/s\n", meanEstVel);
fprintf("\n Position bias: X = %f m; Y = %f m; Z = %f m\n", biasEstPos);
fprintf(" Velocity bias: X = %f m/s; Y = %f m/s; Z = %f m/s\n", biasEstVel);
fprintf("\n Estimated position std: X = %f m; Y = %f m; Z = %f m\n", stdEstVel);
fprintf(" Estimated velocity std: X = %f m/s; Y = %f m/s; Z = %f m/s\n", stdEstVel);

figure;
histogram(errEstPos, nbins);
xlabel("Error [m]");
title("Distribution of error in estimated distance");

figure;
histogram(errEstVel, nbins);
xlabel("Error [m/s]");
title("Distribution of error in estimated velocity");

if showScenario
    scale = 1e2;
    figure; set(gcf, 'Position',  [100, 100, 1200, 800]);
    legend;
    scatter3(txPos(1), txPos(2), txPos(3), 'r', 'x', 'DisplayName', 'Source'); hold on;
    scatter3(rxPos(:, 1), rxPos(:, 2), rxPos(:, 3), 'b', 'x', 'DisplayName', 'Receivers'); hold on;
    scatter3(txEstPos(1), txEstPos(2), txEstPos(3), 'g', 'x', 'DisplayName', 'Estimated position'); hold on;
    quiver3(txPos(1), txPos(2), txPos(3), txVel(1)*scale, txVel(2)*scale, txVel(3)*scale, 'r'); hold on;
    quiver3(txEstPos(1), txEstPos(2), txEstPos(3), ...
        txEstVel(1)*scale, txEstVel(2)*scale, txEstVel(3)*scale, 'g'); hold on;
    for i = 1:numRx
        quiver3(rxPos(i, 1), rxPos(i, 2), rxPos(i, 3), ...
            rxVel(i, 1)*scale, rxVel(i, 2)*scale, rxVel(i, 3)*scale, 'b'); hold on;
    end
end


