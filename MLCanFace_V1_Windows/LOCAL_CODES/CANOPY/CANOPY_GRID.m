function [znc, zhc, dzc, zlai] = Canopy_Grid(PARAMS)

%:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::%
%%                              FUNCTION CODE                            %%
%%                         CONSTRUCT CANOPY GRID                         %%
%:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::%
%-------------------------------------------------------------------------%
% This function is used to construct the canopy grid by evenly spacing 	  %
% nl_can' nodes between the soil surface and canopy top at 'hcan'         %
%   INPUTS:                                                               %
%       nl_can = # of canopy layers                                       %
%       hcan = height of the canopy         [m]                           %
%       LAInorm = normalized LAI profile                                  %
%                                                                         %
%   OUTPUTS:                                                              %
%       znc = canopy node heights           [m]                           %
%       zhc = canopy interface heights      [m]                           %
%       dzc = 0.5* canopy node height       [m]                           %
%       zlai= normalized leaf area profile  [m]                           %
%                                                                         %
%-------------------------------------------------------------------------%
%   Created by  : Darren Drewry                                           %
%   Editted by  : Phong Le                                                %
%   Date        : December 25, 2009                                       %
%% --------------------------------------------------------------------- %%  
%
%
%*************************************************************************%
%% <<<<<<<<<<<<<<<<<<<<<<<<< DE-REFERENCE BLOCK >>>>>>>>>>>>>>>>>>>>>>>> %%
%*************************************************************************%
%
    nl_can	= PARAMS.CanStruc.nl_can;
    hcan 	= PARAMS.CanStruc.hcan;
%    
%*************************************************************************%
%% <<<<<<<<<<<<<<<<<<<<<<<<END OF DE-REFERENCE BLOCK >>>>>>>>>>>>>>>>>>> %%
%*************************************************************************%
%% 
% CALCULATE NODE AND LAYER SPACING
    zhc 	= [1:nl_can] * (hcan / nl_can);
%    
    dzc 	= zhc(1) / 2;
%    
    znc 	= zhc - dzc;
%    
% CALCULATE NORMALIZED LEAF AREA PROFILE
    zb 		= find(znc>(floor(hcan/4)), 1, 'first');
    zlai 	= zeros(size(znc));
    zlai(zb:end)= 1;
    zlai 	= zlai / sum(zlai);
%
%
%:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::%
%% <<<<<<<<<<<<<<<<<<<<<<<<< END OF FUNCTION >>>>>>>>>>>>>>>>>>>>>>>>>>>>%%
%:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::% 