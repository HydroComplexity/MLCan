function [Hs, LEs, Gs, RH] = SOIL_SURFACE_FLUXES(VARIABLES, VERTSTRUC, PARAMS, CONSTANTS)
%         
%:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::%
%%                             FUNCTION CODE                             %%
%%                     CALCULATE SOIL SURFACE FLUXES                     %%
%:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::%
%-------------------------------------------------------------------------%
% This function calculate soil CO2 flux using Q10 relationship and        %
%   solve surface energy balance based on formulation of                  %
%   (Hinzman et al, JGR 1998) --> Equation #s refer to Hinzman            %
%-------------------------------------------------------------------------%
%                                                                         %
%   INPUTS:                                                               %
%       Ts      = soil surface temp                         [C]           %
%       Rabs    = absorbed radiation by soil                [W / m^2]     %
%       Ta1     = air temperature at surface                [C]           %
%       Ts      = soil temperature at surface               [C]           %
%       ea1     = vapor pressure at surface                 [kPa]         %
%       pa      = air pressure at surface                   [kPa]         %
%       U1      = wind speed at surface                     [m / s]       %
%       z1      = height of bottom atmosphere node          [m]           %
%       dzs1    = thickness of top soil layer               [m]           %
%       psis1_MPa = soil water potential of top layer       [MPa]         % --> 1MPa = 1J/g
%       TC1     = thermal conductivity of top soil layer    [-]           %
%       vonk    = von Karman constant                       [-]           %
%       z0      = soil surface roughness length             [-]           %
%       Lv      = latent heat of vaporization of water      [J / kg]      %
%       D       = vapor exchange coefficient                [m / s]       %
%       cp      = specific heat of air at constant pressure [J / kg C]    %      
%       rhoa    = density of air                            [kg / m^3]    %
%-------------------------------------------------------------------------%
%   Created by  : Darren Drewry                                           %
%   Editted by  : Phong Le                                                %
%   Date        : January 10, 2010                                        %
%% --------------------------------------------------------------------- %%  
%
%
%*************************************************************************%
%% <<<<<<<<<<<<<<<<<<<<<<<<< DE-REFERENCE BLOCK >>>>>>>>>>>>>>>>>>>>>>>> %%
%*************************************************************************%
%
    Ta1     = VARIABLES.CANOPY.TAz(1);
    ea1     = VARIABLES.CANOPY.EAz(1);
    pa1     = VARIABLES.CANOPY.PAz(1);
    U1      = VARIABLES.CANOPY.Uz(1);
%    
    Rabs    = VARIABLES.SOIL.Totabs_soil;
    volliq1 = VARIABLES.SOIL.volliq(1);
    psis1   = VARIABLES.SOIL.smp(1);
%
    z1      = VERTSTRUC.znc(1);
    dzs1    = VERTSTRUC.dzs(1);
    TC1     = VERTSTRUC.TK_sol(1);
    porsl1  = VERTSTRUC.porsl(1);
%    
    epss    = PARAMS.Rad.epss;
    z0      = PARAMS.Soil.z0;
%    
    vonk    = CONSTANTS.vonk;
%    
    Lv      = CONSTANTS.Lv;
    boltz   = CONSTANTS.boltz;
    cp_mol  = CONSTANTS.cp_mol;
    R       = CONSTANTS.R;
%
    rho_dry_air = CONSTANTS.rho_dry_air; 
    mmH2OtoMPa  = CONSTANTS.mmH2OtoMPa;
%    
%*************************************************************************%
%% <<<<<<<<<<<<<<<<<<<<<<< END OF DE-REFERENCE BLOCK >>>>>>>>>>>>>>>>>>> %%
%*************************************************************************%
%% 
    psis1_MPa = psis1 * mmH2OtoMPa;
%
% Solve SEB_Remainder with fzero
    Ts = fzero(@(Ts) SEB_Remainder(Ts, Rabs, Ta1, ea1, pa1, U1, z1, dzs1, psis1_MPa, vonk, z0, TC1, epss), Ta1);

% Soil Surface Energy Balance
    rhoa    = rho_dry_air  * 1000 / 28.97;                                  % [mol/m^3]
    cp      = 29.3;                                                         % specific heat of air at constant pressure [J / mol / K]
    Vw      = 18;                                                           % H20 = 18[g/mol]
%    
% Heat and vapor exchange coefficient (Eqn. 9)
    D       = U1 * vonk^2 / (log(z1/z0))^2;                                 % Eqn 9 or eqn 35 in Drewry et al 2009: Part B
    Hs      = cp * rhoa * D * (Ts-Ta1);                                     % Eqn 2 or eqn 33 in Drewry et al 2009: Part B
    
    esatTs  = 0.611 * exp(17.502 * Ts/(Ts+240.97));                         
    RH      = 0.5 * (1-cos(pi * volliq1/porsl1));                           % Relative humidity - which reference???
    LEs     = Lv * rhoa * D * (0.622/pa1) * (esatTs * RH - ea1);            % Eqn 3 & 4 or Eqn 34 in Drewry et al 2009: Part B
%    
    Gs      = TC1 * (Ts-Ta1) / dzs1;                                        % Eqn 13 or eqn 37 in Drewry et al 2009: Part B
%
%
%:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::%
%% <<<<<<<<<<<<<<<<<<<<<<<<< END OF FUNCTION >>>>>>>>>>>>>>>>>>>>>>>>>>>>%%
%:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::%     

    
