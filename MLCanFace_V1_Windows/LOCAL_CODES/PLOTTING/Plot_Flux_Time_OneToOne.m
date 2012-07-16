% CANOPY-TOP FLUXES
% Data Quality

    Fcqc_best_inds = find(Fc_qc==0);
    LEqc_best_inds = find(LE_qc==0);
    Hqc_best_inds = find(H_qc==0);
    
    pfFc = polyfit(Fc_in(Fcqc_best_inds), Fc_eco_store(Fcqc_best_inds), 1);
    pfLE = polyfit(LE_in(LEqc_best_inds), LE_eco_store(LEqc_best_inds), 1);
    pfH = polyfit(H_in(Hqc_best_inds), H_eco_store(Hqc_best_inds), 1);
    
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
    
    pfFc_day = polyfit(Fc_in(Fcqc_daybest_inds), Fc_eco_store(Fcqc_daybest_inds), 1);
    pfLE_day = polyfit(LE_in(LEqc_daybest_inds), LE_eco_store(LEqc_daybest_inds), 1);
    pfH_day = polyfit(H_in(Hqc_daybest_inds), H_eco_store(Hqc_daybest_inds), 1);
    
    
    
    minFc = min(min(Fc_in),min(Fc_eco_store));
    maxFc = max(max(Fc_in),max(Fc_eco_store));
    minLE = min(min(LE_in),min(LE_eco_store));
    maxLE = max(max(LE_in),max(LE_eco_store));
    minH = min(min(H_in),min(H_eco_store));
    maxH = max(max(H_in),max(H_eco_store));
    
    minFc = min(minFc, -70);
    maxFc = max(maxFc, 20);
    minLE = min(minLE, -200);
    maxLE = max(maxLE, 700);
    minH = min(minH, -200);
    maxH = max(maxH, 700);
    
    figure(fignum); clf
        subplot(3,2,1)
            hold on
            plot(timevect(Fcqc_best_inds), Fc_in(Fcqc_best_inds), '.k', 'MarkerSize', 8)
            plot(timevect(Fcqc_best_inds), Fc_eco_store(Fcqc_best_inds), '-b')
            plot(timevect(Fcqc_best_inds), Fc_soil_store(Fcqc_best_inds), '-r')
            plot(timevect, zeros(size(timevect)), '-', 'Color', [0.5 0.5 0.5])
            axis([-Inf Inf minFc maxFc])
            ylabel('\bfNEE [\mumol m^{-2} s^{-1}]')
            title(['\bfBONDVILLE , ', num2str(years)])
            box on
            
        subplot(3,2,2)
            hold on
            plot(Fc_in(Fcqc_best_inds), Fc_eco_store(Fcqc_best_inds), '.k', 'MarkerSize', 8)
            plot([minFc maxFc], [minFc maxFc], '-', 'Color', [0.5 0.5 0.5], 'LineWidth', 3)
            plot([minFc, maxFc], pfFc(1)*[minFc, maxFc]+pfFc(2), '--g', 'LineWidth', 2)
            plot([minFc, maxFc], pfFc_day(1)*[minFc, maxFc]+pfFc_day(2), '--r', 'LineWidth', 2)
            axis([minFc maxFc minFc maxFc])
            xlabel('\bfFc (Obs) [\mumol m^{-2} s^{-1}]')
            ylabel('\bfFc (Mod) [\mumol m^{-2} s^{-1}]')
            title(['\bfslope = ', num2str(pfFc(1)), '    int = ', num2str(pfFc(2))])
            box on
            
        subplot(3,2,3)
            hold on            
            plot(timevect(LEqc_best_inds), LE_in(LEqc_best_inds), '.k', 'MarkerSize', 8)
            plot(timevect(LEqc_best_inds), LE_eco_store(LEqc_best_inds), '-b')
            plot(timevect(LEqc_best_inds), LE_soil_store(LEqc_best_inds), '-r')
            plot(timevect, zeros(size(timevect)), '-', 'Color', [0.5 0.5 0.5])
            axis([-Inf Inf minLE maxLE])
            ylabel('\bfLE [W m^{-2}]')
            box on
            
        subplot(3,2,4)
            hold on
            plot(LE_in(LEqc_best_inds), LE_eco_store(LEqc_best_inds), '.k', 'MarkerSize', 8)
            plot([minLE maxLE], [minLE maxLE], '-', 'Color', [0.5 0.5 0.5], 'LineWidth', 3)            
            plot([minLE, maxLE], pfLE(1)*[minLE, maxLE]+pfLE(2), '--g', 'LineWidth', 2)
            plot([minLE, maxLE], pfLE_day(1)*[minLE, maxLE]+pfLE_day(2), '--r', 'LineWidth', 2)            
            axis([minLE maxLE minLE maxLE])
            xlabel('\bfLE (Obs) [W m^{-2}]')
            ylabel('\bfLE (Mod) [W m^{-2}]')
            title(['\bfslope = ', num2str(pfLE(1)), '    int = ', num2str(pfLE(2))])
            box on
            
        subplot(3,2,5)
            hold on           
            plot(timevect(Hqc_best_inds), H_in(Hqc_best_inds), '.k', 'MarkerSize', 8)
            plot(timevect(Hqc_best_inds), H_eco_store(Hqc_best_inds), '-b')
            plot(timevect(Hqc_best_inds), H_soil_store(Hqc_best_inds), '-r')            
            plot(timevect, zeros(size(timevect)), '-', 'Color', [0.5 0.5 0.5])
            axis([-Inf Inf minH maxLE])
            ylabel('\bfH [W m^{-2}]')
            box on
            
        subplot(3,2,6)
            hold on       
            plot(H_in(Hqc_best_inds), H_eco_store(Hqc_best_inds), '.k', 'MarkerSize', 8)
            plot([minH maxH], [minH maxH], '-', 'Color', [0.5 0.5 0.5], 'LineWidth', 3)
            plot([minH, maxH], pfH(1)*[minH, maxH]+pfH(2), '--g', 'LineWidth', 2)
            plot([minH, maxH], pfH_day(1)*[minH, maxH]+pfH_day(2), '--r', 'LineWidth', 2)
            axis([minH maxLE minH maxLE])
            xlabel('\bfH (Obs) [W m^{-2}]')
            ylabel('\bfH (Mod) [W m^{-2}]')
            title(['\bfslope = ', num2str(pfH(1)), '    int = ', num2str(pfH(2))])
            box on
            
            
            