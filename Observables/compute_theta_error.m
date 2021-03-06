function thetaError  =   compute_theta_error(scen, thetaTilde, rxPow)
%   COMPUTE_THETA_ERROR:      Computes the error in DoA estimation
%
%       This function computes the error in the estimation of the DoA 
%       expressed in radians.
%       A positive angle is defined as a rotation in anti-clockwise sense
%       with respect to the X axis.
%
%   Input:      scen:       Struct. Information of the scenario
%               thetaTilde: Double. Array orientation wrt. the incoming DoA
%               rxPow:      Double. Received power att given receiver
%
%   Output:     thetaError: Double. Error in DoA estimation
    
    if scen.doaVar == 0
        thetaError  =   normrnd(0, sqrt(get_doa_CRB(scen, thetaTilde, rxPow)));
    else
        thetaError  =   normrnd(0, sqrt(scen.doaVar));
    end

end

