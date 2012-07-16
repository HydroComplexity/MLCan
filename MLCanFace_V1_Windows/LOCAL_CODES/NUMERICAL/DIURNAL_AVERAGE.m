function [var_mean, var_std] = DIURNAL_AVERAGE (hours, hours_all, var_in)

    for tt = 1:length(hours)

        inds = find(hours_all==hours(tt) & ~isnan(var_in));

        var_mean(tt) = mean(var_in(inds));
        var_std(tt) = std(var_in(inds));

    end