function [Conc] = ORDER_1_CLOSURE_ALL (Ca_in, z_in, dz, K_in, SS_in, soilf, ctz )
%
%:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::%
%%                              FUNCTION CODE                            %%
%%                           ORDER_1_CLOSURE_ALL                         %%
%:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::%
%   This function calculate the vertical distribution of air temperature, %
%   CO2, and water vapor concentrations through the canopy. Each variable %
%   is calculated by calling the function (change the input and output    %
%   of the function code only).                                           %
%                                                                         %
%   See Eqn (2,3,4,5) - Poggi et al, 2004                                 %
%   See Eqn (31) - Drewry et al, 2009. Part B- Online Supplement          %
%-------------------------------------------------------------------------%
%   PARAMETERS:                                                           %
%       CAz     = Variable need to be calculated      
%       z_in    = canopy interface height
%       dz      = 
%       K_in    = Eddy diffusivity (See Katul et al, 2004)                %
%       SS_in   = Source strength                                         %
%       soilf   = 
%       ctz     = Threshold to identify the index of canopy top (hcan)    %                                         
%-------------------------------------------------------------------------%
%   Date        : January 10, 2010                                        %
%% --------------------------------------------------------------------- %%
%%                                               
% Find index of canopy top
    ct_ind = 0;
    for ii = 1:length(z_in)
        if (ctz <= z_in(ii))
            ct_ind = ii;
            break;
        end
    end    
    if (ct_ind==0)
        ct_ind = length(z_in);
    end
    Ca  = Ca_in(1:ct_ind);
    K   = K_in(1:ct_ind);
    SS  = SS_in(1:ct_ind);
    z   = z_in(1:ct_ind);
    N   = ct_ind;    
%    
    cnt       = 1;
    err       = 10^6;
    epsilon   = 10^-2;
    max_iters = 20;
    while ((err > epsilon) & (cnt < max_iters))
    %
        if (cnt ~= 1)
            Ca_prev = Ca;
        end
    %    
        Conc    = Ca;
    %   Set up coefficients for ODE - Eqn (31) Drewry et al., 2009 - part B
        a1      = K;
        a2(2:N) = diff(K)./dz;
        a2(1)   = a2(2);
        a3      = 0*z;
        a4      = -SS;
    %
    %   Set the elements of the Tri-diagonal Matrix
        upd     = (a1./(dz*dz)+a2./(2*dz));
        dia     = (-a1.*2/(dz*dz)+a3);
        lod     = (a1./(dz*dz)-a2./(2*dz));                       
        co      = a4;
    %
        aa      = [];
        bb      = [];
        cc      = [];
        dd      = [];
    %
        aa      = lod;
        bb      = dia;
        cc      = upd;
        dd      = co;
    %
        aa(1)   = 0;
        bb(1)   = 1;
        cc(1)   = -1;
        dd(1)   = soilf*dz/(K(1)+0.00001);
    %
        aa(N)   = 0;
        bb(N)   = 1;
        cc(N)   = 0;
        dd(N)   = Ca(N);
    %
    %   Use the Thomas Algorithm to solve the tridiagonal matrix
        Cn      = TRIDIAG( N, aa, bb, cc, dd );
        Cn      = Cn(:);
    %
	%	Use successive relaxations in iterations
        eps1    = 0.5;
        Conc    = (eps1 * Cn + (1 - eps1) * Conc);
    %
        Ca = Conc;
    %
        if (cnt ~= 1)
            [err,maxind1] = max(abs(Ca - Ca_prev));   
        end      
    %    
        ee(cnt) = err;
    %    
        cnt     = cnt + 1;
    %            
    end
%    
    Conc(ct_ind+1:length(z_in)) = Conc(ct_ind);
%
    if (cnt >= max_iters)
        disp(['**** Closure Max Iters!!!']);
    end
%
%
%:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::%
%% <<<<<<<<<<<<<<<<<<<<<<<<< END OF FUNCTION >>>>>>>>>>>>>>>>>>>>>>>>>>>>%%
%:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::%
%