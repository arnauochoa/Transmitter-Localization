function [radius, azim, elev, plotOpt] = build_tx_movement(var, const)
%BUILD_TX_MOVEMENT Summary of this function goes here
%   Detailed explanation goes here
I           =   ones(1, var.steps);
step        =   abs((var.end - var.start)/(var.steps-1));
switch var.id
    case 'r'
        radius  =   var.start:step:var.end;
        azim    =   const.azim * I;
        elev    =   const.elev * I;
        % Plot options
        plotOpt.xVect   =   radius;
        plotOpt.label   =   "Radius (m)";
        plotOpt.c1      =   sprintf("azimuth = %dº, ", const.azim);
        plotOpt.c2      =   sprintf("elevation = %dº", const.elev);
    case 'a'
        radius  =   const.rad * I;
        azim    =   var.start:step:var.end;
        elev    =   const.elev * I;
        % Plot options
        plotOpt.xVect   =   azim;
        plotOpt.label   =   "Azimuth (deg)";
        plotOpt.c1      =   sprintf("radius = %d m, ", const.rad);
        plotOpt.c2      =   sprintf("elevation = %dº", const.elev);
    case 'e'
        radius  =   const.rad * I;
        azim    =   const.azim * I;
        elev    =   var.start:step:var.end;
        % Plot options
        plotOpt.xVect   =   elev;
        plotOpt.label   =   "Elevation (deg)";
        plotOpt.c1      =   sprintf("radius = %d m, ", const.rad);
        plotOpt.c2      =   sprintf("azimuth = %dº", const.azim);
    otherwise
        radius  =   const.rad * I;
        azim    =   const.azim * I;
        elev    =   const.elev * I;
end


end

