function txEstPos = rss_doa_method(scen, rx, rxPows, estDoas)
%   RSS_DOA_METHOD:     Estimation of source's position and velocity using 
%                       RSS and DoA.
%
%       Estimation of source's position and velocity using the RSS/DoA 
%       Weighted version of the Stansfield algorithm described by Werner et
%       al.
%
%   Input:      scen:       Struct. Information of the scenario
%               rx:         1xM struct. Information of the receivers
%               rxPows:     Mx1 vector. Received signals' powers
%               estDoas:    Mx1 vector. Estimated directions of arrival
%
%   Output:     txEstPos:   3x1 vector. Source's estimated position


    %- Some initializations
    M   =   length(rx);
    b   =   zeros(M, 1);
    A   =   zeros(M, 2);
    
    %- Assign values to b and A
    for i = 1:M
        b(i)    =   rx(i).pos(1) * sin(estDoas(i)) - rx(i).pos(2) * cos(estDoas(i));
        A(i, :) =   [sin(estDoas(i)), -cos(estDoas(i))];
    end
    
    %- Weighted Least Squares
    
    



    txEstPos = [0 0 0]';

end

