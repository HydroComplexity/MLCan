function [remain] = SEB_Remainder(Ts, Rabs, Ta1, ea1, pa, U1, z1, dzs1, ...
                                  psis1_MPa, vonk, z0, TC1, epss)
%         
%:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::%
%%                             FUNCTION CODE                             %%
%%                    CALCULATE SURFACE ENERGY BALANCE                   %%
%:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::%
%-------------------------------------------------------------------------%
% This function % Solve surface energy balance based on formulation of    %
%   (Hinzman et al, JGR 1998)  --> Equation #s refer to Hinzman           %
%-------------------------------------------------------------------------%
%                                                                         %
%   INPUTS:                                                               %
%       Ts      = soil surface temp                             [C]       %
%       Rabs    = absorbed radiation by soil                    [W/m^2]   %
%       Ta1     = air temperature at surface                    [C]       %
%       ea1     = vapor pressure at surface                     [kPa]     %
%       pa      = air pressure at surface                       [kPa]     %
%       U1      = wind speed at surface                         [m/s]     %       
%       z1      = height of bottom atmosphere node              [m]       %
%       dzs1    = thickness of top soil layer                   [m]       %         
%       psis1_MPa = soil water potential of top layer           [MPa]     % --> 1MPa = 1J/g
%       vonk    = von Karman constant                           [-]       %         
%       z0      = surface roughness length                      [-]       %
%       TC1     = thermal conductivity of top soil layer        [-]       %
%                                                                         %
%% --------------------------------------------------------------------- %%
%%
% Soil Surface Energy Balance
    density_dry_air = 1.2923;                           % [kg / m^3]
    rhoa    = density_dry_air  * 1000 / 28.97;          % [mol/m^3]
    cp      = 29.3;                                     % specific heat of air at constant pressure [J / mol / K]
    Lv      = 44000;                                    % latent heat of vaporization [J / mol]
    boltz   = 5.6697 * 10^-8;                           % [W m^-2 K^-4]
    Vw      = 18;                                       % [g/mol]
    R       = 8.3143;                                   % [J/mol/K]
%    
% Heat and vapor exchange coefficient (Eqn. 9)
    D       = U1 * vonk^2 / (log(z1/z0))^2;                                 % Eqn 9 or eqn 35 in Drewry et al 2009: Part B
%          
    Hs      = cp * rhoa * D * (Ts-Ta1);                                     % Eqn 2 or eqn 33 in Drewry et al 2009: Part B
%                       
    esatTs  = 0.611 * exp(17.502 * Ts/(Ts + 240.97));
    RH      = exp(psis1_MPa * Vw / R / (Ts + 273.15));                      % Eqn 8
    LEs     = Lv * rhoa * D * (0.622/pa) * (esatTs * RH - ea1);             % Eqn 34 in Drewry et al 2009: Part B
%    
    Gs      = TC1 * (Ts-Ta1) / dzs1;                                        % Eqn 13 or eqn 37 in Drewry et al 2009: Part B
%    
    LWups   = epss * boltz * (Ts + 273.15)^4;                               % grey body emission equation
%        
    remain  = Rabs - Hs - LEs - Gs - LWups;                                 % Eqn 32 in Drewry et al 2009: Part B
%
%
%:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::%
%% <<<<<<<<<<<<<<<<<<<<<<<<< END OF FUNCTION >>>>>>>>>>>>>>>>>>>>>>>>>>>>%%
%:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::%     
