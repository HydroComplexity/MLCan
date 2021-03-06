

% CANOPY AND ROOT STRUCTURE

    rootfr_norm = rootfr./dzsmm;
    rootfr_norm = rootfr_norm./(sum(rootfr_norm));
    figure(1); clf
        subplot(1,2,1)
            plot(LADnorm, znc./PARAMS.CanStruc.hcan, '.-')
            ylabel('z / h [-]')
            xlabel('Normalized LAD Profile')
            axis([0 Inf 0 1])
        subplot(1,2,2)
            plot(rootfr_norm, -zns, '.-')
            ylabel('z [m]')
            xlabel('Root Fraction')


