function distrubutions = rx_distributions()
%   RX_SCHEMES: Generation of RX distributions
%
%   	Definition of the distribution of the receivers including
%   	position, velocity and orientation of the antenna array for each
%   	receiver.
%       Orientation of the ULA defined as: 90º if ULA is parallel to X
%       axis.
%
%   Output:     distrubutions:  Cell array. Schemes of the receivers. Every
%                               cell is an array with the receivers of the 
%                               given scheme.

    distrubutions       =   {};
    aux.pos             =   [0 0];
    aux.vel             =   [0 0];
    aux.orientation     =   0;
    
    ori1                =   2*pi*rand(6, 1);
    ori2                =   rem(ori1+pi/2, 2*pi);
    
    %% SCHEME 1.1
    d = 50/sqrt(2);
    rx(1).pos           =   [d, d];     %    [m]        Rx1 position
    rx(1).vel           =   [0, 0];         %   [m/s]       Rx1 velocity
    rx(1).orientation   =   ori1(1);    %   [rad]       Orientation of the ULA wrt. the X axis
    rx(2).pos           =   [100, 0];       %    [m]        Rx2 position
    rx(2).vel           =   [0, 0];         %   [m/s]       Rx2 velocity
    rx(2).orientation   =   ori1(2);    %   [rad]       Orientation of the ULA wrt. the X axis
    rx(3).pos           =   [-100, 0];      %    [m]        Rx3 position
    rx(3).vel           =   [0, 0];         %   [m/s]       Rx3 velocity
    rx(3).orientation   =   ori1(3);    %   [rad]       Orientation of the ULA wrt. the X axis
    rx(4).pos           =   [0, 100];       %    [m]        Rx4 position
    rx(4).vel           =   [0, 0];         %   [m/s]       Rx4 velocity
    rx(4).orientation   =   ori1(4);    %   [rad]       Orientation of the ULA wrt. the X axis
    rx(5).pos           =   [0, -100];      %    [m]        Rx5 position
    rx(5).vel           =   [0, 0];         %   [m/s]       Rx5 velocity
    rx(5).orientation   =   ori1(5);    %   [rad]       Orientation of the ULA wrt. the X axis
    rx(6).pos           =   [-d, -d];   %    [m]        Rx6 position
    rx(6).vel           =   [0, 0];         %   [m/s]       Rx6 velocity
    rx(6).orientation   =   ori1(6);    %   [rad]       Orientation of the ULA wrt. the X axis

    distrubutions{end+1}      =   rx;
    
    %% SCHEME 1.2
    d = 50/sqrt(2);
    rx(1).pos           =   [d, d];     %    [m]        Rx1 position
    rx(1).vel           =   [0, 0];         %   [m/s]       Rx1 velocity
    rx(1).orientation   =   ori2(1);    %   [rad]       Orientation of the ULA wrt. the X axis
    rx(2).pos           =   [100, 0];       %    [m]        Rx2 position
    rx(2).vel           =   [0, 0];         %   [m/s]       Rx2 velocity
    rx(2).orientation   =   ori2(2);    %   [rad]       Orientation of the ULA wrt. the X axis
    rx(3).pos           =   [-100, 0];      %    [m]        Rx3 position
    rx(3).vel           =   [0, 0];         %   [m/s]       Rx3 velocity
    rx(3).orientation   =   ori2(3);    %   [rad]       Orientation of the ULA wrt. the X axis
    rx(4).pos           =   [0, 100];       %    [m]        Rx4 position
    rx(4).vel           =   [0, 0];         %   [m/s]       Rx4 velocity
    rx(4).orientation   =   ori2(4);    %   [rad]       Orientation of the ULA wrt. the X axis
    rx(5).pos           =   [0, -100];      %    [m]        Rx5 position
    rx(5).vel           =   [0, 0];         %   [m/s]       Rx5 velocity
    rx(5).orientation   =   ori2(5);    %   [rad]       Orientation of the ULA wrt. the X axis
    rx(6).pos           =   [-d, -d];   %    [m]        Rx6 position
    rx(6).vel           =   [0, 0];         %   [m/s]       Rx6 velocity
    rx(6).orientation   =   ori2(6);    %   [rad]       Orientation of the ULA wrt. the X axis

    distrubutions{end+1}      =   rx;

    %% SCHEME 2.1
    d = 250/sqrt(2);
    rx(1).pos           =   [d, d];         %    [m]        Rx1 position
    rx(1).vel           =   [0, 0];         %   [m/s]       Rx1 velocity
    rx(1).orientation   =   ori1(1);   %   [rad]       Orientation of the ULA wrt. the X axis
    rx(2).pos           =   [500, 0];       %    [m]        Rx2 position
    rx(2).vel           =   [0, 0];         %   [m/s]       Rx2 velocity
    rx(2).orientation   =   ori1(2);    %   [rad]       Orientation of the ULA wrt. the X axis
    rx(3).pos           =   [-500, 0];      %    [m]        Rx3 position
    rx(3).vel           =   [0, 0];         %   [m/s]       Rx3 velocity
    rx(3).orientation   =   ori1(3);    %   [rad]       Orientation of the ULA wrt. the X axis
    rx(4).pos           =   [0, 500];       %    [m]        Rx4 position
    rx(4).vel           =   [0, 0];         %   [m/s]       Rx4 velocity
    rx(4).orientation   =   ori1(4);    %   [rad]       Orientation of the ULA wrt. the X axis
    rx(5).pos           =   [0, -500];      %    [m]        Rx5 position
    rx(5).vel           =   [0, 0];         %   [m/s]       Rx5 velocity
    rx(5).orientation   =   ori1(5);    %   [rad]       Orientation of the ULA wrt. the X axis
    rx(6).pos           =   [-d, -d];       %    [m]        Rx6 position
    rx(6).vel           =   [0, 0];         %   [m/s]       Rx6 velocity
    rx(6).orientation   =   ori1(6);    %   [rad]       Orientation of the ULA wrt. the X axis

    distrubutions{end+1}      =   rx;
    
    
    %% SCHEME 2.2
    d = 250/sqrt(2);
    rx(1).pos           =   [d, d];         %    [m]        Rx1 position
    rx(1).vel           =   [0, 0];         %   [m/s]       Rx1 velocity
    rx(1).orientation   =   ori2(1);        %   [rad]       Orientation of the ULA wrt. the X axis
    rx(2).pos           =   [500, 0];       %    [m]        Rx2 position
    rx(2).vel           =   [0, 0];         %   [m/s]       Rx2 velocity
    rx(2).orientation   =   ori2(2);        %   [rad]       Orientation of the ULA wrt. the X axis
    rx(3).pos           =   [-500, 0];      %    [m]        Rx3 position
    rx(3).vel           =   [0, 0];         %   [m/s]       Rx3 velocity
    rx(3).orientation   =   ori2(3);        %   [rad]       Orientation of the ULA wrt. the X axis
    rx(4).pos           =   [0, 500];       %    [m]        Rx4 position
    rx(4).vel           =   [0, 0];         %   [m/s]       Rx4 velocity
    rx(4).orientation   =   ori2(4);        %   [rad]       Orientation of the ULA wrt. the X axis
    rx(5).pos           =   [0, -500];      %    [m]        Rx5 position
    rx(5).vel           =   [0, 0];         %   [m/s]       Rx5 velocity
    rx(5).orientation   =   ori2(5);        %   [rad]       Orientation of the ULA wrt. the X axis
    rx(6).pos           =   [-d, -d];       %    [m]        Rx6 position
    rx(6).vel           =   [0, 0];         %   [m/s]       Rx6 velocity
    rx(6).orientation   =   ori2(6);        %   [rad]       Orientation of the ULA wrt. the X axis

    distrubutions{end+1}      =   rx;

    %% SCHEME 3
    d = 50/sqrt(2);
    rx(1).pos           =   [d, d];     %    [m]        Rx1 position
    rx(1).vel           =   [0, 0];         %   [m/s]       Rx1 velocity
    rx(1).orientation   =   pi/4;    %   [rad]       Orientation of the ULA wrt. the X axis
    rx(2).pos           =   [100, 0];       %    [m]        Rx2 position
    rx(2).vel           =   [0, 0];         %   [m/s]       Rx2 velocity
    rx(2).orientation   =   pi/2;    %   [rad]       Orientation of the ULA wrt. the X axis
    rx(3).pos           =   [-100, 0];      %    [m]        Rx3 position
    rx(3).vel           =   [0, 0];         %   [m/s]       Rx3 velocity
    rx(3).orientation   =   0;    %   [rad]       Orientation of the ULA wrt. the X axis
    rx(4).pos           =   [0, 100];       %    [m]        Rx4 position
    rx(4).vel           =   [0, 0];         %   [m/s]       Rx4 velocity
    rx(4).orientation   =   0;    %   [rad]       Orientation of the ULA wrt. the X axis
    rx(5).pos           =   [0, -100];      %    [m]        Rx5 position
    rx(5).vel           =   [0, 0];         %   [m/s]       Rx5 velocity
    rx(5).orientation   =   pi/2;    %   [rad]       Orientation of the ULA wrt. the X axis
    rx(6).pos           =   [-d, -d];   %    [m]        Rx6 position
    rx(6).vel           =   [0, 0];         %   [m/s]       Rx6 velocity
    rx(6).orientation   =   3*pi/4;    %   [rad]       Orientation of the ULA wrt. the X axis

    distrubutions{end+1}      =   rx;

    %% SCHEME 4
    d = 250/sqrt(2);
    rx(1).pos           =   [d, d];         %    [m]        Rx1 position
    rx(1).vel           =   [0, 0];         %   [m/s]       Rx1 velocity
    rx(1).orientation   =   pi/4;           %   [rad]       Orientation of the ULA wrt. the X axis
    rx(2).pos           =   [500, 0];       %    [m]        Rx2 position
    rx(2).vel           =   [0, 0];         %   [m/s]       Rx2 velocity
    rx(2).orientation   =   pi/2;           %   [rad]       Orientation of the ULA wrt. the X axis
    rx(3).pos           =   [-500, 0];      %    [m]        Rx3 position
    rx(3).vel           =   [0, 0];         %   [m/s]       Rx3 velocity
    rx(3).orientation   =   0;              %   [rad]       Orientation of the ULA wrt. the X axis
    rx(4).pos           =   [0, 500];       %    [m]        Rx4 position
    rx(4).vel           =   [0, 0];         %   [m/s]       Rx4 velocity
    rx(4).orientation   =   0;              %   [rad]       Orientation of the ULA wrt. the X axis
    rx(5).pos           =   [0, -500];      %    [m]        Rx5 position
    rx(5).vel           =   [0, 0];         %   [m/s]       Rx5 velocity
    rx(5).orientation   =   pi/2;    %   [rad]       Orientation of the ULA wrt. the X axis
    rx(6).pos           =   [-d, -d];       %    [m]        Rx6 position
    rx(6).vel           =   [0, 0];         %   [m/s]       Rx6 velocity
    rx(6).orientation   =   3*pi/4;    %   [rad]       Orientation of the ULA wrt. the X axis

    distrubutions{end+1}      =   rx;

    %% SCHEME 5
    d = 750/sqrt(2);
    rx(1).pos           =   [d, d];     %    [m]        Rx1 position
    rx(1).vel           =   [0, 0];         %   [m/s]       Rx1 velocity
    rx(1).orientation   =   2*pi*rand();    %   [rad]       Orientation of the ULA wrt. the X axis
    rx(2).pos           =   [750, 0];       %    [m]        Rx2 position
    rx(2).vel           =   [0, 0];         %   [m/s]       Rx2 velocity
    rx(2).orientation   =   2*pi*rand();    %   [rad]       Orientation of the ULA wrt. the X axis
    rx(3).pos           =   [-750, 0];      %    [m]        Rx3 position
    rx(3).vel           =   [0, 0];         %   [m/s]       Rx3 velocity
    rx(3).orientation   =   2*pi*rand();    %   [rad]       Orientation of the ULA wrt. the X axis
    rx(4).pos           =   [0, 750];       %    [m]        Rx4 position
    rx(4).vel           =   [0, 0];         %   [m/s]       Rx4 velocity
    rx(4).orientation   =   2*pi*rand();    %   [rad]       Orientation of the ULA wrt. the X axis
    rx(5).pos           =   [0, -750];      %    [m]        Rx5 position
    rx(5).vel           =   [0, 0];         %   [m/s]       Rx5 velocity
    rx(5).orientation   =   2*pi*rand();    %   [rad]       Orientation of the ULA wrt. the X axis
    rx(6).pos           =   [-d, -d];   %    [m]        Rx6 position
    rx(6).vel           =   [0, 0];         %   [m/s]       Rx6 velocity
    rx(6).orientation   =   2*pi*rand();    %   [rad]       Orientation of the ULA wrt. the X axis

    distrubutions{end+1}      =   rx;

    %% SCHEME 6
    rx(1).pos           =   [0, 0];         %    [m]        Rx1 position
    rx(1).vel           =   [0, 0];         %   [m/s]       Rx1 velocity
    rx(1).orientation   =   0;              %   [rad]       Orientation of the ULA wrt. the X axis
    rx(2).pos           =   [400, 0];       %    [m]        Rx2 position
    rx(2).vel           =   [0, 0];         %   [m/s]       Rx2 velocity
    rx(2).orientation   =   0;              %   [rad]       Orientation of the ULA wrt. the X axis
    rx(3).pos           =   [-400, 0];      %    [m]        Rx3 position
    rx(3).vel           =   [0, 0];         %   [m/s]       Rx3 velocity
    rx(3).orientation   =   0;              %   [rad]       Orientation of the ULA wrt. the X axis
    rx(4).pos           =   [0, 400];       %    [m]        Rx4 position
    rx(4).vel           =   [0, 0];         %   [m/s]       Rx4 velocity
    rx(4).orientation   =   0;              %   [rad]       Orientation of the ULA wrt. the X axis
    rx(5).pos           =   [0, -400];      %    [m]        Rx5 position
    rx(5).vel           =   [0, 0];         %   [m/s]       Rx5 velocity
    rx(5).orientation   =   0;              %   [rad]       Orientation of the ULA wrt. the X axis
    rx(6).pos           =   [200, 200];     %    [m]        Rx4 position
    rx(6).vel           =   [0, 0];         %   [m/s]       Rx4 velocity
    rx(6).orientation   =   0;              %   [rad]       Orientation of the ULA wrt. the X axis
    rx(7).pos           =   [-200, -200];   %    [m]        Rx5 position
    rx(7).vel           =   [0, 0];         %   [m/s]       Rx5 velocity
    rx(7).orientation   =   0;              %   [rad]       Orientation of the ULA wrt. the X axis

    distrubutions{end+1}      =   rx;
    
    %% SCHEME 7
    rx(1).pos           =   [0, 0];         %    [m]        Rx1 position
    rx(1).vel           =   [0, 0];         %   [m/s]       Rx1 velocity
    rx(1).orientation   =   0;              %   [rad]       Orientation of the ULA wrt. the X axis
    rx(2).pos           =   [400, 0];       %    [m]        Rx2 position
    rx(2).vel           =   [0, 0];         %   [m/s]       Rx2 velocity
    rx(2).orientation   =   0;              %   [rad]       Orientation of the ULA wrt. the X axis
    rx(3).pos           =   [-400, 0];      %    [m]        Rx3 position
    rx(3).vel           =   [0, 0];         %   [m/s]       Rx3 velocity
    rx(3).orientation   =   0;              %   [rad]       Orientation of the ULA wrt. the X axis
    rx(4).pos           =   [0, 400];       %    [m]        Rx4 position
    rx(4).vel           =   [0, 0];         %   [m/s]       Rx4 velocity
    rx(4).orientation   =   0;              %   [rad]       Orientation of the ULA wrt. the X axis
    rx(5).pos           =   [0, -400];      %    [m]        Rx5 position
    rx(5).vel           =   [0, 0];         %   [m/s]       Rx5 velocity
    rx(5).orientation   =   0;              %   [rad]       Orientation of the ULA wrt. the X axis
    rx(6).pos           =   [200, 200];     %    [m]        Rx4 position
    rx(6).vel           =   [0, 0];         %   [m/s]       Rx4 velocity
    rx(6).orientation   =   0;              %   [rad]       Orientation of the ULA wrt. the X axis
    rx(7).pos           =   [-200, -200];   %    [m]        Rx5 position
    rx(7).vel           =   [0, 0];         %   [m/s]       Rx5 velocity
    rx(7).orientation   =   0;              %   [rad]       Orientation of the ULA wrt. the X axis

    distrubutions{end+1}      =   rx;
    
    %% SCHEME 8
    rx(1).pos           =   [0, 0];         %    [m]        Rx1 position
    rx(1).vel           =   [0, 0];         %   [m/s]       Rx1 velocity
    rx(1).orientation   =   0;              %   [rad]       Orientation of the ULA wrt. the X axis
    rx(2).pos           =   [400, 0];       %    [m]        Rx2 position
    rx(2).vel           =   [0, 0];         %   [m/s]       Rx2 velocity
    rx(2).orientation   =   0;              %   [rad]       Orientation of the ULA wrt. the X axis
    rx(3).pos           =   [-400, 0];      %    [m]        Rx3 position
    rx(3).vel           =   [0, 0];         %   [m/s]       Rx3 velocity
    rx(3).orientation   =   0;              %   [rad]       Orientation of the ULA wrt. the X axis
    rx(4).pos           =   [0, 400];       %    [m]        Rx4 position
    rx(4).vel           =   [0, 0];         %   [m/s]       Rx4 velocity
    rx(4).orientation   =   0;              %   [rad]       Orientation of the ULA wrt. the X axis
    rx(5).pos           =   [0, -400];      %    [m]        Rx5 position
    rx(5).vel           =   [0, 0];         %   [m/s]       Rx5 velocity
    rx(5).orientation   =   0;              %   [rad]       Orientation of the ULA wrt. the X axis
    rx(6).pos           =   [200, 200];     %    [m]        Rx4 position
    rx(6).vel           =   [0, 0];         %   [m/s]       Rx4 velocity
    rx(6).orientation   =   0;              %   [rad]       Orientation of the ULA wrt. the X axis
    rx(7).pos           =   [200, -200];    %    [m]        Rx5 position
    rx(7).vel           =   [0, 0];         %   [m/s]       Rx5 velocity
    rx(7).orientation   =   0;              %   [rad]       Orientation of the ULA wrt. the X axis

    distrubutions{end+1}      =   rx;
    
    %% SCHEME 9
    rx(1).pos           =   [0, 0];         %    [m]        Rx1 position
    rx(1).vel           =   [0, 0];         %   [m/s]       Rx1 velocity
    rx(1).orientation   =   0;              %   [rad]       Orientation of the ULA wrt. the X axis
    rx(2).pos           =   [400, 0];       %    [m]        Rx2 position
    rx(2).vel           =   [0, 0];         %   [m/s]       Rx2 velocity
    rx(2).orientation   =   0;              %   [rad]       Orientation of the ULA wrt. the X axis
    rx(3).pos           =   [-400, 0];      %    [m]        Rx3 position
    rx(3).vel           =   [0, 0];         %   [m/s]       Rx3 velocity
    rx(3).orientation   =   0;              %   [rad]       Orientation of the ULA wrt. the X axis
    rx(4).pos           =   [0, 400];       %    [m]        Rx4 position
    rx(4).vel           =   [0, 0];         %   [m/s]       Rx4 velocity
    rx(4).orientation   =   0;              %   [rad]       Orientation of the ULA wrt. the X axis
    rx(5).pos           =   [0, -400];      %    [m]        Rx5 position
    rx(5).vel           =   [0, 0];         %   [m/s]       Rx5 velocity
    rx(5).orientation   =   0;              %   [rad]       Orientation of the ULA wrt. the X axis
    rx(6).pos           =   [200, 200];     %    [m]        Rx4 position
    rx(6).vel           =   [0, 0];         %   [m/s]       Rx4 velocity
    rx(6).orientation   =   0;              %   [rad]       Orientation of the ULA wrt. the X axis
    rx(7).pos           =   [200, -200];    %    [m]        Rx5 position
    rx(7).vel           =   [0, 0];         %   [m/s]       Rx5 velocity
    rx(7).orientation   =   0;              %   [rad]       Orientation of the ULA wrt. the X axis
    rx(8).pos           =   [-200, 200];    %    [m]        Rx4 position
    rx(8).vel           =   [0, 0];         %   [m/s]       Rx4 velocity
    rx(8).orientation   =   0;              %   [rad]       Orientation of the ULA wrt. the X axis
    rx(9).pos           =   [-200, -200];   %    [m]        Rx5 position
    rx(9).vel           =   [0, 0];         %   [m/s]       Rx5 velocity
    rx(9).orientation   =   0;              %   [rad]       Orientation of the ULA wrt. the X axis

    distrubutions{end+1}      =   rx;
    
    %% SCHEME 10
    lim         =   500;
    numRx       =   5;
    rx          =   repmat(aux, 1, numRx);
    for i = 1:numRx
        r           =   randi([-lim lim], 1, 2);
        rx(i).pos   =   r(1:2);
    end

    distrubutions{end+1}      =   rx;
    
    %% SCHEME 11
    lim1        =   200;
    lim2        =   400;
    numRx       =   5;
    rx          =   repmat(aux, 1, numRx+1);
    for i = 1:numRx
        r           =   randi([lim1 lim2], 1, 2);
        rx(i).pos   =   r(1:2);
    end
    
    rx(i+1).pos     =   [-400, -400];

    distrubutions{end+1}      =   rx;
    
    %% SCHEME 12
    lim1        =   200;
    lim2        =   400;
    numRx       =   5;
    rx          =   repmat(aux, 1, numRx+2);
    for i = 1:numRx
        r           =   randi([lim1 lim2], 1, 2);
        rx(i).pos   =   r(1:2);
    end
    
    rx(i+1).pos     =   [-400, -400];
    rx(i+2).pos     =   [400, -400];
    distrubutions{end+1}      =   rx;
    
    %% SCHEME 13
    limPos      =   [-500 500];
    limVel      =   [-10 10];
    numRx       =   5;
    rx          =   repmat(aux, 1, numRx);
    for i = 1:numRx
        rx(i).pos   =   randi(limPos, 1, 2);
        rx(i).vel   =   randi(limVel, 1, 2);
    end
    distrubutions{end+1}      =   rx;
    
    %% SCHEME 14
    limPos      =   [200 400];
    limVel      =   [-10 10];
    numRx       =   5;
    rx          =   repmat(aux, 1, numRx+1);
    for i = 1:numRx
        rx(i).pos   =   randi(limPos, 1, 2);
        rx(i).vel   =   randi(limVel, 1, 2);
    end
    rx(i+1).pos     =   [-400, -400];

    distrubutions{end+1}      =   rx;
    
    %% SCHEME 15
    limPos      =   [-500 500];
    limVel      =   [-10 10];
    numRx       =   5;
    rx          =   repmat(aux, 1, numRx+2);
    for i = 1:numRx
        rx(i).pos   =   randi(limPos, 1, 2);
        rx(i).vel   =   randi(limVel, 1, 2);
    end
    
    rx(i+1).pos     =   [-400, -400];
    rx(i+2).pos     =   [400, -400];
    distrubutions{end+1}  =   rx;
end