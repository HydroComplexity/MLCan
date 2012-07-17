function [rpp,      rpp_wgt,    krad,           kax,        dwat,       smp,    kboundary,  ...
          klayer,   smp_wgt,    thsatfrac_wgt,  qlayer,     layeruptake,mberrormm,  type] = ...
          ROOTSOIL(SWITCHES, VERTSTRUC, PARAMS, VARIABLES, CONSTANTS)

% De-reference Structure Values
    dtime       = CONSTANTS.dtime;
    zmm         = VERTSTRUC.znsmm;
    dzmm        = VERTSTRUC.dzsmm;
    zimm        = VERTSTRUC.zhsmm;
    nl_soil     = PARAMS.Soil.nl_soil; 
    
    if  VARIABLES.CANOPY.TR_total > 0 ;
        etr = VARIABLES.CANOPY.TR_total; 
    else  
        etr =0;
    end
    nl_root     = VERTSTRUC.nl_root;
    rootfr      = VERTSTRUC.rootfr; 
    roottr      = VERTSTRUC.roottr;
    rpp         = VARIABLES.ROOT.rpp;
    smp         = VARIABLES.SOIL.smp;    
    wliq        = VARIABLES.SOIL.volliq;
    effporsl    = VERTSTRUC.eff_poros;
    K_rad       = PARAMS.Soil.K_rad;
    K_axs       = PARAMS.Soil.K_axs;
    hr          = SWITCHES.HR_on;    
    rhc         = SWITCHES.rhc;
    phi0        = VERTSTRUC.psi0;
    bsw         = VERTSTRUC.bsw;
    hksati      = VERTSTRUC.HKsat;
    pthr        = VARIABLES.SOIL.qinfl;
  
    
%=========================================================================
% This code solves the model for water flow in the plant root system. 
% The upper boundary condition is set to the transpiration rate while 
% the lower boundary is set to no flux.
%
% Written by Juan Quijano, UIUC, 2009
% All rights reserved!
%
%------------------------- Input Variables -------------------------------
%       dtime           % time step [s]
%       zmm             % layer depth [mm]
%       dzmm            % layer thickness [mm]
%       zimm            % interface level below a "z" level [mm]
%       nl_soil         % number of soil layers [-]
%       etr             % actual transpiration [mm/s]
%       rootfr          % root fraction of a layer [-]
%       rpp             % root pressure potential [mm]
%       smp             % soil matric potential [mm]
%       wliq            % soil water per unit volume [mm/mm]
%       effporsl        % effective porosity of soil
%       K_rad           % radial conductivity of the root system [s^-1]
%       K_axs           % axial specific conductivity of the root system [mm/s]
%       hr              % option for hydraulic redistribution (0 1) [-]
%       rhc             % option for root hydraulic conductivity increasing with depth (0 1)[-]
%       phi0            % minimum soil suction, i.e., soil potential at saturation [mm]
%       bsw             % Clapp-Hornbereger "b" parameter [-]
%       hksati          % hydraulic conductivity at saturation [mm h2o/s]
%       pthr            % Precipitation that reach the soil.
%
%------------------------- Output Variables ------------------------------
%       rpp             % root pressure potential [mm]
%       rpp_wgt         % Wighted mean rpp over root uptake profile [mm] 
%       krad            % radial conductivity of the root [/s]
%       kax             % axial conductivity of the root [mm/s]
%       dwat            % Change in soil moisture
%       smp             % soil matric potential
%       hk              % soil hydraulic conductivity
%       smp_wgt         % % Weighted mean smp over root uptake profile [mm]
%       thsattrac_wgt   % Weighted mean soil saturation fraction over root uptake profile
%       qlayer          % Fluxes in each layer
%                    
%-------------------------- local variables ------------------------------
%       amx             % "a" left off diagonal of tridiagonal matrix
%       bmx             % "b" diagonal column for tridiagonal matrix
%       cmx             % "c" right off diagonal tridiagonal matrix
%       dmx             % "d" forcing term of tridiagonal matrix
% 
%========================================================================

    [krad,kax] = conductivities(nl_soil,zmm,dzmm,rootfr,roottr,rpp,smp,wliq,effporsl,K_rad,K_axs,1,rhc); 
    dif=10e10; 
    cnt=0;                              
    while (abs(dif) > 0.1)
        cnt = cnt+1;
        if (cnt>100);
            break;
        end
        [rpp] = rootmodel(nl_soil,nl_root,zmm,etr,smp,krad,kax);
                
        [krad,kax,etr,cnt1] = conductivities(nl_soil,   zmm,    dzmm,   rootfr, ...
                                            roottr,     rpp,    smp,    wliq,   ...
                                            effporsl,   K_rad,  K_axs,  hr,     ...
                                            rhc,        etr,    cnt); 

        [dwat,smp,kboundary,klayer,ft,fb,qlayer,mberrormm, type] ...
                 = soilmodel(nl_soil,dtime,effporsl,phi0,bsw,hksati,zmm',dzmm',zimm',wliq,rpp,krad,pthr);          
                                   
            
        [krad,kax,etr,cnt1] = conductivities(nl_soil,   zmm,    dzmm,   rootfr, ...
                                            roottr,     rpp,    smp,    wliq,   ...
                                            effporsl,   K_rad,  K_axs,  hr,     ...
                                            rhc,        etr,    cnt); 

        if (max(krad)==0) 
            dif=0;
        else
            dif=(abs(etr-sum(krad.*(smp-rpp)))/etr);
        end
    end
    
    if abs(rpp) > 1.0e+10
        sto = 3;
    end

    if max(rpp)>0
        sto = 9;
    end
   
    % Weighted mean smp over root uptake profile [mm]
    rpp_wgt = sum(rpp(:).*roottr/sum(roottr));% ;
    UPz = etr*rootfr;

    % Weighted mean smp over root uptake profile [mm]
    smp_wgt = sum(smp.*UPz/sum(UPz));% * mmH2OtoMPa;

    % Weighted mean soil saturation fraction over root uptake profile
    thsatfrac_wgt = sum((wliq./effporsl) .* UPz/sum(UPz));

    % Uptake by each layer
    layeruptake=krad.*(smp-rpp);

