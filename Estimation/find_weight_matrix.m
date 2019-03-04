function W = find_weight_matrix(scen, rxPows)
%   FIND_WEIGHT_MATRIX:    Finds weighting matrix for LS.       
%
%   Input:      scen:       Struct. Information of the scenario
%               rxPows:     Mx1 vector. Received signals' powers
%
%   Output:     W:          (numRx-1)x(numRx-1) matrix. Weighting matrix
%
    c       =   299792458;              % Speed of light (m/s)
    
    switch scen.weighting 
        case 'I'
            W   = eye(2*(scen.numRx - 1));
        case 'Q'
            timeVar     =   zeros(1, scen.numRx);
            freqVar     =   zeros(1, scen.numRx);
            
            %- Obtain Time and Frequency CRB for each receiver
            for r = 1:scen.numRx
                timeVar(r)      =   get_time_CRB(scen, rxPows(r));
                freqVar(r)      =   get_freq_CRB(scen, rxPows(r));
            end
            
            %- Separate Time and Frequency CRB for reference receiver and others
            refTimeVar              =   timeVar(scen.refIndex);
            timeVar(scen.refIndex)  =   [];
            refFreqVar              =   freqVar(scen.refIndex);
            freqVar(scen.refIndex)  =   [];

            %- Obtain Range and Range Rate CRB wrt. reference receiver
            rangeVar    =   c^2 * (refTimeVar + timeVar);
            rRateVar    =   (c/scen.freq)^2 * (refFreqVar + freqVar);
            
            %- Build Weighting matrix
            size        =   scen.numRx-1;
            Q1          =   diag(rangeVar);
            Q2          =   diag(rRateVar);
            O           =   zeros(size);
            Q           =   [Q1 O; O Q2];
            W           =   inv(Q);
        otherwise
            W = eye(2*(scen.numRx - 1));
    end
end

