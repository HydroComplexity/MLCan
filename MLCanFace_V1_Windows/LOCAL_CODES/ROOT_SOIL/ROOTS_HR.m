function [rpp, rpp_weight, krad, kax] = ROOTS_HR( SWITCHES, VERTSTRUC, PARAMS, VARIABLES )
%
%:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::%
%%                              FUNCTION CODE                            %%
%%                     ROOT HYDRAULIC REDISTRIBUTION                     %%
%:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::%
%-------------------------------------------------------------------------%
% This code solves the model for water flow in the plant root system.     % 
% The upper boundary condition is set to the transpiration rate while     %
% the lower boundary is set to no flux.                                   %
%                                                                         %
%-------------------------------------------------------------------------%
%   INPUT VARIABLES:::::::::::::::::::::::::::::::::::::::::::            %                                          
%       dtime       = time step                                     [s]   %
%       z           = layer depth                                   [mm]  %
%       dz          = layer thickness                               [mm]  %
%       zi          = interface level below a "z" level             [mm]  %
%       TR          = actual transpiration                          [mm/s]%
%       rootfr      = root fraction of a layer                      [-]   %
%       rpp         = root pressure potential                       [mm]  %
%       smp         = soil matric potential                         [mm]  %
%       vol_liq     = soil water per unit volume                    [mm/mm]
%       eff_porosity= effective porosity of soil                    [-]   %
%       thetadry    = soil moisture content at dryness              [-]   %
%       K_rad       = radial conductivity of the root system        [s^-1]%
%       K_axs       = axial specific conductivity of the root system[mm/s]%
%       hr          = option for hydraulic redistribution           [-]   %
%       rhc         = option for root hydraulic conductivity        [-]   %
%                                                                         %
%   OUTPUR VARIABLES:::::::::::::::::::::::::::::::::::::::::::           %
%       rpp         = root pressure potential                       [mm]  %
%       krad        = radial conductivity of the root               [mm/s]%
%       kax         = axial conductivity of the root                [mm/s]%
%                                                                         %
%   LOCAL VARIABLES::::::::::::::::::::::::::::::::::::::::::::           %
%       amx         = "a" left off diagonal of tridiagonal matrix         %
%       bmx         = "b" diagonal column for tridiagonal matrix          %
%       cmx         = "c" right off diagonal tridiagonal matrix           %
%       dmx         = "d" forcing term of tridiagonal matrix              %
%                                                                         %
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
    rhc     = SWITCHES.rhc;
%
    TR      = VARIABLES.CANOPY.TR_total;
%    
    smp     = VARIABLES.SOIL.smp;
    vol_liq  = VARIABLES.SOIL.volliq;
%    
    z       = VERTSTRUC.znsmm;
    dz      = VERTSTRUC.dzsmm;
    rootfr  = VERTSTRUC.rootfr;
    thetadry= VERTSTRUC.theta_dry;
    eff_porosity = VERTSTRUC.eff_poros;
%
    K_rad   = PARAMS.Soil.K_rad;
    K_axs   = PARAMS.Soil.K_axs;
%    
%*************************************************************************%
%% <<<<<<<<<<<<<<<<<<<<<<< END OF DE-REFERENCE BLOCK >>>>>>>>>>>>>>>>>>> %%
%*************************************************************************%
%% 
    N = length(z);  % # soil layers

% Compute the radial and axial conductivities of the roots
%-------------------------------------------------------------------------
% Root conductativities (both radial and axial) for each soil layer are
% obtained by weighting the conductivity of the root system by the root
% distribution within the layer. The effect of soil moisture on root
% conductivity is also taken into account.
%
    binds = [];
    ginds = [];
    for i = 1:N
        if (vol_liq(i) <= thetadry(i) )
            krad(i) = 0;
            binds   = [binds, i];
        else
        % for radial conductivity, root fraction is used as a weighting factor,
        % because the uptake from a layer is proportional to the total surface 
        % area of roots in that layer. Thus, 
            krad(i) = rootfr(i)*K_rad ...
                      * vol_liq(i)/eff_porosity(i);
        end
        % for axial conductivity, root density is used as a weighting factor,
        % because the flow is proportional to the total x-sectional area of  
        % the roots in that layer. Thus,                       
        kax(i) = (rootfr(i)/dz(i))*K_axs ...
                  * vol_liq(i)/eff_porosity(i); 
        ginds  = [ginds, i];
    end
    krad = krad(:);
    kax = kax(:);
%
% For the case where the root hydraulic conductivity is allowed to increase
% with depth, a linear increasing effect is considered
    if rhc == 1                         % if conductivity is allowed to increases with depth
        krad = krad + (z/1000) .* krad; % linearly increasing 
        kax  = kax  + (z/1000) .* kax;
    end
%
% ROOT PRESSURE POTENTIAL --> HR Model
    % For the top soil layer
	j      = 1;
    den    = z(j+1) - z(j);
    amx(j) = 0;
    bmx(j) = kax(j)/den + krad(j);
    cmx(j) = -kax(j)/den;
    dmx(j) = krad(j)*smp(j) - TR - kax(j);
%
    % For the middile soil layers
    for j = 2:N - 1
        den1   = z(j) - z(j-1);
        den2   = z(j+1) - z(j);
        amx(j) = -kax(j-1)/den1;
        bmx(j) = kax(j-1)/den1 + kax(j)/den2 + krad(j);
        cmx(j) = -kax(j)/den2;
        dmx(j) = krad(j)*smp(j) + kax(j-1) - kax(j);
    end 
%
    % For the bottom soil layer
    j      = N;
    den    = z(j) - z(j-1);
    amx(j) = -kax(j-1)/den;
    bmx(j) = kax(j-1)/den + krad(j);
    cmx(j) = 0;
    dmx(j) = krad(j)*smp(j) + kax(j-1);
%
    % Solve for root pressure potential using tridiagonal matric solver
    aamx   = amx(ginds);
    bbmx   = bmx(ginds);
    ccmx   = cmx(ginds);
    ddmx   = dmx(ginds);
    nl     = length(ginds);
%   rpp_ginds = TRIDIAG(nl, aamx, bbmx, ccmx, ddmx); 
    rpp    = TRIDIAG(N, amx, bmx, cmx, dmx); 
%   rpp(ginds) = rpp_ginds;
%   rpp(binds) = smp(binds);
%    
% Weighted mean smp over root uptake profile [mm]
    rpp    = rpp(:);
    rinds  = find(rootfr>0);
    rpp_weight = sum(rpp(rinds).*rootfr(rinds)/sum(rootfr(rinds)));         % * mmH2OtoMPA;
%
%
%:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::%
%% <<<<<<<<<<<<<<<<<<<<<<<<< END OF FUNCTION >>>>>>>>>>>>>>>>>>>>>>>>>>>>%%
%:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::%
