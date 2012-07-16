function [U, Km, tau] = ORDER_1_CLOSURE_U(FORCING, VERTSTRUC, PARAMS)
%
%:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::%
%%                              FUNCTION CODE                            %%
%%                            ORDER_1_CLOSURE_U                          %%
%:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::%
%   This function calculate the wind profile (attenuation) in the presence%
%   of an extensive and dense canopy.                                     %
%   Numerical method is used to solve the ODE until error < epsilon       %
%   Thomas algorithm-TDMA (function file TRIDIAG written by Amenu in      %
%   folder NUMERICAL) is used to solve the Tri-diagonal matrix            % 
%                                                                         %
%   See Eqn (5) - Poggi et al, 2004                                       %
%   See Eqn (28,29,30) - Drewry et al, 2009. Part B- Online Supplement    %
%-------------------------------------------------------------------------%
%   PARAMETERS:                                                           %
%       Cd      = Drag coefficient                                        %                                         
%       LAD     = Leaf area density                                       %
%       Km      = Eddy diffusivity (See Katul et al, 2004)                %
%       l_mix   = Mixing length through the depth of a dense canopy       %         
%-------------------------------------------------------------------------%
%   Created by  : Darren Drewry                                           %
%   Editted by  : Phong Le                                                %
%   Date        : December 25, 2009                                       %
%% --------------------------------------------------------------------- %%  
%
%
%*************************************************************************%
%% <<<<<<<<<<<<<<<<<<<<<<<<< DE-REFERENCE BLOCK >>>>>>>>>>>>>>>>>>>>>>>> %%
%*************************************************************************%
%
	Utop    = FORCING.U;    
%
    LAD     = VERTSTRUC.LADz;
    znc     = VERTSTRUC.znc;
    dzc     = VERTSTRUC.dzc;
%    
    hcan    = PARAMS.CanStruc.hcan;
    Cd      = PARAMS.MicroEnv.Cd;
    alph    = PARAMS.MicroEnv.alph;
%    
%*************************************************************************%
%% <<<<<<<<<<<<<<<<<<<<<<<<END OF DE-REFERENCE BLOCK >>>>>>>>>>>>>>>>>>> %%
%*************************************************************************%
%% 
% Mixing Length
    l_mix   = alph * hcan;

    z       = [0, znc];
    Ulow    = 0;

    N       = length(z);
    U       = linspace (Ulow, Utop, N);
    LAD     = [0; LAD(:)];
    LAD     = LAD';
%
% Start iterative solution
    err     = 10^9;
    epsilon = 10^-2;
    while err > epsilon
    %---dU/dz
        y       = [];
        dU      = [];
        y(2:N)  = diff(U) ./ dzc;
        y(1)    = y(2);
        dU      = y;
    %
    %---Add model for diffusivity (Km)
        Km      = ( (l_mix).^2) .* abs(y);                                  % Eqn 29 - Drewry et al, 2009. Part B- Online Supplement.
        tau     = -Km.*y;
    %
    %---Set up coefficients for ODE in Eqn 28 
        a1      = -Km;
        a2(2:N) = -diff(Km) ./ dzc;
        a2(1)   = a2(2);
        a3      = 0.5 * Cd * LAD .* U;
        dx      = dzc;
    %
    %--- Set the elements of the Tri-diagonal Matrix
        upd     = (a1 ./ (dx * dx) + a2 ./ (2 * dx));
        dia     = (-a1 .* 2 / (dx * dx) + a3);
        lod     = (a1 ./ (dx * dx)-a2./(2 * dx));
        co      = ones(1,N)*0;
        aa      = [];
        bb      = [];
        cc      = [];
        dd      = [];
        co(1)   = Ulow;
        co(N)   = Utop;
        aa      = lod;
        bb      = dia;
        cc      = upd;
        dd      = co;
        aa(1)   = 0;
        aa(N)   = 0;
        cc(1)   = 0;
        cc(N)   = 0;
        bb(1)   = 1;
        bb(N)   = 1;
    %
    %---Use the Thomas Algorithm to solve the tridiagonal matrix
        Un      = TRIDIAG(N,aa,bb,cc,dd);
        err     = max( abs(Un - U) );
    %
    %---Use successive relaxations in iterations
        eps1    = 0.5;
        U       = (eps1 * Un + (1 - eps1) * U);
    
    end
%
% Remove added bottom node for surface no-slip
    U = U(2:end);
    U = U(:);
%
%
%:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::%
%% <<<<<<<<<<<<<<<<<<<<<<<<< END OF FUNCTION >>>>>>>>>>>>>>>>>>>>>>>>>>>>%%
%:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::%
