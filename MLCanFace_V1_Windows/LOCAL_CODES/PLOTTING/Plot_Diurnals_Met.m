

figure(fignum); clf
    subplot(6,1,1)
        hold on
        errorbar(hr, Rg_diurnal_obs, Rg_std_obs, '-ok')
        xlabel('Hour')
        ylabel('R_g [W m^{-2}]')
        axis([min(hr) max(hr) 00 1200])
        box on
    subplot(6,1,2)
        hold on
        errorbar(hr, LW_diurnal_obs, LW_std_obs, '-ok')
        xlabel('Hour')
        ylabel('LW_{dn} [W m^{-2}]')
        axis([min(hr) max(hr) 350 500])
        box on
    subplot(6,1,3)
        hold on
        errorbar(hr, Ta_diurnal_obs, Ta_std_obs, '-ok')
        xlabel('Hour')
        ylabel('T_a [C]')
        axis([min(hr) max(hr) 5 35])
        box on
    subplot(6,1,4)
        hold on
        errorbar(hr, VPD_diurnal_obs, VPD_std_obs, '-ok')
        xlabel('Hour')
        ylabel('VPD [kPa]')
        axis([min(hr) max(hr) 0 3])
        box on
    subplot(6,1,5)
        hold on
        errorbar(hr, ea_diurnal_obs, ea_std_obs, '-ok')
        xlabel('Hour')
        ylabel('ea [kPa]')
        axis([min(hr) max(hr) -Inf Inf])
        box on
    subplot(6,1,6)
        hold on
        errorbar(hr, U_diurnal_obs, U_std_obs, '-ok')
        xlabel('Hour')
        ylabel('U [m s^{-1}]')
        axis([min(hr) max(hr) 0 8])
        box on