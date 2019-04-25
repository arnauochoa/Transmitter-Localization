function tx = obtain_tx_info(R, azim, vel, var)
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
%               var:        Struct. Variable parameter values
%
%   Output:     tx:         Structure. Transmitter information, includes
%                           position an velocity in cartesian coordinates

    %- Position computation
    %- 3D
%     xPos    =   R * cosd(elev) * cosd(azim);
%     yPos    =   R * cosd(elev) * sind(azim);
%     zPos    =   R * sind(elev);
%     tx.pos  =   [xPos, yPos, zPos];

    %- 2D
    xPos    =   R * cosd(azim);
    yPos    =   R * sind(azim);
    tx.pos  =   [xPos, yPos];
    
    %- Velocity computation
    %-- Set direction
    vel     =   var.dir * vel;
    %-- Angular velocity vector
    switch var.id
        case 'r'
            mov     =   tx.pos/sqrt(tx.pos * tx.pos');
            tx.vel  =   vel * mov;
        case 'a'
            w_vect  =   [0, 0, var.dir * vel];
        otherwise
            w_vect  =   [0, 0, 0];
    end
    if var.id ~= 'r'
        %-- Linear velocity
        pos3d   =   [tx.pos, 0];
        vel3d   =   cross(pos3d, w_vect);
        tx.vel  =   vel3d(1:2);
    end
end

