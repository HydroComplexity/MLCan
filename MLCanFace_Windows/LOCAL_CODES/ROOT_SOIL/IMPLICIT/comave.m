function [average] = comave(vector,zsoi,dzsoi,zisoi,nl_soil)

%=========================================================================
% This code computes a vector of size (n-1) with average of a vector 
% with size (n). In order to compute the average the function computes
% the weights using the dpeth of each layer.
%
% Written by Juan Camilo Quijano, UIUC, 2008
%
%------------------------- Input Variables -------------------------------
%       vector      % Raw vector of size n.
%       zsoi        % Vector with depth of midpoint of each layer [mm]
%       dzsoi       % Vector with Layer thicknesses information [mm]
%       zisoi       % Vector with depth of boundaries of layers [mm] 
%       nl_soil     % Number of layes
%
%------------------------- Output Variables ------------------------------
%       average     % Average of the vector. Has size of n-1
%
%-------------------------------------------------------------------------

average=zeros(nl_soil-1,1);
for i=1:1:nl_soil-1;
    average(i)=(vector(i)*(zisoi(i)-zsoi(i))+vector(i+1)*(zsoi(i+1)-zisoi(i)))/((zisoi(i)-zsoi(i))+(zsoi(i+1)-zisoi(i)));
end    
    
    
    
    
    