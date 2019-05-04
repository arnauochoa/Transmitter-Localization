function schemes = rx_schemes(selectedSchemes)

    schemes             =   {};
    aux.pos             =   [0 0];
    aux.vel             =   [0 0];
    aux.orientation     =   0;

    %% SCHEME 1
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

    schemes{end+1}      =   rx;

    %% SCHEME 2
    rx(1).pos           =   [0, 0];         %    [m]        Rx1 position
    rx(1).vel           =   [0, 0];         %   [m/s]       Rx1 velocity
    rx(1).orientation   =   0;              %   [rad]       Orientation of the ULA wrt. the X axis
    rx(2).pos           =   [200, 0];       %    [m]        Rx2 position
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

    schemes{end+1}      =   rx;

    %% SCHEME 3
    rx(1).pos           =   [0, 0];         %    [m]        Rx1 position
    rx(1).vel           =   [0, 0];         %   [m/s]       Rx1 velocity
    rx(1).orientation   =   0;              %   [rad]       Orientation of the ULA wrt. the X axis
    rx(2).pos           =   [200, 0];       %    [m]        Rx2 position
    rx(2).vel           =   [0, 0];         %   [m/s]       Rx2 velocity
    rx(2).orientation   =   0;              %   [rad]       Orientation of the ULA wrt. the X axis
    rx(3).pos           =   [-400, 0];      %    [m]        Rx3 position
    rx(3).vel           =   [0, 0];         %   [m/s]       Rx3 velocity
    rx(3).orientation   =   0;              %   [rad]       Orientation of the ULA wrt. the X axis
    rx(4).pos           =   [0, 400];       %    [m]        Rx4 position
    rx(4).vel           =   [0, 0];         %   [m/s]       Rx4 velocity
    rx(4).orientation   =   0;              %   [rad]       Orientation of the ULA wrt. the X axis
    rx(5).pos           =   [0, -200];      %    [m]        Rx5 position
    rx(5).vel           =   [0, 0];         %   [m/s]       Rx5 velocity
    rx(5).orientation   =   0;              %   [rad]       Orientation of the ULA wrt. the X axis

    schemes{end+1}      =   rx;

    %% SCHEME 4
    rx(1).pos           =   [0, -400];         %    [m]        Rx1 position
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

    schemes{end+1}      =   rx;

    %% SCHEME 5
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
    rx(6).pos           =   [200, 200];       %    [m]        Rx4 position
    rx(6).vel           =   [0, 0];         %   [m/s]       Rx4 velocity
    rx(6).orientation   =   0;              %   [rad]       Orientation of the ULA wrt. the X axis
    rx(7).pos           =   [-200, -200];      %    [m]        Rx5 position
    rx(7).vel           =   [0, 0];         %   [m/s]       Rx5 velocity
    rx(7).orientation   =   0;              %   [rad]       Orientation of the ULA wrt. the X axis

    schemes{end+1}      =   rx;

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

    schemes{end+1}      =   rx;
    
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

    schemes{end+1}      =   rx;
    
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

    schemes{end+1}      =   rx;
    
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

    schemes{end+1}      =   rx;
    
    %% SCHEME 10
    lim         =   500;
    numRx       =   5;
    rx          =   repmat(aux, 1, numRx);
    for i = 1:numRx
        r           =   randi([-lim lim], 1, 2);
        rx(i).pos   =   r(1:2);
    end

    schemes{end+1}      =   rx;
    
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

    schemes{end+1}      =   rx;
    
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
    schemes{end+1}      =   rx;
    
    %% SCHEME 13
    limPos      =   [-500 500];
    limVel      =   [-10 10];
    numRx       =   5;
    rx          =   repmat(aux, 1, numRx);
    for i = 1:numRx
        rx(i).pos   =   randi(limPos, 1, 2);
        rx(i).vel   =   randi(limVel, 1, 2);
    end
    schemes{end+1}      =   rx;
    
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

    schemes{end+1}      =   rx;
    
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
    schemes{end+1}  =   rx;
    
    schemes         =   schemes(selectedSchemes);
end