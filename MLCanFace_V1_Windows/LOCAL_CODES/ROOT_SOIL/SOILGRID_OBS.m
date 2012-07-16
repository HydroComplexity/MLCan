function [znode_all, dz_all, zlayer_all, nl_soil] = SOILGRID_OBS
% Interpolate Observed Root profiles to model soil grid
% Output normalized root profile

% Load profile information from temporary file
load './Temps/temp_variable.mat' 'dat_root'

    zlayer_all      = dat_root(:,1);
    length_z        = length(zlayer_all);
    zlayer_add(1)   = 0;
    for i = 1:length_z
        zlayer_add(i+1) = zlayer_all(i);
        znode_all(i)    = (zlayer_add(i+1)+zlayer_add(i))/2;
        dz_all(i)       = zlayer_add(i+1)-zlayer_add(i);
    end
    root_den        = dat_root(:,2);

% Calculate the number of soil layer
    nl_soil     = length(zlayer_all);
    
    znode_all = znode_all';
    dz_all = dz_all';
end