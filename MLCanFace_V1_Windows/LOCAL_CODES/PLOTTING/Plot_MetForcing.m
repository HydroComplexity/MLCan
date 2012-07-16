

% Met Variables
figure(fignum); clf
    subplot(6,1,1)
        hold on
        plot(timevect, Rg_in, 'k')
        plot(timevect, Rgup_in, 'r')%'Color', [0.5 0.5 0.5])     
        legend('SW Down', 'SW Up')
        axis([-Inf Inf -100 1000])
        ylabel('Shortwave [W m^{-2}]')
        title('OBSERVED MET VARIABLES', 'FontSize', 12) 
    subplot(6,1,2)
        hold on
        plot(timevect, LWdn_in, 'k')
        plot(timevect, LWup_in, 'r')%'Color', [0.5 0.5 0.5])
        legend('LW Down', 'LW Up')
        axis([-Inf Inf 300 500])
        ylabel('Longwave [W m^{-2}]')    
    subplot(6,1,3)
        hold on
        plot(timevect, Ta_in, 'k')
        plot(timevect, Tskin_in, 'r')
        legend('Ta', 'Tskin')
        axis([-Inf Inf -Inf Inf])
        ylabel('Ta [C]')
    subplot(6,1,4)
        hold on
        plot(timevect, VPD_in, 'k')
        plot(timevect, ea_in, 'r')
        axis([-Inf Inf -Inf Inf])
        legend('VPD', 'ea')
        ylabel('VPD, ea [kPa]')
    subplot(6,1,5)
        hold on
        plot(timevect, U_in, 'k')
        plot(timevect, ustar_in, 'r')
        axis([-Inf Inf -Inf Inf])
        ylabel('U [m s^{-1}]')
        legend('U', 'u*')
    subplot(6,1,6)
        plot(timevect, PPT_in/CONSTANTS.dtime, 'k')
        axis([-Inf Inf -Inf Inf])
        ylabel('PPT [mm s^{-1}]')
        xlabel(timelabel)
    
