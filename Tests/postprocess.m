clearvars;
close all;
clc;

testName    =   'test_rad_2';

directory   =   strcat('Results/', testName, '/data.mat');

load(directory);

errorA      =   zeros(var.steps, var.radSteps);
errorB      =   zeros(var.steps, var.radSteps);
err2dA      =   zeros(var.steps, 2, var.radSteps);
err2dB      =   zeros(var.steps, 2, var.radSteps);
for i = 1:var.steps
    for rad = 1:var.radSteps
       errorA(i, rad) = sqrt(sum((tx(i, rad).pos - estA(i, rad).pos).^2));
       errorB(i, rad) = sqrt(sum((tx(i, rad).pos - estB(i, rad).pos).^2));
       
       err2dA(i, :, rad) = tx(i, rad).pos - estA(i, rad).pos;
       err2dB(i, :, rad) = tx(i, rad).pos - estB(i, rad).pos;
    end
end

radVar      =   linspace(var.near, var.far, var.radSteps);
azVar       =   linspace(var.start, var.end, var.steps);
radLegend   =   cell(size(radVar));
azLegend    =   cell(size(azVar));
for rad = 1:length(radVar)
    radLegend{rad} = sprintf('R = %d m', radVar(rad));
end

for az = 1:length(azVar)
    azLegend{az} = sprintf('az = %d º', azVar(az));
end


figure;
for i = 1:var.radSteps
    cdfplot(errorA(:, i)); hold on;
end
xlabel('Error [m]');
legend(radLegend, 'Location', 'southeast'); 
legend('boxoff');
title("CDF of TDoA/FDoA method over radius variation");
figure;
for i = 1:var.radSteps
    cdfplot(errorB(:, i)); hold on;
end
xlabel('Error [m]');
legend(radLegend, 'Location', 'southeast'); 
legend('boxoff');
title("CDF of RSS/DoA method over radius variation");


% figure;
% for i = 1:var.steps
%     cdfplot(errorA(i, :)); hold on;
% end
% xlabel('Error [m]');
% legend(azLegend, 'Location', 'southeast'); 
% legend('boxoff');
% title("CDF of TDoA/FDoA method over azimuth variation");
% 
% figure;
% for i = 1:var.steps
%     cdfplot(errorB(i, :)); hold on;
% end
% xlabel('Error [m]');
% legend(azLegend, 'Location', 'southeast'); 
% legend('boxoff');
% title("CDF of RSS/DoA method over azimuth variation");

scale = 10;
figure; set(gcf, 'Position',  [400, 50, 950, 900]);
legend;
for rad = 1:var.radSteps
    for i = 1:var.steps
        %- Actual positions
        name    =   sprintf("Receiver at az=%d, rad=%d", i, rad);
        scatter(tx(i, rad).pos(1), tx(i, rad).pos(2), 'g', 'x', 'DisplayName', name); hold on;
        %- Estimated positions
        %-- TDoA/FDoA
        name    =   sprintf("(TDoA/FDoA) Estimation at az=%d, rad=%d", i, rad);
        scatter(estA(i, rad).pos(1), estA(i, rad).pos(2), 'r', 'x', 'DisplayName', name); hold on;
        C       =   cov(txEstPosA(:, :, rad, i));
        error_ellipse(C, estA(i, rad).pos);
        %-- RSS/DoA
        name    =   sprintf("(RSS/DoA) Estimation at az=%d, rad=%d", i, rad);
        scatter(estB(i, rad).pos(1), estB(i, rad).pos(2), 'm', 'x', 'DisplayName', name); hold on;
        C       =   cov(txEstPosB(:, :, rad, i));
        error_ellipse(C, estB(i, rad).pos);
    end
end

for i = 1:scen.numRx
    scatter(rx(i).pos(1), rx(i).pos(2), 'b', 'x', 'DisplayName', 'Receivers'); hold on;
    quiver(rx(i).pos(1), rx(i).pos(2), ...
        rx(i).vel(1)*scale, rx(i).vel(2)*scale, 'b'); hold on;
end
xlabel('x'); ylabel('y');


