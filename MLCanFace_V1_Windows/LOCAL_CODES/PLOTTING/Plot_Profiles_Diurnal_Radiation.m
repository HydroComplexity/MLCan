% Plot Diurnal Canopy Shortwave Radiation Absorption and Emittance
    minPAR = min(min(PARabs_canopy_diurnal_prof));  
    maxPAR = max(max(PARabs_canopy_diurnal_prof));
    
    minNIR = min(min(NIRabs_canopy_diurnal_prof));  
    maxNIR = max(max(NIRabs_canopy_diurnal_prof));
    
    hcan   = PARAMS.CanStruc.hcan;
    figure(fignum); clf
    % PAR
        subplot(4,2,1)
            pcolor(hr, zhc/hcan, PARabs_canopy_diurnal_prof)
            shading interp
            colorbar
            caxis([minPAR maxPAR])
            title('\bf PAR_{abs} CANOPY [\mumol m^{-2} s^{-1}]', 'FontSize', 12)
            ylabel('\bf z / h', 'FontSize', 12)
        subplot(4,2,3)
            pcolor(hr, zhc/hcan, PARabs_sun_diurnal_prof)
            shading interp
            colorbar
            caxis([minPAR maxPAR])
            title('\bf PAR_{abs} SUNLIT [\mumol m^{-2} s^{-1}]', 'FontSize', 12)
            ylabel('\bf z / h', 'FontSize', 12)
        subplot(4,2,5)
            pcolor(hr, zhc/hcan, PARabs_shade_diurnal_prof)
            shading interp
            colorbar
            caxis([minPAR maxPAR])
            title('\bf PAR_{abs} SHADED [\mumol m^{-2} s^{-1}]', 'FontSize', 12)
            ylabel('\bf z / h', 'FontSize', 12)
           
    % NIR
        subplot(4,2,2)
            pcolor(hr, zhc/hcan, NIRabs_canopy_diurnal_prof)
            shading interp
            colorbar
            caxis([minNIR maxNIR])
            title('\bf NIR_{abs} CANOPY [W m^{-2} s^{-1}]', 'FontSize', 12)
            ylabel('\bf z / h', 'FontSize', 12)
        subplot(4,2,4)
            pcolor(hr, zhc/hcan, NIRabs_sun_diurnal_prof)
            shading interp
            colorbar
            caxis([minNIR maxNIR])
            title('\bf NIR_{abs} SUNLIT [W m^{-2} s^{-1}]', 'FontSize', 12)
            ylabel('\bf z / h', 'FontSize', 12)
        subplot(4,2,6)
            pcolor(hr, zhc/hcan, NIRabs_shade_diurnal_prof)
            shading interp
            colorbar
            caxis([minNIR maxNIR])
            title('\bf NIR_{abs} SHADED [W m^{-2} s^{-1}]', 'FontSize', 12)
            ylabel('\bf z / h', 'FontSize', 12)
            
     % LW
        subplot(4,2,7)
            pcolor(hr, zhc/hcan, LWabs_can_diurnal_prof)
            shading interp
            colorbar
            %caxis([minNIR maxNIR])
            title('\bf LW_{abs} CANOPY [W m^{-2} s^{-1}]', 'FontSize', 12)
            ylabel('\bf z / h', 'FontSize', 12)
            
        subplot(4,2,8)
            pcolor(hr, zhc/hcan, LWemit_can_diurnal_prof)
            shading interp
            colorbar
            %caxis([minNIR maxNIR])
            title('\bf LW_{emit} CANOPY [W m^{-2} s^{-1}]', 'FontSize', 12)
            ylabel('\bf z / h', 'FontSize', 12)     
        