function [rRate, dRel]   =   compute_range_rate(rxPos, rxVel, txPos, txVel)
%   COMPUTE_RANGE_RATE:     Computes the range rate and relative distance
%   between Rx and Tx
%
%       Computation of the range rate (time rate of change of the distance
%       between two locations.
%
%   Input:      rxPos:  3x1 vector. Receiver position
%               rxVel:  3x1 vector. Receiver velocity
%               txPos:  3x1 vector. Transmitter position
%               txVel:  3x1 vector. Transmitter velocity
%
%   Output:     rRate: 	Double. Range rate between Tx and Rx
%               dRel:   Double. Relative distance between Tx and Rx
    
    %- Relative distance vector and norm
    d       =   rxPos - txPos;
    dRel    =   norm(d);
    
    %- Scalar projections
    vT      =   dot(txVel, d) / dRel;
    vR      =   dot(rxVel, d) / dRel;
    
    %- Range rate
    rRate   =   vT + vR;
end