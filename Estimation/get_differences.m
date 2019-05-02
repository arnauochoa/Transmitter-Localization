function [rx, ref, dRange, dRrate] = get_differences(scen, rx, toas, foas)
%   GET_DIFFERENCES Returns the reference position and reference and the 
%   TDOAs and FDOAs wrt. the reference
%
%       The reference receiver is selected and extracted from the position
%       and velocity vectors. Then the TDOAs and FDOAs are computed with
%       respect to the reference receiver. The receivers' positions and
%       velocities vectors are also updated removing the reference
%       receiver.
%
%   Input:      rx:         1xM struct. Information of the receivers
%               toas:       Mx1 vector. Observed TOAs
%               foas:       Mx1 vector. Observed FOAs
%
%   Output:     rx:         1x(M-1) struct. Receivers without the reference
%                           receiver
%               ref:        Struct. Reference receiver
%               dRange:     (M-1)x1 vector. Differential ranges wrt. the
%                           reference receiver
%               dRrate:     (M-1)x1 vector. Differential range rates wrt.
%                           the reference receiver
    
    %- Assignation of a reference receiver 
    ref                 =   rx(scen.refIndex);
    rx(scen.refIndex)   =   [];
    
    refTOA              =   toas(scen.refIndex);
    toas(scen.refIndex) =   [];
    refFOA              =   foas(scen.refIndex);
    foas(scen.refIndex) =   [];
    
    %- TDOAs and FDOAs computation
    tdoas  = toas - refTOA;
    fdoas  = foas - refFOA;
    
    %- Differential ranges and range rates for receivers
    dRange  = tdoas .* scen.v;
    dRrate  = -fdoas .* (scen.v/scen.freq);
end

