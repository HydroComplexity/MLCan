% Initialize Storage Vectors for Nutrient Variables
% Set Parameter Values


%=========================================
% PARAMETERS
    a_Amm = 0.05;       % [-]
    a_Nit = 1;          % [-]
    DEMp = 0.2;         % [gN / m^3 / d]
    DEMm = 0.5;         % [gN / m^3 / d]
    kd = 8.5*10^-3;     % [d^-1]
    kl = 6.5*10^-5;     % [m^3 / d / gC]
    kh = 2.5*10^-6;     % [m^3 / d / g?]
    kn = 0.6/100;       % [m^3 / d / gC]
    ki_Amm = 1;         % [m^3 / d / gC]
    ki_Nit = 1;         % [m^3 / d / gC]
    ku_Amm = 0.1;
    ku_Nit = 0.1;
        
    rhmin = 0.25;
    rr = 0.6;
        
% Constant flux of plant residues
    CNa = 50;
    ADD = 1.5;      % [gC/m^2/d]

    
Ts_reduc_on = 0;
Ts_max = 0;
leach_on = 1;
%=========================================
    
    
% Initialize Soil States: Table 2 of (D'Odorico et al)
    
    CNb = 11.5;
    CNh = 22;
    CNl = 40*ones(nl_soil,1);
        
    Cl = 1000*ones(nl_soil,1);
    Ch = 8000*ones(nl_soil,1);
    Cb = 50*ones(nl_soil,1);
    Nl = Cl./CNl;
    Amm = 0.002*ones(nl_soil,1);
    Nit = 0.4*ones(nl_soil,1);
    
    
% Initialize Storage Vectors
Cl_store = NaN(nl_soil,N);
Ch_store = NaN(nl_soil,N);
Cb_store = NaN(nl_soil,N);
Nl_store = NaN(nl_soil,N);
Amm_store = NaN(nl_soil,N);
Nit_store = NaN(nl_soil,N);
CNl_store = NaN(nl_soil,N);
UPamm_store = NaN(nl_soil,N);
UPnit_store = NaN(nl_soil,N);
LCHamm_store = NaN(nl_soil,N);
LCHnit_store = NaN(nl_soil,N);



