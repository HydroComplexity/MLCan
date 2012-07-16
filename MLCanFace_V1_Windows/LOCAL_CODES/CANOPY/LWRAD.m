function [LWabs_can, LWabs_sun, LWabs_shade, LWabs_soil, LW_sky, LWup, ...
          LWcan_emit, LWsun_emit, LWshade_emit, LWsoil_emit] = ...
    LWRad (FORCING, VARIABLES, VERTSTRUC, PARAMS, CONSTANTS)
%
%:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::%
%%                             FUNCTION CODE                             %%
%%                   CALCULATE THE LONGWAVE RADIATION                    %%
%:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::%
%   This function calls the longwave radiation absorption subroutine,     %
%       iterating until most of the incident longwave, and that emitted   %
%       by vegetation and the soil, are absorbed or directed to the       %
%       atmosphere                                                        %
%-------------------------------------------------------------------------%
%   Created by  : Darren Drewry                                           %
%   Editted by  : Phong Le                                                %
%   Date        : January 09, 2010                                        %
%-------------------------------------------------------------------------%
%                                                                         %
%   INPUTS:                                                               %
%       LWin    = downward longwave measured at top of canopy   [W/m^2]   %
%                  --> should be set to NaN if observation not available  %
%       Tatop   = temp above canopy                             [C]       %
%       Tl_sun  = profile of leaf temps for sunlit fraction     [C]       %
%       Tl_shade= profile of leaf temps for shaded fraction     [C]       %
%       Ts      = temp of soil surface                          [C]       %
%       eatop   = vapor pressure of atmosphere                  [kPa]     %
%       LAIz    = LAI profile                                   [m^2/m^2] %
%       zendeg  = zenith angle                                  [degrees] %
%       epsv    = LW emissivity of vegetation                   [-]       %
%       epsa    = LW emissivity of atmosphere                   [-]       %
%       epss    = LW emissivity of soil                         [-]       %
%       clump   = vegetation clumping factor                    [-]       %
%       Kdf     = extinction coefficient for diffuse radiation  [-]       %
%       LAIsun  = sunlit LAI at each canopy layer               [m^2/m^2] %
%       LAIshade= shaded LAI at each canopy layer               [m^2/m^2] %
%       dz      = node spacing                                  [mm]      %
%                                                                         %
%   OUTPUTS:                                                              %
%       LWabs_can   = LW absorbed by each canopy layer          [W/m^2]   %
%       LWabs_soil  = LW absorbed by soil                       [W/m^2]   %
%     	LW_sky      = downward LW from sky                      [W/m^2]   %
%   	LWup        = LW transmitted up to atmosphere           [W/m^2]   %
%      	LWcan_emit  = profile of canopy emission                [W/m^2]   %
%       LWsoil_emit = soil emission                             [W/m^2]   %
%                                                                         %
%% --------------------------------------------------------------------- %%  
%
%
%*************************************************************************%
%% <<<<<<<<<<<<<<<<<<<<<<<<< DE-REFERENCE BLOCK >>>>>>>>>>>>>>>>>>>>>>>> %%
%*************************************************************************%
%
    zendeg  = FORCING.zen;
    LWin    = FORCING.LWdn;
    Tatop   = FORCING.Ta;
    eatop   = FORCING.ea;
%    
    Tl_sun  = VARIABLES.CANOPY.Tl_sun;
    Tl_shade= VARIABLES.CANOPY.Tl_shade;
    fsun    = VARIABLES.CANOPY.fsun;
    fshade  = VARIABLES.CANOPY.fshade;
    LAIsun  = VARIABLES.CANOPY.LAIsun;
    LAIshade= VARIABLES.CANOPY.LAIshade;
%    
    Ts      = VARIABLES.SOIL.Ts(1);
%    
    LAIz    = VERTSTRUC.LAIz;
    dz      = VERTSTRUC.dzc;
%    
    Kdf     = PARAMS.Rad.Kdf;
    clump   = PARAMS.Rad.clump;
    epsv    = PARAMS.Rad.epsv;
    epss    = PARAMS.Rad.epss;
%    
    boltz   = CONSTANTS.boltz;
%    
%*************************************************************************%
%% <<<<<<<<<<<<<<<<<<<<<<< END OF DE-REFERENCE BLOCK >>>>>>>>>>>>>>>>>>> %%
%*************************************************************************%
%%
% CONVERT ZENITH ANGLE FROM DEGREE TO RADIAN
    zenrad  = zendeg * pi/180;
%    
% DOWNWARD LONGWAVE FROM SKY
    if (~isnan(LWin))
        LW_sky  = LWin;
    else
        epsa    = 1.72 * (eatop / (Tatop + 273.15))^(1/7);                  % Eqn (10.10), pp 163 - C&N 1998, or Eqn (26)-Drewry et al 2009
                                                                            % Original, Eqn (6.20), pp 139 - Brusaert 1982: 1.24 , 
                                                                            % Theoretical justification - Brusaert 1984: 1.72
    %
        LW_sky  = epsa * boltz * (Tatop + 273.15)^4;                        % Eqn (10.7 & 10.9), pp 162,163 - C&N 1998, or Eqn (25)-Drewry et al 2009
    end
%    
% INITIALIZE ARRAYS
    len         = length(LAIz);
    LWabs_can   = zeros(len,1);
    diffdn      = zeros(len,1);
    diffup      = zeros(len,1);
    LWabs_soil  = 0;
    radlost     = 0;
%    
% Iterate to Solve LW Absorption Profile
    count       = 0;
    maxiters    = 10;
    percdiff    = 1;
    LW_top      = LW_sky; 
%                     
    while (percdiff > 0.01)        
        [LWabs_can, LWabs_soil, diffdn,     diffup,         radlost,...
                    LW_can_out, LW_sun_out, LW_shade_out,   LW_soil_out] = ...
         LW_ATTENUATION (LW_top,Tatop,      Tl_sun,     Tl_shade,   Ts,...
                        LAIz,   epsv,       epss,       clump,      Kdf,...
                        count,  fsun,       fshade,     LAIsun,     LAIshade,...
                        dz,     LWabs_can,  LWabs_soil, diffdn,     diffup,...
                        radlost);
    %
        if (count==0)
           LWtot        = LW_sky + sum(LW_can_out) + LW_soil_out; 
        %   
           LWcan_emit   = LW_can_out(:);
        %   
           LWsun_emit   = LW_sun_out(:);
           LWshade_emit = LW_shade_out(:);
        %   
           LWsoil_emit  = LW_soil_out;
        end
    %
        LW_top      = 0;  
        radremain   = sum(diffdn) + sum(diffup);
        percdiff    = radremain / LWtot;
    %
    %   disp(['    count = ', num2str(count), ':   ', num2str(percdiff)]);
        count = count + 1;
        if (count>maxiters)
            disp('TOO MANY ITERATIONS IN  LW LOOP!!!');
            break;
        end
    end
%   
    LWup = radlost;
%    
% Total Absorbed Radiation By Each Canopy Fraction (Sunlit and Shaded)
    LWabs_sun   = LWabs_can.*fsun;
    LWabs_shade = LWabs_can.*fshade;
%
%
%:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::%
%% <<<<<<<<<<<<<<<<<<<<<<<<< END OF FUNCTION >>>>>>>>>>>>>>>>>>>>>>>>>>>>%%
%:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::%
%