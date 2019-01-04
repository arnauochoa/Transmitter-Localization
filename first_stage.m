function [txEstPos, txEstVel, refRange, refRrate] = first_stage(rxPos, rxVel, toas, foas)
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
    
    c       =   299792458;              % Speed of light (m/s)

    [rxPos, rxVel, refPos, refVel, tdoas, fdoas] = ...
        get_reference(rxPos, rxVel, toas, foas);
    
    dRange  =   tdoas .* c;
    dRrate  =   fdoas .* c; % TODO: review this 
    
    %- Vector h definition
    %-- First part of h, corresponding to TDOA
    h1  =   (dRange.^2) - (rxPos * rxPos.') + (refPos * refPos.');
    %-- Second part of h, corresponding to FDOA
    h2  =   2 * (dRange .* dRrate - rxVel * rxPos.' + refVel * refPos.');

    h   =   [h1; h2];
    
    %- Matrix G definition
    O   =   zeros(1, 3);
    %-- First part of G, corresponding to TDOA
    G1  =   [(rxPos-refPos), dRange, O, 0];
    %-- Second part of G, corresponding to FDOA
    G2  =   [(rxVel-refVel), dRrate, (rxPos-refPos), dRange];
    
    G   =   -2 .* [G1; G2];
    
    %- Weighted Least Squares
    W   =   eye(size(G)); % TODO: external function  will find W from Q
    
    theta       = pinv(G.' * W * G) * G.' * W * h;
    txEstPos    = theta(1);
    txEstVel    = theta(2);
    refRange    = theta(3);
    refRrate    = theta(4);
    
end