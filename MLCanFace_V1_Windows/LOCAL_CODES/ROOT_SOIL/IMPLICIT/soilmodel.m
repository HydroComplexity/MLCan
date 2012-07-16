function [dwat,psicom,kf,kl,fluxt,fluxb,flux_s,mberrormm, type] ...
                = soilmodel(nl_soil, dtime, thetas, pentry, bpar, ks, ...
                            zsoi, dzsoi, zisoi, thetai, psiroot, krad, pthr)
                        
                        
%=========================================================================
% This function solves the implicit scheme for a given time step. In this
% function an iteratively solution is implemented
%
% Written by Juan Camilo Quijano, UIUC, 2008
%
%------------------------- Input Variables -------------------------------
%       nl_soil     % Number of layes
%       dtime       % Time step [s]
%       thetas      % Soil moisture at saturation 
%       thetadry    % Smallest values of soil moisture that may be reached
%       pentry      % minimum soil suction, i.e., soil potential at saturation [mm]
%       bpar        % Clapp-Hornbereger "b" parameter
%       ks          % Hydraulic conductivity at saturation [m/s]
%       zsoi        % Vector with depth of midpoint of each layer [mm]
%       dzsoi       % Vector with Layer thicknesses information [mm]
%       zisoi       % Vector with depth of boundaries of layers [mm] 
%       thetai      % Soil moisture in previous time step 
%       ki          % Hydraulic conductivity in previous time step [mm/s]
%       psirooti    % Root head in previous time step [mm] 
%       psidry      % Highest Soil matrix potential at dry conditions [mm]
%       krad        % Radial conductivities [1/s]
%       pthr        % Rainfall that reach the soil (Not intercepted). Flux [mm/s] 
%       fluxi_s     % Fluxes between layers in the soil in previous time step
%       fluxi_sr    % Fluxes between soil and roots in previous time step.
%       type        % Type of top boundary condition.
%                   Type = 1, flux boundary condition.
%                   Type = 2, head boundary condition, first layer saturated . 
%
%------------------------- Output Variables ------------------------------
%      dwat         % Change in soil moisture
%      psicom       % Soil matrix solution. [mm]
%      kf           % Hydraulic conductivity at solution. [mm/s]
%      fluxt        % Flux at the top. [mm/s]
%      fluxb        % Flux at the bottom. [mm/s]
%      flux_s       % Fluxes between soil layers. [mm/s]
%      flux_sr      % Fluxes between soil and roots at all layers [mm/s]
%      mberrormm    % Mass balance error [mm]
%
%-------------------------------------------------------------------------                        
%  Create vector to compute the flux boundary condition

    vec1=[1 10^(-1) 10^(-2) 10^(-3) 10^(-4)];
    vec2=(vec1(1:4)+vec1(2:5))/2;
    indf = (1:5)*2-1; 
    vecf(indf) = vec1;
    indf1 = (1:5)*2-1; 
    indf2 = (1:4)*2;
    vecf(indf1) = vec1;
    vecf(indf2) = vec2;
%-------------------------------------------------------------------------                        

    type=1;
    [psii, ki, kli, thetai] = characteristic(thetai,thetas,ks,nl_soil,zsoi,dzsoi,zisoi,bpar,pentry,2);

    for i=1:1:length(vecf)  
        criteria=10000; 
        criteriamin=10000;  
        iteration=0;
        
        while criteria>0.05*10^(-1);
            iteration=iteration+1; 
            if (iteration>20);
                break;
            end;   
            
            % Initalize the variables
            if iteration==1
                psiant=psii;thetaant=thetai;kant=ki;
                [Cant] = computec(psiant,thetas,nl_soil,bpar,pentry);                        
            else
                psiant=psicom; 
                [thetaant, kant, klant, psiant] = characteristic(psiant,thetas,ks,nl_soil,zsoi,dzsoi,zisoi,bpar,pentry,1);
                [Cant] = computec(psiant,thetas,nl_soil,bpar,pentry);                        
            end
           
            fb = ks(nl_soil)*(thetaant(nl_soil)/thetas(nl_soil))^(2*bpar(nl_soil)+3);
            ft = min([pthr*vecf(i) ks(1)]); 

            [Am,KK,GG,CC,KKr] = matrices(nl_soil,Cant,kant,dzsoi,dtime,ft,fb,zsoi,krad);% Compute matrices                
            psicom=(Am+CC+KKr)^(-1)*(GG+KK+CC*psiant-(1/dtime)*(thetaant-thetai)+KKr*psiroot);                  
             
            [thetaf, kf, kl, psicom] = characteristic(psicom,thetas,ks,nl_soil,zsoi,dzsoi,zisoi,bpar,pentry,1); 
            criteria=max(abs((psicom-psiant))./abs(psiant));
            
            if criteria < criteriamin
                psicoms=psicom;
                criteriamin=criteria;
            end
        end
        if iteration < 20
            if i > 1
                type = 3;
            end
            break
        end

end       
        if (iteration > 20)
            psicom=psicoms;
        end

        [thetaf, kf, kl, psicom] = characteristic(psicom,thetas,ks,nl_soil,zsoi,dzsoi,zisoi,bpar,pentry,1); 
        [flux_s,flux_sr,fluxt,fluxb,dwat,mberror,mberrormm] = compflux(psicom,psiroot,kf,krad,ft,fb,dzsoi,zsoi,nl_soil,type,thetai,thetaf,dtime);

    if (abs(mberrormm)>0.1)
        stop=2;
    end   
    if ((max(psicom-pentry)>=0) && (max(psicom(1)-pentry(1))<0))
        type=3;
    elseif (max(psicom(1)-pentry(1))>=0)
        type=2;       
    end
    
if type==2

      HB=0;
       criteria=10000; criteriamin=10000;  
        iteration=0;
        while criteria>0.05*10^(-1);
            iteration=iteration+1; 
            if (iteration>20);
                break;
            end;   % Initalize the variables
            if iteration==1
                [thetaant, kant, klant,psiant] = characteristic(psii,thetas,ks,nl_soil,zsoi,dzsoi,zisoi,bpar,pentry,1);
                psiant=psii;thetaant=thetai;kant=ki;
                [Cant] = computec(psiant,thetas,nl_soil,bpar,pentry);  
                [thetaant, kant, klant,psiant] = characteristic(psiant,thetas,ks,nl_soil,zsoi,dzsoi,zisoi,bpar,pentry,1);
            else
                psiant=psicom; 
                [thetaant, kant, klant,psiant] = characteristic(psiant,thetas,ks,nl_soil,zsoi,dzsoi,zisoi,bpar,pentry,1);
                [Cant] = computec(psiant,thetas,nl_soil,bpar,pentry);                        
            end
           
            fb=ks(nl_soil)*(thetaant(nl_soil)/thetas(nl_soil))^(2*bpar(nl_soil)+3);
            ft=0;
            [Am,KK,GG,CC,KKr] = matrices3(nl_soil,Cant,kant,klant,dzsoi,dtime,HB,fb,zsoi,krad);
%             psicom=(Am+CC+KKr)^(-1)*(-GG-KK+CC*psii(2:nl_soil))+KKr*psiroot(2:nl_soil);
             psicom=(Am+CC+KKr)^(-1)*(GG+KK+CC*psiant(1:nl_soil)-(1/dtime)*(thetaant(1:nl_soil)-thetai(1:nl_soil))+KKr*psiroot(1:nl_soil));
%             psicom=[HB;psicom];
                      
            [thetaf, kf,kl, psicom] = characteristic(psicom,thetas,ks,nl_soil,zsoi,dzsoi,zisoi,bpar,pentry,1); 
            criteria=max(abs((thetaf-thetaant))./abs(thetaant));
            if criteria < criteriamin
                psicoms=psicom;
                criteriamin=criteria;
            end
        end
        if (iteration > 20)
            psicom=psicoms;
        end
        
        [thetaf, kf, kl, psicom] = characteristic(psicom,thetas,ks,nl_soil,zsoi,dzsoi,zisoi,bpar,pentry,1); 
        [flux_s,flux_sr,fluxt,fluxb,dwat,mberror,mberrormm]=compflux(psicom,psiroot,kf,krad,ft,fb,dzsoi,zsoi,nl_soil,type,thetai,thetaf,dtime);

end

