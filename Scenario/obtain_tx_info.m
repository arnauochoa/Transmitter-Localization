function tx = obtain_tx_info(R, azim, elev, vel, var)
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
%               vel:        Double. Angular velocity module in rad/s or
%                           linear velocity in m/s (for id='r')
%               var:        Struct. Variable parameter values
%
%   Output:     tx:         Structure. Transmitter information, includes
%                           position an velocity in cartesian coordinates

    %- Position computation
    xPos    =   R * cosd(elev) * cosd(azim);
    yPos    =   R * cosd(elev) * sind(azim);
    zPos    =   R * sind(elev);
    tx.pos  =   [xPos, yPos, zPos];
    
    %- Velocity computation
    %-- Set direction
    vel     =   var.dir * vel;
    %-- Angular velocity vector
    switch var.id
        case 'r'
            mov     =   tx.pos/sqrt(tx.pos * tx.pos');
            tx.vel  =   vel * mov;
        case 'a'
            el_w    =   90 - elev;
            az_w    =   azim - 180;
            x_w     =   vel * cosd(el_w) * cosd(az_w);
            y_w     =   vel * cosd(el_w) * sind(az_w);
            z_w     =   vel * sind(el_w);
            w_vect  =   [x_w, y_w, z_w];
        case 'e'
            x_w     =   -vel * cosd(azim);
            y_w     =   vel * sind(azim);
            w_vect  =   [x_w, y_w, 0];
        otherwise
            w_vect  =   [0, 0, 0];
    end
    if var.id ~= 'r'
        %-- Linear velocity
        tx.vel  =   cross(tx.pos, w_vect);
    end
end

