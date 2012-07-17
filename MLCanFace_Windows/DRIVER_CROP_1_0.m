function DRIVER_CROP_1_0(hObject, eventdata, handles)
%:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::%
%%                           MAIN PROGRAM                                %%
%%           Canopy-Root-Soil-Atmosphere Exchange Model                  %%
%:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::%
%-------------------------------------------------------------------------%
% This model is used to simulate the exchange of                          % 
%   + CO2                                                                 %
%   + Water vapor                                                         % 
%   + Latent heat                                                         %
%   + Sensible heat                                                       %
%-------------------------------------------------------------------------%
%   Created by  : Darren Drewry                                           %
%   Modifield by: Phong Le                                                %
%   Date        : December 22, 2009                                       %
%-------------------------------------------------------------------------%
%
%    clear all                       % Clear all memory and variables      %
%    close all                       % Close all programs and functions    %
    clc                             % Clear the screen                    %
%
%% --------------------------- STRUCTURES --------------------------------%
%   SWITCHES    :   Model conditional switches                            %
%   VERTSTRUC   :   Variables describing vertical structure of canopy&soil%
%   SOILVAR     :   Soil variables                                        %
%   CANVAR      :   Canopy variables                                      %
%   FORCING     :   Holds current timestep forcing variables              %
%   CONSTANTS   :   Site indepentdent constants, unit conversions         %
%   PARAMS                                                                %
%       .CanStruc     :   Canopy structural parameters                    %
%       .Rad          :   Radiation parameters                            %
%       .Photosyn     :   Photosynthesis paramters                        %
%       .StomCond     :   Stomtatal conductance parameters                %
%       .Resp         :   Ecosystem respiration parameters                %
%       .MicroEnv     :   Canopy microenvironment parameters              %
%       .Soil         :   Soil paramters                                  %
%                                                                         %
%-------------------------------------------------------------------------%
%*************************************************************************%
%%                           USER SPECIFICATIONS                         %%
%*************************************************************************%
%   Read information from file set up by the model
    load (  './Temps/temp_variable.mat',...
            'crop_name'     , 'LAImin_face' , 'num_can'     , 'num_root'    , 'ph_type'     ,   ...
            'Turbulence'    , 'HR'          , 'RHC'         , 'Soil_heat'   , 'rnm'         ,   ...
            'CO2_Elev_con'  , 'CO2_Elev'    , 'opt_root'    , 'root_init'   ,                   ...
            'fullpath_forcings'             , 'working_forcings');
    load (  fullpath_forcings, 'year_crop');
    year_start  = year_crop(1);
    year_end    = year_crop(end);
%
    years       = [year_start:1:year_end];                                  % Simulation years 
    doys        = [1:366];                                                  % Days of year: 1 to 366 
    LAImin      = LAImin_face;                                              % Value indicates close canopy
%
    SWITCHES.ph_type	 = ph_type;                                           % 1 = C3, 
%                                                                           % 0 = C4.    
%
    SWITCHES.turb_on     = Turbulence;                                      % 1 = scalar profiles resolved,
%                                                                           % 0 = scalar profiles not resolved.
%    
    SWITCHES.HR_on       = HR;                                              % 1 = Hydraulic redistribution (HR) is on, 
%                                                                           % 0 = Hydraulic redistribution (HR) is off. 
%
    SWITCHES.rhc         = RHC;                                             % 1 = linearly increasing root hydraulic conductivity with depth
%                                                                           % 0 = non-linearly increasing root hydraulic conductivity with depth
%
    SWITCHES.ns          = rnm;                                             % 1 = Implicit numerical scheme 
%                                                                           % 0 = Explicit numerical scheme 
%    
    SWITCHES.soilheat_on = Soil_heat;                                       % 1 = Soil heat is on,  
%                                                                           % 0 = soil heat is off.    
%   
    SWITCHES.save_on     = 1;                                               % 1 = Save stored variables to .mat file, 
%                                                                           % 0 = No save performed.
%
    SWITCHES.plots_on    = 0;                                               % 1 = Plotting results, 
%                                                                           % 0 = No plotting
%
    SWITCHES.elevatedCO2 = CO2_Elev;                                        % 1 = elevated CO2, 
%                                                                           % 0 = ambient C02.
%  
    CO2base_ambient      = 370;                                             % Ambient CO2 is controled at 370 [ppm]
    CO2base_elevated     = CO2_Elev_con;                                    % Ambient CO2 is elevated to value chosen by users [ppm]
%    
    volliqinit           = root_init(:,2);                                  % Soil water per unit volume
%    
    paramfilename = 'PARAMETERS_Crop';
%
%*************************************************************************%
%%                      END OF USER SPECIFICATIONS                       %%
%*************************************************************************%
%
    yearstr = num2str(years(1));
    for yy = 2:length(years)
        yearstr = [yearstr, '_', num2str(years(yy))];
    end
%
    disp_text = ([crop_name,'_simulation:']);
    disp(disp_text);
%
%% ---------------------Select CO2 mode and set up output file------------%
%
    if (SWITCHES.elevatedCO2)                                               % elevated CO2 mode
        CO2base         = CO2base_elevated;
        if (SWITCHES.ph_type)
          LAI_fact      = 1.1;
        else
          LAI_fact      = 1.0; 
        end
%
        disp(['ELEVATED CO_2:  ', num2str(CO2base), ' [ppm]']);
        disp(['YEARS: ', yearstr]);
    else                                                                    % no elevated CO2 mode
        CO2base         = CO2base_ambient;
        LAI_fact        = 1;
    %
        disp(['AMBIENT CO_2:  ', num2str(CO2base), ' [ppm]']);
        disp(['YEARS: ', yearstr]);
    end
    
    outputfile = ['./Result_', crop_name, '_Year_', yearstr, '_CO2=', ...
                    num2str(CO2base), '.mat'];

%
%% Select path and data file for input (in mat format)--------------------%
    datafile = fullpath_forcings;
%
%% Code Library Paths-----------------------------------------------------%
    addpath('./LOCAL_CODES/CANOPY/');
    addpath('./LOCAL_CODES/ROOT_SOIL/');
    addpath('./LOCAL_CODES/ROOT_SOIL/IMPLICIT');        
    addpath('./LOCAL_CODES/NUMERICAL/');
    addpath('./LOCAL_CODES/PLOTTING/');
    addpath('./LOCAL_CODES/VEGETATION/');    
%
%    
%% LOAD PARAMETERS--------------------------------------------------------%
    eval(paramfilename);
    nl_can = PARAMS.CanStruc.nl_can;
%        
%% LOAD DATA by function--------------------------------------------------%
        [ELEV, LAT      , LONG      , decyear   , decdoy    , year      , doy       ,   ...
               hour     , ZEN_in    , LAI_in    , Rg_in     , Ta_in     , VPD_in    ,   ...
               PPT_in   , U_in      , ustar_in  , Pa_in     , ea_in     , LWdn_in   ] = ...
               ...
    LOAD_DATA_MLCan(...
               years    , doys      , LAImin                ,                           ...
               PARAMS.CanStruc.hobs	, PARAMS.CanStruc.hcan  , PARAMS.CanStruc.z0    ,   ... 
               PARAMS.CanStruc.d0   , CONSTANTS.vonk        , datafile);
%
    N = length(decyear);
%
%% Identifying the beginning and end of each years------------------------%    
    for yy = 1:length(years)
        ybeginds(yy) = find(year==years(yy), 1, 'first');
        yendinds(yy) = find(year==years(yy), 1, 'last');
    end
%        
%        
%% SET UP GRIDS-----------------------------------------------------------%
%
    % CANOPY GRID 
    [znc, zhc, dzc]     = CANOPY_GRID(PARAMS);
        VERTSTRUC.znc   = znc;                                              % Canopy node heights       [m]                                  
        VERTSTRUC.zhc   = zhc;                                              % Canopy interface heights  [m] 
        VERTSTRUC.dzc   = dzc;                                              % 0.5* canopy node height   [m]                           
%
    % LEAF AREA DISTRIBUTION
    [LADnorm]           = LAD_Profile(VERTSTRUC);                           % Setup LAD profile grid
        vinds           = find(LADnorm>0);
        nvinds          = find(LADnorm<=0);
        VERTSTRUC.LAD   = LADnorm;                                          % Normalized Leaf Area Density
        VERTSTRUC.vinds = vinds;
        VERTSTRUC.nvinds= nvinds;     
%        
    % CHECK OPTION FROM TEMPORARY FILE TO CHOOSE SOILGRID FUNCTION
    if opt_root == 1
        % SOIL GRID FOR OBSERVED
        [zns, dzs, zhs, nl_soil] = SOILGRID_OBS;
        %
        % ROOT DISTRIBUTION FOR OBSERVED
        [rootfr] = ROOTDIST_LOGISTIC_OBS;                                    % See Amenu and Kumar, 2008 - Eqn 16, pp. 60                      
    else
        % SOIL GRID FOR EQUATION
        [zns, dzs, zhs, nl_soil] = SOILGRID_EQN(PARAMS);
        %
        % ROOT DISTRIBUTION FOR EQUATIOIN
        [rootfr] = ROOTDIST_LOGISTIC_EQN( zns, dzs, PARAMS );               % See Amenu and Kumar, 2008 - Eqn 16, pp. 60                      
    end 
    	znsmm = zns(:) * 1000;                                              % Node depths (center of layers)        [mm]      
    	dzsmm = dzs(:) * 1000;                                              % Soil space steps or Layer thickness   [mm]
       	zhsmm = zhs(:) * 1000;                                              % Depths of soil layer interfaces       [mm]
        
        VERTSTRUC.zns   = zns;                                              % These 3 variables are identical
        VERTSTRUC.dzs   = dzs;                                              %   to ones mentioned above but 
        VERTSTRUC.zhs   = zhs;                                              %   the units are in [m]

        VERTSTRUC.znsmm = znsmm;                                            % These 3 variables are totally identical
        VERTSTRUC.dzsmm = dzsmm;                                            %     above but in [mm] unit
        VERTSTRUC.zhsmm = zhsmm;            
        
        VERTSTRUC.rootfr    = rootfr;                                       % Root fraction distribution calculated
        VERTSTRUC.roottr    = rootfr;
        PARAMS.Soil.nl_soil = nl_soil;                                      % Number of soil layer
        VERTSTRUC.nl_root   = nl_soil;
%
    % SOIL PROPERTIES    
        VERTSTRUC.sand = ones(nl_soil,1)*PARAMS.Soil.sand;                  % % sand
        VERTSTRUC.clay = ones(nl_soil,1)*PARAMS.Soil.clay;                  % % clay
%        
    [HC_sol, porsl, psi0, bsw, TK_sol, TK_dry, HKsat, theta_dry] = ...
        SOIL_PROPERTIES(PARAMS, VERTSTRUC);                                 % Calculate the soil profile properties. See Oleson et al., 2004
%
    % ASSIGN
        VERTSTRUC.HC_sol    = HC_sol;                                       % Heat capacity of soil
        VERTSTRUC.porsl     = porsl;                                        % Soil porosity
        VERTSTRUC.psi0      = psi0;                                         % Soil potential at saturation
        VERTSTRUC.bsw       = bsw;                                          % Clapp-Hornberger "b" parameter [-] in 7.73 (Oleson et al 2004)
        VERTSTRUC.TK_sol    = TK_sol;                                       % Thermal conductivity of soil minerals [W / m / K]
        VERTSTRUC.TK_dry    = TK_dry;                                       % Thermal conductivity of dry soil minerals [W / m / K]
        VERTSTRUC.HKsat     = HKsat;                                        % Hydraulic conductivity at saturation [mm / s] 
        VERTSTRUC.theta_dry = theta_dry;                                    % Soil moisture content at complete dryness
        VERTSTRUC.eff_poros = VERTSTRUC.porsl;                              % Set effective porosity
%        
    % ALLOCATE STORAGE FOR MODELLED VARIABLES
    ALLOCATE_STORAGE;     
%
%
%% RUN CANOPY-ROOT-SOIL MODEL---------------------------------------------%
    maxiters = 10;                                                          % Maximum iterations = 10
    disp(['Running ', num2str(N), ' simulation periods.']);
%
% LOOP OVER EACH YEAR TO RE-INITIALIZE CANOPY/SOIL STATES FOR EACH YEAR    
    for yy = 1:length(years)                        
        ybind = ybeginds(yy);
        yeind = yendinds(yy);
        
    % INITIALIZATIONS FOR START OF NEW YEAR
        % INITIALIZE CANOPY STATES
        VARIABLES.CANOPY.Tl_sun     = Ta_in(ybind) * ones(nl_can,1);        % Leaf temperature              - sunlit
        VARIABLES.CANOPY.gsv_sun    = 0.01 * ones(nl_can,1);                % Stomatal conductance to vapor - sunlit
        VARIABLES.CANOPY.Ci_sun     = 0.7 * CO2base*ones(nl_can,1);         % Internal CO2 concentration    - sunlit

        VARIABLES.CANOPY.Tl_shade   = Ta_in(ybind) * ones(nl_can,1);        % Leaf temperature              - shaded
        VARIABLES.CANOPY.gsv_shade  = 0.01 * ones(nl_can,1);                % Stomatal conductance to vapor - shaded
        VARIABLES.CANOPY.Ci_shade   = 0.7 * CO2base*ones(nl_can,1);         % Internal CO2 concentration    - shaded

        VARIABLES.CANOPY.TR         = zeros(length(znc),1);                 % Transpiration
        VARIABLES.CANOPY.Sh2o_prof  = zeros(length(znc),1);                 % Water storage
    %
        % INITIALIZE SOIL STATES
        VARIABLES.SOIL.volliq       = volliqinit;                           % Soil water per unit volume      
        VARIABLES.SOIL.smp          = psi0 .* (VARIABLES.SOIL.volliq ./...
                                      VERTSTRUC.porsl) .^ (-VERTSTRUC.bsw); % Soil matric potential
    %
        % INITIALIZE SOIL TEMPERATURE
    %
        Ts = root_init(:,3);
        %Ts = zeros(nl_soil,1);
        VARIABLE.Ts = Ts;
        
        % INITIALIZE ROOT POTENTIAL
        VARIABLES.ROOT.rpp_wgt = VARIABLES.SOIL.smp(1);      
        VARIABLES.ROOT.rpp     = VARIABLES.SOIL.smp;          
    %
        % LOOP OVER EACH TIME PERIOD IN YEAR yy
        for tt = ybind:yeind
        %
            % FORCING CONDITIONS
            FORCING.doy     = doy(tt);                                      % Decimal year      [-]
            FORCING.Rg      = Rg_in(tt);                                    % Incident short-wave radiation [W / m2]
            FORCING.Pa      = Pa_in(tt);                                    % Air Pressure      [kPa]
            FORCING.LWdn    = LWdn_in(tt);                                  % Longwave Rad down [W / m2]    
            FORCING.zen     = ZEN_in(tt);                                   % Zenith Angel      [Degree]
            FORCING.U       = U_in(tt);                                     % Wind velocity     [m / s]
            FORCING.ppt     = PPT_in(tt);                                   % Precipitation     [mm]
            FORCING.Ta      = Ta_in(tt);                                    % Air temperature   [C]
            FORCING.ea      = ea_in(tt);                                    % Vapor pressure    [kPa]
            FORCING.Ca      = CO2base;                                      % CO2 concentration [ppm]
            if (~SWITCHES.soilheat_on)
                VARIABLES.Ts = Ts;
            else
                VARIABLES.Ts = Ts;
            end
        %    
            VARIABLES.SOIL.Ts = Ts;                                         % Soil temperature
        %
            % CANOPY STRUCTURE    
            VERTSTRUC.LAIz = LAI_in(tt)*LADnorm * LAI_fact;
            VERTSTRUC.LADz = VERTSTRUC.LAIz ./ dzc;
        %
            % INITIALIZE CANOPY ENVIRONMENT
            VARIABLES.CANOPY.TAz = Ta_in(tt) * ones(nl_can,1);
            VARIABLES.CANOPY.CAz = CO2base   * ones(nl_can,1);
            VARIABLES.CANOPY.EAz = ea_in(tt) * ones(nl_can,1);
            VARIABLES.CANOPY.PAz = Pa_in(tt) * ones(nl_can,1);
            VARIABLES.CANOPY.Uz  = U_in(tt)  * ones(nl_can,1);
        %
            VARIABLES.CANOPY.TR_sun   = zeros(nl_can,1);
            VARIABLES.CANOPY.TR_shade = zeros(nl_can,1);
        %
        %
            %-------------------------------------------------------------%
            % DE-COUPLE CANOPY AND ROOT-SOIL MODELS FOR NOW...
            % ITERATIVE ROOT-SOIL SOLUTION
            % converged_rs = 0;    cnt_rs = 0;
            % while (~converged_rs) 
            % cnt_rs = cnt_rs+1;            
            %-------------------------------------------------------------%
            %
            % Canopy Solution           
            [An_can,LE_can,     TR_can,     H_can,      Rnrad_can,...
                    Fc_soil,    LE_soil,    H_soil,     Rnrad_soil,...
                    G,          Rnrad_sun,  Rnrad_shade,Rnrad_eco,...
                    An_sun,     An_shade,   LE_sun,     LE_shade,...
                    H_sun,      H_shade,    Tl_sun,     Tl_shade,...
                    psil_sun,   psil_shade, gsv_sun,    gsv_shade,...
                    fsv_sun,    fsv_shade,  Ci_sun,     Ci_shade,...
                    CAz,        TAz,        EAz,        Uz,...
                    gbv_sun,    gbh_sun,    gbv_shade,  gbh_shade,...
                    LAI_sun,    LAI_shade,  fsun,       fshade,...
                    PARabs_sun, PARabs_shade,NIRabs_sun,NIRabs_shade,...
                    SWout,      LWabs_can,  LWemit_can, LWout,...
                    RH_soil,    fdiff,      Sh2o_prof,  Sh2o_can,...
                    ppt_ground, Ch2o_prof,  Ch2o_can,   Evap_prof,...  
                    Evap_can,   dryfrac,    wetfrac,    Vz,...
                    VARIABLES   An_sun_2    An_shaded   LAI_sunlit...
                    LAI_shaded  gs_sun_2    An_can_top  ] = ...         
            CANOPY_MODEL(...
                    SWITCHES,   VERTSTRUC,  FORCING,    PARAMS,...
                    VARIABLES,  CONSTANTS);

            E_soil          = LE_soil / CONSTANTS.Lv_g;                     % Soil evaporation [mm/s]=[g/m^2/s]  
            pptrate_ground  = ppt_ground / CONSTANTS.dtime;                 % Rate of rainfall hit the ground
            qthrough        = pptrate_ground - E_soil;                      % net water input from top [mm/s]
            volliq          = VARIABLES.SOIL.volliq;
            deficit         = zhsmm(1)/CONSTANTS.dtime*(VERTSTRUC.eff_poros(1) - volliq(1));
            if qthrough> deficit
                qinfl = deficit;
                q_over = qthrough - deficit;
            else
                qinfl = qthrough;
                q_over = 0;
            end
        %
            % ASSIGN
            VARIABLES.SOIL.qinfl = qinfl;
        %
            % Implicit Solution
            if (SWITCHES.ns)
                [rpp,       rpp_wgt,        krad,       kax,        dwat,           ...
                    smp,    bk,             hk,         smp_wgt,    thsattrac_wgt,  ...
                    qlayer, layeruptake,    mberrormm,  type] =                     ...
                ROOTSOIL(SWITCHES, VERTSTRUC, PARAMS, VARIABLES, CONSTANTS);

                VARIABLES.SOIL.qinfl    = qlayer(1);            

                VARIABLES.ROOT.rpp      = rpp;
                VARIABLES.ROOT.rpp_wgt  = rpp_wgt;
                VARIABLES.ROOT.krad     = krad;
                mberrormm               = (qlayer(1) - TR_can - qlayer(nl_soil+1))*1800 - sum(dwat.*dzsmm); 
                mberrormm1              = (qlayer(1) - TR_can - qlayer(nl_soil+1))*1800;
                mberrormm2              = sum(dwat.*dzsmm); 
                qinfl                   = qlayer(1);
                q_over                  = qthrough - qinfl;
            else
                % Root Model Solution
                if (SWITCHES.HR_on)
                    [rpp, rpp_wgt, krad] = ROOTS_HR(SWITCHES, VERTSTRUC, PARAMS, VARIABLES);
                else                                     
                    [rpp, rpp_wgt, krad] = ROOTS_NOHR(SWITCHES, VERTSTRUC, PARAMS, VARIABLES);
                end
                VARIABLES.ROOT.rpp      = rpp;                                  % Root pressure potential           [mm]
                VARIABLES.ROOT.rpp_wgt  = rpp_wgt;                              % Root pressure potential weight    [mmH20 to MPA]
                VARIABLES.ROOT.krad     = krad;                                 % radial conductivity of the root   [mm/s]
            %
                % Soil Moisture Solution
                [dwat, smp, hk, smp_wgt, thsatfrac_wgt, qlayer] = ...
                SOILMOISTURE(SWITCHES, VERTSTRUC, PARAMS, VARIABLES, CONSTANTS);  
                mberrormm=(qlayer(1) - TR_can - qlayer(nl_soil+1))*1800 - sum(dwat'.*dzsmm);  
                mberrormm1              = (qlayer(1) - TR_can - qlayer(nl_soil+1))*1800;
                mberrormm2              = sum(dwat'.*dzsmm);                 
            end
        %
            volliq = VARIABLES.SOIL.volliq;
            volliq = volliq(:) + dwat(:); 
            %volliq = max(theta_dry, volliq);
            %volliq = min(VERTSTRUC.eff_poros, volliq);
        %
            % ASSIGN
            VARIABLES.SOIL.volliq   = volliq;
            VARIABLES.SOIL.smp      = smp;
            VARIABLES.SOIL.qinfl    = qinfl;                                % net water input from top [mm/s]
            VARIABLES.SOIL.smp      = smp;                                  % Soil matric potential
            VARIABLES.SOIL.rpp      = rpp;                                 	% Root pressure potential
            VARIABLES.SOIL.krad     = krad;                                	% radial conductivity of the root
        %
            if (SWITCHES.soilheat_on)
                % Soil Temperature Solution
                [Ts, cpv] =...
                SOILHEAT   (nl_soil,	CONSTANTS.dtime,        zns,...
                            zhs,        dzs,        Ts,         G,...
                            PARAMS.Soil.alphCN,     PARAMS.Soil.Tf,...
                            volliq,     TK_dry, 	TK_sol,...
                            PARAMS.Soil.TK_liq,     PARAMS.Soil.TK_ice,...
                            porsl,      HC_sol,...
                            PARAMS.Soil.HC_liq,     PARAMS.Soil.HC_ice,...
                            PARAMS.Soil.rho_liq,    PARAMS.Soil.rho_ice);
            end
        %
            STORE_DATA;            
            if (rem(tt,500)==0)
                disp(['Period ', num2str(tt), ' complete!']);               % Show every 500 of completed period
            end
        end
    end    
%
    MAKE_AVERAGES;
      
%% MAKE FIGURES ----------------------------------------------------------%
    % Produce Plots
    if (length(years)==1)
        timevect  = decdoy;
        timelabel = ['DOY: ', num2str(years)];
    else
        timevect  = [1:length(decyear)];
%       timevect  = decyear;
        timelabel = ['Decimal Year'];
    end
    
%% SAVE OUTPUTS ----------------------------------------------------------%
    if (SWITCHES.save_on)
        save(outputfile);
    end
     
%% PLOTS -----------------------------------------------------------------%
    %{
    fignum = 1; Plot_CanopyRootStructure;
    fignum = 2; Plot_MetForcing;
    fignum = 3; Plot_Diurnals_Met;
    fignum = 4; Plot_Flux_OneToOne_Diurnals;
    fignum = 5; Plot_Profiles_Diurnal_Condensation;
    fignum = 7; Plot_Flux_Profiles
    fignum = 8; Plot_Profiles_Diurnal_Radiation;
    fignum = 9; Plot_Profiles_Diurnal_Flux;
    %}
% Remove Code Library Paths
%    rmpath('./LOCAL_CODES/CANOPY/');
%    rmpath('./LOCAL_CODES/ROOT_SOIL/');
%    rmpath('./LOCAL_CODES/NUMERICAL/');
%
disp 'DONE!'
%:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::%
%% <<<<<<<<<<<<<<<<<<<<<<<<<<< END OF FILE >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>%%
%:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::%
    





