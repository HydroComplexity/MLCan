function [Tl, H, LE, gv] = LEB_QUARTIC_WET (VARIABLES, PARAMS, VERTSTRUC, CONSTANTS, sunlit)
%
%:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::%
%%                             FUNCTION CODE                             %%
%%                            LEB_QUARTIC_WET                            %%
%:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::%
%   This function solve exact energy balance equation as presented in     %
%   Nikolov et al (1995) using an expansion of the saturation vapor       %
%   pressure at leaf temperature using a fourth order polynomial          %
%                                                                         %
%   Rabs = LE + H + Me + LWout                                            %
%                                                                         %
%   where   Rabs is the bi-directional absorbed radiation                 %
%           Me is the energy stored in biochemical reactions              %
%           LW is the emitted LW radiation by the leaf layer              %
%                                                                         %
%           all terms are in [W / m^2 leaf area]                          %
%-------------------------------------------------------------------------%
%   Date        : January 13, 2010                                        %
%-------------------------------------------------------------------------%
%   INPUTS:                                                               %
%       Rabs    - total absorbed radiation                                % [W/m^2 leaf area]
%       An      - net CO2 uptake                                          % [umol/m^2 la/s]
%       Taz     - ambient air temperture profile                          % [C]
%       eaz     - ambient vapor pressure profile                          % [kPa]
%       gsv     - stomatal conductance to vapor transport                 % [mol/m^2 la/s]
%       gbv     - boundary layer conductance to vapor transport           % [mol/m^2 la/s]
%       gbh     - boundary layer conductance to heat transport            % [mol/m^2 la/s]
%       Paz     - ambient air pressure                                    % [kPa]
%       epsv    - leaf long-wave emissivity                               % [-]
%       LWfact  - # leaf sides LW emitted from                            % [-]
%       Hfact   - # leaf sides sensible heat exchanged from               % [-]
%       LEfact  - # leaf sides latent heat exchanged from                 % [-]
%                                                                         %
%   OUTPUTS:                                                              %
%       Tl      - leaf temperature profile                                % [C]
%       H       - sensible heat flux profile                              % [W / m^2 leaf area]
%       LE      - latent heat flux profile                                % [W / m^2 leaf area]
%       gv      - total vapor conductance profile                         % [W / m^2 leaf area]
%                                                                         %
%% --------------------------------------------------------------------- %%  
%
%
%*************************************************************************%
%% <<<<<<<<<<<<<<<<<<<<<<<<< DE-REFERENCE BLOCK >>>>>>>>>>>>>>>>>>>>>>>> %%
%*************************************************************************%
%
    if (sunlit)
        Rabs    = VARIABLES.CANOPY.Rabs_sun;
        An      = VARIABLES.CANOPY.An_sun;
        gsv     = VARIABLES.CANOPY.gsv_sun;
        gbv     = VARIABLES.CANOPY.gbv_sun;
        gbh     = VARIABLES.CANOPY.gbh_sun;
        leaffrac= VARIABLES.CANOPY.fsun;
        LAIfrac = VARIABLES.CANOPY.LAIsun;
    else
        Rabs    = VARIABLES.CANOPY.Rabs_shade;
        An      = VARIABLES.CANOPY.An_shade;
        gsv     = VARIABLES.CANOPY.gsv_shade;
        gbv     = VARIABLES.CANOPY.gbv_shade;
        gbh     = VARIABLES.CANOPY.gbh_shade;
        leaffrac= VARIABLES.CANOPY.fshade;
        LAIfrac = VARIABLES.CANOPY.LAIshade;
    end
%                                            
    taud    = VARIABLES.CANOPY.taud;
%                                        
    eaz     = VARIABLES.CANOPY.EAz;
    Taz     = VARIABLES.CANOPY.TAz;
    Paz     = VARIABLES.CANOPY.PAz;
%
    epsv    = PARAMS.Rad.epsv;
    LWfact  = PARAMS.CanStruc.LWfact;
    Hfact   = PARAMS.CanStruc.Hfact;
    LEfact  = PARAMS.CanStruc.LEfact;
%    
    vinds   = VERTSTRUC.vinds; 
%    
    Lv      = CONSTANTS.Lv;                     % latent heat of vaporization [J / mol]
    boltz   = CONSTANTS.boltz;                  % Stefan-Boltzmann constant [W / m^2 / K^4]
    cp      = CONSTANTS.cp_mol;                 % [J/mol/K]
%    
%*************************************************************************%
%% <<<<<<<<<<<<<<<<<<<<<<< END OF DE-REFERENCE BLOCK >>>>>>>>>>>>>>>>>>> %%
%*************************************************************************%
%% 
	gbh = gbh * 0;
%
% Energy stored in biochemical reactions (Me)
	Me = 0.506 * An;                            % [W / m^2] - energy stored in biochemical reactions
%        
% Total vapor conductance (gv)
	gv = gbv;                                   % [mol/m^2/s]
%
%    
    aa = 273.15;
    bb = LWfact * epsv * boltz * (1-taud) .* leaffrac ./ LAIfrac;
    dd = Hfact * cp * gbh;
    ee = LEfact * gv * Lv ./ Paz;
    
    % Parameters in eqn (39)
    c1 = (5.82436*10^-4) / 1000;
    c2 = (1.5842*10^-2) / 1000;
    c3 = 1.55186 / 1000;
    c4 = 44.513596 / 1000;
    c5 = 607.919 / 1000;
    
    % Terms of Quartic
    T4 = ee.*c1 + bb;                                       % * Tl^4
    T3 = ee.*c2 + 4*aa.*bb;                                 % * Tl^3
    T2 = ee.*c3 + 6*bb.*aa.^2;                              % * Tl^2
    T1 = ee.*c4 + dd + 4*bb.*aa.^3;                         % * Tl
    T0 = ee.*(c5-eaz) - dd.*Taz + bb.*aa.^4 - Rabs + Me;    % constant term            
%    
    for ii = vinds'%1:length(Taz)
        Tl_roots = roots([T4(ii), T3(ii), T2(ii), T1(ii), T0(ii)]);
        rcnt     = 0;
        Tl_all   = [];
        for jj = 1:length(Tl_roots)
            if (isreal(Tl_roots(jj)) && Tl_roots(jj)>0)
                rcnt = rcnt + 1;
                Tl_all = [Tl_all, Tl_roots(jj)];
            end
        end
    %
	% Error Check
        if (rcnt == 0)
            disp(['NO REAL, POSITIVE ROOTS FOUND IN LEB_WET!!!'])
            Tl(ii) = Taz(ii);
        else    
            Tl(ii) = min(Tl_all);
        end
    end
%
    estarTl = 0.611 * exp( (17.502*Tl) ./ (Tl + 240.97) );
    LE      = LEfact.*(Lv*gv./Paz).*(estarTl' - eaz);
    H       = Hfact.*cp.*gbh.*(Tl' - Taz);
%
    H       = H(:);
    LE      = LE(:);
    Tl      = Tl(:);
    gv      = gv(:);
%
% Compute normalized energy balance terms for checking:
    LE_check    = ee.*(c1.*Tl.^4 + c2.*Tl.^3 + c3.*Tl.^2 + c4.*Tl + c5 - eaz);
    H_check     = dd.*(Tl - Taz);
    LWout_check = bb.*(Tl.^4 + 4*aa.*Tl.^3 + (6*aa.^2).*Tl.^2 + (4*aa.^3).*Tl + aa.^4);
%
%
%:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::%
%% <<<<<<<<<<<<<<<<<<<<<<<<< END OF FUNCTION >>>>>>>>>>>>>>>>>>>>>>>>>>>>%%
%:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::%
%



