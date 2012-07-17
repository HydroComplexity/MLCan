function [fsv] = Tuzet_Function (VARIABLES, PARAMS, sunlit)
%
%:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::%
%%                             FUNCTION CODE                             %%
%%                   CALCULATE THE LONGWAVE RADIATION                    %%
%:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::%
%   This function calculates the stomatal conductance reduction function  %
%   due to plant hydraulic constraint from Tuzet et al (PCE, 2003)        %                                           %
%-------------------------------------------------------------------------%
%   Date        : January 13, 2010                                        %
%-------------------------------------------------------------------------%
%                                                                         %
%   OUTPUTS:                                                              %
%       psil_MPa = leaf water potential                     [MPa]         %
%       fsv      = stomatal conductance reduction factor    [-]           %
%                  (varies from 0-1)                                      %
%                                                                         %
%       sf       = Sensitivity parameter (See Bunce, 2004)  [-]           %
%% --------------------------------------------------------------------- %%  
%
%
%*************************************************************************%
%% <<<<<<<<<<<<<<<<<<<<<<<<< DE-REFERENCE BLOCK >>>>>>>>>>>>>>>>>>>>>>>> %%
%*************************************************************************%
%
    if (sunlit)
        psil_MPa = VARIABLES.CANOPY.psil_sun;
    else
        psil_MPa = VARIABLES.CANOPY.psil_shade;
    end
    
    sf   = PARAMS.StomCond.sf;
    psif = PARAMS.StomCond.psif;
%    
%*************************************************************************%
%% <<<<<<<<<<<<<<<<<<<<<<< END OF DE-REFERENCE BLOCK >>>>>>>>>>>>>>>>>>> %%
%*************************************************************************%
%%  
    fsv  = (1 + exp(sf * psif)) ./ (1 + exp(sf * (psif - psil_MPa)));       % Eqn 2 - Tuzet et al, 2003
                                                                            % or Eqn 12 in Part B: Online Supplement, Drewry et al, 2009
%
%
%:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::%
%% <<<<<<<<<<<<<<<<<<<<<<<<< END OF FUNCTION >>>>>>>>>>>>>>>>>>>>>>>>>>>>%%
%:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::%
%