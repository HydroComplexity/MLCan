subplot(1,2,1)
hold on;
%grid on;
%plot(LADnorm, znc./(2.5), 'bs-','LineWidth',1.5,'MarkerFaceColor','b');
plot(MG_LADnorm, znc_MG./(3.5), 'ko-','LineWidth',0.5);
plot(SW_LADnorm, znc_SW./(2), 'kd-','LineWidth',0.5,'MarkerFaceColor','k');
%legend('Miscanthus','Switchgrass');
%title('\bf Canopy LAD profile');
ylabel('z / h [-]')
xlabel('Normalized LAD Profile')
axis([0 Inf 0 1])


subplot(1,2,2)
hold on;
%grid on;
%plot(LADnorm, znc./(2.5), 'bs-','LineWidth',1.5,'MarkerFaceColor','b');
plot(MG_rootfr, -zns_MG./(1.2), 'ko-','LineWidth',0.5);
plot(SW_rootfr, -zns_SW./(1.2), 'kd-','LineWidth',0.5,'MarkerFaceColor','k');
legend('Miscanthus','Switchgrass');
%title('\bf Canopy LAD profile');
ylabel('z / h [-]')
xlabel('Normalized Root Fraction')

