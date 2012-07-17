function [A,KK,GG,CC,KKr] = matrices2(Ne,Ce,Ke,dz,dt,psi0,fb,zsoi,krad)

%=========================================================================
% This code computes the matrices that compose the linear system of the 
% fully implicit scheme. The matrices computed in this code are used to solve 
% richards equation with a head boundary condition at the top and a flux
% boundary condition at the bottom. In this case the top boundary condition
% is saturation in the first layer.
%
% Written by Juan Camilo Quijano, UIUC, 2008
%
%------------------------- Input Variables -------------------------------
%       Ne       % Number of layers
%       Ce       % Value of parameter C for each layer. Size (Ne x 1) 
%       ke       % Hydraulic conductivity in all the boundaries between layers
%                  Size (Ne-1 x 1)  [mm/s]
%       dz       % Thickness of each layer. Size (Ne x 1). [mm] 
%       dt       % time for the time step. [s] 
%       psi      % Top boundary condition. Head [mm] 
%       fb       % Flux boundary condition at the botoom. [mm/s]
%       zso      % Vector with depth of midpoint of each layer [mm]
%       krad     % Radial conductivities [1/s]
%
%------------------------- Output Variables ------------------------------
% This code gives as output the matrices A, KK, GG CC according to 
% equation   P'(A+CC)=(GG+KK+CC*P-(thn-th)/dt)
% where P' is matric pressure in new iteration, P is matric pressure in old iteration
% thn is soil moisture in old iteration th is soil moisture in the prior
% time step and dt is the time of each time step.
%
%-------------------------------------------------------------------------
N=Ne-1; % Size N of the matrices created 

[den]=createden(Ne,zsoi);


%FIRST VALUES
%Matrix A
A(1,1)=(1/(dz(2)))*(Ke(1)/den(1)+Ke(2)/den(2));
A(1,2)=-(1/(dz(2)))*(Ke(2)/den(2));



A(N,N)=(1/(dz(Ne)))*(Ke(Ne-1)/den(Ne-1));
A(N,N-1)=-(1/(dz(Ne)))*(Ke(Ne-1)/den(Ne-1));

%Vector CC
CC(1,1)=(Ce(2)/dt); 
CC(N,N)=(Ce(Ne)/dt);

%Vector GG
GG=zeros(N,1);
GG(1)=psi0*(1/(dz(2)))*(Ke(1)/den(1))-psi0*krad(1);
GG(N)=-fb/(dz(Ne));

%Vector KK
KK(1)=-(1/dz(2))*(Ke(2)-Ke(1)); 
KK(N,1)=(1/(dz(Ne)))*(Ke(Ne-1));
 
%THE REST FILLED WITH A LOOP
% The loop is row by row
for i=2:1:N-1;
    %Matrix A
    A(i,i-1)=-(1/(dz(i+1)))*(Ke(i)/den(i));     
    A(i,i+1)=-(1/(dz(i+1)))*(Ke(i+1)/den(i+1));   
    A(i,i)=(1/(dz(i+1)))*(Ke(i)/den(i)+Ke(i+1)/den(i+1));  
    %Vector KK
    KK(i,1)=-(1/(dz(i+1)))*(Ke(i+1)-Ke(i)); 
    %Vector CC
    CC(i,i)=(Ce(i+1)/dt);
end
krad=krad./dz';
KKr=diag(krad); 
KKr=KKr(2:Ne,2:Ne);