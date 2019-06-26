clear all;
load('dist');
load('orientations');
load('Results/final_4/scheme_2/data', 'estDoas')

rx          =   distributions{4};
thetas      =   linspace(0,180,7);
rads        =   [300, 1500];

thetaInd    =   7;
radInd      =   1;

R           =   rads(radInd); % m
thetaTrue   =   thetas(thetaInd); % deg

thetaTic    =   orientations2;

xPos        =   R * cosd(thetaTrue);
yPos        =   R * sind(thetaTrue);
tx.pos      =   [xPos, yPos];

theta  =   zeros(1, length(rx));

for i = 1:length(rx)
    if tx.pos == rx(i).pos
        theta(i)       =   0;
    else
%         theta(i)       =   atand((tx.pos(2) - rx(i).pos(2)) / (tx.pos(1) - rx(i).pos(1)));
        theta(i)      =   atan2d((tx.pos(2) - rx(i).pos(2)), (tx.pos(1) - rx(i).pos(1)));
    end
end
theta       =   wrapTo360(theta);

thetaTilde  =   theta - thetaTic;

% figure;
% bar(1:6, thetaTilde); hold on;
% plot(xlim, [90 90], 'r');
% plot(xlim, [270 270], 'r');

figure;
bar(1:6, theta);
ylim([0 360]);
xlabel('Receivers'); ylabel('True DoA [º]');

figure;
bar(1:6, abs(cosd(thetaTilde)));
xlabel('Receivers');
ylabel('$\cos(\tilde{\alpha^o})$','Interpreter','latex')
ylim([0 1]);

%% DoA Bars
showDoas    =   estDoas(:, :, radInd, thetaInd);
avgDoas     =   rad2deg(mean(showDoas, 2));

x           =   1:6;
y           =   (wrapTo360(avgDoas));
% negat       =   y-min(showDoas, [], 2);
% posit       =   max(showDoas, [], 2)-y;

figure
bar(x, y);
xlabel('Receivers'); ylabel('Estimated DoA [º]');
ylim([0 360]);


