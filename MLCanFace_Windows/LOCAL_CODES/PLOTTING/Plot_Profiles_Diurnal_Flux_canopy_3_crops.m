% Plot Diurnal Canopy Shortwave Radiation Absorption and Emittance
    minAn = min([min(min(CO_An_canopy_diurnal_prof)), min(min(MG_An_canopy_diurnal_prof)), min(min(SW_An_canopy_diurnal_prof))]);  
    maxAn = max([max(max(CO_An_canopy_diurnal_prof)), max(max(MG_An_canopy_diurnal_prof)), max(max(SW_An_canopy_diurnal_prof))]); 
    
    minLE = min([min(min(CO_LE_canopy_diurnal_prof)), min(min(MG_LE_canopy_diurnal_prof)), min(min(SW_LE_canopy_diurnal_prof))]);  
    maxLE = max([max(max(CO_LE_canopy_diurnal_prof)), max(max(MG_LE_canopy_diurnal_prof)), max(max(SW_LE_canopy_diurnal_prof))]); 
    
    minH = min([min(min(CO_H_canopy_diurnal_prof)), min(min(MG_H_canopy_diurnal_prof)), min(min(SW_H_canopy_diurnal_prof))]);  
    maxH = max([max(max(CO_H_canopy_diurnal_prof)), max(max(MG_H_canopy_diurnal_prof)), max(max(SW_H_canopy_diurnal_prof))]); 
    
    minRn = min([min(min(CO_Rnrad_canopy_diurnal_prof)), min(min(MG_Rnrad_canopy_diurnal_prof)), min(min(SW_Rnrad_canopy_diurnal_prof))]);  
    maxRn = max([max(max(CO_Rnrad_canopy_diurnal_prof)), max(max(MG_Rnrad_canopy_diurnal_prof)), max(max(SW_Rnrad_canopy_diurnal_prof))]); 
        
    hr = 0:0.5:23.5;    
    figure(1); clf
% CORN
    % An
        subplot(3,4,1)
            pcolor(hr, zhc_CO/2.5, CO_An_canopy_diurnal_prof)
            shading interp
            colorbar
            caxis([minAn maxAn])
            title('\bf An CANOPY [\mumol m^{-2} s^{-1}]')
            ylabel('\bf z / h')
            
    % LE         
        subplot(3,4,2)
            pcolor(hr, zhc_CO/2.5, CO_LE_canopy_diurnal_prof)
            shading interp
            colorbar
            caxis([minLE maxLE])
            title('\bf LE CANOPY [W m^{-2}]')
            ylabel('\bf z / h')
            
    % H
        subplot(3,4,3)
            hold on
            pcolor(hr, zhc_CO/2.5, CO_H_canopy_diurnal_prof)
            shading interp
            colorbar
            caxis([minH maxH])
            %axis([0 23.5 znc(vinds(1)) 1])
            title('\bf H CANOPY [W m^{-2}]')
            ylabel('\bf z / h')
            axis tight
                    
    % Rnrad
        subplot(3,4,4)
            pcolor(hr, zhc_CO/2.5, CO_Rnrad_canopy_diurnal_prof)
            shading interp
            colorbar
            caxis([minRn maxRn])
            title('\bf Rn CANOPY [W m^{-2}]')
            ylabel('\bf z / h')
%--------------------------------------------------------------------------

% MISCANTHUS
    % An
        subplot(3,4,5)
            pcolor(hr, zhc_MG/3.5, MG_An_canopy_diurnal_prof)
            shading interp
            colorbar
            caxis([minAn maxAn])
            title('\bf An CANOPY [\mumol m^{-2} s^{-1}]')
            ylabel('\bf z / h')
            
    % LE         
        subplot(3,4,6)
            pcolor(hr, zhc_MG/3.5, MG_LE_canopy_diurnal_prof)
            shading interp
            colorbar
            caxis([minLE maxLE])
            title('\bf LE CANOPY [W m^{-2}]')
            ylabel('\bf z / h')
            
    % H
        subplot(3,4,7)
            hold on
            pcolor(hr, zhc_MG/3.5, MG_H_canopy_diurnal_prof)
            shading interp
            colorbar
            caxis([minH maxH])
            %axis([0 23.5 znc(vinds(1)) 1])
            title('\bf H CANOPY [W m^{-2}]')
            ylabel('\bf z / h')
            axis tight
                    
    % Rnrad
        subplot(3,4,8)
            pcolor(hr, zhc_MG/3.5, MG_Rnrad_canopy_diurnal_prof)
            shading interp
            colorbar
            caxis([minRn maxRn])
            title('\bf Rn CANOPY [W m^{-2}]')
            ylabel('\bf z / h')
            
%--------------------------------------------------------------------------

% CORN
    % An
        subplot(3,4,9)
            pcolor(hr, zhc_SW/2.0, SW_An_canopy_diurnal_prof)
            shading interp
            colorbar
            caxis([minAn maxAn])
            title('\bf An CANOPY [\mumol m^{-2} s^{-1}]')
            ylabel('\bf z / h')
            
    % LE         
        subplot(3,4,10)
            pcolor(hr, zhc_SW/2.0, SW_LE_canopy_diurnal_prof)
            shading interp
            colorbar
            caxis([minLE maxLE])
            title('\bf LE CANOPY [W m^{-2}]')
            ylabel('\bf z / h')
            
    % H
        subplot(3,4,11)
            hold on
            pcolor(hr, zhc_SW/2.0, SW_H_canopy_diurnal_prof)
            shading interp
            colorbar
            caxis([minH maxH])
            %axis([0 23.5 znc(vinds(1)) 1])
            title('\bf H CANOPY [W m^{-2}]')
            ylabel('\bf z / h')
            axis tight
                    
    % Rnrad
        subplot(3,4,12)
            pcolor(hr, zhc_SW/2.0, SW_Rnrad_canopy_diurnal_prof)
            shading interp
            colorbar
            caxis([minRn maxRn])
            title('\bf Rn CANOPY [W m^{-2}]')
            ylabel('\bf z / h')