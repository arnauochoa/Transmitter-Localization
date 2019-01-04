function [rxPos, rxVel, refPos, refVel, tdoas, fdoas] = get_differences(rxPos, rxVel, toas, foas)
%GET_DIFFERENCES Returns the reference position and reference and the TDOAs
%   and FDOAs wrt. the reference
%
%       The reference receiver is selected and extracted from the position
%       and velocity vectors. Then the TDOAs and FDOAs are computed with
%       respect to the reference receiver. The receivers' positions and
%       velocities vectors are also updated removing the reference
%       receiver.
%
%   Input:      rxPos:      Mx3 matrix. Receivers' positions
%               rxVel:      Mx3 matrix. Receivers' velocities
%               toas:       Mx1 vector. Observed TOAs
%               foas:       Mx1 vector. Observed FOAs
%
%   Output:     rxPos:      (M-1)x3 matrix. Receivers' positions without
%                           reference receiver
%               rxVel:      (M-1)x3 matrix. Receivers' velocities without
%                           reference receiver
%               refPos:     1x3 vector. Position of the reference receiver
%               refVel:     1x3 vector. Velocity of the reference receiver
%               tdoas:      (M-1)x1 vector. TDOAs wrt. the reference
%                           receiver
%               fdoas:      (M-1)x1 vector. FDOAs wrt. the reference
%                           receiver
    
    refIndex    = 1;
    %- Assignation of a reference receiver 
    refPos              =   rxPos(refIndex, :);
    rxPos(refIndex)     =   [];
    refVel              =   rxVel(refIndex, :);
    rxVel(refIndex)     =   [];
    
    refTOA              =   toas(refIndex);
    toas(refIndex)      =   [];
    refFOA              =   foas(refIndex);
    foas(refIndex)      =   [];
    
    %- TDOAs and FDOAs computation
    tdoas  = abs(refTOA - toas);
    fdoas  = abs(refFOA - foas);
end

