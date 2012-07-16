function [flux_s,flux_sr,ft,fb,dwat,mberror,mberrormm]=compflux(psicom,psiroot,kf,krad,ft,fb,dzsoi,zsoi,nl_soil, type,thetai,thetaf,dtime)

%=========================================================================
% This function computes the water fluxes between layers in the soil colum
% and also it computes the fluxes between the soil and the root.   
%  
%
% Written by Juan Camilo Quijano, UIUC, 2008
%
%------------------------- Input Variables -------------------------------
%       psicom      % Head Solution in each layer.
%       psiroot        % Vector with depth of midpoint of each layer [mm]
%       kf       % Vector with Layer thicknesses information [mm]
%       krad       % Vector with depth of boundaries of layers [mm] 
%       ft          % Number of layespsic
%       fb          % Flux top boundary condition 
%       dzsoi       % Vector with Layer thicknesses information [mm]
%       zisoi       % Vector with depth of boundaries of layers [mm] 
%       nl_soil     % Number of layes
%       type        % Type of top boundary condition.
%                   Type = 1, flux boundary condition.
%                   Type = 2, head boundary condition, first layer saturated .
%       thetai      % Soil moisture in previous time step
%       thetaf      % Solution of soil moisture in current time step
%       dtime       % Time step
%
%------------------------- Output Variables ------------------------------
%       average     % Average of the vector. Has size of n-1
%
%-------------------------------------------------------------------------

[den]=createden(nl_soil,zsoi);


for i=2:1:nl_soil
    flux_s(i)=-((psicom(i)-psicom(i-1))/(den(i-1)))*kf(i-1)+kf(i-1);    
    flux_s(nl_soil+1)=fb;
end
for i=1:1:nl_soil
    flux_sr(i)=(psicom(i)-psiroot(i))*krad(i);  
end

if type==2
    flux_s(1)=flux_s(2)+flux_sr(1)+(((thetaf(1)-thetai(1))*dzsoi(1))/dtime);
    ft=flux_s(1);
else
    flux_s(1)=ft;
end

flux_s=flux_s(:);
flux_sr=flux_sr(:);

dwat=thetaf-thetai; 

mberror=ft-sum(flux_sr)-fb-sum((thetaf-thetai).*dzsoi')/dtime; %Mass balance error in [mm/s]
mberrormm=mberror*dtime;