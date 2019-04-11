function txEstPos = rss_doa_method(scen, rx, rxPows, estDoas)
%   RSS_DOA_METHOD:     Estimation of source's position and velocity using 
%                       RSS and DoA.
%
%       Estimation of source's position and velocity using the RSS/DoA 
%       Weighted version of the Stansfield algorithm described by Werner et
%       al.
%
%   Input:      scen:       Struct. Information of the scenario
%               rx:         1xM struct. Information of the receivers
%               rxPows:     Mx1 vector. Received signals' powers
%               estDoas     Mx1 vector. Estimated directions of arrival
%
%   Output:     txEstPos:   3x1 vector. Source's estimated position


txEstPos = [0 0 0]';

end

