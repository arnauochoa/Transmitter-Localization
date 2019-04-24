function estTheta    =   get_est_theta(rx, tx, scen, rxPow)
%   GET_EST_THETA:      Computes the estimated Doa
%
%       This function computes the estimated DoA expressed in radians. A
%       positive angle is defined as a rotation in anti-clockwise sense
%       with respect to the X axis.
%
%   Input:      rx:         Struct. Receiver information
%               tx:         Struct. Transmitter information
%               scen:       Struct. Values describing the scenario
%               rxPow:      Double. Received power att given receiver
%
%   Output:     estTheta:   Double. Estimated DoA in radians

    %- Computation of the true DoA
    theta       =   atan((tx.pos(1) - rx.pos(1)) / (tx.pos(2) - rx.pos(2)));
    
    %- Orientation of the ULA wrt. the incoming DoA
    thetaTilde  =   theta - rx.orientation;
    
    %- Computation of the estimated DoA
    thetaError  =   compute_theta_error(scen, thetaTilde, rxPow);
    estTheta    =   theta + thetaError;
end

