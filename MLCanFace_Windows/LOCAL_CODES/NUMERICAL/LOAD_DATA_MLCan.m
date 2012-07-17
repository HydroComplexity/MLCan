function [ELEV, LAT     , LONG      , decyear 	, decdoy    , year      , doy       ,   ... 
                hour    , ZEN       , LAI       , Rg        , Ta        , VPD       ,   ...
                PPT     , U         , ustar     , Pa        , ea        , LWin      ] = ...
                ...
         LOAD_DATA_MLCan(   years   , doys      , laimin    , hobs      , hcan      ,  	...
                            z0      , d0        , vonk      , datafile)
                           
%:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::%
%%                             FUNCTION CODE                             %%
%%                        LOAD_DATA_cropAmeriflux                        %%
%:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::%
%-------------------------------------------------------------------------%
% This function is used to load Soy (Bondville) Ameriflux data            %
%   - gapfilled .mat data file name is hardcoded                          %
%-------------------------------------------------------------------------%
%   Created by  : Darren Drewry                                           %
%   Modified by : Phong Le                                                %
%   Date        : December 23, 2009                                       %
%-------------------------------------------------------------------------%    
% 
%
load(datafile);

    inds = find(ismember(year_crop, years) & ...
                ismember(doy_crop, doys)   & ...
                LAI_crop >= laimin);
%    
    decyear = decyear_crop(inds);
    decdoy  = decdoy_crop(inds);
    year    = year_crop(inds);
    doy     = doy_crop(inds);
    hour    = hour_crop(inds);
    ZEN     = ZEN_crop(inds);           % Zenith Angle
    LAI     = LAI_crop(inds);           % Leaf Area Index
%    
    Ta      = Ta_crop(inds);			% Air temperature
    VPD     = VPD_crop(inds);			% Vapour Pressure Deficit
    PPT     = PPT_crop(inds);			% Precipitation
    U       = U_crop(inds);             % Wind
    ustar   = ustar_crop(inds);			% Friction velocity
    Pa      = Pa_crop(inds);			% Pressure
    ea      = ea_crop(inds);            % Vapor pressure
%    
    Rg      = Rg_crop(inds);                % Global radiation [W m-2]
    LWin    = LWin_crop(inds);              % Longwave radiation in [W m-2]
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
          
          
          
          
          
          
          