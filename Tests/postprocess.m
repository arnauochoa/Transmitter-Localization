% 
% POSTPROCESS: Script used for post-processing the results obtained with advanced_simulation.
%

clearvars;
close all;
clc;

testName    =   'cc/scheme_1';
directory   =   strcat('Results/', testName);
filePath    =   strcat(directory, '/data.mat');
load(filePath);

azIndForCDF     =   1;    % Indices of azimuth values to compare on CDF
radIndForCDF    =   1;  % Indices of azimuth values to compare on CDF
radIndFor2D     =   1;  % Indices of radius to show on 2D plot

fig         =   [];

%% Bias and variance plots over azimuth
if azim.steps > 1
    lgnd = cell(1, rad.steps);
    for r = 1:rad.steps
        lgnd{r} = sprintf("R=%d", mov.radVals(r));
    end
    %- Bias of the position
    %-- TDoA/FDoA
    fig = [fig, figure]; set(gcf, 'Position', [10, 600, 400, 500]);
    subplot(2,1,1);
    plot(mov.azimVals, pos.x.biasA, '-o');
    title("Position bias (TDoA/FDoA)");
    ylabel("Bias of position (X) (m)");
    xlabel("Azimuth (deg)");
    legend(lgnd, 'Location', 'best'); 
    legend('boxoff');
    subplot(2,1,2);
    plot(mov.azimVals, pos.y.biasA, '-o');
    ylabel("Bias of position (Y) (m)");
    xlabel("Azimuth (deg)");
    legend(lgnd, 'Location', 'best'); 
    legend('boxoff');
    
    %-- RSS/DoA
    fig = [fig, figure]; set(gcf, 'Position', [10, 0, 400, 500]);
    subplot(2,1,1);
    plot(mov.azimVals, pos.x.biasB, '-o');
    title("Position bias (RSS/DoA)");
    ylabel("Bias of position (X) (m)");
    xlabel("Azimuth (deg)");
    legend(lgnd, 'Location', 'best'); 
    legend('boxoff');
    subplot(2,1,2);
    plot(mov.azimVals, pos.y.biasB, '-o');
    ylabel("Bias of position (Y) (m)");
    xlabel("Azimuth (deg)");
    legend(lgnd, 'Location', 'best'); 
    legend('boxoff');
    
    %- Standard deviation of the position
    %-- TDoA/FDoA
    fig = [fig, figure]; set(gcf, 'Position',  [420, 600, 400, 500]);
    subplot(2,1,1);
    plot(mov.azimVals, pos.x.stdA, '-o');
    title("Position standard deviation (TDoA/FDoA)");
    ylabel("STD of position (X) (m)");
    xlabel("Azimuth (deg)");
    legend(lgnd, 'Location', 'best'); 
    legend('boxoff');
    subplot(2,1,2);
    plot(mov.azimVals, pos.y.stdA, '-o');
    ylabel("STD of position (Y) (m)");
    xlabel("Azimuth (deg)");
    legend(lgnd, 'Location', 'best'); 
    legend('boxoff');
    
    %-- RSS/DoA
    fig = [fig, figure]; set(gcf, 'Position',  [420, 0, 400, 500]);
    subplot(2,1,1);
    plot(mov.azimVals, pos.x.stdB, '-o');
    title("Position standard deviation (RSS/DoA)");
    ylabel("STD of position (X) (m)");
    xlabel("Azimuth (deg)");
    legend(lgnd, 'Location', 'best'); 
    legend('boxoff');
    subplot(2,1,2);
    plot(mov.azimVals, pos.y.stdB, '-o');
    ylabel("STD of position (Y) (m)");
    xlabel("Azimuth (deg)");
    legend(lgnd, 'Location', 'best'); 
    legend('boxoff');
    
    %- Bias of the velocity
    fig = [fig, figure];  set(gcf, 'Position',  [850, 600, 400, 500]);
    subplot(2,1,1);
    plot(mov.azimVals, vel.x.biasA, '-o');
    title("Velocity bias (TDoA/FDoA)");
    ylabel("Bias of velocity (X) (m/s)");
    xlabel("Azimuth (deg)");
    legend(lgnd, 'Location', 'best'); 
    legend('boxoff');
    subplot(2,1,2);
    plot(mov.azimVals, vel.y.biasA, '-o');
    ylabel("Bias of velocity (Y) (m/s)");
    xlabel("Azimuth (deg)");
    legend(lgnd, 'Location', 'best'); 
    legend('boxoff');
    
    %- Standard deviation of the velocity
    fig = [fig, figure];  set(gcf, 'Position',  [1240, 600, 400, 500]);
    subplot(2,1,1);
    plot(mov.azimVals, vel.x.stdA, '-o');
    title("Velocity standard deviation (TDoA/FDoA)");
    ylabel("STD of velocity (X) (m/s)");
    xlabel("Azimuth (deg)");
    legend(lgnd, 'Location', 'best'); 
    legend('boxoff');
    subplot(2,1,2);
    plot(mov.azimVals, vel.y.stdA, '-o');
    ylabel("STD of velocity (Y) (m/s)");
    xlabel("Azimuth (deg)");
    legend(lgnd, 'Location', 'best'); 
    legend('boxoff');
end

%% Bias and variance plots over radius
if rad.steps > 1
    lgnd = cell(1, azim.steps);
    for a = 1:azim.steps
    lgnd{a} = sprintf("a=%d", mov.azimVals(a));
    end
    
    %- Bias of the position
    %-- TDoA/FDoA
    fig = [fig, figure]; set(gcf, 'Position', [10, 600, 400, 500]);
    subplot(2,1,1);
    plot(mov.radVals, pos.x.biasA.', '-o');
    title("Position bias (TDoA/FDoA)");
    ylabel("Bias of position (X) (m)");
    xlabel("Radius (m)");
    legend(lgnd, 'Location', 'best'); 
    legend('boxoff');
    subplot(2,1,2);
    plot(mov.radVals, pos.y.biasA.', '-o');
    ylabel("Bias of position (Y) (m)");
    xlabel("Radius (m)");
    legend(lgnd, 'Location', 'best'); 
    legend('boxoff');

    %-- RSS/DoA
    fig = [fig, figure]; set(gcf, 'Position', [10, 0, 400, 500]);
    subplot(2,1,1);
    plot(mov.radVals, pos.x.biasB.', '-o');
    title("Position bias (RSS/DoA)");
    ylabel("Bias of position (X) (m)");
    xlabel("Radius (m)");
    legend(lgnd);
    subplot(2,1,2);
    plot(mov.radVals, pos.y.biasB.', '-o');
    ylabel("Bias of position (Y) (m)");
    xlabel("Radius (m)");
    legend(lgnd, 'Location', 'best'); 
    legend('boxoff');

    %- Standard deviation of the position
    %-- TDoA/FDoA
    fig = [fig, figure]; set(gcf, 'Position',  [420, 600, 400, 500]);
    subplot(2,1,1);
    plot(mov.radVals, pos.x.stdA.', '-o');
    title("Position standard deviation (TDoA/FDoA)");
    ylabel("STD of position (X) (m)");
    xlabel("Radius (m)");
    legend(lgnd, 'Location', 'best'); 
    legend('boxoff');
    subplot(2,1,2);
    plot(mov.radVals, pos.y.stdA.', '-o');
    ylabel("STD of position (Y) (m)");
    xlabel("Radius (m)");
    legend(lgnd, 'Location', 'best'); 
    legend('boxoff');

    %-- RSS/DoA
    fig = [fig, figure]; set(gcf, 'Position',  [420, 0, 400, 500]);
    subplot(2,1,1);
    plot(mov.radVals, pos.x.stdB.', '-o');
    title("Position standard deviation (RSS/DoA)");
    ylabel("STD of position (X) (m)");
    xlabel("Radius (m)");
    legend(lgnd, 'Location', 'best'); 
    legend('boxoff');
    subplot(2,1,2);
    plot(mov.radVals, pos.y.stdB.', '-o');
    ylabel("STD of position (Y) (m)");
    xlabel("Radius (m)");
    legend(lgnd, 'Location', 'best'); 
    legend('boxoff');
    
    %- Bias of the velocity
    fig = [fig, figure];  set(gcf, 'Position',  [850, 600, 400, 500]);
    subplot(2,1,1);
    plot(mov.radVals, vel.x.biasA.', '-o');
    title("Velocity bias (TDoA/FDoA)");
    ylabel("Bias of velocity (X) (m/s)");
    xlabel("Radius (m)");
    legend(lgnd, 'Location', 'best'); 
    legend('boxoff');
    subplot(2,1,2);
    plot(mov.radVals, vel.y.biasA.', '-o');
    ylabel("Bias of velocity (Y) (m/s)");
    xlabel("Radius (m)");
    legend(lgnd, 'Location', 'best'); 
    legend('boxoff');

    %- Standard deviation of the velocity
    fig = [fig, figure];  set(gcf, 'Position',  [1240, 600, 400, 500]);
    subplot(2,1,1);
    plot(mov.radVals, vel.x.stdA.', '-o');
    title("Velocity standard deviation (TDoA/FDoA)");
    ylabel("STD of velocity (X) (m/s)");
    xlabel("Radius (m)");
    legend(lgnd, 'Location', 'best'); 
    legend('boxoff');
    subplot(2,1,2);
    plot(mov.radVals, vel.y.stdA.', '-o');
    ylabel("STD of velocity (Y) (m/s)");
    xlabel("Radius (m)");
    legend(lgnd, 'Location', 'best'); 
    legend('boxoff');
end

%% CDFs
errorA      =   zeros(N, rad.steps, azim.steps);
errorB      =   zeros(N, rad.steps, azim.steps);
err2dA      =   zeros(N, nDim, rad.steps, azim.steps);
err2dB      =   zeros(N, nDim, rad.steps, azim.steps);
for a = 1:azim.steps
    for r = 1:rad.steps
       err2dA(:, :, r, a)   =   tx(r, a).pos - txEstPosA(:, :, r, a);
       err2dB(:, :, r, a)   =   tx(r, a).pos - txEstPosB(:, :, r, a);
       
       errorA(:, r, a)      =   sqrt(sum(err2dA(:, :, r, a).^2, 2));
       errorB(:, r, a)      =   sqrt(sum(err2dB(:, :, r, a).^2, 2));
    end
end

cdfLegend   =   cell(size(mov.radVals));
for r = 1:length(mov.radVals)
    cdfLegend{r} = sprintf('R = %d m', mov.radVals(r));
end

cdfFigs     =   [figure figure];
cdfLegend   =   cell(1, length(radIndForCDF)*length(azIndForCDF)); 
i = 1;
for a = azIndForCDF
    for r = radIndForCDF
        cdfLegend{i} = sprintf('R = %d m, a = %d º', mov.radVals(r), mov.azimVals(a));
        
        figure(cdfFigs(1));
        cdfplot(errorA(:, r, a)); hold on;
        
        figure(cdfFigs(2));
        cdfplot(errorB(:, r, a)); hold on;
        
        i = i + 1;
    end
end
figure(cdfFigs(1));
xlabel('Error [m]');
legend(cdfLegend, 'Location', 'best'); 
legend('boxoff');
title("CDF of TDoA/FDoA method");

figure(cdfFigs(2));
xlabel('Error [m]');
legend(cdfLegend, 'Location', 'best'); 
legend('boxoff');
title("CDF of RSS/DoA method");

fig = [fig, cdfFigs];

%% 2D plot
scale   =   10;
fig     =   [fig, figure]; set(gcf, 'Position',  [400, 50, 950, 900]);
rxPos   =   cell2mat({rx.pos}.');
rxVel   =   cell2mat({rx.vel}.').*scale;
scatter(rxPos(:, 1), rxPos(:, 2), 'b', 'v'); hold on;
quiver(rxPos(:, 1), rxPos(:, 2), rxVel(:, 1), rxVel(:, 2), 'b'); hold on;


for r = radIndFor2D
    for a = 1:azim.steps
        %- Actual positions
        scatter(tx(r, a).pos(1), tx(r, a).pos(2), 'g', 'x'); hold on;
        %- Estimated positions
        %-- TDoA/FDoA
        color   =   rand(1, 3);
        scatter(estA(r, a).pos(1), estA(r, a).pos(2), [], color, 'o'); 
        hold on;
        C       =   cov(txEstPosA(:, :, r, a));
        error_ellipse(C, estA(r, a).pos, 'style', '--', 'Color', color); 
        %-- RSS/DoA
        color   =   rand(1, 3);
        scatter(estB(r, a).pos(1), estB(r, a).pos(2), [], color, 's');
        hold on;
        C       =   cov(txEstPosB(:, :, r, a));
        error_ellipse(C, estB(r, a).pos, 'style', '--', 'Color', color);
    end
end

xlabel('x'); ylabel('y');
L = legend('a', 'b', 'c', 'd', 'e', 'f');
v = findall(gcf, 'marker', 'v');
set(v, 'DisplayName', 'Rx positions');
x = findall(gcf, 'marker', 'x');
set(x, 'DisplayName', 'Actual Tx position');
o = findall(gcf, 'marker', 'o');
set(o, 'DisplayName', 'TDoA/FDoA estimation');
s = findall(gcf, 'marker', 's');
set(s, 'DisplayName', 'RSS/DoA estimation');
l1 = findall(gcf, 'linestyle', '--');
set(l1, 'DisplayName', '50% error ellipse');
l2 = findall(gcf, 'linestyle', '-');
set(l2, 'DisplayName', 'Rx velocities');

%% Save data
fprintf('Selected test: %s \n\n', testName);
saveAnswer  =   menu('Save figures?', 'YES', 'NO');
if saveAnswer == 1
    prompt      =   strcat('Name the figures folder (inside: ', directory, '/ ): ');
    dlgtitle    =   'Figures folder';
    dims        =   [1 35];
    definput    =   {'name'};
    figDirName  =   inputdlg(prompt, dlgtitle, dims, definput);
   
    directory = strcat(directory, '/', figDirName{1}, '/');
    if ~exist(directory, 'dir')
        mkdir(directory);
    end

    for i = 1:length(fig)
        saveas(figure(i), sprintf('%sfig_%d.fig', directory, i));
    end
    close all
    
else
    closeAnswer  =   menu('Close figures?', 'YES', 'NO');
    if closeAnswer == 1
        close all
    end
end



