function [txEstPos, txEstVel, refRange, refRrate] = first_stage(txFreq, rx, toas, foas)
%   FIRST_STAGE:     First estimation of source's position and velocity.   
%
%       First estimation of source's position and velocity using the first 
%       stage method described by Ho and Xo.
%
%   Input:      txFreq:     Double. Transmission frequency
%               rx:         1xM struct. Information of the receivers  
%               toas:       Mx1 vector. Observed TOAs
%               foas:       Mx1 vector. Observed FOAs
%
%   Output:     txEstPos:   3x1 vector. Source's estimated position
%               txEstVel:   3x1 vector. Source's estimated velocity
%               refRange:   3x1 vector. Reference receiver's range to source
%               refRrate:   3x1 vector. Reference receiver's range rate to source
%

    M   = length(toas);

    [rx, ref, dRange, dRrate] = ...
        get_differences(txFreq, rx, toas, foas);
    
    %- Vector h definition
    h1  =   zeros(M-1, 1);
    h2  =   zeros(M-1, 1);
    %- Matrix G definition
    O   =   zeros(1, 3);
    G1  =   zeros(M-1, 8);
    G2  =   zeros(M-1, 8);
    for row = 1:M-1
        %-- First part of h, corresponding to TDOA
        h1(row)  =   (dRange(row)^2) - dot(rx(row).pos, rx(row).pos) + dot(ref.pos, ref.pos);
        %-- Second part of h, corresponding to FDOA
        h2(row)  =   2 * (dot(dRrate(row), dRange(row)) - dot(rx(row).vel, rx(row).pos) + dot(ref.vel, ref.pos));
        
        %-- First part of G, corresponding to TDOA
        G1(row, :)  =   [(rx(row).pos - ref.pos), dRange(row), O, 0];
        %-- Second part of G, corresponding to FDOA
        G2(row, :)  =   [(rx(row).vel - ref.vel), dRrate(row), ...
            (rx(row).pos - ref.pos), dRange(row)];
    end
    h   =   [h1; h2];
    G   =   -2 .* [G1; G2];
    
    %- Weighted Least Squares
    W   =   find_weight_matrix(dRange, dRrate);
    
%     theta       = pinv(G' * W * G) * G' * W * h;
    theta       = pinv(G) * h;
    txEstPos    = theta(1:3);
    refRange    = theta(4);
    txEstVel    = theta(5:7);
    refRrate    = theta(8);
    
end