

% CANOPY FLUX PROFILES
    figure(fignum); clf
        subplot(3,1,1)
            pcolor(timevect, zhc, An_canopy_prof)
            shading interp
            colorbar
            title('\bf An (Canopy)', 'FontSize', 12)
            ylabel('\bf z [m]', 'FontSize', 12)
            xlabel('\bf DOY', 'FontSize', 12)
        subplot(3,1,2)
            pcolor(timevect, zhc, LE_canopy_prof)
            shading interp
            colorbar
            ylabel('\bf z [m]', 'FontSize', 12)
            title('\bf LE (Canopy)', 'FontSize', 12)
            xlabel('\bf DOY', 'FontSize', 12)
        subplot(3,1,3)
            pcolor(timevect, zhc, H_canopy_prof)
            %caxis([lwmin lwmax])
            shading interp
            colorbar
            ylabel('\bf z [m]', 'FontSize', 12)
            title('\bf H (Canopy)', 'FontSize', 12)
            xlabel('\bf DOY', 'FontSize', 12)
            