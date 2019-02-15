function tx = obtain_tx_info(R, azim, elev, angVel)
%   OBTAIN_TX_INFO Generation of tx struct
%
%   	Generation of the tx struct (i.e. position and velocity) from
%   	espherical coordinates and angular velocity.
%
%   Input:      R:     Double. Radius on espherical coordinates
%               azim:       Double. Azimuth angle on espherical coordinates
%                           in rad
%               elev:       Double. Elevation angle on espherical
%                           coordinates in rad
%               angVel:     Double. Angular velocity module in rad/s
%
%   Output:     tx:         Structure. Transmitter information, includes
%                           position an velocity in cartesian coordinates

    %- Position computation
    xPos    =   R * cosd(elev) * cosd(azim);
    yPos    =   R * cosd(elev) * sind(azim);
    zPos    =   R * sind(elev);
    tx.pos  =   [xPos, yPos, zPos];
    
    %- Velocity computation
    %-- Angular velocity vector
    x_w     =   angVel * sind(azim);
    y_w     =   -angVel * cosd(azim);
    w_vect  =   [x_w, y_w, 0];
    
    tx.vel  =   cross(tx.pos, w_vect);
end

