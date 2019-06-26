% 
% POSTPROCESS: Script used for post-processing the results obtained with advanced_simulation.
%

% vvv remove
for w1 = 1:2
    for w2 = 1:4
%         w1 = 1; % radInd
%         w2 = 2; % scenInd
        % ^^^ remove
        
        
        clearvars -except w1 w2;
        close all;
        clc;
        
        %% Parameters initialisation
        testName    =   sprintf('final_4/scheme_%d', w2);
        directory   =   strcat('Results/', testName);
        filePath    =   strcat(directory, '/data.mat');
        load(filePath);

        azIndForCDF     =   1:azim.steps;    % Indices of azimuth values to compare on CDF
        radIndForCDF    =   w1;  % Indices of azimuth values to compare on CDF
        radIndFor2D     =   w1;  % Indices of radius to show on 2D plot

        % Colors for 2D
        rxColor     =   [0, 0.64, 1];
        txColor     =   [0, 0, 0];
        tdoaColor   =   [0 0.9 0.4];
        doaColor    =   [1, 0.25, 0];
        mrkrSize    =   90;
        mrkrLWidth  =   1.9;
        
        fig             =   [];

         %% Orientation Bars
%         oriDeg = nan(1, scen.numRx);
%         for r = 1:scen.numRx
%             oriDeg(r) = rad2deg(rx(r).orientation);
%         end
% 
%         fig = [fig, figure];
%         bar(1:scen.numRx, oriDeg);
%         xlabel('Receivers'); ylabel('Orientation [º]');


        %% SNR computation & Bars
        avgPows     =   mean(rxPows, 2);
        SNR         =   pow2db(avgPows(:, 1, radIndForCDF, :)) - pow2db(scen.No);

        x           =   1:scen.numRx;
        y           =   mean(SNR, 4);
        negat       =   y-min(SNR, [], 4);
        posit       =   max(SNR, [], 4)-y;

        fig = [fig, figure];
        bar(x, y); hold on;

        er = errorbar(x, y, negat, posit);
        er.Color = [0 0 0];                            
        er.LineStyle = 'none';
        xlabel('Receivers'); ylabel('SNR [dB]');
        % title(sprintf('Radius = %d m', mov.radVals(radIndForCDF)));

         %% DoA Bars
%         avgDoas     =   rad2deg(mean(estDoas, 2));
%         showDoas    =   avgDoas(:, 1, radIndForCDF, :);
% 
%         x           =   1:scen.numRx;
%         y           =   mean(showDoas, 4);
%         negat       =   y-min(showDoas, [], 4);
%         posit       =   max(showDoas, [], 4)-y;
% 
%         fig = [fig, figure];
%         bar(x, y); hold on;
% 
%         er = errorbar(x, y, negat, posit);
%         er.Color = [0 0 0];                            
%         er.LineStyle = 'none';
%         xlabel('Receivers'); ylabel('DoA [º]');
%         % title(sprintf('Radius = %d m', mov.radVals(radIndForCDF)));

      %% TDoA Bars
%         avgTimes     =   rad2deg(mean(rxTimes, 2));
%         showTimes    =   avgTimes(:, 1, radIndForCDF, :)*10e3;
% 
%         x           =   1:scen.numRx;
%         y           =   mean(showTimes, 4);
%         negat       =   y-min(showTimes, [], 4);
%         posit       =   max(showTimes, [], 4)-y;
% 
%         fig = [fig, figure];
%         bar(x, y); hold on;
% 
%         er = errorbar(x, y, negat, posit);
%         er.Color = [0 0 0];                            
%         er.LineStyle = 'none';
%         xlabel('Receivers'); ylabel('TDoA [ms]');
%         % title(sprintf('Radius = %d m', mov.radVals(radIndForCDF)));

         %% FDoA Bars
%         avgFreqs     =   rad2deg(mean(rxFreqs, 2));
%         showFreqs    =   avgFreqs(:, 1, radIndForCDF, :)/10e9;
% 
%         x           =   1:scen.numRx;
%         y           =   mean(showFreqs, 4)/scen.freq;
%         negat       =   y-min(showFreqs, [], 4);
%         posit       =   max(showFreqs, [], 4)-y;
% 
%         fig = [fig, figure];
%         bar(x, y); hold on;
% 
%         er = errorbar(x, y, negat, posit);
%         er.Color = [0 0 0];                            
%         er.LineStyle = 'none';
%         xlabel('Receivers'); ylabel('FDoA [GHz]');
%         % title(sprintf('Radius = %d m', mov.radVals(radIndForCDF)));

        %% RMSE computation
        % for r = 1:rad.steps
        %    for a = 1:azim.steps
        %        pos.rmseA(r, a)       =   sqrt(1/N * sum(sum((txEstPosA(:, :, r, a) - tx(r,a).pos).^2, 2)));
        %        pos.rmseB(r, a)       =   sqrt(1/N * sum(sum((txEstPosB(:, :, r, a) - tx(r,a).pos).^2, 2)));
        %    end
        % end

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
            plot(mov.azimVals, pos.x.biasA(1,:), '-o');hold on;
            plot(mov.azimVals, pos.x.biasA(2,:), '-^');hold on;
            title("Position bias (TDoA/FDoA)");
            ylabel("Bias of position (X) (m)");
            xlabel("Azimuth (deg)");
            legend(lgnd, 'Location', 'best'); 
            legend('boxoff');
            subplot(2,1,2);
            plot(mov.azimVals, pos.y.biasA(1,:), '-o');hold on;
            plot(mov.azimVals, pos.y.biasA(2,:), '-^');hold on;
            ylabel("Bias of position (Y) (m)");
            xlabel("Azimuth (deg)");
            legend(lgnd, 'Location', 'best'); 
            legend('boxoff');

            %-- RSS/DoA
            fig = [fig, figure]; set(gcf, 'Position', [10, 0, 400, 500]);
            subplot(2,1,1);
            plot(mov.azimVals, pos.x.biasB(1,:), '-o');hold on;
            plot(mov.azimVals, pos.x.biasB(2,:), '-^');hold on;
            title("Position bias (RSS/DoA)");
            ylabel("Bias of position (X) (m)");
            xlabel("Azimuth (deg)");
            legend(lgnd, 'Location', 'best'); 
            legend('boxoff');
            subplot(2,1,2);
            plot(mov.azimVals, pos.y.biasB(1,:), '-o');hold on;
            plot(mov.azimVals, pos.y.biasB(2,:), '-^');hold on;
            ylabel("Bias of position (Y) (m)");
            xlabel("Azimuth (deg)");
            legend(lgnd, 'Location', 'best'); 
            legend('boxoff');

        %     %- RMSE of the position
        %     %-- TDoA/FDoA
        %     fig = [fig, figure]; set(gcf, 'Position', [10, 600, 400, 500]);
        %     plot(mov.azimVals, pos.rmseA, '-o');
        %     title("Position RMSE (TDoA/FDoA)");
        %     ylabel("RMSE of position (m)");
        %     xlabel("Azimuth (deg)");
        %     legend(lgnd, 'Location', 'best'); 
        %     legend('boxoff');
        %     
        %     %-- RSS/DoA
        %     fig = [fig, figure]; set(gcf, 'Position', [10, 0, 400, 500]);
        %     plot(mov.azimVals, pos.rmseB, '-o');
        %     title("Position RMSE (RSS/DoA)");
        %     ylabel("RMSE of position (m)");
        %     xlabel("Azimuth (deg)");
        %     legend(lgnd, 'Location', 'best'); 
        %     legend('boxoff');

            %- Standard deviation of the position
            %-- TDoA/FDoA
            fig = [fig, figure]; set(gcf, 'Position',  [420, 600, 400, 500]);
            subplot(2,1,1);
            plot(mov.azimVals, pos.x.stdA(1,:), '-o');hold on;
            plot(mov.azimVals, pos.x.stdA(2,:), '-^');hold on;
            title("Position standard deviation (TDoA/FDoA)");
            ylabel("STD of position (X) (m)");
            xlabel("Azimuth (deg)");
            legend(lgnd, 'Location', 'best'); 
            legend('boxoff');
            subplot(2,1,2);
            plot(mov.azimVals, pos.y.stdA(1,:), '-o');hold on;
            plot(mov.azimVals, pos.y.stdA(2,:), '-^');hold on;
            ylabel("STD of position (Y) (m)");
            xlabel("Azimuth (deg)");
            legend(lgnd, 'Location', 'best'); 
            legend('boxoff');

            %-- RSS/DoA
            fig = [fig, figure]; set(gcf, 'Position',  [420, 0, 400, 500]);
            subplot(2,1,1);
            plot(mov.azimVals, pos.x.stdB(1,:), '-o');hold on;
            plot(mov.azimVals, pos.x.stdB(2,:), '-^');hold on;
            title("Position standard deviation (RSS/DoA)");
            ylabel("STD of position (X) (m)");
            xlabel("Azimuth (deg)");
            legend(lgnd, 'Location', 'best'); 
            legend('boxoff');
            subplot(2,1,2);
            plot(mov.azimVals, pos.y.stdB(1,:), '-o');hold on;
            plot(mov.azimVals, pos.y.stdB(2,:), '-^');hold on;
            ylabel("STD of position (Y) (m)");
            xlabel("Azimuth (deg)");
            legend(lgnd, 'Location', 'best'); 
            legend('boxoff');

            %- Bias of the velocity
            %-- TDoA/FDoA
            fig = [fig, figure];  set(gcf, 'Position',  [850, 600, 400, 500]);
            subplot(2,1,1);
            plot(mov.azimVals, vel.x.biasA(1,:), '-o');hold on;
            plot(mov.azimVals, vel.x.biasA(2,:), '-^');hold on;
            title("Velocity bias (TDoA/FDoA)");
            ylabel("Bias of velocity (X) (m/s)");
            xlabel("Azimuth (deg)");
            legend(lgnd, 'Location', 'best'); 
            legend('boxoff');
            subplot(2,1,2);
            plot(mov.azimVals, vel.y.biasA(1,:), '-o');hold on;
            plot(mov.azimVals, vel.y.biasA(2,:), '-^');hold on;
            ylabel("Bias of velocity (Y) (m/s)");
            xlabel("Azimuth (deg)");
            legend(lgnd, 'Location', 'best'); 
            legend('boxoff');

            %-- RSS/DoA
            fig = [fig, figure];  set(gcf, 'Position',  [850, 600, 400, 500]);
            subplot(2,1,1);
            plot(mov.azimVals, vel.x.biasB(1,:), '-o');hold on;
            plot(mov.azimVals, vel.x.biasB(2,:), '-^');hold on;
            title("Velocity bias (RSS/DoA)");
            ylabel("Bias of velocity (X) (m/s)");
            xlabel("Azimuth (deg)");
            legend(lgnd, 'Location', 'best'); 
            legend('boxoff');
            subplot(2,1,2);
            plot(mov.azimVals, vel.y.biasB(1,:), '-o');hold on;
            plot(mov.azimVals, vel.y.biasB(2,:), '-^');hold on;
            ylabel("Bias of velocity (Y) (m/s)");
            xlabel("Azimuth (deg)");
            legend(lgnd, 'Location', 'best'); 
            legend('boxoff');

            %- Standard deviation of the velocity
            %-- TDoA/FDoA
            fig = [fig, figure];  set(gcf, 'Position',  [1240, 600, 400, 500]);
            subplot(2,1,1);
            plot(mov.azimVals, vel.x.stdA(1,:), '-o');hold on;
            plot(mov.azimVals, vel.x.stdA(2,:), '-^');hold on;
            title("Velocity standard deviation (TDoA/FDoA)");
            ylabel("STD of velocity (X) (m/s)");
            xlabel("Azimuth (deg)");
            legend(lgnd, 'Location', 'best'); 
            legend('boxoff');
            subplot(2,1,2);
            plot(mov.azimVals, vel.y.stdA(1,:), '-o');hold on;
            plot(mov.azimVals, vel.y.stdA(2,:), '-^');hold on;
            ylabel("STD of velocity (Y) (m/s)");
            xlabel("Azimuth (deg)");
            legend(lgnd, 'Location', 'best'); 
            legend('boxoff');

            %-- RSS/DoA
            fig = [fig, figure];  set(gcf, 'Position',  [1240, 600, 400, 500]);
            subplot(2,1,1);
            plot(mov.azimVals, vel.x.stdB(1,:), '-o');hold on;
            plot(mov.azimVals, vel.x.stdB(2,:), '-^');hold on;
            title("Velocity standard deviation (RSS/DoA)");
            ylabel("STD of velocity (X) (m/s)");
            xlabel("Azimuth (deg)");
            legend(lgnd, 'Location', 'best'); 
            legend('boxoff');
            subplot(2,1,2);
            plot(mov.azimVals, vel.y.stdB(1,:), '-o');hold on;
            plot(mov.azimVals, vel.y.stdB(2,:), '-^');hold on;
            ylabel("STD of velocity (Y) (m/s)");
            xlabel("Azimuth (deg)");
            legend(lgnd, 'Location', 'best'); 
            legend('boxoff');
        end

        %% Bias and variance plots over radius
        % if rad.steps > 1
        %     lgnd = cell(1, azim.steps);
        %     for a = 1:azim.steps
        %         lgnd{a} = sprintf("a=%d", mov.azimVals(a));
        %     end
        %     
        %     %- Bias of the position
        %     %-- TDoA/FDoA
        %     fig = [fig, figure]; set(gcf, 'Position', [10, 600, 400, 500]);
        %     subplot(2,1,1);
        %     plot(mov.radVals, pos.x.biasA.', '-o');
        %     title("Position bias (TDoA/FDoA)");
        %     ylabel("Bias of position (X) (m)");
        %     xlabel("Radius (m)");
        %     legend(lgnd, 'Location', 'best'); 
        %     legend('boxoff');
        %     subplot(2,1,2);
        %     plot(mov.radVals, pos.y.biasA.', '-o');
        %     ylabel("Bias of position (Y) (m)");
        %     xlabel("Radius (m)");
        %     legend(lgnd, 'Location', 'best'); 
        %     legend('boxoff');
        % 
        %     %-- RSS/DoA
        %     fig = [fig, figure]; set(gcf, 'Position', [10, 0, 400, 500]);
        %     subplot(2,1,1);
        %     plot(mov.radVals, pos.x.biasB.', '-o');
        %     title("Position bias (RSS/DoA)");
        %     ylabel("Bias of position (X) (m)");
        %     xlabel("Radius (m)");
        %     legend(lgnd);
        %     subplot(2,1,2);
        %     plot(mov.radVals, pos.y.biasB.', '-o');
        %     ylabel("Bias of position (Y) (m)");
        %     xlabel("Radius (m)");
        %     legend(lgnd, 'Location', 'best'); 
        %     legend('boxoff');
        % 
        %     %- RMSE of the position
        %     %-- TDoA/FDoA
        %     fig = [fig, figure]; set(gcf, 'Position', [10, 600, 400, 500]);
        %     plot(mov.azimVals, pos.rmseA.', '-o');
        %     title("Position RMSE (TDoA/FDoA)");
        %     ylabel("RMSE of position (m)");
        %     xlabel("Radius (m)");
        %     legend(lgnd, 'Location', 'best'); 
        %     legend('boxoff');
        %     
        %     %-- RSS/DoA
        %     fig = [fig, figure]; set(gcf, 'Position', [10, 0, 400, 500]);
        %     plot(mov.azimVals, pos.rmseB.', '-o');
        %     title("Position RMSE (RSS/DoA)");
        %     ylabel("RMSE of position (m)");
        %     xlabel("Radius (m)");
        %     legend(lgnd, 'Location', 'best'); 
        %     legend('boxoff');
        %     
        %     %- Standard deviation of the position
        %     %-- TDoA/FDoA
        %     fig = [fig, figure]; set(gcf, 'Position',  [420, 600, 400, 500]);
        %     subplot(2,1,1);
        %     plot(mov.radVals, pos.x.stdA.', '-o');
        %     title("Position standard deviation (TDoA/FDoA)");
        %     ylabel("STD of position (X) (m)");
        %     xlabel("Radius (m)");
        %     legend(lgnd, 'Location', 'best'); 
        %     legend('boxoff');
        %     subplot(2,1,2);
        %     plot(mov.radVals, pos.y.stdA.', '-o');
        %     ylabel("STD of position (Y) (m)");
        %     xlabel("Radius (m)");
        %     legend(lgnd, 'Location', 'best'); 
        %     legend('boxoff');
        % 
        %     %-- RSS/DoA
        %     fig = [fig, figure]; set(gcf, 'Position',  [420, 0, 400, 500]);
        %     subplot(2,1,1);
        %     plot(mov.radVals, pos.x.stdB.', '-o');
        %     title("Position standard deviation (RSS/DoA)");
        %     ylabel("STD of position (X) (m)");
        %     xlabel("Radius (m)");
        %     legend(lgnd, 'Location', 'best'); 
        %     legend('boxoff');
        %     subplot(2,1,2);
        %     plot(mov.radVals, pos.y.stdB.', '-o');
        %     ylabel("STD of position (Y) (m)");
        %     xlabel("Radius (m)");
        %     legend(lgnd, 'Location', 'best'); 
        %     legend('boxoff');
        %     
        %     %- Bias of the velocity
        %     %-- TDoA/FDoA
        %     fig = [fig, figure];  set(gcf, 'Position',  [850, 600, 400, 500]);
        %     subplot(2,1,1);
        %     plot(mov.radVals, vel.x.biasA.', '-o');
        %     title("Velocity bias (TDoA/FDoA)");
        %     ylabel("Bias of velocity (X) (m/s)");
        %     xlabel("Radius (m)");
        %     legend(lgnd, 'Location', 'best'); 
        %     legend('boxoff');
        %     subplot(2,1,2);
        %     plot(mov.radVals, vel.y.biasA.', '-o');
        %     ylabel("Bias of velocity (Y) (m/s)");
        %     xlabel("Radius (m)");
        %     legend(lgnd, 'Location', 'best'); 
        %     legend('boxoff');
        % 
        %     %-- RSS/DoA
        %     fig = [fig, figure];  set(gcf, 'Position',  [850, 600, 400, 500]);
        %     subplot(2,1,1);
        %     plot(mov.radVals, vel.x.biasB.', '-o');
        %     title("Velocity bias (RSS/DoA)");
        %     ylabel("Bias of velocity (X) (m/s)");
        %     xlabel("Radius (m)");
        %     legend(lgnd, 'Location', 'best'); 
        %     legend('boxoff');
        %     subplot(2,1,2);
        %     plot(mov.radVals, vel.y.biasB.', '-o');
        %     ylabel("Bias of velocity (Y) (m/s)");
        %     xlabel("Radius (m)");
        %     legend(lgnd, 'Location', 'best'); 
        %     legend('boxoff');
        % 
        %     %- Standard deviation of the velocity
        %     %-- TDoA/FDoA
        %     fig = [fig, figure];  set(gcf, 'Position',  [1240, 600, 400, 500]);
        %     subplot(2,1,1);
        %     plot(mov.radVals, vel.x.stdA.', '-o');
        %     title("Velocity standard deviation (TDoA/FDoA)");
        %     ylabel("STD of velocity (X) (m/s)");
        %     xlabel("Radius (m)");
        %     legend(lgnd, 'Location', 'best'); 
        %     legend('boxoff');
        %     subplot(2,1,2);
        %     plot(mov.radVals, vel.y.stdA.', '-o');
        %     ylabel("STD of velocity (Y) (m/s)");
        %     xlabel("Radius (m)");
        %     legend(lgnd, 'Location', 'best'); 
        %     legend('boxoff');
        %     
        %     %-- RSS/DoA
        %     fig = [fig, figure];  set(gcf, 'Position',  [1240, 600, 400, 500]);
        %     subplot(2,1,1);
        %     plot(mov.radVals, vel.x.stdB.', '-o');
        %     title("Velocity standard deviation (RSS/DoA)");
        %     ylabel("STD of velocity (X) (m/s)");
        %     xlabel("Radius (m)");
        %     legend(lgnd, 'Location', 'best'); 
        %     legend('boxoff');
        %     subplot(2,1,2);
        %     plot(mov.radVals, vel.y.stdB.', '-o');
        %     ylabel("STD of velocity (Y) (m/s)");
        %     xlabel("Radius (m)");
        %     legend(lgnd, 'Location', 'best'); 
        %     legend('boxoff');
        % end

        %% CDFs Position
        posErrorA      =   zeros(N, rad.steps, azim.steps);
        posErrorB      =   zeros(N, rad.steps, azim.steps);
        posErr2dA      =   zeros(N, nDim, rad.steps, azim.steps);
        posErr2dB      =   zeros(N, nDim, rad.steps, azim.steps);
        for a = 1:azim.steps
            for r = 1:rad.steps
               posErr2dA(:, :, r, a)   =   tx(r, a).pos - txEstPosA(:, :, r, a);
               posErr2dB(:, :, r, a)   =   tx(r, a).pos - txEstPosB(:, :, r, a);

               posErrorA(:, r, a)      =   sqrt(sum(posErr2dA(:, :, r, a).^2, 2));
               posErrorB(:, r, a)      =   sqrt(sum(posErr2dB(:, :, r, a).^2, 2));
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
                cdfLegend{i} = sprintf('\\alpha^o = %d º', mov.azimVals(a));

                figure(cdfFigs(1));
                cdfplot(posErrorA(:, r, a)); hold on;

                figure(cdfFigs(2));
                cdfplot(posErrorB(:, r, a)); hold on;

                i = i + 1;
            end
        end
        figure(cdfFigs(1));
        xlabel('Error [m]');
        legend(cdfLegend, 'Location', 'best'); 
        legend('boxoff');
        title('');
        % title("CDF of TDoA/FDoA method");

        figure(cdfFigs(2));
        xlabel('Error [m]');
        legend(cdfLegend, 'Location', 'best'); 
        legend('boxoff');
        title('');
        % title("CDF of RSS/DoA method");

        fig = [fig, cdfFigs];

        %% CDFs Velocity
        velErrorA      =   zeros(N, rad.steps, azim.steps);
        velErrorB      =   zeros(N, rad.steps, azim.steps);
        velErr2dA      =   zeros(N, nDim, rad.steps, azim.steps);
        velErr2dB      =   zeros(N, nDim, rad.steps, azim.steps);
        for a = 1:azim.steps
            for r = 1:rad.steps
               velErr2dA(:, :, r, a)   =   tx(r, a).vel - txEstVelA(:, :, r, a);
               velErr2dB(:, :, r, a)   =   tx(r, a).vel - txEstVelB(:, :, r, a);

               velErrorA(:, r, a)      =   sqrt(sum(velErr2dA(:, :, r, a).^2, 2));
               velErrorB(:, r, a)      =   sqrt(sum(velErr2dB(:, :, r, a).^2, 2));
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
                cdfLegend{i} = sprintf('\\alpha^o = %d º', mov.azimVals(a));

                figure(cdfFigs(1));
                cdfplot(velErrorA(:, r, a)); hold on;

                figure(cdfFigs(2));
                cdfplot(velErrorB(:, r, a)); hold on;

                i = i + 1;
            end
        end
        figure(cdfFigs(1));
        xlabel('Error [m/s]');
        legend(cdfLegend, 'Location', 'best'); 
        legend('boxoff');
        title('');
        % title("CDF of TDoA/FDoA method");

        figure(cdfFigs(2));
        xlabel('Error [m/s]');
        legend(cdfLegend, 'Location', 'best'); 
        legend('boxoff');
        title('');
        % title("CDF of RSS/DoA method");

        fig = [fig, cdfFigs];

        %% 2D plot
        scale   =   10;
        fig     =   [fig, figure]; set(gcf, 'Position',  [400, 50, 950, 900]);
        rxPos   =   cell2mat({rx.pos}.');
        % rxVel   =   cell2mat({rx.vel}.').*scale;
        scatter(rxPos(:, 1), rxPos(:, 2), mrkrSize, rxColor, 'v', 'LineWidth',mrkrLWidth); 
        hold on;
        % quiver(rxPos(:, 1), rxPos(:, 2), rxVel(:, 1), rxVel(:, 2), 'b'); hold on;


        for r = radIndFor2D
            for a = 1:azim.steps
                %- Actual positions
                scatter(tx(r, a).pos(1), tx(r, a).pos(2), mrkrSize, txColor, 'x', 'LineWidth',mrkrLWidth); 
                hold on;
                %- Estimated positions
                %-- TDoA/FDoA
                scatter(estA(r, a).pos(1), estA(r, a).pos(2), mrkrSize, tdoaColor, 'o', 'LineWidth',mrkrLWidth);
                hold on;
                C       =   cov(txEstPosA(:, :, r, a));
                error_ellipse(C, estA(r, a).pos, 'conf', 0.8,  'style', '--', 'Color', tdoaColor); 
                %-- RSS/DoA
                scatter(estB(r, a).pos(1), estB(r, a).pos(2), mrkrSize, doaColor, 's', 'LineWidth',mrkrLWidth);
                hold on;
                C       =   cov(txEstPosB(:, :, r, a));
                error_ellipse(C, estB(r, a).pos, 'conf', 0.8, 'style', '--', 'Color', doaColor);
            end
        end

        xlabel('X coordinate [m]'); ylabel('Y coordinate [m]');
        L = legend('a', 'b', 'c', 'd', 'e', 'f');
%         icons = findobj(icons,'Marker','v','-or','Marker','x','-or','Marker','o','-or','Marker','s');
%         set(icons, 'MarkerSize',mrkrSize);
        v = findall(gcf, 'marker', 'v');
        set(v, 'DisplayName', 'Rx positions');
        x = findall(gcf, 'marker', 'x');
        set(x, 'DisplayName', 'Actual Tx position');
        o = findall(gcf, 'marker', 'o');
        set(o, 'DisplayName', 'TDoA/FDoA estimation');
        s = findall(gcf, 'marker', 's');
        set(s, 'DisplayName', 'RSS/DoA estimation');
        l1 = findall(gcf, 'linestyle', '--');
        set(l1, 'DisplayName', '80% error ellipse');
        l2 = findall(gcf, 'linestyle', '-');
        set(l2, 'DisplayName', 'Rx velocities');
        L.FontSize = 12;


        %% Save data
        fprintf('Selected test: %s \n\n', testName);
        % saveAnswer  =   menu('Save figures?', 'YES', 'NO');
        saveAnswer = 1;
        if saveAnswer == 1
        %     prompt      =   strcat('Name the figures folder (inside: ', directory, '/ ): ');
        %     dlgtitle    =   'Figures folder';
        %     dims        =   [1 35];
        %     definput    =   {'postprocess_'};
        %     figDirName  =   inputdlg(prompt, dlgtitle, dims, definput);

            figDirName = {sprintf('postprocess_%d', mov.radVals(radIndForCDF))};

            directory = strcat(directory, '/', figDirName{1}, '/');
            if ~exist(directory, 'dir')
                mkdir(directory);
            end

            for i = 1:length(fig)
                saveas(figure(i), sprintf('%sfig_%d.fig', directory, i));
                saveas(figure(i), sprintf('%sfig_%d.png', directory, i));
            end
            close all

        else
            closeAnswer  =   menu('Close figures?', 'YES', 'NO');
            if closeAnswer == 1
                close all
            end
        end
        
    end
end


