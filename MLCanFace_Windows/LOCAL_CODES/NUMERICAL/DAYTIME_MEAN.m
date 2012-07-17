function [var_mean, var_std] = DAYTIME_MEAN (doy, Rg, Rgmin, var_in)

    % Assume ONLY DATA FROM ONE YEAR IS INPUT!!!
    
    doy_unique = unique(doy);

    for tt = 1:length(doy_unique)

        inds = find(doy==doy_unique(tt) & Rg>Rgmin & ~isnan(var_in));

        var_mean(tt) = mean(var_in(inds));
        var_std(tt) = std(var_in(inds));

    end
    
    var_mean = var_mean(:);