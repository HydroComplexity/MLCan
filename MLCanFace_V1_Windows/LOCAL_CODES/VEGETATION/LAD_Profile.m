function [LADnorm] = LAD_Profile(VERTSTRUC)

% Interpolate Observed LAI profiles to model grid
% Output normalized LAD profile

% Load profile information from temporary file
load './Temps/temp_variable.mat' 'dat_LAD'

znc = VERTSTRUC.znc;
assignin('base','znc',znc);

height = dat_LAD(:,1)';

% Ambient
LAI_amb =dat_LAD(:,2)';
LAI_amb_normalized = LAI_amb./sum(LAI_amb);

LAI_obs_norm = LAI_amb_normalized;
assignin('base','LAI_obs_norm',LAI_obs_norm);

% Interpolate Observations to Grid
try
    LADnorm = interp1(height, LAI_obs_norm, znc, 'linear', 'extrap');
	LADnorm(find(LADnorm<0)) = 0;
    LADnorm = LADnorm/sum(LADnorm);
    LADnorm = LADnorm(:);
catch exception
    msgbox('LAD profile Data should be distinct, please enter information and run the model again','MLCan error','error');
end
