function tx = obtain_tx_info(R, azim, vel, dir)
%   OBTAIN_TX_INFO Generation of tx struct
%
%   	Generation of the tx struct (i.e. position and velocity) from
%   	espherical coordinates and angular velocity.
%
%   Input:      R:          Double. Radius on spherical coordinates
%               azim:       Double. Azimuth angle on espherical coordinates
%                           in rad
%               elev:       Double. Elevation angle on espherical
%                           coordinates in rad
%               vel:        Double. Angular velocity module in rad/s or
%                           linear velocity in m/s (for id='r')
%               mov:        Struct. Description of movement
%
%   Output:     tx:         Structure. Transmitter information, includes
%                           position an velocity in cartesian coordinates

    %- Position computation
    xPos        =   R * cosd(azim);
    yPos        =   R * sind(azim);
    tx.pos      =   [xPos, yPos];
    
    %- Move tx if its position is(0,0) to aprox (0,0) to prevent NaN on 
    % some computations
    aux         =   tx.pos == 0;
    tx.pos(aux) =   1e-300;
    
    %- Velocity computation
    %-- Set direction
    vel     =   dir * vel;
    %-- Angular velocity vector
    w_vect  =   [0, 0, dir * vel];

    %-- Linear velocity
    pos3d   =   [tx.pos, 0];
    vel3d   =   cross(pos3d, w_vect);
    tx.vel  =   vel3d(1:2);
    tx.time =   0;
end

