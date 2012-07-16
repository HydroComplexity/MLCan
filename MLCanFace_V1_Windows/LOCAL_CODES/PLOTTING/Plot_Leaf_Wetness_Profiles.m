

% LEAF POTENTIAL AND HYDRAULIC STOMATAL CONTROL
    minlw = min(min(Sh2o_canopy_prof));  
    maxlw = max(max(Sh2o_canopy_prof));  
    figure(fignum); clf
        subplot(5,1,1)
            hold on
            plot(timevect, Sh2o_canopy, 'k')
            plot(timevect, Ch2o_canopy, 'b')
            plot(timevect, Evap_canopy, 'r')
            axis([timevect(1) timevect(end) 0 Inf])
            legend('H_2O Storage', 'Condensation', 'Evaporation')
            ylabel('\bf Leaf Wetness [mm]', 'FontSize', 12)
            box on
        subplot(5,1,2)
            pcolor(timevect, zhc, Sh2o_canopy_prof)
            colormap(flipdim(jet,1))
            shading interp
            colorbar
            caxis([0 maxlw])
            title('\bf Leaf Wetness (Sh2o)', 'FontSize', 12)
            ylabel('\bf z / h', 'FontSize', 12)
            box on
        subplot(5,1,3)
            pcolor(timevect, zhc, Ch2o_canopy_prof)
            colormap(flipdim(jet,1))
            shading interp
            colorbar
            caxis([0 maxlw])
            title('\bf Condensation (Ch2o)', 'FontSize', 12)
            ylabel('\bf z / h', 'FontSize', 12)
            box on    
        subplot(5,1,4)
            pcolor(timevect, zhc, dryfrac_prof)
            colormap(flipdim(jet,1))
            shading interp
            colorbar
            %caxis([0 maxlw])
            title('\bf Canopy Dry Fraction', 'FontSize', 12)
            ylabel('\bf z / h', 'FontSize', 12)
            box on    
        subplot(5,1,5)
            plot(timevect, PPT_in)
            axis([timevect(1) timevect(end) 0 Inf])
            ylabel('\bf PPT [mm]', 'FontSize', 12)
            xlabel('\bf DOY', 'FontSize', 12)
            box on