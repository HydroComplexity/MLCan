    
    
    figure(fignum); clf
        subplot(1,3,1)
            pcolor(hr, zhc, Sh2o_canopy_diurnal_prof)
            shading interp
            colorbar
            title('\bf H_2O Storage [mm]', 'FontSize', 12)
            ylabel('\bf z [m]', 'FontSize', 12)
            xlabel('\bfHour', 'FontSize', 12)
        subplot(1,3,2)
            pcolor(hr, zhc, Ch2o_canopy_diurnal_prof)
            shading interp
            colorbar
            title('\bf Condensation [mm]', 'FontSize', 12)
            ylabel('\bf z [m]', 'FontSize', 12)
            xlabel('\bfHour', 'FontSize', 12)
        subplot(1,3,3)
            pcolor(hr, zhc, dryfrac_diurnal_prof)
            shading interp
            colorbar
            caxis([0 1])
            title('\bf Dry Fraction [-]', 'FontSize', 12)
            ylabel('\bf z [m]', 'FontSize', 12)
            xlabel('\bfHour', 'FontSize', 12)
           
 