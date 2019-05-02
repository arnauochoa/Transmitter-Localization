function MSBW = get_MS_BW()
%   OBSERVABLES_GENERATION:     Calculation of the Mean Square Bandwidth
%
%       Calculation of the Mean Square Bandwidth for the given band
%       information.
%
%   Input:      scen:   Struct. Information of the scenario
%
%   Output:     MSBW:   Double. Mean Square Bandwidth
    global scen;
    %- Band limit definition
    B               =   scen.bw/2;
    band            =   [scen.freq-B scen.freq+B];
    %- Integration limit definition
    L               =   2*B;
    limit           =   [scen.freq-L scen.freq+L];
    %- Frequency symbolic variable definition
    f               =   sym('f');
    
    %- Power spectral density
    %-- Pulse shape definition 
    switch scen.shape
        case 'r'
            H      =   rectangularPulse(band(1), band(2), f);
        case 't'
            H      =   triangularPulse(band(1), band(2), f);
        case 's'
            H      =   sinc((f - scen.freq)/B);
        otherwise
            H      =   rectangularPulse(band(1), band(2), f);
    end
    
    %-- Assign true power
    normAux         =   double(int(H, limit(1), limit(2)));
    S               =   scen.power/normAux * H;
    
    %- Compute Mean Square Bandwidth
    f1              =   (2*pi*(f))^2 * abs(S)^2;
    f2              =   abs(S)^2;
    
    num             =   int(f1, limit(1), limit(2));
    denom           =   int(f2, limit(1), limit(2));
    
    MSBW            =   double(num/denom);
    
    %- Showing resulting band shape
    if scen.showBand
        figure;
        fplot(S, limit); 
        y1 = get(gca,'ylim'); hold on;
        plot([band(1) band(1)], y1, 'r'); hold on;
        plot([band(2) band(2)], y1, 'r'); hold on;
        xlabel("Frequency (Hz)");
        ylabel("Power Spectral Density (W/Hz)");
        
        figure;
        fplot(f1, limit); hold on;
        xlabel("Frequency (Hz)");
        ylabel("Square Power Spectral Density (W/Hz)");
        
    end
end