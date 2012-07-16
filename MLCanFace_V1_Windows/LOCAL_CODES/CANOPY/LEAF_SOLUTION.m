function [Ph,       An,         Ci,         gsv,        Tl,...
            LE,     TR,         Evap_mm,    H,          psil,...
            fsv,    Ch2o_mm,    gbv,        gbh,        VARIABLES] = ...
    LEAF_SOLUTION(...
          FORCING,  VARIABLES,  PARAMS,     CONSTANTS,  VERTSTRUC,  sunlit)
                
%
%:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::%
%%                             FUNCTION CODE                             %%
%%                      CALCULATE THE LEAF SOLUTION                      %%
%:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::%
%-------------------------------------------------------------------------%
%   Created by  : Darren Drewry                                           %
%   Editted by  : Phong Le                                                %
%   Date        : January 09, 2010                                        %
%-------------------------------------------------------------------------%
%                                                                         %
%   VARIABLES:                                                            %                                                              
%       dryfrac     = Dry fraction                                        %
%       wetfrac     = Wet fraction                                        %
%       CAz         = atmospheric CO2 concentration                       %                         
%       TAz         = atmospheric temperature                             %
%       ph_type     = photosynthesis type                                 %
%       Lv_g        = Latent heat of vaporization in [J / g]              %
%% --------------------------------------------------------------------- %%  
%
%
%*************************************************************************%
%% <<<<<<<<<<<<<<<<<<<<<<<<< DE-REFERENCE BLOCK >>>>>>>>>>>>>>>>>>>>>>>> %%
%*************************************************************************%
%
    dryfrac = VARIABLES.CANOPY.dryfrac;
    wetfrac = VARIABLES.CANOPY.wetfrac;
%    
    CAz     = VARIABLES.CANOPY.CAz;
    TAz     = VARIABLES.CANOPY.TAz;
%    
    ph_type = PARAMS.Photosyn.ph_type;
%    
    Lv_g    = CONSTANTS.Lv_g;                   % [J / g]
%    
%*************************************************************************%
%% <<<<<<<<<<<<<<<<<<<<<<< END OF DE-REFERENCE BLOCK >>>>>>>>>>>>>>>>>>> %%
%*************************************************************************%
%%       
    relax       = 0;
    relaxval    = 0.25;
    maxchange   = 0.25;
    maxiters    = 50;
    converged   = 0;
    cnt         = 0;
%
    while(~converged)
    % PHOTOSYNTHESIS
        if (ph_type==1) % C3 type
            [Ph, An, Phtype, Gam] = PHOTOSYNTHESIS_C3(VARIABLES, PARAMS,...
                                    VERTSTRUC, CONSTANTS, sunlit);
        else            % C4 type
            [Ph, An] = PHOTOSYNTHESIS_C4(VARIABLES, PARAMS, VERTSTRUC, sunlit);
        end
    %    
        if (cnt>0)
            Ph = Ph - relax*(Ph-Ph_prev);
            An = An - relax*(An-An_prev);
        end
    %
        if (sunlit)
            VARIABLES.CANOPY.An_sun   = An;
        else
            VARIABLES.CANOPY.An_shade = An;
        end
    %
    % LEAF BOUNDARY LAYER CONDUCTANCES
        [gbv, gbh] = BLC_Nikolov(VARIABLES, PARAMS, sunlit);
        if (sunlit)
            VARIABLES.CANOPY.gbv_sun   = gbv;
            VARIABLES.CANOPY.gbh_sun   = gbh;
        else
            VARIABLES.CANOPY.gbv_shade = gbv;
            VARIABLES.CANOPY.gbh_shade = gbh;
        end        
    %
    % LEAF WATER POTENTIAL    
        [psil] = LEAF_WATER_POTENTIAL(VARIABLES, PARAMS, VERTSTRUC, CONSTANTS);
        if (sunlit)
            VARIABLES.CANOPY.psil_sun   = psil;
        else
            VARIABLES.CANOPY.psil_shade = psil;
        end
    %
        [fsv] = Tuzet_Function(VARIABLES, PARAMS, sunlit);
        if (sunlit)
            VARIABLES.CANOPY.fsv_sun    = fsv;
        else
            VARIABLES.CANOPY.fsv_shade  = fsv;
        end
    %
    % STOMATAL CONDUCTANCE     
        [gsv, Ci] = BALL_BERRY(VARIABLES, PARAMS, VERTSTRUC, sunlit);
        if (cnt>0)
            gsv = gsv - relax*(gsv-gsv_prev);
            Ci  = Ci - relax*(Ci-Ci_prev);
        end
    %
        if (sunlit)
            VARIABLES.CANOPY.gsv_sun    = gsv;
            VARIABLES.CANOPY.Ci_sun     = Ci;
        else
            VARIABLES.CANOPY.gsv_shade  = gsv;
            VARIABLES.CANOPY.Ci_shade   = Ci;
        end  
    %
    % LEAF ENERGY BALANCE - DRY LEAF FRACTION
        [Tl_dry, H_dry, LE_dry, gv_dry] = LEB_QUARTIC_DRY (VARIABLES, PARAMS,...
                                            VERTSTRUC, CONSTANTS, sunlit);
        if (sunlit)
            VARIABLES.CANOPY.TR_sun     = LE_dry/Lv_g;      % [mm/s / LAI]  
        else
            VARIABLES.CANOPY.TR_shade   = LE_dry/Lv_g;      % [mm/s / LAI]  
        end  
        TR = LE_dry / Lv_g;                                 % [mm/s / LAI] 
    %
    % LEAF ENERGY BALANCE - WET LEAF FRACTION
    %   LE_wet = evaporation; H_wet is alway zero
        [Tl_wet, H_wet, LE_wet, gv_wet] = LEB_QUARTIC_WET (VARIABLES, PARAMS,...
                                            VERTSTRUC, CONSTANTS, sunlit);
    %
    % Mean Leaf Temperature
        Tl = Tl_dry .* dryfrac + Tl_wet .* wetfrac;
        if (sunlit)
            VARIABLES.CANOPY.Tl_sun     = Tl;
        else
            VARIABLES.CANOPY.Tl_shade   = Tl;
        end  
        VARIABLES.CANOPY.Tl = Tl;
    %
    % TEST FOR SOLUTION DIVERGENCE
        if (cnt > 0)
            gsvdiff = gsv - gsv_prev;
        %
            % Check for solution divergence
            if ( max(abs(Ci-Ci_prev)  ./ Ci_prev)  > maxchange || ...
                 max(abs(gsv-gsv_prev)./ gsv_prev) > maxchange || ...
                 max(abs(Tl-Tl_prev)  ./ Tl_prev)  > maxchange )
        %
            % Rewind calculation and set relaxation on
                gsv     = gsv_prev;
                Ci      = Ci_prev;
                Tl      = Tl_prev;
        %
        	% Turn on relaxation
                relax   = relaxval;
        %
            elseif (relax > 0)
                relax   = 0;
            end
        %
     	% Check for solution oscillation
            if (cnt>2)
               md1 = max(abs(gsvdiffprev));
               md2 = max(abs(gsvdiff));
            %
            % Compare real numbers for "equality"
               if ( (md1 > (md2-0.01*md2)) && (md1 < (md2+0.01*md2)) )
                   relax = relaxval;
               end
            end
        %
            gsvdiffprev = gsvdiff;
        end
    %
    % TEST CONVERGENCE
        if (cnt>0)
            if ( (max(abs(gsv-gsv_prev)./gsv_prev) < 0.01) && ...
                 (max(abs(Ci-Ci_prev)./Ci_prev) < 0.01) && ...
                 (max(abs(Tl-Tl_prev)./Tl_prev) < 0.01) )
                converged = 1;
            end
        end
    %
    % Update convergence check variables
        Ph_prev = Ph;
        An_prev = An;
        Ci_prev = Ci;
        gsv_prev= gsv;
        Tl_prev = Tl;
    %
        if (cnt>maxiters && converged==0)
        %disp(['*** TOO MANY INTERATIONS IN LEAF MODEL!!! --> Timestep:'])
            break;
        end
    %
        cnt = cnt + 1;
    end
%
% Compute energy fluxes, condensation and water storage for each layer
    H   = H_dry  .* dryfrac;                % only dry fraction can produce sensible heat
    LE  = LE_dry .* dryfrac + LE_wet .* wetfrac;
%
% Compute Evaporation
    Evap_wm2 = LE_wet.*wetfrac;
    Evap_wm2(find(Evap_wm2<0)) = 0;         % condensation instead of evaporation
    Evap_mm = Evap_wm2 / Lv_g;              % [mm/s / LAI]
%
% Compute Condensation
    Ch2o_mm_dry = LE_dry / Lv_g;            % [mm/s / LAI]
    Ch2o_mm_dry(find(Ch2o_mm_dry>0)) = 0;   % Transpiration instead of condensation
%
    Ch2o_mm_wet = LE_wet / Lv_g;            % [mm/s / LAI]
    Ch2o_mm_wet(find(Ch2o_mm_wet>0)) = 0;   % Evaporation instead of condensation
%
    Ch2o_mm = Ch2o_mm_dry + Ch2o_mm_wet;    % [mm/s / LAI]
%
%
%:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::%
%% <<<<<<<<<<<<<<<<<<<<<<<<< END OF FUNCTION >>>>>>>>>>>>>>>>>>>>>>>>>>>>%%
%:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::%
