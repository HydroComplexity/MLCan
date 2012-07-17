function [gsv, Ci, Hs] = BALL_BERRY (VARIABLES, PARAMS, VERTSTRUC, sunlit)
%
%:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::%
%%                             FUNCTION CODE                             %%
%%                     CALCULATE BALL-BERRY EQUATION                     %%
%:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::%
%   This function calculates stomatal conductance using the               %
%   Ball-Berry equation. See Ball, Woodrow, Berry (1987)                  %
%-------------------------------------------------------------------------%
%   Created by  : Darren Drewry                                           %
%   Editted by  : Phong Le                                                %
%   Date        : January 13, 2010                                        %
%-------------------------------------------------------------------------%
%                                                                         %
%   VARIABLES:                                                            %
%       Cs      = Leaf surface CO2 concentraion                           %
%       An      = Net assimilation                                        %
%       Hs      = Leaf surface relative humidity                          %
%       mslope  = Proportionality constant                                %  
%       gsv     = Stomatal conductance for vapor                          %
%       bint    = Minimum conductance or intercept parameter              %
%% --------------------------------------------------------------------- %%  
%
%
%*************************************************************************%
%% <<<<<<<<<<<<<<<<<<<<<<<<< DE-REFERENCE BLOCK >>>>>>>>>>>>>>>>>>>>>>>> %%
%*************************************************************************%
%
    if (sunlit)
        An  = VARIABLES.CANOPY.An_sun;
        Tl_C= VARIABLES.CANOPY.Tl_sun;
        gsv = VARIABLES.CANOPY.gsv_sun;
        fsv = VARIABLES.CANOPY.fsv_sun;
        gbv = VARIABLES.CANOPY.gbv_sun;
    else
        An  = VARIABLES.CANOPY.An_shade;
        Tl_C= VARIABLES.CANOPY.Tl_shade;
        gsv = VARIABLES.CANOPY.gsv_shade;
        fsv = VARIABLES.CANOPY.fsv_shade;
        gbv = VARIABLES.CANOPY.gbv_shade;
    end
%    
    Ca = VARIABLES.CANOPY.CAz; 
    ea = VARIABLES.CANOPY.EAz;
%
    mslope = PARAMS.StomCond.mslope;
    bint   = PARAMS.StomCond.bint; 
%    
    nvinds = VERTSTRUC.nvinds; 
%    
%*************************************************************************%
%% <<<<<<<<<<<<<<<<<<<<<<< END OF DE-REFERENCE BLOCK >>>>>>>>>>>>>>>>>>> %%
%*************************************************************************%
%% 
% Fick's Law (18c - Sellers et al, 1992)
	Cs      = Ca - (1.37 * An) ./ gbv;
%
% Ball / Berry
    estarTl = 0.611 * exp( (17.502 * (Tl_C)) ./ (Tl_C + 240.97) );          % [kPa]
    ei      = estarTl;                                                      % Assume inter-cellular space saturated at Tl            
    es      = (gsv .* ei + gbv .* ea) ./ (gsv + gbv);
    Hs      = es ./ estarTl;         
    gsv     = fsv .* mslope .* An .* Hs ./ Cs + bint;                       % Eqn 11: Drewry et al, 2009.Part B-Online Supplement
%
% Internal CO2 Concentration
    Ci      = Ca - (1.37 * An)./gbv - (1.6 * An)./gsv;              
    % equivalent Ci = Cs * (1 - (1.6*An)./gsv)                              % Eqn 4: Ball-Woodrow-Berry, 1987                            
%    
% No net uptake
    binds       = find(An<=0);
    Ci(binds)   = Ca(binds);
    gsv(binds)  = bint;
    
% Non-vegetated levels    
    gsv(nvinds) = 0;
    Ci(nvinds)  = 0;
%        
    gsv = gsv(:);
    Ci  = Ci(:);
%
%
%:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::%
%% <<<<<<<<<<<<<<<<<<<<<<<<< END OF FUNCTION >>>>>>>>>>>>>>>>>>>>>>>>>>>>%%
%:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::%
%