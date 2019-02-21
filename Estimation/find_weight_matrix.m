function W = find_weight_matrix(scen)
%   FIND_WEIGHT_MATRIX:    Finds weighting matrix for LS.       
%
%   Input:      scen:       Struct. Information of the scenario
%
%   Output:     W:           (numRx-1)x(numRx-1) matrix. Weighting matrix
%
    c       =   299792458;              % Speed of light (m/s)
    
    switch scen.weighting 
        case 'I'
            W   = eye(2*length(scen.numRx - 1));
        case 'Q'
            timeVar     =   get_time_CRB(scen.snr, scen.ns, scen.freq);
            freqVar     =   get_freq_CRB(scen.snr, scen.ns);
            
            rangeVar    =   2 * c^2 * timeVar;
            rRateVar    =   2 * (c/scen.freq)^2 * freqVar;
            
            size        =   scen.numRx-1;
            Q1          =   rangeVar * eye(size);
            Q2          =   rRateVar * eye(size);
            O           =   zeros(size);
            Q           =   [Q1 O; O Q2];
            W           =   inv(Q);
        otherwise
            W = eye(2*(scen.numRx - 1));
    end
end

