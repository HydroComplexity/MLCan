%-------------------------------------------------------------------------%
% Calculation of diurnal variables in specific months for Switchgrass.    %
% Created by: Phong Le                                                    %
% Date      : 03-07-2010                                                  %
%-------------------------------------------------------------------------% 

% CO2 Uptake
%[An_can_06,hour_06] = EXTRACT_VAR(168,181,hour,An_can_store);
[An_can_07,hour_07] = EXTRACT_VAR(182,212,hour,An_can_store);
[An_can_08,hour_08] = EXTRACT_VAR(213,243,hour,An_can_store);
%
%[SW_MON6_An_diurnal_can, SW_MON6_An_std_can] = DIURNAL_AVERAGE (hr, hour_06, An_can_06); 
[SW_MON7_An_diurnal_can, SW_MON7_An_std_can] = DIURNAL_AVERAGE (hr, hour_07, An_can_07); 
[SW_MON8_An_diurnal_can, SW_MON8_An_std_can] = DIURNAL_AVERAGE (hr, hour_08, An_can_08); 

%
% Latent Heat
%[LE_can_06,hour_06] = EXTRACT_VAR(168,181,hour,LE_can_store);
[LE_can_07,hour_07] = EXTRACT_VAR(182,212,hour,LE_can_store);
[LE_can_08,hour_08] = EXTRACT_VAR(213,243,hour,LE_can_store);
%
%[SW_MON6_LE_diurnal_can, SW_MON6_LE_std_can] = DIURNAL_AVERAGE (hr, hour_06, LE_can_06); 
[SW_MON7_LE_diurnal_can, SW_MON7_LE_std_can] = DIURNAL_AVERAGE (hr, hour_07, LE_can_07); 
[SW_MON8_LE_diurnal_can, SW_MON8_LE_std_can] = DIURNAL_AVERAGE (hr, hour_08, LE_can_08); 

%
% Sensible Heat
%[H_can_06,hour_06] = EXTRACT_VAR(168,181,hour,H_can_store);
[H_can_07,hour_07] = EXTRACT_VAR(182,212,hour,H_can_store);
[H_can_08,hour_08] = EXTRACT_VAR(213,243,hour,H_can_store);
%
%[SW_MON6_H_diurnal_can, SW_MON6_H_std_can] = DIURNAL_AVERAGE (hr, hour_06, H_can_06); 
[SW_MON7_H_diurnal_can, SW_MON7_H_std_can] = DIURNAL_AVERAGE (hr, hour_07, H_can_07); 
[SW_MON8_H_diurnal_can, SW_MON8_H_std_can] = DIURNAL_AVERAGE (hr, hour_08, H_can_08); 

%
% Ground Heat
%[G_can_06,hour_06] = EXTRACT_VAR(168,181,hour,H_can_store);
[G_can_07,hour_07] = EXTRACT_VAR(182,212,hour,H_can_store);
[G_can_08,hour_08] = EXTRACT_VAR(213,243,hour,H_can_store);
%
%[SW_MON6_G_diurnal_can, SW_MON6_G_std_can] = DIURNAL_AVERAGE (hr, hour_06, G_can_06); 
[SW_MON7_G_diurnal_can, SW_MON7_G_std_can] = DIURNAL_AVERAGE (hr, hour_07, G_can_07); 
[SW_MON8_G_diurnal_can, SW_MON8_G_std_can] = DIURNAL_AVERAGE (hr, hour_08, G_can_08); 
%
% Net Radiation
%[Rnrad_can_06,hour_06] = EXTRACT_VAR(168,181,hour,Rnrad_can_store);
[Rnrad_can_07,hour_07] = EXTRACT_VAR(182,212,hour,Rnrad_can_store);
[Rnrad_can_08,hour_08] = EXTRACT_VAR(213,243,hour,Rnrad_can_store);
%
%[SW_MON6_Rnrad_diurnal_can, SW_MON6_Rnrad_std_can] = DIURNAL_AVERAGE (hr, hour_06, Rnrad_can_06); 
[SW_MON7_Rnrad_diurnal_can, SW_MON7_Rnrad_std_can] = DIURNAL_AVERAGE (hr, hour_07, Rnrad_can_07); 
[SW_MON8_Rnrad_diurnal_can, SW_MON8_Rnrad_std_can] = DIURNAL_AVERAGE (hr, hour_08, Rnrad_can_08); 

save ('SW_Monthly_Variables','-regexp','^SW_MON');