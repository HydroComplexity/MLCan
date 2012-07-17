function [var_tot] = DAYTIME_TOTAL (doy, Rg, Rgmin, var_in)

    % Assume ONLY DATA FROM ONE YEAR IS INPUT!!!
    
    doy_unique = unique(doy);

    for tt = 1:length(doy_unique)

        inds = find(doy==doy_unique(tt) & Rg>Rgmin & ~isnan(var_in));

        var_tot(tt) = sum(var_in(inds));

    end
    
    var_tot = var_tot(:);