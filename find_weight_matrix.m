function W = find_weight_matrix(dRange, dRrate)
%   FIND_WEIGHT_MATRIX:    Finds weighting matrix for LS.       
%
%   Input:      dRange:      1x(numRx-1) vector. Differential ranges
%               dRrate:      1x(numRx-1) vector. Differential range rates
%
%   Output:     W:           (numRx-1)x(numRx-1) matriix. Weighting matrix
%

% TODO: find W from covariance matrix Q


W = eye(2*length(dRange));
end

