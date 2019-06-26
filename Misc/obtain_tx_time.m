function time = obtain_tx_time(tx, i, rad, azim)
%   OBTAIN_TX_TIME Computation of time when current tx position
%
%   	Computation of the time at which the transmitter is at current
%   	position from the tx velocity.
%
%   Input:      tx:         Struct vector. Vector of tx structs for all
%                           positions at current radius
%               i:          Double. Index of the current azimuth
%               rad:        Double. Current radius value
%               azim:       Vector. All azimuth values
%
%   Output:     t:          Double. Time at current position


    if i == 1
        time = 0;
    else
        prevTx  =   tx(i-1);
        
        movAzim =   azim(i) - azim(i-1);
        dist    =   (2 * pi * rad * movAzim) / 360;
        
        time    =   prevTx.time + dist / norm(tx(i).vel);
    end
        

end
