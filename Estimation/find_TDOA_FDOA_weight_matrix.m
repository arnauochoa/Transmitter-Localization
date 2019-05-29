function W = find_TDOA_FDOA_weight_matrix(scen, rxPows)
%   FIND_TDOA_FDOA_WEIGHT_MATRIX:    Finds weighting matrix for TDOA/FDOA method. 
%                      
%       Finds weighting matrix for the TDoA/FDoA method. The weighting matrix can be the
%       identity matrix or the inverse covariance matrix, built from the
%       CRLB for time and frequency.
%
%   Input:      scen:       Struct. Information of the scenario
%               rxPows:     Mx1 vector. Received signals' powers
%
%   Output:     W:          (numRx-1)x(numRx-1) matrix. Weighting matrix

    size    =   scen.numRx - 1;
    switch scen.tdoaWeighting 
        case 'I'
            W   = eye(2*size);
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

            %- Obtain TDOA and FDOA CRB wrt. reference receiver
            tdoaVar    =   scen.v^2 * (refTimeVar + timeVar);
            fdoaVar    =   (scen.v/scen.freq)^2 * (refFreqVar + freqVar);
            
            %- Build Weighting matrix
            Q1          =   diag(tdoaVar);
            Q2          =   diag(fdoaVar);
            O           =   zeros(size);
            Q           =   [Q1 O; O Q2]; %%% <----
            W           =   inv(Q);
        case 'R'
            R1          =   ones(size)/2 + eye(size)/2;
%             R2          =   ones(size)/2;
            Q1          =   scen.tdoaVar * R1;
            Q2          =   scen.fdoaVar * R1;
            O           =   zeros(size);
            Q           =   [Q1 O; O Q2];
            W           =   inv(Q);
        otherwise
            W = eye(2*(scen.numRx - 1));
    end
end

