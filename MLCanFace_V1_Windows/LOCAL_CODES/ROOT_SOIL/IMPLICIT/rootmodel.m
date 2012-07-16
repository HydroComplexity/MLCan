
function [rpp] = rootmodel(nl_soil,nl_root,z,etr,smp,krad,kax)

%=========================================================================
% This code solves the model for water flow in the plant root system. 
% The upper boundary condition is set to the transpiration rate while 
% the lower boundary is set to no flux.
%
% Written by Geremew G. Amenu, UIUC, 2006
% All rights reserved!
%
%------------------------- Input Variables -------------------------------
%       nl_soil         % number of soil layers [-]
%       z               % layer depth [mm]
%       etr             % actual transpiration [mm/s]
%       smp             % soil matric potential [mm]
%       K_rad           % radial conductivity of the root system [s^-1]
%       K_axs           % axial specific conductivity of the root system [mm/s]
%
%------------------------- Output Variables ------------------------------
%       rpp             % root pressure potential [mm]
%                    
%-------------------------- local variables ------------------------------
%       amx             % "a" left off diagonal of tridiagonal matrix
%       bmx             % "b" diagonal column for tridiagonal matrix
%       cmx             % "c" right off diagonal tridiagonal matrix
%       dmx             % "d" forcing term of tridiagonal matrix
% 
%=========================================================================



% Setup the vectors 'a', 'b', 'c', and 'd' for tridiagonal matrix solution
%-------------------------------------------------------------------------


    % For the top soil layer
      j = 1;
      den    = z(j+1) - z(j);
      amx(j) = 0;
      bmx(j) = kax(j)/den + krad(j);
      cmx(j) = -kax(j)/den;
      dmx(j) = krad(j)*smp(j) - etr - kax(j);
    
    % For the middile soil layers
      for j = 2:nl_root - 1
          den1   = z(j) - z(j-1);
          den2   = z(j+1) - z(j);
          amx(j) = -kax(j-1)/den1;
          bmx(j) = kax(j-1)/den1 + kax(j)/den2 + krad(j);
          cmx(j) = -kax(j)/den2;
          dmx(j) = krad(j)*smp(j) + kax(j-1) - kax(j);
      end 
 
    % For the bottom soil layer
      j = nl_root;
      den    = z(j) - z(j-1);
      amx(j) = -kax(j-1)/den;
      bmx(j) = kax(j-1)/den + krad(j);
      cmx(j) = 0;
      dmx(j) = krad(j)*smp(j) + kax(j-1);


    % Solve for root pressure potential using tridiagonal matric solver
    rpp = tridia(nl_root ,amx ,bmx ,cmx ,dmx);
    if nl_soil > nl_root
       rpp(nl_root+1:nl_soil)= 0; 
    end
    rpp=rpp(:);

%**************************************************************************
%                 Check if all krad are zero

if max(krad)==0
   rpp=zeros(nl_soil,1);     
end
%================================ End ==================================

