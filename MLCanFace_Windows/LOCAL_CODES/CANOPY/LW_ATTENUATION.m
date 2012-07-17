function[LWabs_can,        LWabs_soil,         diffdn,         diffup,...
            radlost,        LW_can_out,         LW_sun_out,     LW_shade_out,...
            LW_soil_out     ] = ...
        LW_ATTENUATION (    LW_sky,             Tatop,          Tl_sun,...
            Tl_shade,       Tsoil,              LAIz,           epsv,...
            epss,           clump,              Kdf,            count,...
            fsun,           fshade,             LAIsun,         LAIshade,...
            dz,             LWabs_can,          LWabs_soil,     diffdn,...
            diffup,         radlost)
%
%:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::%
%%                              FUNCTION CODE                            %%
%%                     LONGWAVE ATTENUATION CALCULATION                  %%
%:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::%
%-------------------------------------------------------------------------%
%   NOTE: index (1) refers to the layer just above the soil               %
%   Assume no reflected IR, all incident IR either absorbed or transmitted%
%   Thermal emissivity and absorptivity are equal                         %
%-------------------------------------------------------------------------%
%   Created by  : Darren Drewry                                           %
%   Editted by  : Phong Le                                                %
%   Date        : January 11, 2010                                        %
%-------------------------------------------------------------------------%
%                                                                         %
%   VARIABLES:                                                            %
%       beam_inc    = incident radiation on layer below         [W/m^2]   %
%       beam_int    = intercepted beam                          [W/m^2]   %
%       taub        = transmitted beam fraction                 [W/m^2]   %
%       taud        = transmitted diffuse fraction              [W/m^2]   %
%       epsv        = LW emissivity of vegetation               [-]       %
%       clump       = vegetation clumping factor                [-]       %
%       PREFIX:                                                           %
%         - LW      : Longwave                                            %                                              
%         - diff    : Diffuse                                             %
%         - Refl    : Reflect                                             %
%         - Sun     : Sunlit                                              %
%         - Shade   : Shaded                                              %
%         - Soil    : Soil                                                %
%       SUFFIX:                                                           %
%         - dn      : downward                                            %
%         - up      : upward                                              %
%         - abs     : absorbed                                            %
%         - inc     : incident                                            %
%         - int     : intercepted                                         %
%                                                                         %
%% --------------------------------------------------------------------- %%
%%
    soil_inc = 0;
    boltz    = 5.6697 * 10^-8;                                              % Stefan Boltzman constant [W m^-2 K^-4]
%
%=====================
% DOWNWARD RADIATION
%=====================   
    tind = length(LAIz);
    bind = 1;
    diffdn(tind) = diffdn(tind) + LW_sky;                                   % Cumulative diffuse downward
	for ii = tind:-1:bind  
    %    
    % ABSORBED DOWNWARD
        taud          = exp(-Kdf * clump * LAIz(ii));                       % Eqn 22, Drewry et al, 2009: part B Online Supplement
        LW_int        = diffdn(ii) - taud*diffdn(ii);
        LWabs_can(ii) = LWabs_can(ii) + epsv*LW_int;
    %
    % DOWNWARD FLUX
        if (ii>bind)
            diffdn(ii-1) = diffdn(ii-1) + taud * diffdn(ii) +...
                            (1 - epsv) * LW_int;
        else
            soil_inc     = soil_inc + taud * diffdn(ii) +...
                            (1 - epsv) * LW_int;
        end
    %
    % THERMAL CONTRIBUTION FROM FOLIAGE AND SOIL
        if (count==0)
            LW_flux_sun     = fsun(ii) * (1-taud) * epsv * boltz *...
                                (Tl_sun(ii) + 273.15)^4;
            LW_flux_shade   = fshade(ii) * (1-taud) * epsv * boltz *...
                                (Tl_shade(ii) + 273.15)^4;
        %    
            LW_flux         = LW_flux_sun + LW_flux_shade; 
        %                                 
            LW_can_out(ii)  = 2 * LW_flux;
            LW_sun_out(ii)  = 2 * LW_flux_sun;
            LW_shade_out(ii)= 2 * LW_flux_shade;
        %    
            % UPWARD FLUX
            if (ii<tind)
                diffup(ii+1) = diffup(ii+1) + LW_flux;
            else
                radlost = radlost + LW_flux;
            end
        %    
            % DOWNWARD FLUX
            if (ii>bind)
                diffdn(ii-1) = diffdn(ii-1) + LW_flux;
            else
                soil_inc = soil_inc + LW_flux;
            end
        %    
            % SOIL EMISSION
            diffup(1)   = epss * boltz * (Tsoil+273.15)^4;             
            LW_soil_out = epss * boltz * (Tsoil+273.15)^4;
    %
        else
            LW_can_out  = 0;
            LW_soil_out = 0;
        end
    %        
        diffdn(ii)  = 0;  % Downward flux has been absorbed or tranmitted
    end
	LWabs_soil = LWabs_soil + epss * soil_inc;
    diffup(1)  = diffup(1) + (1-epss) * soil_inc;
%    
%    
%===================
% UPWARD RADIATION
%===================      
	for ii = 1:tind       
	%
    % ABSORBED UPWARD
        taud            = exp(-Kdf * clump * LAIz(ii));
        LW_int          = diffup(ii) - taud * diffup(ii);
        LWabs_can(ii)   = LWabs_can(ii) + epsv  *LW_int;
    %
    % UPWARD FLUX
        if (ii<tind)
            diffup(ii+1) = diffup(ii+1) + taud * diffup(ii) + (1-epsv) * LW_int;
        else
            radlost      = radlost + taud * diffup(ii) + (1-epsv) * LW_int;
        end
    %
        diffup(ii) = 0;
    end
%
%
%:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::%
%% <<<<<<<<<<<<<<<<<<<<<<<<< END OF FUNCTION >>>>>>>>>>>>>>>>>>>>>>>>>>>>%%
%:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::%    

