% Store simulation results

LAIz = VERTSTRUC.LAIz;

% CANOPY VARIABLES
    % Radiation Absorption
        PARabs_sun_prof(:,tt) = PARabs_sun;                    %#ok<AGROW>
        PARabs_shade_prof(:,tt) = PARabs_shade;                %#ok<AGROW>
        PARabs_canopy_prof(:,tt) = PARabs_sun + PARabs_shade;  %#ok<AGROW>
                
        PARabs_sun_norm_prof(:,tt) = PARabs_sun./LAIz;                    %#ok<AGROW>
        PARabs_shade_norm_prof(:,tt) = PARabs_shade./LAIz;                %#ok<AGROW>
        PARabs_canopy_norm_prof(:,tt) = (PARabs_sun + PARabs_shade)./LAIz;  %#ok<AGROW>
                
        NIRabs_sun_prof(:,tt) = NIRabs_sun;                    %#ok<AGROW>
        NIRabs_shade_prof(:,tt) = NIRabs_shade;                %#ok<AGROW>
        NIRabs_canopy_prof(:,tt) = NIRabs_sun + NIRabs_shade;  %#ok<AGROW>
        
        NIRabs_sun_norm_prof(:,tt) = NIRabs_sun./LAIz;                    %#ok<AGROW>
        NIRabs_shade_norm_prof(:,tt) = NIRabs_shade./LAIz;                %#ok<AGROW>
        NIRabs_canopy_norm_prof(:,tt) = (NIRabs_sun + NIRabs_shade)./LAIz;  %#ok<AGROW>
        
        LWabs_can_prof(:,tt) = LWabs_can;                      %#ok<AGROW>
        LWemit_can_prof(:,tt) = LWemit_can;                    %#ok<AGROW>
        
        SWout_store(tt) = SWout;                                %#ok<AGROW>
        LWout_store(tt) = LWout;                                %#ok<AGROW>
        fdiff_store(tt) = fdiff;                                %#ok<AGROW>

    % Ecosystem Fluxes (Canopy + Soil)    
        Fc_eco_store(tt) = Fc_soil - An_can;                    %#ok<AGROW>
        LE_eco_store(tt) = LE_can + LE_soil;                    %#ok<AGROW> 
        H_eco_store(tt) = H_can + H_soil;                       %#ok<AGROW> 
        Rnrad_eco_store(tt) = Rnrad_eco;                        %#ok<AGROW>
        
    % Canopy Fluxes
        An_can_store(tt) = An_can;                              %#ok<AGROW>
        An_sun_2_store(tt) = An_sun_2;                                      %Phong added.
        An_shaded_store(tt) = An_shaded;                                    %Phong added.
        An_can_top_store(tt,1) = An_can_top;                                  %Phong added.
        LAI_sunlit_store(tt) = LAI_sunlit;                                  %Phong added.
        LAI_shaded_store(tt) = LAI_shaded;                                  %Phong added.
        gs_sun_2_store(tt)   = gs_sun_2;                                    %Phong added.
        LE_can_store(tt) = LE_can;                              %#ok<AGROW> 
        H_can_store(tt) = H_can;                                %#ok<AGROW>
        Rnrad_can_store(tt) = Rnrad_can;                        %#ok<AGROW>  
        TR_can_store(tt) = TR_can;                              %#ok<AGROW> 
                
    % Soil Fluxes
        Fc_soil_store(tt) = Fc_soil;                            %#ok<AGROW>
        H_soil_store(tt) = H_soil;                              %#ok<AGROW>
        LE_soil_store(tt) = LE_soil;                            %#ok<AGROW>
        G_store(tt) = G;                                        %#ok<AGROW>
        Rnrad_soil_store(tt) = Rnrad_soil;                      %#ok<AGROW>
        RH_soil_store(tt) = RH_soil;                            %#ok<AGROW>
        E_soil_store(tt) = E_soil;                              %#ok<AGROW>

        
% FLUXES:        
    % Flux Profiles
        An_sun_prof(:,tt) = An_sun.*LAI_sun;                   %#ok<AGROW>
        LE_sun_prof(:,tt) = LE_sun.*LAI_sun;                   %#ok<AGROW>
        H_sun_prof(:,tt) = H_sun.*LAI_sun;                     %#ok<AGROW>
        Rnrad_sun_prof(:,tt) = Rnrad_sun;                      %#ok<AGROW>

        An_shade_prof(:,tt) = An_shade.*LAI_shade;             %#ok<AGROW>
        LE_shade_prof(:,tt) = LE_shade.*LAI_shade;             %#ok<AGROW>
        H_shade_prof(:,tt) = H_shade.*LAI_shade;               %#ok<AGROW>
        Rnrad_shade_prof(:,tt) = Rnrad_shade;                  %#ok<AGROW>
        
    % Mean Flux Profiles
        An_canopy_prof(:,tt) = An_sun_prof(:,tt) + An_shade_prof(:,tt);  %#ok<AGROW>
        LE_canopy_prof(:,tt) = LE_sun_prof(:,tt) + LE_shade_prof(:,tt);  %#ok<AGROW>
        H_canopy_prof(:,tt) = H_sun_prof(:,tt) + H_shade_prof(:,tt);     %#ok<AGROW>
        Rnrad_canopy_prof(:,tt) = Rnrad_sun_prof(:,tt) + Rnrad_shade_prof(:,tt);     %#ok<AGROW>    
        
    % Normalized Flux Profiles (ie. per unit LAI)    
    %   Sunlit
        An_sun_norm_prof(:,tt) = An_sun;
        LE_sun_norm_prof(:,tt) = LE_sun;
        H_sun_norm_prof(:,tt) = H_sun;
        Rnrad_sun_norm_prof(:,tt) = Rnrad_sun./LAI_sun;
        
    %   Shaded
        An_shade_norm_prof(:,tt) = An_shade;
        LE_shade_norm_prof(:,tt) = LE_shade;  
        H_shade_norm_prof(:,tt) = H_shade;
        Rnrad_shade_norm_prof(:,tt) = Rnrad_shade./LAI_shade;
        
    %   Canopy
        An_canopy_norm_prof(:,tt) = An_sun.*fsun + An_shade.*fshade;
        LE_canopy_norm_prof(:,tt) = LE_sun.*fsun + LE_shade.*fshade;  
        H_canopy_norm_prof(:,tt) = H_sun.*fsun + H_shade.*fshade;
        Rnrad_canopy_norm_prof(:,tt) = (Rnrad_sun./LAI_sun).*fsun + (Rnrad_shade./LAI_shade).*fshade;
    
        
% CANOPY STATES:        
    % Leaf States
        Tl_sun_prof(:,tt) = Tl_sun;                            %#ok<AGROW>
        Tl_shade_prof(:,tt) = Tl_shade;                        %#ok<AGROW>
        Tl_sun_Ta_Diff(:,tt) = Tl_sun - TAz;                    %#ok<AGROW>
        Tl_shade_Ta_Diff(:,tt) = Tl_shade - TAz;                %#ok<AGROW>
        
        psil_sun_prof(:,tt) = psil_sun;                        %#ok<AGROW>
        psil_shade_prof(:,tt) = psil_shade;                    %#ok<AGROW>
        
        fsv_sun_prof(:,tt) = fsv_sun;                          %#ok<AGROW>
        fsv_shade_prof(:,tt) = fsv_shade;                      %#ok<AGROW>
        
        gsv_sun_prof(:,tt) = gsv_sun;                          %#ok<AGROW>
        gsv_shade_prof(:,tt) = gsv_shade;                      %#ok<AGROW>
        
        Ci_sun_prof(:,tt) = Ci_sun;                            %#ok<AGROW>
        Ci_shade_prof(:,tt) = Ci_shade;                        %#ok<AGROW>
        
        gbv_sun_prof(:,tt) = gbv_sun;                          %#ok<AGROW>
        gbh_sun_prof(:,tt) = gbh_sun;                          %#ok<AGROW>
        gbv_shade_prof(:,tt) = gbv_shade;                      %#ok<AGROW>
        gbh_shade_prof(:,tt) = gbh_shade;                      %#ok<AGROW>

        LAI_sun_prof(:,tt) = LAI_sun;                          %#ok<AGROW>
        LAI_shade_prof(:,tt) = LAI_shade;                      %#ok<AGROW>
        fsun_prof(:,tt) = fsun;                                %#ok<AGROW>
        fshade_prof(:,tt) = fshade;                            %#ok<AGROW>
        dryfrac_prof(:,tt) = dryfrac;                          %#ok<AGROW>
        wetfrac_prof(:,tt) = wetfrac;                          %#ok<AGROW>
                
        ppt_ground_store(tt) = ppt_ground;                      %#ok<AGROW>
        qinfl_store(tt) = qinfl;                                %#ok<AGROW>
        mberrormm_store(tt) = mberrormm;
        mberrormm1_store(tt) = mberrormm1;
        mberrormm2_store(tt) = mberrormm2;
    % Mean Canopy Profiles    
        Ci_canopy_prof(:,tt) = Ci_sun.*fsun + Ci_shade.*fshade;        %#ok<AGROW>
        Tl_canopy_prof(:,tt) = Tl_sun.*fsun + Tl_shade.*fshade;        %#ok<AGROW>
        gsv_canopy_prof(:,tt) = gsv_sun.*fsun + gsv_shade.*fshade;     %#ok<AGROW>
        psil_canopy_prof(:,tt) = psil_sun.*fsun + psil_shade.*fshade;  %#ok<AGROW>
        fsv_canopy_prof(:,tt) = fsv_sun.*fsun + fsv_shade.*fshade;     %#ok<AGROW>
        gbv_canopy_prof(:,tt) = gbv_sun.*fsun + gbv_shade.*fshade;     %#ok<AGROW>
        gbh_canopy_prof(:,tt) = gbh_sun.*fsun + gbh_shade.*fshade;     %#ok<AGROW>    
                
    % Mean Canopy States
        Ci_mean(tt) = sum(Ci_canopy_prof(vinds,tt).*LADnorm(vinds))/sum(LADnorm);
        Tl_mean(tt) = sum(Tl_canopy_prof(vinds,tt).*LADnorm(vinds))/sum(LADnorm);
        gsv_mean(tt) = sum(gsv_canopy_prof(vinds,tt).*LADnorm(vinds))/sum(LADnorm);
        psil_mean(tt) = sum(psil_canopy_prof(vinds,tt).*LADnorm(vinds))/sum(LADnorm);
        fsv_mean(tt) = sum(fsv_canopy_prof(vinds,tt).*LADnorm(vinds))/sum(LADnorm);

    % Canopy Microenvironment
        CAz_prof(:,tt) = CAz;                                       %#ok<AGROW>
        TAz_prof(:,tt) = TAz;                                       %#ok<AGROW>
        EAz_prof(:,tt) = EAz;                                       %#ok<AGROW>
        Uz_prof(:,tt) = Uz;                                         %#ok<AGROW>
        
        
    % Canopy H2O Storage
        Sh2o_canopy_prof(:,tt) = Sh2o_prof; % [mm H2O]                  %#ok<AGROW>
        Sh2o_canopy(tt) = Sh2o_can;                                     %#ok<AGROW>
        
    % Condensation
        Ch2o_canopy_prof(:,tt) = Ch2o_prof; % [mm H2O]                  %#ok<AGROW>  
        Ch2o_canopy(tt) = Ch2o_can; % [mm H2O]                          %#ok<AGROW>
        
    % Evaporation
        Evap_canopy_prof(:,tt) = Evap_prof; % [mm H2O]                  %#ok<AGROW>
        Evap_canopy(tt) = Evap_can; % [mm H2O]                          %#ok<AGROW>
        
        
% SOIL VARIABLES
    q_over_store(:,tt) = q_over;
    qthrough_store(tt) = qthrough;
    
    volliq_store(:,tt) = volliq;    
    dwat_store(:,tt) = dwat;
    krad_store(:,tt) = krad;
    hk_store(:,tt) = hk;
    smp_store(:,tt) = smp;
    rpp_store(:,tt) = rpp;
    
    smpMPA_store(:,tt) = smp*CONSTANTS.mmH2OtoMPa;
    rppMPA_store(:,tt) = rpp*CONSTANTS.mmH2OtoMPa;
    
    smp_weight_store(tt) = smp_wgt*CONSTANTS.mmH2OtoMPa;
    rpp_weight_store(tt) = rpp_wgt*CONSTANTS.mmH2OtoMPa;   
    
    qout_layer(:,tt) = qlayer;
    
    if (SWITCHES.soilheat_on)
        Ts_store(:,tt) = Ts;
    end

        
        
    