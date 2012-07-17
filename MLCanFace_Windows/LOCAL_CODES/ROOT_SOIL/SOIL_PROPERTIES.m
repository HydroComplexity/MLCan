function [HC_sol, porsl, psi0, bsw, TK_sol, TK_dry, HKsat, theta_dry] ...
            = SOIL_PROPERTIES(PARAMS, VERTSTRUC)

%:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::%
%%                             FUNCTION CODE                             %%
%%                            SOIL_PROPERTIES                            %%
%:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::%
%-------------------------------------------------------------------------%
% This function calculates the profiles of the soil properties that are   %
% dependent solely on soil composition (sand and clay content)            %
% See Oleson et al (2004) (CLM Documentation) for equation # references   %                                                          %
%                                                                         %
%-------------------------------------------------------------------------%
%   Created by  : Darren Drewry                                           %
%   Editted by  : Phong Le                                                %
%   Date        : December 26, 2009                                       %
%% --------------------------------------------------------------------- %%  
%
%
%*************************************************************************%
%% <<<<<<<<<<<<<<<<<<<<<<<<< DE-REFERENCE BLOCK >>>>>>>>>>>>>>>>>>>>>>>> %%
%*************************************************************************%
%
    sand    = VERTSTRUC.sand;
    clay    = VERTSTRUC.clay;
    zhs     = VERTSTRUC.zhs;
    smpmin  = PARAMS.Soil.smpmin;
    scalek  = PARAMS.Soil.scalek;
%    
%*************************************************************************%
%% <<<<<<<<<<<<<<<<<<<<<<<<END OF DE-REFERENCE BLOCK >>>>>>>>>>>>>>>>>>> %%
%*************************************************************************%
%%  
% HEAT CAPACITY OF SOIL SOLIDS [J / m^3 / K]
    HC_sol  = (2.128*sand+2.385*clay) ./ (sand+clay) * 10^6;       % (6.68) 
%    
% POROSITY = WATER CONTENT AT SATURATION [-]
%    porsl = 0.489 - 0.00126*sand;                                 % (7.72)
    porsl   = 0.4 * ones(size(sand));                              % Set all porosity equal to 0.4 instead of using (7.72)
     
% MINIMUM SOIL SUCTION = SOIL POTENTIAL AT SATURATION [mm]
    psi0    = -10 * ( 10.^(1.88-0.0131*sand) );                    % (7.75)
%     
% Clapp-Hornberger "b" parameter [-]
    bsw     = 2.91 + 0.159*clay;                                   % (7.73)
%    
% THERMAL CONDUCTIVITY OF SOIL MINERALS [W / m / K]
    TK_sol  = (8.80*sand+2.92*clay) ./ (sand+clay);                % (6.61)
%     
% BULK DENSITY [kg / m^3]
    rhod    = 2700*(1 - porsl);                             % (before 6.62)
%    
% THERMAL CONDUCTIVITY OF DRY SOIL [W / m / K]
    TK_dry  = (0.135*rhod + 64.7) ./ (2700 - 0.947*rhod);          % (6.62)
%     
% HYDRAULIC CONDUCTIVITY AT SATURATION [mm / s] 
    HKsat   = 0.0070556 * ( 10.^(-0.884+0.0153*sand) )...          % (7.71)
                       .*exp(-zhs/scalek);
%
% SOIL MOISTURE CONTENT AT COMPLETE DRYNESS
    theta_dry   = porsl .* ( psi0./smpmin ).^(1./bsw);                    % 
%
%
%:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::%
%% <<<<<<<<<<<<<<<<<<<<<<<<< END OF FUNCTION >>>>>>>>>>>>>>>>>>>>>>>>>>>>%%
%:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::%          
                