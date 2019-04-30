function [radius, azim, plotOpt] = build_tx_movement(var, const)
%   OBSERVABLES_GENERATION:     Generation of the vectors describing Tx
%                               movement
%
%       Generation of the vectors describing Tx movement. Movement can be
%       done on radius relative to [0, 0, 0], azimuth angle or elevation
%       angle.
%
%   Input:      var:        Struct. Variable parameter values
%               const:      Struct. Constant parameters
%
%   Output:     radius:     1xsteps. Vector describing the variation in
%                           radius
%               azim:       1xsteps. Vector describing the variation in
%                           azimuth
%               elev:       1xsteps. Vector describing the variation in
%                           elevation
%               plotOpt:    Struct. Information needed for plotting results
    
    I           =   ones(1, var.steps);
    switch var.id
        case 'r'
            radius  =   linspace(var.start, var.end, var.steps);
            azim    =   const.azim * I;
            % Plot options
            plotOpt.xVect   =   radius;
            plotOpt.label   =   "Radius (m)";
            plotOpt.c1      =   sprintf("azimuth = %dº, ", const.azim);
        case 'a'
            radius  =   const.rad * I;
            azim    =   linspace(var.start, var.end, var.steps);
            % Plot options
            plotOpt.xVect   =   azim;
            plotOpt.label   =   "Azimuth (deg)";
            plotOpt.c1      =   sprintf("radius = %d m, ", const.rad);
        otherwise
            error('Value of var.id is not defined properly. Possible values are "a" for azimuth or "r" for radius.');
    end
end

