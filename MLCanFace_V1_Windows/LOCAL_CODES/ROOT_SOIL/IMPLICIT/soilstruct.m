
%==========================  SOIL DISCRETIZATION =============================

stp.nl_soil = 12;       % number of soil layers [-]


%stp.zmm(1,1)=0.1;stp.zmm(2,1)=0.2;stp.zmm(3,1)=0.4;stp.zmm(4,1)=0.6;
%for j = 5:1:18
%    stp.zmm(j) =stp.zmm(j-1)+0.5;  %node depths   
%end

scalez  = 0.025;%0.0001;%0.01;%0.025;    % scale for soil layer thickness discretization [-]
scalez2 = 0.5;
%Soil layer node depths, i.e., depth of layer center from surface [m]
 stp.zmm(1) =scalez*(exp(scalez2*(1-scalez2))-1);  %node depth
 for j = 2:1:stp.nl_soil
       stp.zmm(j) =scalez*(exp(scalez2*(j-scalez2))-1);  %node depths
 end
 
 
stp.zmm=stp.zmm*1000;
% Soil layer thicknesses 
stp.dzmm(1,1)  = 0.5*(stp.zmm(1)+stp.zmm(2));        
stp.dzmm(stp.nl_soil,1)= stp.zmm(stp.nl_soil)-stp.zmm(stp.nl_soil-1);
for j = 2:stp.nl_soil-1
    stp.dzmm(j,1)= 0.5*(stp.zmm(j+1)-stp.zmm(j-1));   
end

% Soil layer interface depths from the surface [m]
stp.zimm(stp.nl_soil,1) = stp.zmm(stp.nl_soil) + 0.5*stp.dzmm(stp.nl_soil);
for j = 1:stp.nl_soil-1
    stp.zimm(j,1)= 0.5*(stp.zmm(j)+stp.zmm(j+1));      
end

