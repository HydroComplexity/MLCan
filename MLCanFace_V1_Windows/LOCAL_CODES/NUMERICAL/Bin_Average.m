function [binavg_vals, std_vals, xavg] = Bin_Average (xdata, ydata, bins)

    % Returns bin-averaged values, and standard deviations within each bin

    binds = find( xdata <= bins(1) );
    binavg_vals(1) = mean( ydata(binds) );
    std_vals(1) = std( ydata(binds) );
    xavg(1) = bins(1) - (bins(2)-bins(1))/2;
    
    binds = find( xdata > bins(length(bins)) );
    binavg_vals(length(bins)+1) = mean( ydata(binds) );
    std_vals(length(bins)+1) = std( ydata(binds) );
    xavg(length(bins)+1) = bins(length(bins)) + (bins(2)-bins(1))/2;
    
    for ii = 2:length(bins)
        
        binds = find( xdata <= bins(ii) & xdata > bins(ii-1) );
        if (ii == length(bins))
            binds = find( xdata > bins(ii-1) );
        end
        
        binavg_vals(ii) = mean( ydata(binds) );
        
        std_vals(ii) = std( ydata(binds) );
        
        xavg(ii) = bins(ii-1) + (bins(ii)-bins(ii-1))/2;
        
    end