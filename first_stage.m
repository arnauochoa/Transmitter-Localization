function [txEstPos, txEstVel, refRange, refRrate] = first_stage(txFreq, rxPos, rxVel, toas, foas)
%   FIRST_STAGE:     First estimation of source's position and velocity.
%
%       First estimation of source's position and velocity using the first 
%       stage method described by Ho and Xo.
%
%   Input:      rxPos:      Mx3 matrix. Receivers' positions
%               rxVel:      Mx3 matrix. Receivers' velocities
%               toas:       Mx1 vector. Observed TOAs
%               foas:       Mx1 vector. Observed FOAs
%
%   Output:     txEstPos:   3x1 vector. Source's estimated position
%               txEstVel:   3x1 vector. Source's estimated velocity
%               refRange:   3x1 vector. Reference receiver's range to source
%               refRrate:   3x1 vector. Reference receiver's range rate to source

    M   = length(toas);

    [rxPos, rxVel, refPos, refVel, dRange, dRrate] = ...
        get_differences(txFreq, rxPos, rxVel, toas, foas);
    
    %- Vector h definition
    h1  =   zeros(M-1, 1);
    h2  =   zeros(M-1, 1);
    %- Matrix G definition
    O   =   zeros(1, 3);
    G1  =   zeros(M-1, 8);
    G2  =   zeros(M-1, 8);
    for row = 1:M-1
        %-- First part of h, corresponding to TDOA
        h1(row)  =   (dRange(row)^2) - (rxPos(row, :) * rxPos(row, :).') + (refPos * refPos.');
        %-- Second part of h, corresponding to FDOA
        h2(row)  =   2 * (dRrate(row) * dRange(row) - rxVel(row, :) * rxPos(row, :).' + refVel * refPos.');
        
        %-- First part of G, corresponding to TDOA
        G1(row, :)  =   [(rxPos(row, :) - refPos), dRange(row), O, 0];
        %-- Second part of G, corresponding to FDOA
        G2(row, :)  =   [(rxVel(row, :) - refVel), dRrate(row), ...
            (rxPos(row, :) - refPos), dRange(row)];
    end
    h   =   [h1; h2];
    G   =   -2 .* [G1; G2];
    
    %- Weighted Least Squares
    W   =   eye(2*(M-1)); % TODO: external function will find W from Q
    
    theta       = pinv(G.' * W * G) * G.' * W * h;
    txEstPos    = theta(1:3);
    refRange    = theta(4);
    txEstVel    = theta(5:7);
    refRrate    = theta(8);
    
end