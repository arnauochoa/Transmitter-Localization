function txEstPos = rss_doa_method(scen, rx, rxPows, estDoas)
%   RSS_DOA_METHOD:     Estimation of source's position and velocity using 
%                       RSS and DoA.
%
%       Estimation of source's position and velocity using the RSS/DoA 
%       Weighted version of the Stansfield algorithm described by Werner et
%       al.
%
%   Input:      rx:         1xM struct. Information of the receivers
%               rxPows:     Mx1 vector. Received signals' powers
%               estDoas:    Mx1 vector. Estimated directions of arrival
%
%   Output:     txEstPos:   2x1 vector. Source's estimated position

    %- Some initializations
    b           =   zeros(scen.numRx, 1);
    A           =   zeros(scen.numRx, 2);
    thetaTilde  =   zeros(scen.numRx, 1);
%     d   =   zeros(scen.numRx, 1);
    
    %- Assign values to b and A
    for i = 1:scen.numRx
        b(i)        =   rx(i).pos(1) * sin(estDoas(i)) - rx(i).pos(2) * cos(estDoas(i));
        A(i, :)     =   [sin(estDoas(i)), -cos(estDoas(i))];
        
        %- Orientation of the ULA wrt. the incoming DoA
        thetaTilde(i)  =   estDoas(i) - rx(i).orientation;
    end
    
    %- Weighted Least Squares
    W           =   find_RSS_DOA_weight_matrix(scen, thetaTilde, rxPows);
    txEstPos    =   pinv(A' * W * A) * A' * W * b;
end

