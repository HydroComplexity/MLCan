function [Sh2o_prof, Sh2o_can] = EVAP_CONDENSATION_ADJUST(VARIABLES, VERTSTRUC, PARAMS)
%
%:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::%
%%                              FUNCTION CODE                            %%
%%                    EVAPORATION CONDENSATION ADJUSTMENT                %%
%:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::%
%-------------------------------------------------------------------------%
% This function is used to adjust canopy water storage for condensation   %
% and evaporation                                                         %
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
    Ch2o_prof   = VARIABLES.CANOPY.Ch2o_prof;
    Evap_prof   = VARIABLES.CANOPY.Evap_prof;
    Sh2o_prof   = VARIABLES.CANOPY.Sh2o_prof;
    Smaxz       = VARIABLES.CANOPY.Smaxz;
%    
    ppt_ground  = VARIABLES.SOIL.ppt_ground;
%    
    znc         = VERTSTRUC.znc;
%    
    Ffact       = PARAMS.CanStruc.Ffact;
%    
%*************************************************************************%
%% <<<<<<<<<<<<<<<<<<<<<<< END OF DE-REFERENCE BLOCK >>>>>>>>>>>>>>>>>>> %%
%*************************************************************************%
%% 
% Adjust Canopy Water Storage
    H2oinc      = Ch2o_prof - Evap_prof;
    drip        = 0;
%
% Loop from top to bottom of canopy
    for zz = length(znc):-1:1
        Sh2o_prof(zz) = Sh2o_prof(zz) + H2oinc(zz) + drip;
        if (Sh2o_prof(zz) < 0)
            Sh2o_prof(zz) = 0;
        elseif (Sh2o_prof(zz) >= Smaxz(zz))
            drip = Sh2o_prof(zz) - Smaxz(zz);
            Sh2o_prof(zz) = Smaxz(zz);
        end
    end
%
    Sh2o_can    = sum(Sh2o_prof);
    ppt_ground  = ppt_ground + drip;                                        % total H2O incident on the ground
    wetfrac     = Ffact.*(Sh2o_prof./Smaxz);
    dryfrac     = 1 - wetfrac;
%
%
%:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::%
%% <<<<<<<<<<<<<<<<<<<<<<<<< END OF FUNCTION >>>>>>>>>>>>>>>>>>>>>>>>>>>>%%
%:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::%