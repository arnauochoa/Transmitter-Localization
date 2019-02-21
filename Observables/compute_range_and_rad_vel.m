function [range, radVel]   =   compute_range_and_rad_vel(rx, tx)
%   COMPUTE_RANGE_RATE:     Computes the range rate and relative distance
%                           between Rx and Tx
%
%       Computation of the range rate (time rate of change of the distance
%       between two locations).
%
%   Input:      rxPos:  Struct. Receiver information
%               txPos:  Struct. Transmitter information
%
%   Output:     rRate: 	Double. Range rate between Tx and Rx
%               dRel:   Double. Relative distance between Tx and Rx
    
    %- Relative distance vector and norm
    d       =   rx.pos - tx.pos;
    range    =   norm(d);
    
    %- Scalar projections
    vT      =   dot(tx.vel, d) / range;
    vR      =   dot(rx.vel, d) / range;
    
    %- Range rate
    radVel   =   vT + vR;
end