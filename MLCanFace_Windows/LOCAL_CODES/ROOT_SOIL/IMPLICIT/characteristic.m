function [vars, km, kl, var] = characteristic(var,thetas,ks,nl_soil,zsoi,dzsoi,zisoi,bpar,pentry,type)

%=========================================================================
% This function implemenes the characteristic function of Brooks and   
% Corey Model. With the matric pressure the characteristic function is 
% used to computed the soil moisture and hydraulic conductivity.
%
% Written by Juan Camilo Quijano, UIUC, 2008
%
%------------------------- Input Variables -------------------------------
%       var         % Comming variable. Matric Pressure.
%       thetas      % saturated soil moisture 
%       ks          % Hydraulic conductivity at saturation [m/s]
%       number      % Choose the type of characteristic function
%       nl_soil     % Number of layers in the soil        
%       zsoi        % Vector with depth of midpoint of each layer 
%       dzsoi       % Vector with Layer thicknesses information
%       zisoi       % Vector with depth of bounries of layers
%
%------------------------- Output Variables ------------------------------
%       vars        % Soil moisture for each layer
%       k           % Hydraulic conductivity for each layer
%
%-------------------------- Unit Conversions -----------------------------

%CASE BROOKS AND COREY TYPE II
% Constants for Brooks and Corey
if type==1; % compute theta based on psi
%   check theta is smaller than saturated
    varm=var;
    mc=(var>pentry); varm(mc)=pentry(mc);            
    vars=thetas.*(varm./pentry).^(-1./bpar);
    kl=ks.*((vars)./thetas).^(2.*bpar+3);          
    [varsP] = comave(vars,zsoi,dzsoi,zisoi,nl_soil);[bparP] = comave(bpar,zsoi,dzsoi,zisoi,nl_soil);  
    [thetasP] = comave(thetas,zsoi,dzsoi,zisoi,nl_soil);[ksP] = comave(ks,zsoi,dzsoi,zisoi,nl_soil);
    km=ksP.*((varsP)./thetasP).^(2.*bparP+3);   
elseif type ==2 % compute psi based on theta
% check psi is smaller than saturated    
%    mc=(var>thetas); var(mc)=thetas(mc);          
    vars=pentry.*(var./thetas).^(-bpar);
    kl=ks.*((var)./thetas).^(2.*bpar+3);                
    ind=(var==0);vars(ind)=thetas(ind); 
    [varP] = comave(var,zsoi,dzsoi,zisoi,nl_soil);[bparP] = comave(bpar,zsoi,dzsoi,zisoi,nl_soil);  
    [thetasP] = comave(thetas,zsoi,dzsoi,zisoi,nl_soil);[ksP] = comave(ks,zsoi,dzsoi,zisoi,nl_soil);
    km=ksP.*((varP)./thetasP).^(2.*bparP+3);            
end
        
        
        