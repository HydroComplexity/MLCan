close all

vl_mn = min( min(min(volliq_store)) );
vl_mx = max( max(max(volliq_store)) );
rpp_mn = min( min(min(rppMPA_store)) );
rpp_mx = max( max(max(rppMPA_store)) );
smp_mn = min( min(min(smpMPA_store)) );
smp_mx = max( max(max(smpMPA_store)) );

i = find(TR_can_store < 0);
TR_can_store(i) = 0;

TotalET = (TR_can_store+E_soil_store)*1800 + Evap_canopy;

%figure(1);
x_day = 145:5:185;
font_size = 14;
    subplot(4,1,1)
        bar(PPT_in);
        axis([0 2064 0 20]);
        ylabel('PPT [mm]','FontSize', font_size);
        set(gca,'XTick',(x_day-143)*48,'XTickLabel',x_day);
        set(gca,'FontSize', font_size,'TickLength',[0.003 0.003]);
        set(gca,'LineWidth',2);
        text(42*48, 22, '(a)', 'FontSize', font_size + 1);
        box on

    subplot(4,1,2)
        plot(Rg_in,'k');
        axis([0 2064 -100 1200]);
        ylabel('Rg [W m^{-2}]','FontSize', font_size);
        set(gca,'XTick',(x_day-143)*48,'XTickLabel',x_day);
        set(gca,'FontSize', font_size,'TickLength',[0.003 0.003]);
        set(gca,'LineWidth',2);
        text(42*48, 1300, '(b)', 'FontSize', font_size + 1);
        box on
        
    subplot(4,1,3)
        plot(TotalET*2);
        ylabel('ET [mm/h]','FontSize', font_size);
        axis([0 2064 0 1]);
        set(gca,'XTick',(x_day-143)*48,'XTickLabel',x_day);
        set(gca,'FontSize', font_size,'TickLength',[0.003 0.003]);
        set(gca,'FontSize', font_size);
        set(gca,'LineWidth',2);
        text(42*48, 1.1, '(c)', 'FontSize', font_size + 1);
        box on
        
    subplot(4,1,4)
        y_timevect = ones(length(timevect),1)*1.2;
        pcolor(timevect, -zns, volliq_store); hold on 
        colormap(flipdim(jet,1))
        caxis([vl_mn vl_mx])
        shading interp
        colorbar
        ylabel('z [m]','FontSize', font_size)
        title('\theta [m^3 m^{-3}]','FontSize', font_size)
        set(gca,'FontSize', font_size);
        set(gca,'LineWidth',2);
        plot(timevect,-y_timevect,'--','Color',[80 80 80]/255,'LineWidth',2);
        xlabel('Day of year');
        text(185, 0.3, '(d)', 'FontSize', font_size + 1);
        box on
