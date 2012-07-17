function [sun_abs,      shade_abs,      soil_abs,...
            fsun,       fshade,         diffdn,         diffup,...
            radabs_tot, radlost,        radremain       ] = ...
        SW_ATTENUATION (...
            beam_top,   diff_top,       LAIz,           trans,...
            refl,       refl_soil,      clump,          Kbm,        Kdf,...
            count,      sun_abs,        shade_abs,      diffdn,     diffup,...
            soil_abs,   fsun,           fshade,         radlost)
%
%:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::%
%%                              FUNCTION CODE                            %%
%%                    SHORTWAVE ATTENUATION CALCULATION                  %%
%:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::%
%-------------------------------------------------------------------------%
%   NOTE: index (1) refers to the layer just above the soil               %
%-------------------------------------------------------------------------%
%   Created by  : Darren Drewry                                           %
%   Editted by  : Phong Le                                                %
%   Date        : January 13, 2010                                        %
%-------------------------------------------------------------------------%
%                                                                         %
%   VARIABLES:                                                            %
%       beam_inc    = incident radiation on layer below                   %
%       beam_int    = intercepted beam                                    %                                      
%       taub        = transmitted beam fraction                           %
%       taud        = transmitted diffuse fraction                        %
%       PREFIX:                                                           %
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
%
%=====================
% DOWNWARD RADIATION
%=====================   
    tind        = length(LAIz);
    bind        = 1;
    beam_inc    = beam_top;
    diffdn(tind)= diffdn(tind) + diff_top;
    LAIc        = 0;
    for ii = tind:-1:bind        
        LAIc        = LAIc + LAIz(ii);                                      % cumulative LAI
        fsun(ii)    = exp(-Kbm * clump * LAIc);                             % sunlit leaf fraction 
        fshade(ii)  = 1 - fsun(ii);                                         % shaded leaf fraction
    %        
    % BEAM RADIATION     
        if (Kbm>0 && beam_top>0 && count==0)
        %
            taub        = exp(-Kbm * clump * LAIz(ii));                     % Eqn 22, Drewry et al, 2009: part B Online Supplement
                                                                            % Eqn (15.1), pp 249 - C&N 1998
        %
            beam_int    = beam_inc - taub*beam_inc;                       	% intercepted beam
        %
            beam_inc    = taub*beam_inc;                                  	% incident radiation on layer below
        %
            sun_abs(ii) = (1-refl-trans)*beam_int;                          % sunlit absorbed at layer iith
        %    
        % intercepted beam that is transmitted
            if (ii==bind)
                soil_inc = trans*beam_int + beam_inc;
            else
                diffdn(ii-1) = trans * beam_int;
            end
        %    
        % intercepted beam that is reflected
            if (ii<tind)
                diffup(ii+1) = refl*beam_int;
            else
                reflbup = refl * beam_int;                                  % used for debugging
            end
        else
            reflbup = 0;
        end
    %    
	% DIFFUSE RADIATION
        taud = exp(-Kdf * clump * LAIz(ii));

        diff_int = diffdn(ii) - taud*diffdn(ii);                            % intercepted downward diffuse
    %    
    % downward transmission
        if (ii==bind)
            soil_inc = soil_inc + trans*diff_int + taud*diffdn(ii);
        else
            diffdn(ii-1) = diffdn(ii-1) + trans*diff_int + taud*diffdn(ii); 
        end
    %    
	% upward reflection
        if (ii<tind)
            diffup(ii+1) = diffup(ii+1) + refl*diff_int;                    
        else
            refldup = refl*diff_int; % for debugging                        
        end
    %
	% absorbed fraction
        sun_abs(ii)   = sun_abs(ii) + (1-refl-trans)*diff_int*fsun(ii);     % sunlit absorbed
        shade_abs(ii) = shade_abs(ii) + (1-refl-trans)*diff_int*fshade(ii); % shaded absorbed
    end
%
    soil_abs  = soil_abs + (1-refl_soil)*soil_inc;                          % soil absorbed
    diffup(1) = diffup(1) + refl_soil*soil_inc; % diffdn(1);                  
    soil_inc  = 0;
    diffdn    = diffdn * 0;
%    
%    
%==========================
% UPWARD DIFFUSE RADIATION
%==========================
	for ii = bind:tind
        taud = exp(-Kdf * clump * LAIz(ii));                                % Eqn 22, Drewry et al, 2009: part B Online Supplement
        diff_int = diffup(ii) - taud*diffup(ii);
    %    
    % upward tranmission
        if (ii<tind)
            diffup(ii+1) = diffup(ii+1) + trans*diff_int + taud*diffup(ii);
        else
            diffuplost = trans*diff_int + taud*diffup(ii); 
        end
        
        % downward reflection
        if (ii==bind)
            soil_inc = soil_inc + refl*diff_int;
        else
            diffdn(ii-1) = diffdn(ii-1) + refl*diff_int;
        end
        
        % absorbed fraction
        sun_abs(ii)   = sun_abs(ii) + (1-refl-trans)*diff_int*fsun(ii);     % sunlit absorbed
        shade_abs(ii) = shade_abs(ii) + (1-refl-trans)*diff_int*fshade(ii); % shaded absorbed
    %    
    end
    diffup    = diffup*0;
    soil_abs  = soil_abs + (1-refl_soil)*soil_inc;                          % soil absorbed
    diffup(1) = refl_soil*soil_inc;
%    
%    
% Absorbed Radiation
    radabs_tot  = sum(sun_abs) + sum(shade_abs) + soil_abs;
% Lost Radiation
    radlost     = radlost + reflbup + refldup + diffuplost;
% Radiation Remaining in System
    radremain   = sum(diffdn) + sum(diffup);
%
%:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::%
%% <<<<<<<<<<<<<<<<<<<<<<<<< END OF FUNCTION >>>>>>>>>>>>>>>>>>>>>>>>>>>>%%
%:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::%
%