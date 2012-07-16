%=========================================================================
% This function solves Richards Equation using Finite Difference Fully 
% Implicit method. 
%
% Written by Juan Camilo Quijano, UIUC, 2008
% UIUC 
function [dwat,psicom,kf,klayer,ft,fb,ql] ...
                = soil(nl_soil,dtime,thetas,...
                            pentry,bpar,ks,zsoi,dzsoi,zisoi,...
                            thetai,eff_porosity,...
                            psiroot,krad,pthr)

pentry=-pentry;


%**********************************************************************
[psii, ki,thetai] = characteristic(thetai,thetas,ks,nl_soil,zsoi,dzsoi,zisoi,bpar,pentry,2);

%Compute the initial soil moisture and hydraulic conductivity
[thetai, ki,psii] = characteristic(psii,thetas,ks,nl_soil,zsoi,dzsoi,zisoi,bpar,pentry,1);
%Preallocate variables
criteria=10000; criteriamin=10000;
iteration=0; conver=0; type=1;
        while (criteria>2*10^(-1));
            iteration=iteration+1; if (iteration>30);break;end;   % Initalize the variables
            if iteration==1
                psiant=psii;thetaant=thetai;kant=ki;
                [Cant] = computec(psiant,thetas,nl_soil,bpar,pentry);                        
            else
                psiant=psicom; 
                [thetaant, kant,psiant] = characteristic(psiant,thetas,ks,nl_soil,zsoi,dzsoi,zisoi,bpar,pentry,1);
                [Cant] = computec(psiant,thetas,nl_soil,bpar,pentry);                        
            end
            ft=min(pthr,((eff_porosity(1)-thetaant(1))*dzsoi(1))/dtime );
            fb=ks(nl_soil)*(thetaant(nl_soil)/thetas(nl_soil))^(2*bpar(nl_soil)+3);
            if (type==1)     
                 [Am,KK,GG,CC,KKr] = matrices(nl_soil,Cant,kant,dzsoi,dtime,ft,fb,zsoi,krad);%Compute matrices                
                 psicom=(Am+CC+KKr)^(-1)*(-GG-KK+CC*psii+KKr*psiroot);
%                 psicom=(Am+CC+KKr)^(-1)*(-GG-KK+CC*psiant-(1/dtime)*(thetaant-thetai)+KKr*psiroot);
            end     
            if or(psicom(1)>pentry(1),type==2)
                 type=2;
                 [Am,KK,GG,CC,KKr] = matrices2(nl_soil,Cant,kant,dzsoi,dtime,pentry(1),fb,zsoi,krad);
                 psicom=(Am+CC+KKr)^(-1)*(-GG-KK+CC*psii(2:nl_soil))+KKr*psiroot(2:nl_soil);
%                psicom=(Am+CC+KKr)^(-1)*(-GG-KK+CC*psiant(2:nl_soil)-(1/dtime)*(thetaant(2:nl_soil)-thetai(2:nl_soil))+KKr*psiroot(2:nl_soil));
                 psicom=[pentry(1);psicom];
            end            
            criteria=max(abs((psicom-psiant))./abs(psicom));
            if criteria < criteriamin; psicoms=psicom; criteriamin=criteria;end
        end
 if iteration > 30
     psicom=psicoms;
 end    
[thetaf, kf,psicom] = characteristic(psicom,thetas,ks,nl_soil,zsoi,dzsoi,zisoi,bpar,pentry,1);
klayer=ks.*(thetaf./thetas).^(2*bpar+3);
[ql]=compflux(psicom,kf,ft,fb,dzsoi,nl_soil);
dwat=thetaf-thetai; 
