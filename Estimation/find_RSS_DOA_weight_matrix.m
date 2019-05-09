function W = find_RSS_DOA_weight_matrix(scen, thetaTilde, rxPows)
%   FIND_RSS_DOA_WEIGHT_MATRIX:    Finds weighting matrix for TDOA/FDOA method. 
%
%       This function computes the weighting matrix as selected on
%       scen.rssWeighting.
%
%   Input:      thetaTilde:     Mx1 vector. Array orientation wrt. the incoming DoA
%               rxPow:          Mx1 vector. Received power att given receiver
%
%   Output:     W:              MxM matrix. Weighting matrix

    switch scen.rssWeighting
        case 'I'
            d       =   ones(size(thetaTilde));
        case 'P'
            %- Estimated doa variance
            d       =   get_doa_CRB(scen, thetaTilde, rxPows);
    end

    W           =   diag(d);
end