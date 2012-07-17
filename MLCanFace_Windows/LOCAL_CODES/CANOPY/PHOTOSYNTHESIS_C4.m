function [Ph, An] = PHOTOSYNTHESIS_C4(VARIABLES, PARAMS, VERTSTRUC, sunlit) 
%
%:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::%
%%                              FUNCTION CODE                            %%
%%                     C4 PHOTOSYNTHESIS CALCULATION                     %%
%:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::%
%-------------------------------------------------------------------------%                                                   
% This function is used to calculates leaf photosynthesis according to    %
%   the Collatz et al (AJPP, 1992) model for C4 photosynthesis            %
%-------------------------------------------------------------------------%
%   INPUTS:                                                               %
%       Qabs    = absorbed PAR                                            % [umol/m^2 leaf area/s]    
%       Tl      = leaf temperature                                        % [C]                       
%       Ci      = internal CO2 concentration                              % [ppm]                     
%       O       = oxygen concentration                                    % 
%       Vmax    = Maximum rubisco capacity                                % [umol/m^2 leaf area/s]    
%       Q10     = proportional increase for parameter value for           %
%                  10C increase in Tl                                     % [-]
%       kk      = initial slope of photosynthetic CO2 response            % [mol/m^2 leaf area/s]
%       theta   = curvature parameter                                     % [-]                       
%       beta    = curvature parameter                                     % [-]                       
%       Vz      = decay of photosynthetic capacity with canopy depth      % [-]
%                                                                         %
%   OUTPUTS:                                                              %
%       Ph      = leaf photosynthesis                                     % [umol/m^2 leaf area/s]
%       An      = net leaf CO2 uptake rate                                % [umol/m^2 leaf area/s]
%                                                                         %
%   OTHERS:                                                               %
%       RT      = leaf respiration                                        %                                          
%       kT      = temperature-dependent pseudo-first order rate constant  %
%                                                                         %
%-------------------------------------------------------------------------%
%   Date        : January 12, 2010                                        %
%% --------------------------------------------------------------------- %%  
%
%
%*************************************************************************%
%% <<<<<<<<<<<<<<<<<<<<<<<<< DE-REFERENCE BLOCK >>>>>>>>>>>>>>>>>>>>>>>> %%
%*************************************************************************%
%
	if (sunlit)  
        Qabs = VARIABLES.CANOPY.PARabs_sun;
        Tl   = VARIABLES.CANOPY.Tl_sun;
        Ci   = VARIABLES.CANOPY.Ci_sun;
    else
        Qabs = VARIABLES.CANOPY.PARabs_shade;
        Tl   = VARIABLES.CANOPY.Tl_shade;
        Ci   = VARIABLES.CANOPY.Ci_shade;
    end
%
    Vmax    = PARAMS.Photosyn.Vmax_C4;        
    kk      = PARAMS.Photosyn.kk_C4;
    Q10     = PARAMS.Photosyn.Q10_C4;
    theta   = PARAMS.Photosyn.theta_C4;
    beta    = PARAMS.Photosyn.beta_C4;
    Rd      = PARAMS.Photosyn.Rd_C4;
    al      = PARAMS.Photosyn.al_C4;    
%
    Vz      = VARIABLES.CANOPY.Vz;
%    
    nvinds  = VERTSTRUC.nvinds; 
%    
%*************************************************************************%
%% <<<<<<<<<<<<<<<<<<<<<<< END OF DE-REFERENCE BLOCK >>>>>>>>>>>>>>>>>>> %%
%*************************************************************************%
%% 
    Vmaxs   = Vz * Vmax;
% 
% Equation 5B in Appendix B, pp.537
    Q10s    = Q10.^((Tl-25)./10);
    VT      = (Vmaxs .* Q10s)./( (1 + exp(0.3 * (13-Tl))) .*...
                (1 + exp(0.3 * (Tl-36))) );
    RT      = Rd .* Q10s ./ (1 + exp(1.3 * (Tl-55)));
    kT      = kk * Q10s;
% 
% Equation 2B in Appendix B, pp.537
    aa      = theta * ones(size(Qabs));
    bb      = -(VT + al * Qabs);
    cc      = VT * al .* Qabs;
    for ii = 1:length(aa)
        Mroots = roots([aa(ii), bb(ii), cc(ii)]);
        M(ii)  = min(Mroots);
    end
    M = M(:);
%  
% Equation 3B in Appendix B, pp.537
    aa      = beta * ones(size(Qabs));
    bb      = -(M+kT.*Ci);
    cc      = M.*kT.*Ci;
    for ii = 1:length(aa)
        Aroots = roots([aa(ii), bb(ii), cc(ii)]);
        Ph(ii) = min(Aroots);
    end
%
    Ph = Ph(:);
%
    An = Ph - RT;
%
%
%:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::%
%% <<<<<<<<<<<<<<<<<<<<<<<<< END OF FUNCTION >>>>>>>>>>>>>>>>>>>>>>>>>>>>%%
%:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::%
 