clear all;

testName    =   'tl1';

directory   =   strcat('Results/', testName, '/data.mat');

load(directory);

errorA      =   zeros(var.steps, var.radSteps);
errorB      =   zeros(var.steps, var.radSteps);

for i = 1:var.steps
    for j = 1:var.radSteps
       errorA(i, j) = sqrt(sum((tx(i, j).pos - estA(i, j).pos).^2));
       errorB(i, j) = sqrt(sum((tx(i, j).pos - estB(i, j).pos).^2));
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


