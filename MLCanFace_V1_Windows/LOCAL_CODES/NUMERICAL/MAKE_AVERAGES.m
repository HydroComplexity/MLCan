% CALCULATE DIURNAL AVERAGES
    hr = unique(hour);
    
    % Modeled Canopy States
    [Ci_diurnal_mod, Ci_std_mod] = DIURNAL_AVERAGE (hr, hour, Ci_mean);
    [Tl_diurnal_mod, Tl_std_mod] = DIURNAL_AVERAGE (hr, hour, Tl_mean);
    [gsv_diurnal_mod, gsv_std_mod] = DIURNAL_AVERAGE (hr, hour, gsv_mean);
    [psil_diurnal_mod, psil_std_mod] = DIURNAL_AVERAGE (hr, hour, psil_mean);
    [Sh2o_diurnal_mod, Sh2o_std_mod] = DIURNAL_AVERAGE (hr, hour, Sh2o_canopy);
    [Ch2o_diurnal_mod, Ch2o_std_mod] = DIURNAL_AVERAGE (hr, hour, Ch2o_canopy);
    
    % Modeled Ecosystem Fluxes
    [Fc_diurnal_eco, Fc_std_eco] = DIURNAL_AVERAGE (hr, hour, Fc_eco_store);
    [LE_diurnal_eco, LE_std_eco] = DIURNAL_AVERAGE (hr, hour, LE_eco_store);
    [H_diurnal_eco, H_std_eco] = DIURNAL_AVERAGE (hr, hour, H_eco_store);
    [Rn_diurnal_eco, Rn_std_eco] = DIURNAL_AVERAGE (hr, hour, Rnrad_eco_store);
    
    % Modeled Canopy Fluxes
    [An_diurnal_can, An_std_can] = DIURNAL_AVERAGE (hr, hour, An_can_store);
    [LE_diurnal_can, LE_std_can] = DIURNAL_AVERAGE (hr, hour, LE_can_store);
    [H_diurnal_can, H_std_can] = DIURNAL_AVERAGE (hr, hour, H_can_store);
    [Rn_diurnal_can, Rn_std_can] = DIURNAL_AVERAGE (hr, hour, Rnrad_can_store);
    [Evap_diurnal_mod, Evap_std_mod] = DIURNAL_AVERAGE (hr, hour, Evap_canopy);
    
    % Modeled Soil Fluxes
    [Fc_diurnal_soil, Fc_std_soil] = DIURNAL_AVERAGE (hr, hour, Fc_soil_store);
    [LE_diurnal_soil, LE_std_soil] = DIURNAL_AVERAGE (hr, hour, LE_soil_store);
    [H_diurnal_soil, H_std_soil] = DIURNAL_AVERAGE (hr, hour, H_soil_store);
    [Rn_diurnal_soil, Rn_std_soil] = DIURNAL_AVERAGE (hr, hour, Rnrad_soil_store);
    [G_diurnal_mod, G_std_mod] = DIURNAL_AVERAGE (hr, hour, G_store);    
    
% Mean Profiles
    for ii = 1:nl_can
        
    % Radiation
        [PARabs_sun_diurnal_prof(ii,:), PARabs_sun_std_prof(ii,:)] = DIURNAL_AVERAGE (hr, hour, PARabs_sun_prof(ii,:)');
        [PARabs_shade_diurnal_prof(ii,:), PARabs_shade_std_prof(ii,:)] = DIURNAL_AVERAGE (hr, hour, PARabs_shade_prof(ii,:)');
        [PARabs_canopy_diurnal_prof(ii,:), PARabs_canopy_std_prof(ii,:)] = DIURNAL_AVERAGE (hr, hour, PARabs_canopy_prof(ii,:)');
        
        [PARabs_sun_norm_diurnal_prof(ii,:), PARabs_sun_norm_std_prof(ii,:)] = DIURNAL_AVERAGE (hr, hour, PARabs_sun_norm_prof(ii,:)');
        [PARabs_shade_norm_diurnal_prof(ii,:), PARabs_shade_norm_std_prof(ii,:)] = DIURNAL_AVERAGE (hr, hour, PARabs_shade_norm_prof(ii,:)');
        [PARabs_canopy_norm_diurnal_prof(ii,:), PARabs_canopy_norm_std_prof(ii,:)] = DIURNAL_AVERAGE (hr, hour, PARabs_canopy_norm_prof(ii,:)');
        
        [NIRabs_sun_diurnal_prof(ii,:), NIRabs_sun_std_prof(ii,:)] = DIURNAL_AVERAGE (hr, hour, NIRabs_sun_prof(ii,:)');
        [NIRabs_shade_diurnal_prof(ii,:), NIRabs_shade_std_prof(ii,:)] = DIURNAL_AVERAGE (hr, hour, NIRabs_shade_prof(ii,:)');
        [NIRabs_canopy_diurnal_prof(ii,:), NIRabs_canopy_std_prof(ii,:)] = DIURNAL_AVERAGE (hr, hour, NIRabs_canopy_prof(ii,:)');
        
        [LWabs_can_diurnal_prof(ii,:), LWabs_can_std_prof(ii,:)] = DIURNAL_AVERAGE (hr, hour, LWabs_can_prof(ii,:)');
        [LWemit_can_diurnal_prof(ii,:), LWemit_can_std_prof(ii,:)] = DIURNAL_AVERAGE (hr, hour, LWemit_can_prof(ii,:)');
        
    % Fluxes
        [An_sun_diurnal_prof(ii,:), An_sun_std_prof(ii,:)] = DIURNAL_AVERAGE (hr, hour, An_sun_prof(ii,:)');
        [LE_sun_diurnal_prof(ii,:), LE_sun_std_prof(ii,:)] = DIURNAL_AVERAGE (hr, hour, LE_sun_prof(ii,:)');
        [H_sun_diurnal_prof(ii,:), H_sun_std_prof(ii,:)] = DIURNAL_AVERAGE (hr, hour, H_sun_prof(ii,:)');
        [Rnrad_sun_diurnal_prof(ii,:), Rnrad_sun_std_prof(ii,:)] = DIURNAL_AVERAGE (hr, hour, Rnrad_sun_prof(ii,:)');
        
        [An_shade_diurnal_prof(ii,:), An_shade_std_prof(ii,:)] = DIURNAL_AVERAGE (hr, hour, An_shade_prof(ii,:)');
        [LE_shade_diurnal_prof(ii,:), LE_shade_std_prof(ii,:)] = DIURNAL_AVERAGE (hr, hour, LE_shade_prof(ii,:)');
        [H_shade_diurnal_prof(ii,:), H_shade_std_prof(ii,:)] = DIURNAL_AVERAGE (hr, hour, H_shade_prof(ii,:)');
        [Rnrad_shade_diurnal_prof(ii,:), Rnrad_shade_std_prof(ii,:)] = DIURNAL_AVERAGE (hr, hour, Rnrad_shade_prof(ii,:)');
        
        [An_canopy_diurnal_prof(ii,:), An_canopy_std_prof(ii,:)] = DIURNAL_AVERAGE (hr, hour, An_canopy_prof(ii,:)');
        [LE_canopy_diurnal_prof(ii,:), LE_canopy_std_prof(ii,:)] = DIURNAL_AVERAGE (hr, hour, LE_canopy_prof(ii,:)');
        [H_canopy_diurnal_prof(ii,:), H_canopy_std_prof(ii,:)] = DIURNAL_AVERAGE (hr, hour, H_canopy_prof(ii,:)');
        [Rnrad_canopy_diurnal_prof(ii,:), Rnrad_canopy_std_prof(ii,:)] = DIURNAL_AVERAGE (hr, hour, Rnrad_canopy_prof(ii,:)');
        
        [An_sun_norm_diurnal_prof(ii,:), An_sun_std_prof(ii,:)] = DIURNAL_AVERAGE (hr, hour, An_sun_norm_prof(ii,:)');
        [An_shade_norm_diurnal_prof(ii,:), An_shade_std_prof(ii,:)] = DIURNAL_AVERAGE (hr, hour, An_shade_norm_prof(ii,:)');
        
     % Canopy States
        [Tl_sun_diurnal_prof(ii,:), Tl_sun_std_prof(ii,:)] = DIURNAL_AVERAGE (hr, hour, Tl_sun_prof(ii,:)');
        [gsv_sun_diurnal_prof(ii,:), gsv_sun_std_prof(ii,:)] = DIURNAL_AVERAGE (hr, hour, gsv_sun_prof(ii,:)');
        [gbv_sun_diurnal_prof(ii,:), gbv_sun_std_prof(ii,:)] = DIURNAL_AVERAGE (hr, hour, gbv_sun_prof(ii,:)');
        [Ci_sun_diurnal_prof(ii,:), Ci_sun_std_prof(ii,:)] = DIURNAL_AVERAGE (hr, hour, Ci_sun_prof(ii,:)');
        
        [Tl_shade_diurnal_prof(ii,:), Tl_shade_std_prof(ii,:)] = DIURNAL_AVERAGE (hr, hour, Tl_shade_prof(ii,:)');
        [gsv_shade_diurnal_prof(ii,:), gsv_shade_std_prof(ii,:)] = DIURNAL_AVERAGE (hr, hour, gsv_shade_prof(ii,:)');
        [gbv_shade_diurnal_prof(ii,:), gbv_shade_std_prof(ii,:)] = DIURNAL_AVERAGE (hr, hour, gbv_shade_prof(ii,:)');
        [Ci_shade_diurnal_prof(ii,:), Ci_shade_std_prof(ii,:)] = DIURNAL_AVERAGE (hr, hour, Ci_shade_prof(ii,:)');
        
        [Tl_canopy_diurnal_prof(ii,:), Tl_canopy_std_prof(ii,:)] = DIURNAL_AVERAGE (hr, hour, Tl_canopy_prof(ii,:)');
        [gsv_canopy_diurnal_prof(ii,:), gsv_canopy_std_prof(ii,:)] = DIURNAL_AVERAGE (hr, hour, gsv_canopy_prof(ii,:)');
        [gbv_canopy_diurnal_prof(ii,:), gbv_canopy_std_prof(ii,:)] = DIURNAL_AVERAGE (hr, hour, gbv_canopy_prof(ii,:)');
        [Ci_canopy_diurnal_prof(ii,:), Ci_canopy_std_prof(ii,:)] = DIURNAL_AVERAGE (hr, hour, Ci_canopy_prof(ii,:)');
        
        [Sh2o_canopy_diurnal_prof(ii,:), Sh2o_canopy_std_prof(ii,:)] = DIURNAL_AVERAGE (hr, hour, Sh2o_canopy_prof(ii,:)');
        [Ch2o_canopy_diurnal_prof(ii,:), Ch2o_canopy_std_prof(ii,:)] = DIURNAL_AVERAGE (hr, hour, Ch2o_canopy_prof(ii,:)');
        [dryfrac_diurnal_prof(ii,:), dryfrac_std_prof(ii,:)] = DIURNAL_AVERAGE (hr, hour, dryfrac_prof(ii,:)');
        [wetfrac_diurnal_prof(ii,:), wetfrac_std_prof(ii,:)] = DIURNAL_AVERAGE (hr, hour, wetfrac_prof(ii,:)');
                
     % Canopy Microenvironment
        [CAz_diurnal_prof(ii,:), CAz_std_prof(ii,:)] = DIURNAL_AVERAGE (hr, hour, CAz_prof(ii,:)');
        [TAz_diurnal_prof(ii,:), TAz_std_prof(ii,:)] = DIURNAL_AVERAGE (hr, hour, TAz_prof(ii,:)');
        [EAz_diurnal_prof(ii,:), EAz_std_prof(ii,:)] = DIURNAL_AVERAGE (hr, hour, EAz_prof(ii,:)');
        [Uz_diurnal_prof(ii,:), Uz_std_prof(ii,:)] = DIURNAL_AVERAGE (hr, hour, Uz_prof(ii,:)');
        
     % Tl-Ta   
        [TlmTa_sun_diurnal_prof(ii,:), TlmTa_sun_std_prof(ii,:)] = DIURNAL_AVERAGE (hr, hour, (Tl_sun_prof(ii,:)-TAz_prof(ii,:))');
        [TlmTa_shade_diurnal_prof(ii,:), TlmTa_shade_std_prof(ii,:)] = DIURNAL_AVERAGE (hr, hour, (Tl_shade_prof(ii,:)-TAz_prof(ii,:))');
        [TlmTa_canopy_diurnal_prof(ii,:), TlmTa_canopy_std_prof(ii,:)] = DIURNAL_AVERAGE (hr, hour, (Tl_canopy_prof(ii,:)-TAz_prof(ii,:))');
        
        
     % Sunlit / Shaded Fractions
        [fsun_diurnal_prof(ii,:), fsun_std_prof(ii,:)] = DIURNAL_AVERAGE (hr, hour, fsun_prof(ii,:)');
        [fshade_diurnal_prof(ii,:), fshade_std_prof(ii,:)] = DIURNAL_AVERAGE (hr, hour, fshade_prof(ii,:)');
    end
    
    

    