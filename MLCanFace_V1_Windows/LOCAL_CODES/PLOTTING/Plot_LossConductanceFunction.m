
sf = PARAMS.StomCond.sf;
psif = PARAMS.StomCond.psif;


psil_all=[]; fsv_all=[];
psil_all = [-3:0.1:0];  % [MPa]
for ii = 1:length(psil_all)

        psil = psil_all(ii);

        [fsv_all(ii)] = Tuzet_Function (sf, psif, psil);

end
    
% Plot loss of hydraulic conductivity vs leaf pressure potential
figure(fignum)
    plot(psil_all, fsv_all, '-k', 'LineWidth', 2)
    xlabel('\bf \Psi_l [MPa]', 'FontSize', 12)
    ylabel('\bf Fraction Conductivity', 'FontSize', 12)
    axis([psil_all(1) 0 0 1])
    box on
