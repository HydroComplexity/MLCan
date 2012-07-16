function [ rootfr ] = ROOTDIST_LOGISTIC( zn, dz, PARAMS )
% 
%:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::%
%%                             FUNCTION CODE                             %%
%%                           ROOTDIST_LOGISTIC                           %%
%:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::%
%-------------------------------------------------------------------------%
%   This function calculate the logistic root fraction distribution       %                                                  %
%   following the the methodology of Schenk and Jackson(2002). Root       %
%   fraction distribution will be used to calculate the root hydraulic    %
%   conductivity in soil layers.                                          %
%   See Amenu and Kumar, 2008 - Eqn 16, pp. 60                            %
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
%
%
%*************************************************************************%
%% <<<<<<<<<<<<<<<<<<<<<<<<< DE-REFERENCE BLOCK >>>>>>>>>>>>>>>>>>>>>>>> %%
%*************************************************************************%
%
    z50 = PARAMS.Soil.z50;
    z95 = PARAMS.Soil.z95;
    maxrootdepth = PARAMS.Soil.maxrootdepth;
%    
%*************************************************************************%
%% <<<<<<<<<<<<<<<<<<<<<<<<END OF DE-REFERENCE BLOCK >>>>>>>>>>>>>>>>>>> %%
%*************************************************************************%
%% 
    cc     = 1.27875 / (log10(z50) - log10(z95));                           % see Root_distribution_logistic.pdf and Amenu & Kumar, 2008.
%
    rootfr = -dz*cc/z50 .* (zn/z50).^(cc-1) .* (1+(zn/z50).^cc).^-2;
%
% Cut off roots at maximum depth
    mind   = find(zn>maxrootdepth, 1, 'first');
    rootfr(mind:end) = 0;
%
    rootfr = rootfr / sum(rootfr);
%
%
%:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::%
%% <<<<<<<<<<<<<<<<<<<<<<<<< END OF FUNCTION >>>>>>>>>>>>>>>>>>>>>>>>>>>>%%
%:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::%
