function [txEstPos, refRange] = tdoa_method(scen, rx, rxPows, rxTimes)
%   FIRST_STAGE:     Estimation of source's position and velocity using TDoA and FDoA.   
%
%       Estimation of source's position and velocity using the TDoA and 
%       FDoA method described by Ho and Xo.
%
%   Input:      scen:       Struct. Information of the scenario
%               rx:         1xM struct. Information of the receivers
%               rxPows:     Mx1 vector. Received signals' powers
%               rxTimes:    Mx1 vector. Observed TOAs
%
%   Output:     txEstPos:   3x1 vector. Source's estimated position
%               refRange:   3x1 vector. Reference receiver's range to source
%
    
    global nDim;
    
    M       =   scen.numRx;  % TODO: change this

    rxFreqs =   zeros(size(rxTimes));  % TODO: change this
    
    [rx, ref, dRange, ~] = ...
        get_differences(scen, rx, rxTimes, rxFreqs); % TODO: change this
    
    %- Vector h definition
    h1  =   zeros(M-1, 1);
    %- Matrix G definition
    O   =   zeros(1, nDim);
    G1  =   zeros(M-1, 2*nDim+2);
    for row = 1:M-1
        %-- First part of h, corresponding to TDOA
        h1(row)  =   (dRange(row)^2) - dot(rx(row).pos, rx(row).pos) + dot(ref.pos, ref.pos);
        
        %-- First part of G, corresponding to TDOA
        G1(row, :)  =   [(rx(row).pos - ref.pos), dRange(row), O, 0];
    end
    h   =   -h1;
    G   =   2 .* G1;
    
    %- Weighted Least Squares
    W   =   find_TDOA_FDOA_weight_matrix(scen, rxPows);
    
    W   =   W(1:M-1, 1:M-1);
    
    theta       =   pinv(G' * W * G) * G' * W * h;


    txEstPos    =   theta(1:nDim);
    refRange    =   theta(nDim+1);
end