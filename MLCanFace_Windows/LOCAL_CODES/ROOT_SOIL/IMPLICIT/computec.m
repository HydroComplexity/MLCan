function [C] = computec(vpsi,thetas,nl_soil,bpar,pentry);                        
%=========================================================================
% This code computes C which is defined as the rate of change of soil
% moisture with respect to soil matric pressure. The analytical solution
% of the derivative of Brooks and Corey equation is implemented.
%
% Written by Juan Camilo Quijano, UIUC, 2008
%
%------------------------- Input Variables -------------------------------
%       vpsi     % soil matric pressure
%       thetas   % saturated soil moisture
%       nl_soil  % number of layers  
%       bpar     % Clapp-Hornbereger "b" parameter
%       pentry   % minimum soil suction, i.e., soil potential at
%                   saturation [mm]
%
%------------------------- Output Variables ------------------------------
%       C        % variable C. Rate of change of soil moisture with respect
%                  to soil matric pressure.
%
%-------------------------------------------------------------------------

mc=vpsi>pentry;vpsi(mc)=pentry(mc);
C=thetas./pentry.*(-1./bpar).*(vpsi./pentry).^(-1./bpar-1);
       
        