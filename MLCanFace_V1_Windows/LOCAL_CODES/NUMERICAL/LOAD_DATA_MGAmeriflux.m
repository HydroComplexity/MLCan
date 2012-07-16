function [ELEV, LAT,    LONG,   decyear,    decdoy,     year,   doy,... 
                hour,   ZEN,    LAI,        Rg,         Ta,     VPD,...
                PPT,    U,      ustar,      Pa,         ea,     Fc,...
                LE,     H,      Hg,         Fc_qc,      LE_qc,  H_qc,...
                Tskin,  Ts4,    Ts8,        Ts16,       Ts32,   Ts64,   Ts128,...
                SWC10,  SWC20,  SWC30,      SWC40,      SWC50,	SWC60,  SWC100,...
                Rgout,  LWin,   LWout,      Rn  ] = ...
                ...
         LOAD_DATA_MGAmeriflux(years,      doys,       laimin, hobs,   hcan,...
                                z0,         d0,         vonk,   datafile)
                           
%:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::%
%%                             FUNCTION CODE                             %%
%%                        LOAD_DATA_MGAmeriflux                          %%
%:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::%
%-------------------------------------------------------------------------%
% This function is used to load (Bondville) Ameriflux data                %
%   - gapfilled .mat data file name is hardcoded                          %
%-------------------------------------------------------------------------%
%   Created by  : Darren Drewry                                           %
%   Modified by : Phong Le                                                %
%   Date        : December 23, 2009                                       %
%-------------------------------------------------------------------------%    
% 
%
load(datafile);

    inds = find(ismember(year_MG, years) & ...
                ismember(doy_MG, doys)   & ...
                LAI_MG >= laimin);
%    
    decyear = decyear_MG(inds);
    decdoy  = decdoy_MG(inds);
    year    = year_MG(inds);
    doy     = doy_MG(inds);
    hour    = hour_MG(inds);
    ZEN     = ZEN_MG(inds);             % Zenith Angle
    LAI     = LAI_MG(inds);             % Leaf Area Index
%    
    Ta      = Ta_MG(inds);              % Air temperature
    VPD     = VPD_MG(inds);             % Vapour Pressure Deficit
    PPT     = PPT_MG(inds);             % Precipitation
    U       = U_MG(inds);               % Wind
    ustar   = ustar_MG(inds);			% Friction velocity
    Pa      = Pa_MG(inds);              % Pressure
    ea      = ea_MG(inds);              % Vapor pressure
%    
    Fc      = Fc_MG(inds);              % CO2 fluxes
    LE      = LE_MG(inds);              % Latent heat
    H       = H_MG(inds);               % Sensible heat
    Hg      = Hg_MG(inds);              % Heat conducted into soil
%    
    Fc_qc   = 0; %Fc_qc_MG(inds);           % qc means flag
    LE_qc   = 0; %LE_qc_MG(inds);           % same
    H_qc    = 0; %H_qc_MG(inds);            % same
%    
% SOIL TEMPERATURE DEPTHS (Surface, 4, 8, 16, 32, 64, 128) [Degree celcius]
    Tskin   = Tskin_MG(inds);
    Ts4     = Ts4_MG(inds);
    Ts8     = Ts8_MG(inds);
    Ts16    = Ts16_MG(inds);
    Ts32    = Ts32_MG(inds);
    Ts64    = Ts64_MG(inds);
    Ts128   = Ts128_MG(inds);
%
% SOIL WATER CONTENT DEPTHS 10, 20, 30, 40, 50, 60, 10 [% Volume]            
    SWC10   = SWC10_MG(inds);
    SWC20   = SWC20_MG(inds);
    SWC30   = SWC30_MG(inds);
    SWC40   = SWC40_MG(inds);
    SWC50   = SWC50_MG(inds);
    SWC60   = SWC60_MG(inds);
    SWC100  = SWC100_MG(inds);
%
    Rg      = Rg_MG(inds);                % Global radiation [W m-2]
    Rgout   = Rgout_MG(inds);             % Global radiation out [W m-2]
    LWin    = LWin_MG(inds);              % Longwave radiation in [W m-2]
    LWout   = LWout_MG(inds);             % Longwave radiation out [W m-2]
    Rn      = Rn_MG(inds);                % Net radiation [W m-2]
%    
% Calculate Vapor Variables (See Campbell and Norman, 1998)
    aa      = 0.611;                        % [kPa]
    bb      = 17.502;                       % [Dimensionless]
    cc      = 240.97;                       % [Degree Celcius]
    esat    = aa * exp((bb * Ta)./(cc+Ta));	% Saturation vapor pressure (Tetens formula, Buck 1981)
    ean     = esat - VPD;
    hr      = ea ./ esat;                   % Relative humidity
%    
% Data Corrections    
    uinds   = find(U<0.1);
    U(uinds)= 0.1;
%
% Calculate ustar for missing periods
    binds   = find(isnan(ustar) | ustar<=0);
    ustar(binds) = vonk.*U(binds)./(log((hobs-d0)/z0));
%    
% Adjust U from measurement height to canopy height (Brutsaert, 4.2)
    U       = U - (ustar/vonk).*log(hobs/hcan);
    uinds   = find(U<0.1);
    U(uinds)= 0.1;
%    
% Downward LW - eliminate pre-2005.5 data as they appear to be filled with
% low values
%    binds = find(decyear<2005.5);
%    LWin(binds) = NaN;
%
%:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::%
%% <<<<<<<<<<<<<<<<<<<<<<<<< END OF FUNCTION >>>>>>>>>>>>>>>>>>>>>>>>>>>>%%
%:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::%          
          
          
          
          
          
          
          