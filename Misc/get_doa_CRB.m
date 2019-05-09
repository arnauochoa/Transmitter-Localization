function thetaCRB = get_doa_CRB(scen, thetaTilde, rxPow)
%   GET_DOA_CRB:      Computes the error in DoA estimation
%
%       This function computes CRB of the DoA estimation error following
%       the equation described in "Cramer-Rao Bounds for Joint RSS/
%       DoA-Based Primary-User Localization in Cognitive Radio Networks", 
%       by Wang et al.
%
%   Input:      scen:           Struct. Information of the scenario
%               thetaTilde: Double. Array orientation wrt. the incoming DoA
%               rxPow:      Double. Received power att given receiver
%
%   Output:     thetaCRB:   Double. CRB of the DoA estimation error

    %- Some initializations
    lambda      =   scen.v / scen.freq;
    if scen.spacing == 0
        d       =   lambda / 2;
    else
        d       =   scen.spacing;
    end

    %- Computation of CRB
    k           =   2*pi*d / lambda;
    beta        =   (6 * scen.No) / ((k^2) * scen.ns * scen.nAnt * (scen.nAnt^2 - 1));
    thetaCRB    =   beta .* (1 ./ rxPow) .* (1 ./ cos(thetaTilde).^2);
end

