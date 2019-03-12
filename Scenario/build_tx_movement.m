function [radius, azim, elev, plotOpt] = build_tx_movement(var, const)
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
            elev    =   const.elev * I;
            % Plot options
            plotOpt.xVect   =   radius;
            plotOpt.label   =   "Radius (m)";
            plotOpt.c1      =   sprintf("azimuth = %dº, ", const.azim);
            plotOpt.c2      =   sprintf("elevation = %dº", const.elev);
        case 'a'
            radius  =   const.rad * I;
            azim    =   linspace(var.start, var.end, var.steps);
            elev    =   const.elev * I;
            % Plot options
            plotOpt.xVect   =   azim;
            plotOpt.label   =   "Azimuth (deg)";
            plotOpt.c1      =   sprintf("radius = %d m, ", const.rad);
            plotOpt.c2      =   sprintf("elevation = %dº", const.elev);
        case 'e'
            radius  =   const.rad * I;
            azim    =   const.azim * I;
            elev    =   linspace(var.start, var.end, var.steps);
            % Plot options
            plotOpt.xVect   =   elev;
            plotOpt.label   =   "Elevation (deg)";
            plotOpt.c1      =   sprintf("radius = %d m, ", const.rad);
            plotOpt.c2      =   sprintf("azimuth = %dº", const.azim);
        otherwise
            radius  =   const.rad * I;
            azim    =   const.azim * I;
            elev    =   const.elev * I;
            % Plot options
            plotOpt.xVect   =   elev;
            plotOpt.label   =   "";
            plotOpt.c1      =   "";
            plotOpt.c2      =   "";
    end
end

