function [Sh2o_prof, Smaxz, ppt_ground, wetfrac, dryfrac] = PRECIP_INTERCEPTION(FORCING, VARIABLES, VERTSTRUC, PARAMS)

%:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::%
%%                             FUNCTION CODE                             %%
%%                       PRECIPITATION INTERCEPTION                      %%
%:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::%
%-------------------------------------------------------------------------%
% This function is used to calculate the augmentations of current canopy  %
% water storage with intercepted precipitation                            %
% See Eqn 27 - Drewry et al, 2009, Part B: Online Supplement              %  
%-------------------------------------------------------------------------%
%   Created by  : Darren Drewry                                           %
%   Editted by  : Phong Le                                                %
%   Date        : January 7, 2010                                         %
%-------------------------------------------------------------------------%
%   VARIABLES:                                                            %
%       Smax        = Maximum H20 storage capacity for foliage  [mm/LAI]  %
%       Smaxz       = Maximum canopy moisture storage           [mm]      %
%       ppt_ground  = Precipitation incident on the ground      [mm]      %
%       wetfrac     = Wet fraction                              [-]       %
%       dryfrac     = Dry fraction                              [-]       %
%       pptintfact  = precipitation interception factor         [-]       %
%       LAIz(i)     = Leaf Area Index at layer ith              [-]       %
%       clump       = foliage clumping parameter                [-]       % 
%       nvinds      = Grid indices for which there is no vegetation       %
%                                                                         %
%% --------------------------------------------------------------------- %%  
%
%
%*************************************************************************%
%% <<<<<<<<<<<<<<<<<<<<<<<<< DE-REFERENCE BLOCK >>>>>>>>>>>>>>>>>>>>>>>> %%
%*************************************************************************%
%
    ppt         = FORCING.ppt;
%    
    Sh2o_prof   = VARIABLES.CANOPY.Sh2o_prof;
%    
    LAIz        = VERTSTRUC.LAIz;
    znc         = VERTSTRUC.znc;
    nvinds      = VERTSTRUC.nvinds;
%    
    Smax        = PARAMS.CanStruc.Smax;
    Ffact       = PARAMS.CanStruc.Ffact;
    pptintfact  = PARAMS.CanStruc.pptintfact;
    clump       = PARAMS.Rad.clump;
%    
%*************************************************************************%
%% <<<<<<<<<<<<<<<<<<<<<<<<END OF DE-REFERENCE BLOCK >>>>>>>>>>>>>>>>>>> %%
%*************************************************************************%
%% 
    Smaxz       = Smax * LAIz;      % [mm]                                  % Maximum canopy moisture storage
%                                                                               
    % Attenuate precipitation through canopy
    if (ppt>0)
        % Loop from top to bottom of canopy
        for zz = length(znc):-1:1
            if (Sh2o_prof(zz) >= Smaxz(zz))                                 % If water storage > maximum storage (at each layer)
                continue;
            else                                                            % Re-calculate the water storage (at each layer)
                % Potential H2O intercepted
                pptint_pot = (1 - exp(-pptintfact * clump * LAIz(zz)))*ppt; % Eqn 27
                if ( (Sh2o_prof(zz) + pptint_pot) <= Smaxz(zz) )
                    Sh2o_prof(zz) = Sh2o_prof(zz) + pptint_pot;
                    ppt = ppt - pptint_pot;
                else
                    pptint = Smaxz(zz) - Sh2o_prof(zz);
                    Sh2o_prof(zz) = Smaxz(zz);
                    ppt = ppt - pptint;
                end
            end
            
        end
    end
%    
    ppt_ground = ppt;  % ppt is now the precipitation incident on the ground
%    
    wetfrac = Ffact .* (Sh2o_prof ./ Smaxz);
    dryfrac = 1 - wetfrac;
    wetfrac(nvinds) = 0;
    dryfrac(nvinds) = 0;
%    
%:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::%
%% <<<<<<<<<<<<<<<<<<<<<<<<< END OF FUNCTION >>>>>>>>>>>>>>>>>>>>>>>>>>>>%%
%:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::%
