function [fdiff] = DIFFUSE_FRACTION (zendeg, doy, SWdn)
%
%:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::%
%%                             FUNCTION CODE                             %%
%%                    CALCULATE THE DIFFUSE FRACTION                     %%
%:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::%
%   This function implements the algorithm of Spitters et al (1986)-      %
%   - part 1 to calculate the  diffuse fraction of short wave radiation   %
%   from incident global shortwave, and the theoretical incident          %
%   extra-terrestrial shortwave                                           %       
%-------------------------------------------------------------------------%
%   Created by  : Darren Drewry                                           %
%   Editted by  : Phong Le                                                %
%   Date        : January 12, 2010                                        %
%-------------------------------------------------------------------------%
%                                                                         %
%   PARAMETERS:                                                           %
%       Scs     = Solar constant                                [J/m^2/s] %
%       solelev = Solar elevation beta - Eqn (15)               [-]       %         
%                 (or Angle of sun above horizon)                         %
%       So      = Extra-terrestrial irradiance on a plane                 %
%                   parallel to the earth surface               [J/m^2/s] %
%       doy     = refer to the day since January 1st                      %                        
%       R, K    = Parameters in the regression of diffuse                 %
%                   share on transmission                                 %                                   
%% --------------------------------------------------------------------- %%
%%
%
	dinds       = find(zendeg<90);
    ninds       = find(zendeg>=90);
%
    Scs         = 1370;                         % [J/m^2/s] Solar Constant
    solelev     = (90 - zendeg) * pi/180;
    So          = Scs.*(1+0.033*cos((360*doy/365)*pi/180)) .* sin(solelev); % Eqn (1)
%
    So(ninds)   = NaN;
%
    Sg_o_So     = SWdn./So;                                                 % Eqn (3)
%
    % Fraction Diffuse
    sinbeta     = sin(solelev);
    R           = 0.847 - 1.61 * sinbeta + 1.04 * sinbeta .^ 2;             % Eqn (20) - after 20d
    K           = (1.47 - R) ./ 1.66;                                       % Eqn (20) - after 20d
%
    i1          = find(Sg_o_So <= 0.22);                        
    fdiff(i1)   = 1;                                                        % Eqn (20a)
    i2          = find(Sg_o_So > 0.22 & Sg_o_So <= 0.35);
    fdiff(i2)   = 1 - 6.4*(Sg_o_So(i2) - 0.22).^2;                          % Eqn (20b)
    i3          = find(Sg_o_So > 0.35 & Sg_o_So <= K);
    fdiff(i3)   = 1.47 - 1.66*Sg_o_So(i3);                                  % Eqn (20c)
    i4          = find(Sg_o_So > K);
    fdiff(i4)   = R(i4);                                                    % Eqn (20d)
%
%
%:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::%
%% <<<<<<<<<<<<<<<<<<<<<<<<< END OF FUNCTION >>>>>>>>>>>>>>>>>>>>>>>>>>>>%%
%:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::%
%
    