function [txEstPos, txEstVel, refRange, refRrate] = tdoa_fdoa_method(rx, rxPows, rxTimes, rxFreqs)
%   FIRST_STAGE:     Estimation of source's position and velocity using TDoA and FDoA.   
%
%       Estimation of source's position and velocity using the TDoA and 
%       FDoA method described by Ho and Xo.
%
%   Input:      scen:       Struct. Information of the scenario
%               rx:         1xM struct. Information of the receivers
%               rxPows:     Mx1 vector. Received signals' powers
%               rxTimes:    Mx1 vector. Observed TOAs
%               rxFreqs:    Mx1 vector. Observed FOAs
%
%   Output:     txEstPos:   3x1 vector. Source's estimated position
%               txEstVel:   3x1 vector. Source's estimated velocity
%               refRange:   3x1 vector. Reference receiver's range to source
%               refRrate:   3x1 vector. Reference receiver's range rate to source
%
    
    M       =   length(rxTimes);
    nDim    =   2;

    [rx, ref, dRange, dRrate] = ...
        get_differences(rx, rxTimes, rxFreqs);
    
    %- Vector h definition
    h1  =   zeros(M-1, 1);
    h2  =   zeros(M-1, 1);
    %- Matrix G definition
    O   =   zeros(1, nDim);
    G1  =   zeros(M-1, 2*nDim+2);
    G2  =   zeros(M-1, 2*nDim+2);
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
    W   =   find_TDOA_FDOA_weight_matrix(rxPows);
    
    
    theta       =   pinv(G' * W * G) * G' * W * h;


    txEstPos    =   theta(1:nDim);
    refRange    =   theta(nDim+1);
    txEstVel    =   theta(nDim+2:2*nDim+1);
    refRrate    =   theta(2*nDim+2);
    
end