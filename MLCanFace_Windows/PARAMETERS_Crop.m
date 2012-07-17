%:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::%
%%                              DATA FILE                                %%
%%               CORN CROP PARAMETERS AT BONDVILLE SITE                  %%
%:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::%
%-------------------------------------------------------------------------%
% This file provide characteristic for Corn species                       % 
%   + Site independent constants and fixed values                         %                                                                  %
%   + Canopy                                                              % 
%   + Soil                                                                %
%-------------------------------------------------------------------------%
%   Created by  : Darren Drewry                                           %
%   Modified by : Phong Le                                                %
%   Date        : December 23, 2009                                       %
%-------------------------------------------------------------------------%
%=========================================================================%
%%         SITE INDEPENDENT CONSTANTS AND FIXED VALUES                   %%
%=========================================================================%
%
% LOAD PARAMETERS FROM TABLE IN GUIS---------------------------------------
    load ('./Temps/temp_variable.mat',...
            'para_leaf'             , 'para_canopy'             , 'para_radiation'          ,   ... 
            'para_soil'             , 'para_conductance'        , 'para_microenvironment'   ,   ...
            'para_photosynthesisC3' , 'para_photosynthesisC4'   , 'para_respiration'        ,   ...
            'set_para_root'         , 'set_root_func'           );

    PARAMS.Photosyn.ph_type = SWITCHES.ph_type;
%
% CONVERSION FACTORS ------------------------------------------------------
    CONSTANTS.umoltoWm2     = (2.17*10^5) / 10^6;                           % Radiation conversion
    CONSTANTS.Wm2toumol     = 1/CONSTANTS.umoltoWm2;                        % Radiation conversion
    CONSTANTS.mmH2OtoMPa    = 9.8066e-06;                                   % Pressure conversion
%
% PHYSICAL CONSTANTS ------------------------------------------------------
    CONSTANTS.R             = 8.314;                                        % Gas constant [J mol^-1 K^-1]
    CONSTANTS.R_kJ          = CONSTANTS.R/1000;                             % Gas constant in [kJ mol^-1 K^-1]  
    CONSTANTS.Lv            = 44000;                                        % Latent heat of vaporization [J/mol]
    CONSTANTS.Lv_g          = 2260*1000;                                    % Latent heat of vaporization in [J / g]
    CONSTANTS.cp_mol        = 29.3;                                         % Specific heat of air at constant pressure [J/mol/degree C]
    CONSTANTS.cp_JkgK       = 1012;                                         % Specific heat of air at constant pressure in [J/kg/K]
    CONSTANTS.boltz         = 5.6697 * 10^-8;                               % Stefan-Boltzmann constant [W/m^2/K^4]
    CONSTANTS.vonk          = 0.41;                                         % von Karman constant
    CONSTANTS.rho_dry_air   = 1.2923;                                       % Density of dry air [kg / m^3]
    CONSTANTS.grav          = 9.8;                                          % Gravity [m / s^2]
%
% SITE SPECIFIC CONSTANTS -------------------------------------------------
    CONSTANTS.timestep      = 30;                                           % fixed time step [minutes]
    CONSTANTS.dtime         = CONSTANTS.timestep*60;                        % fixed time step in second [s]
    %
    PARAMS.CanStruc.nl_can  = 15;                                           % # canopy layers
    %
    PARAMS.CanStruc.LEfact  = cell2mat(para_leaf(1,2));                     % Multiplicative factor for Fc and LE calculations
                                                                            %   1 = fluxes from only one side of leaf, 
                                                                            %   2 = fluxes from both sides
    %   
    PARAMS.CanStruc.Hfact   = cell2mat(para_leaf(2,2));                     % Multiplicative factor for H and LW calculations
                                                                            %   1 = fluxes from only one side of leaf, 
                                                                            %   2 = fluxes from both sides
    %                                    
    PARAMS.CanStruc.LWfact  = cell2mat(para_leaf(3,2));                     % Same comment as aboved.
					
%=========================================================================%
%%         END OF SITE INDEPENDENT CONSTANTS AND FIXED VALUES            %%
%=========================================================================%          
%*************************************************************************%
%%                               CANOPY                                  %%
%*************************************************************************%
%
%
% CANOPY STRUCTURE --------------------------------------------------------
    PARAMS.CanStruc.hcan    = cell2mat(para_canopy(1,2));                   % Canopy height [m]
    PARAMS.CanStruc.hobs    = cell2mat(para_canopy(2,2));                   % Observation height [m]
    PARAMS.CanStruc.z0      = 0.13 * PARAMS.CanStruc.hcan;                  % Canopy roughness length [m]
    PARAMS.CanStruc.d0      = 2/3  * PARAMS.CanStruc.hcan;                  % Canopy displacement height [m]
%                                                                           % z0 and d0 eqns: Campbell and Norman (1998), pp 71
%
% BETA DISTRIBUTION FOR LAD STRUCTURE -------------------------------------
    PARAMS.CanStruc.B1      = 6.84;
    PARAMS.CanStruc.B2      = 0.2;
    PARAMS.CanStruc.B3      = 0.5;

    PARAMS.CanStruc.leaftype= cell2mat(para_leaf(4,2));                     % 1 = broad leaves
                                                                            % 2 = needles
%
    PARAMS.CanStruc.ld      = cell2mat(para_canopy(3,2));                   % Leaf width or needle diameter [m]
    PARAMS.CanStruc.lw      = cell2mat(para_canopy(4,2));                   % Shoot diameter for conifers 
                                                                            % Leaf width for broadleaved vegetation (= ld)
%
%
% Parameters from [Boedhram et al]'s model describing foliage -------------
% Distribution in CORN
    PARAMS.CanStruc.Zopt    = 0.4;                                          % Fraction of canopy height at which optimum LAD is located
    PARAMS.CanStruc.sigsqd  = 0.8;
%
%
% Smax = maximum h2o storage capacity for foliage [mm/LAI unit]------------
    if (PARAMS.CanStruc.leaftype==1)                                        % Broad leaves
        PARAMS.CanStruc.Smax = 0.10;
    else                                                                    % Conifers
        PARAMS.CanStruc.Smax = 0.15;
    end
    PARAMS.CanStruc.Ffact    = cell2mat(para_canopy(5,2));
    PARAMS.CanStruc.pptintfact = cell2mat(para_canopy(6,2));
%        
%    
% RADIATION ---------------------------------------------------------------
    PARAMS.Rad.transmiss    = cell2mat(para_radiation(1,2));                % Atmospheric transmissivity
    PARAMS.Rad.epsv         = cell2mat(para_radiation(2,2));                % Vegetation emissivity - C&N - bean leaf
    PARAMS.Rad.epss         = cell2mat(para_radiation(3,2));                % Soil emissivity
    PARAMS.Rad.epsa         = cell2mat(para_radiation(4,2));                % Atmospheric emissivity
    PARAMS.Rad.xx           = cell2mat(para_radiation(5,2));                % Leaf angle dist param - Campbell and Norman, 1998 (Table 15.1, p. 253)
    PARAMS.Rad.clump        = cell2mat(para_radiation(6,2));                % Leaf clumping parameter
    PARAMS.Rad.Kdf          = cell2mat(para_radiation(7,2));                % Extinction coeff for diffuse

    PARAMS.Rad.absorp_PAR   = cell2mat(para_radiation(8,2));                % Leaf absorptivity to PAR
    PARAMS.Rad.absorp_NIR   = cell2mat(para_radiation(9,2));                % Leaf absorptivity to NIR
%
    PARAMS.Rad.refl_PAR     = (1-sqrt(PARAMS.Rad.absorp_PAR))/...
                              (1+sqrt(PARAMS.Rad.absorp_PAR));              % PAR reflection coeff
%
    PARAMS.Rad.refl_NIR     = (1-sqrt(PARAMS.Rad.absorp_NIR))/...
                              (1+sqrt(PARAMS.Rad.absorp_NIR));              % NIR reflection coeff
%
    PARAMS.Rad.refl_soil    = 0.2;                                          % Soil reflection coeff
%
    PARAMS.Rad.trans_PAR    = 1 - PARAMS.Rad.absorp_PAR -...                % PAR transmission coeff
                              PARAMS.Rad.refl_PAR;
%
    PARAMS.Rad.trans_NIR    = 1 - PARAMS.Rad.absorp_NIR -...                % NIR transmission coeff
                              PARAMS.Rad.refl_NIR;
%   
%                                   
% PHOTOSYNTHESIS ----------------------------------------------------------
%
    % C3 Photosynthesis Parameters - Not availabe for Corn (C4)
    if PARAMS.Photosyn.ph_type == 1
        PARAMS.Photosyn.beta_ph_C3  = cell2mat(para_photosynthesisC3(1,2)); % Fraction absorbed Q available to photosystem III
        PARAMS.Photosyn.Vcmax25_C3  = cell2mat(para_photosynthesisC3(2,2)); % Maximum rate of Rubisco-limited carboxylation at 25 C [umol / m^2 / s]
        PARAMS.Photosyn.Jmax25_C3   = cell2mat(para_photosynthesisC3(3,2)); % Maximum electron transport rate at 25 C [umol / m^2 / s]
        PARAMS.Photosyn.Rd25        = 0.015*PARAMS.Photosyn.Vcmax25_C3;     % [umol / m^2 / s]
        PARAMS.Photosyn.kn_canopy   = cell2mat(para_photosynthesisC3(4,2)); % Vertical Distribution of Photosynthetic Capacity
        
    else % C4 Photosynthesis Parameters
        PARAMS.Photosyn.Vmax_C4     = cell2mat(para_photosynthesisC4(1,2)); % Reference Value for substrate saturated Rubisco capacity [mmol / m^2 / s]
        PARAMS.Photosyn.Rd_C4       = cell2mat(para_photosynthesisC4(2,2)); % Reference Value for leaf respiration [mmol / m^2 / s]
        PARAMS.Photosyn.Q10_C4      = cell2mat(para_photosynthesisC4(3,2)); % Temperature sensitivity of temperature-dependent C4 parameters
        PARAMS.Photosyn.kk_C4       = cell2mat(para_photosynthesisC4(4,2)); % Initial slope of C4 photosynthetic CO2 response [mmol / m^2 / s]
        PARAMS.Photosyn.theta_C4    = cell2mat(para_photosynthesisC4(5,2));
        PARAMS.Photosyn.beta_C4     = cell2mat(para_photosynthesisC4(6,2));
        PARAMS.Photosyn.al_C4       = cell2mat(para_photosynthesisC4(7,2)); % Intrinsic quantum yield of C4 photosynthesis [mol / mol]
        PARAMS.Photosyn.kn_canopy   = cell2mat(para_photosynthesisC4(8,2)); % Vertical Distribution of Photosynthetic Capacity
    end
%
    if (PARAMS.CanStruc.leaftype == 1)
        PARAMS.Photosyn.ap = 0.41;
        PARAMS.Photosyn.bp = 0.06;
    elseif (PARAMS.CanStruc.leaftype == 2)
        PARAMS.Photosyn.ap = 0.03;
        PARAMS.Photosyn.bp = 0.0;
    end
%
    PARAMS.Photosyn.Oi  	= 210;                                          % Intercellular oxygen concentration [mmol / mol]  
%    
%    
% RESPIRATION -------------------------------------------------------------       
    % Ecosystem Respiration
    PARAMS.Resp.Ro          = cell2mat(para_respiration(1,2));              % [umol / m^2 / s]
    PARAMS.Resp.Q10         = cell2mat(para_respiration(2,2));
%
%    
% STOMATAL CONDUCTANCE ----------------------------------------------------
    % Ball-Berry
    PARAMS.StomCond.mslope  = cell2mat(para_conductance(1,2));              % slope parameter in BB model [-] 
                                                                            % (Leakey: m=10.6 (ambient); m=10.9 (elevated))

    PARAMS.StomCond.bint    = cell2mat(para_conductance(2,2));              % intercept parameter in BB model [mol/m^2/s] 
                                                                            % (Leakey: b=0.008 (ambient); b=0.007 (elevated))

    % (Tuzet et al, PCE 2003)
    PARAMS.StomCond.sf      = cell2mat(para_conductance(3,2));              % sensitivity parameter for initial decrease in leaf potential [-]
    PARAMS.StomCond.psif    = cell2mat(para_conductance(4,2));              % leaf potential at which half of the hydraulic conductance is lost [MPa]
    PARAMS.StomCond.Rp      = cell2mat(para_conductance(5,2));
%
%
% TURBULENCE --------------------------------------------------------------
    PARAMS.MicroEnv.Cd      = cell2mat(para_microenvironment(1,2));
    PARAMS.MicroEnv.alph    = CONSTANTS.vonk/3;                             % mixing length parameter [-]
                                                                            % See Katul et al (BLM, 2004, p. 84)
%
%                                    
%*************************************************************************%
%%                              END OF CANOPY                            %%
%*************************************************************************%                                    
%=========================================================================%
%%                                SOIL                                   %%
%=========================================================================%
    PARAMS.Soil.sand        = cell2mat(para_soil(1,2));                     % Percent of sand
    PARAMS.Soil.clay        = cell2mat(para_soil(2,2));                     % Percent of clay

    PARAMS.Soil.Cd_soil     = cell2mat(para_soil(3,2));                     % Soil Drag coefficient

    PARAMS.Soil.z50         = cell2mat(set_para_root(2,2));                 % Z50 parameter
    PARAMS.Soil.z95         = cell2mat(set_para_root(3,2));                 % Z95 parameter
    PARAMS.Soil.maxrootdepth= cell2mat(set_para_root(1,2));                 % Maximum root depth
    
    PARAMS.Soil.dzs         = cell2mat(set_root_func(:,1))';                % Layer spacings [m]
    PARAMS.Soil.depths      = cell2mat(set_root_func(:,2))';                % Depths for each layer spacing [m]
    PARAMS.Soil.z0          = cell2mat(para_soil(4,2));                     % Soil surface roughness length [m]
 %
 %
 % CONSTANTS --------------------------------------------------------------
    PARAMS.Soil.smpmin      = -1.e8;                                        % Restriction for min of soil poten. [mm]
    PARAMS.Soil.wimp        = 0.05;                                         % Water impermeable if porosity less than wimp [-]
 %
 %
 % TOTAL ROOT SYSTEM CONDUCTIVITIES ---------------------------------------
    PARAMS.Soil.K_rad       = 0.5e-7;                                       % Radial conductivity of the root system [s^-1]
    PARAMS.Soil.K_axs       = 2.0e-1;                                       % Axial specific conductivity of the root system [mm/s]   
    PARAMS.Soil.scalek      = 0.5;                                          % Length scale for the exponential decrease in Ksat [m]
 %
 %
 % HEAT CAPACITIES [J / kg / K)] ------------------------------------------   
    PARAMS.Soil.HC_air      = 1.00464 * 10^3;                               % Dry Air   - vapor    
    PARAMS.Soil.HC_liq      = 4.188 * 10^3;                                 % Water     - liquid    
    PARAMS.Soil.HC_ice      = 2.11727 * 10^3;                               % Ice       - solid   
%
%
    % DENSITIES [kg / m^3] ------------------------------------------------
    PARAMS.Soil.rho_liq     = 1000;                                         % Water     - liquid
    PARAMS.Soil.rho_ice     = 917;                                          % Ice       - solid
%
%
    % THERMAL CONDUCTIVITIES [W / m / K] ----------------------------------
    PARAMS.Soil.TK_liq      = 0.6;                                          % Water     - liquid                     
    PARAMS.Soil.TK_ice      = 2.29;                                         % Ice       - solid   
    PARAMS.Soil.TK_air      = 0.023;                                        % Dry Air   - vapor
%
    % FREEZING TEMPERATURE OF FRESH WATER [K] -----------------------------
    PARAMS.Soil.Tf          = 273.16;
    PARAMS.Soil.alphCN      = 0.5;
%
%=========================================================================%
%%                             END OF SOIL                               %%
%=========================================================================%
%
%
%:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::%
%% <<<<<<<<<<<<<<<<<<<<<<<<<<< END OF FILE >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>%%
%:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::%
                                    


    
    
    
    
    
    
    
