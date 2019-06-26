function estTheta    =   get_est_theta(scen, rx, tx, rxPow)
%   GET_EST_THETA:      Computes the estimated Doa
%
%       This function computes the estimated DoA expressed in radians. A
%       positive angle is defined as a rotation in anti-clockwise sense
%       with respect to the X axis.
%
%   Input:      scen:       Struct. Information of the scenario
%               rx:         Struct. Receiver information
%               tx:         Struct. Transmitter information
%               rxPow:      Double. Received power att given receiver
%
%   Output:     estTheta:   Double. Estimated DoA in radians
    
    %- Computation of the true DoA
    if tx.pos == rx.pos
        theta       =   0;
    else
        % theta       =   atan((tx.pos(2) - rx.pos(2)) / (tx.pos(1) - rx.pos(1)));
        theta       =   atan2d((tx.pos(2) - rx.pos(2)), (tx.pos(1) - rx.pos(1)));
    end
    
    %- Orientation of the ULA wrt. the incoming DoA
    thetaTilde  =   theta - rx.orientation;
    
    %- Computation of the estimated DoA
    thetaError  =   compute_theta_error(scen, thetaTilde, rxPow);
    estTheta    =   theta + thetaError;
end

