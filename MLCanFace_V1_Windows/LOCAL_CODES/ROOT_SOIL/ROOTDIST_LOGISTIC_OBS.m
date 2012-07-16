function [rootfr] = ROOTDIST_LOGISTIC_OBS
% 
%:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::%
%%                             FUNCTION CODE                             %%
%%                           ROOTDIST_LOGISTIC                           %%
%:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::%
%-------------------------------------------------------------------------%
%   This function calculate the logistic root fraction distribution       %                                                  %
%                                                                         %
%   INPUTS:                                                               %
%       zn = node depths [m]                                              %
%       dz = layer thicknesses [m]                                        %
%       Z50 = depth to which 50% of root biomass exists                   %
%       Z95 = depth to which 95% of root biomass exists                   %
%                                                                         %
%-------------------------------------------------------------------------%
%   Created by  : Darren Drewry                                           %
%   Editted by  : Phong Le                                                %
%   Date        : December 26, 2009                                       %
%% --------------------------------------------------------------------- %%  

load './Temps/temp_variable.mat' 'dat_root'
% Root density
    root_den        = dat_root(:,2);
%
% Interpolate root soil grid
    rootfr      = root_den/sum(root_den);
%
%
%:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::%
%% <<<<<<<<<<<<<<<<<<<<<<<<< END OF FUNCTION >>>>>>>>>>>>>>>>>>>>>>>>>>>>%%
%:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::%
