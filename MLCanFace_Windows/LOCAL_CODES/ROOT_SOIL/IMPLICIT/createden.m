function [den]=createden(nl_soil,zsoi)

% Compute the radial and axial conductivities of the roots
%-------------------------------------------------------------------------
% Root conductativities (both radial and axial) for each soil layer are
% obtained by weighting the conductivity of the root system by the root
% distribution within the layer. The effect of soil moisture on root
% conductivity is also taken into account.

% Written by Juan Camilo Quijano, UIUC, 2008
%
%------------------------- Input Variables -------------------------------
%       nl_soil     % Number of layers 
%       zsoi         % Vector with depth of midpoint of each layer [mm]
%
%------------------------- Output Variables ------------------------------
%       den        % Distance of nodes between layers.
%
%-------------------------------------------------------------------------


den=zeros(nl_soil-1,1);
for i=2:1:nl_soil;
    den(i-1)=zsoi(i)-zsoi(i-1);
end    