function [var_tot] = DAYNIGHT_TOTAL (doy, var_in)

    % Assume ONLY DATA FROM ONE YEAR IS INPUT!!!
    
    doy_unique = unique(doy);

    for tt = 1:length(doy_unique)

        inds = find(doy==doy_unique(tt) & ~isnan(var_in));

        var_tot(tt) = sum(var_in(inds));

    end
    
    var_tot = var_tot(:);