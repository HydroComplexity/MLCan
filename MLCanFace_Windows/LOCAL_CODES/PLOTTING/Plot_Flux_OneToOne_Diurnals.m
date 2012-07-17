% CANOPY-TOP FLUXES
% Data Quality

    hours = unique(hour);

    Rnvar = Rnrad_eco_store;

    Fcqc_best_inds = find(Fc_qc==0);
    LEqc_best_inds = find(LE_qc==0);
    Hqc_best_inds = find(H_qc==0);
    Rn_good_inds = find(~isnan(Rn_in));
    
    pfFc = polyfit(Fc_in(Fcqc_best_inds), Fc_eco_store(Fcqc_best_inds), 1);
    pfLE = polyfit(LE_in(LEqc_best_inds), LE_eco_store(LEqc_best_inds), 1);
    pfH = polyfit(H_in(Hqc_best_inds), H_eco_store(Hqc_best_inds), 1);
    pfRn = polyfit(Rn_in(Rn_good_inds), Rnvar(Rn_good_inds), 1);
    
    Fcqc_good_inds = find(Fc_qc==1);
    LEqc_good_inds = find(LE_qc==1);
    Hqc_good_inds = find(H_qc==1);
    
    Fcqc_bad_inds = find(Fc_qc>1);
    LEqc_bad_inds = find(LE_qc>1);
    Hqc_bad_inds = find(H_qc>1); 
    
    % Daytime Best Indices
    Fcqc_daybest_inds = find(Fc_qc==0 & Rg_in>=50);
    LEqc_daybest_inds = find(LE_qc==0 & Rg_in>=50);
    Hqc_daybest_inds = find(H_qc==0 & Rg_in>=50);
    Rn_daybest_inds = find(~isnan(Rn_in) & Rg_in>=50);
    
    pfFc_day = polyfit(Fc_in(Fcqc_daybest_inds), Fc_eco_store(Fcqc_daybest_inds), 1);
    pfLE_day = polyfit(LE_in(LEqc_daybest_inds), LE_eco_store(LEqc_daybest_inds), 1);
    pfH_day = polyfit(H_in(Hqc_daybest_inds), H_eco_store(Hqc_daybest_inds), 1);
    pfRn_day = polyfit(Rn_in(Rn_daybest_inds), Rnvar(Rn_daybest_inds), 1);
    
    
    minFc = min(min(Fc_in),min(Fc_eco_store)) - 5;
    maxFc = max(max(Fc_in),max(Fc_eco_store)) + 5;
    minLE = min(min(LE_in),min(LE_eco_store)) - 20;
    maxLE = max(max(LE_in),max(LE_eco_store)) + 20;
    minH = min(min(H_in),min(H_eco_store));
    maxH = max(max(H_in),max(H_eco_store));
    minRn = min(min(H_in(Rn_good_inds)),min(Rnvar));
    maxRn = max(max(H_in(Rn_good_inds)),max(Rnvar));
    
    minFc = -65; %min(minFc, -70);
    maxFc = 23; %max(maxFc, 20);
    minLE = -200; %min(minLE, -200);
    maxLE = 620; %max(maxLE, 700);
    minH = -200; %min(minH, -200);
    maxH = 620; %max(maxH, 700);
    minRn = -200;
    maxRn = 850;
    
    figure(fignum); clf
            
    % FLUX ONE-TO-ONES
        subplot(4,2,1)
            hold on
            plot([minFc maxFc], [minFc maxFc], '-k')
            plot(Fc_in(Fcqc_best_inds), Fc_eco_store(Fcqc_best_inds), '.k', 'MarkerSize', 8)
            plot([minFc, maxFc], pfFc(1)*[minFc, maxFc]+pfFc(2), '--', 'LineWidth', 2, 'Color', [0.5 0.5 0.5])
            %plot([minFc, maxFc], pfFc_day(1)*[minFc, maxFc]+pfFc_day(2), '--r', 'LineWidth', 2)
            axis([minFc maxFc minFc maxFc])
            xlabel('\itF_c \rm(Obs) [\mumol m^{-2} s^{-1}]', 'FontSize', 12)
            ylabel('\itF_c \rm(Mod) [\mumol m^{-2} s^{-1}]', 'FontSize', 12)
            box on
            
        subplot(4,2,3)
            hold on
            plot([minLE maxLE], [minLE maxLE], '-k')
            plot(LE_in(LEqc_best_inds), LE_eco_store(LEqc_best_inds), '.k', 'MarkerSize', 8)
            plot([minLE, maxLE], pfLE(1)*[minLE, maxLE]+pfLE(2), '--', 'LineWidth', 2, 'Color', [0.5 0.5 0.5])
            %plot([minLE, maxLE], pfLE_day(1)*[minLE, maxLE]+pfLE_day(2), '--r', 'LineWidth', 2)            
            axis([minLE maxLE minLE maxLE])
            xlabel('\itLE \rm(Obs) [W m^{-2}]', 'FontSize', 12)
            ylabel('\itLE \rm(Mod) [W m^{-2}]', 'FontSize', 12)
            box on
            
        subplot(4,2,5)
            hold on       
            plot([minH maxH], [minH maxH], '-k')
            plot(H_in(Hqc_best_inds), H_eco_store(Hqc_best_inds), '.k', 'MarkerSize', 8)
            plot([minH, maxH], pfH(1)*[minH, maxH]+pfH(2), '--', 'LineWidth', 2, 'Color', [0.5 0.5 0.5])
            %plot([minH, maxH], pfH_day(1)*[minH, maxH]+pfH_day(2), '--r', 'LineWidth', 2)
            axis([minH maxLE minH maxLE])
            xlabel('\itH \rm(Obs) [W m^{-2}]', 'FontSize', 12)
            ylabel('\itH \rm(Mod) [W m^{-2}]', 'FontSize', 12)
            box on

        subplot(4,2,7)
            hold on       
            plot([minRn maxRn], [minRn maxRn], '-k')
            plot(Rn_in(Rn_good_inds), Rnvar(Rn_good_inds), '.k', 'MarkerSize', 8)
            plot([minRn, maxRn], pfRn(1)*[minRn, maxRn]+pfRn(2), '--', 'LineWidth', 2, 'Color', [0.5 0.5 0.5])
            %plot([minRn, maxRn], pfRn_day(1)*[minRn, maxRn]+pfRn_day(2), '--r', 'LineWidth', 2)
            axis([minRn maxRn minRn maxRn])
            xlabel('\itR_n \rm(Obs) [W m^{-2}]', 'FontSize', 12)
            ylabel('\itR_n \rm(Mod) [W m^{-2}]', 'FontSize', 12)
            box on
        
            
    % FLUX DIURNALS        
        subplot(4,2,2)
            hold on
            plot(hours, zeros(size(hours)), ':k')
            errorbar(hours, Fc_diurnal_obs, Fc_std_obs, '-ok', 'MarkerFaceColor', 'k');
            errorbar(hours, Fc_diurnal_eco, Fc_std_eco, '-sr');
            axis([0 23.5 -50 15])
            box on
            xlabel('Hour', 'FontSize',12)
            ylabel('\itF_c \rm[\mumol m^{-2} s^{-1}]', 'FontSize', 12)
            
        subplot(4,2,4)
            hold on
            plot(hours, zeros(size(hours)), ':k')
            errorbar(hours, LE_diurnal_obs, LE_std_obs, '-ok', 'MarkerFaceColor', 'k')
            errorbar(hours, LE_diurnal_eco, LE_std_eco, '-sr')   
            axis([0 23.5 -100 450])
            box on
            xlabel('Hour', 'FontSize',12)
            ylabel('\itLE \rm[W m^{-2}]', 'FontSize', 12)
            
        subplot(4,2,6)
            hold on
            plot(hours, zeros(size(hours)), ':k')
            p1 = errorbar(hours, H_diurnal_obs, H_std_obs, '-ok', 'MarkerFaceColor', 'k');
            p2 = errorbar(hours, H_diurnal_eco, H_std_eco, '-sr');
            axis([0 23.5 -100 450])
            box on
            legend([p1,p2], 'Observed', 'Modeled')
            xlabel('Hour', 'FontSize',12)
            ylabel('\itH \rm[W m^{-2}]', 'FontSize', 12)
            
        subplot(4,2,8)
            hold on
            plot(hours, zeros(size(hours)), ':k')
            errorbar(hours, Rn_diurnal_obs, Rn_std_obs, '-ok', 'MarkerFaceColor', 'k')
            errorbar(hours, Rn_diurnal_eco, Rn_std_eco, '-sr')
            axis([0 23.5 -100 800])
            box on
            xlabel('Hour', 'FontSize',12)
            ylabel('\itR_n \rm[W m^{-2}]', 'FontSize', 12)
            
            