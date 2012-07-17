

% CANOPY FLUX PROFILES
    figure(fignum); clf
        subplot(2,1,1)
            pcolor(timevect, zhc, fsun_prof)
            shading interp
            colorbar
            title('\bf Sunlit Fraction', 'FontSize', 12)
            ylabel('\bf z / h', 'FontSize', 12)
            xlabel('\bf DOY', 'FontSize', 12)
        subplot(2,1,2)
            pcolor(timevect, zhc, fshade_prof)
            shading interp
            colorbar
            ylabel('\bf z / h', 'FontSize', 12)
            title('\bf Shaded Fraction', 'FontSize', 12)
            xlabel('\bf DOY', 'FontSize', 12)
        
            