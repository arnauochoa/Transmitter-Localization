function [range, radVel]   =   compute_range_and_rad_vel(rx, tx)
%   COMPUTE_RANGE_AND_RAD_VEL:     Computes the range rate and relative distance
%                                  between Rx and Tx
%
%       Computation of the range and the radial velocity between
%       transmitter and given receiver.
%
%   Input:      rx:         Struct. Receiver information
%               tx:         Struct. Transmitter information
%
%   Output:     range:      Double. Relative distance between Tx and Rx
%               radVel:     Double. Relative radial velocity between Tx and Rx
    
    %- Relative distance vector and norm
    d       =   rx.pos - tx.pos;
    range   =   norm(d);
    if range == 0 
        range = 1e-10;
    end
    
    %- Scalar projections
    vT      =   dot(tx.vel, d) / range;
    vR      =   dot(rx.vel, d) / range;
    
    %- Range rate
    radVel   =   vT + vR;
end