function [znode_all, dz_all, zlayer_all, nl_soil] = SOILGRID_EQN (PARAMS)

%:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::%
%%                             FUNCTION CODE                             %%
%%                       CONSTRUCT THE SOIL GRID                         %%
%:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::%
%-------------------------------------------------------------------------%
%   This function constructs the soil grid, with 0.1m grid spacing down   %
%   to 1m depth, and 0.5 meter spacing below that, down to the specified  %
%   maxdepth                                                              %
%                                                                         %
%   INPUTS:                                                               %
%       dzs 	= Layer spacings [m]                                      %
%       depths 	= Depth of soil column to grid for each layer             %
%                   spacing (dzs) [m] --> sum(depths) = total depth       %
%                   of soil column                                        %
%                                                                         %
%   OUTPUTS:                                                              %
%       znode   - node depths (center of layers)     [m]                  %
%       dznode  - layer thicknesses                  [m]                  %
%       zlayer  - depths of soil layer interfaces    [m]                  %
%       nl_soil - number of soil layers              [-]                  %
%                                                                         %
%-------------------------------------------------------------------------%
%   Created by  : Darren Drewry                                           %
%   Date        : January 01, 2008                                        %
%   Editted by  : Phong Le                                                %
%   Date        : December 23, 2009                                       %
%% --------------------------------------------------------------------- %%  
%
%
%*************************************************************************%
%% <<<<<<<<<<<<<<<<<<<<<<<<< DE-REFERENCE BLOCK >>>>>>>>>>>>>>>>>>>>>>>> %%
%*************************************************************************%
%
    dzs     = PARAMS.Soil.dzs;
    depths  = PARAMS.Soil.depths;
%    
%*************************************************************************%
%% <<<<<<<<<<<<<<<<<<<<<<<<END OF DE-REFERENCE BLOCK >>>>>>>>>>>>>>>>>>> %%
%*************************************************************************%
%% 
    if (length(dzs) ~= length(depths))		% Check the consistency	  %
        disp('*** ERROR: ''dzs'' and ''depths'' must have same length!');
        return;
    end
%
%    
    % Construct Grid
    zl = 0;
    znode_all=[]; dz_all=[]; zlayer_all=[];
    for ii = 1:length(dzs)
        znode   = []; 
        dz      = []; 
        zlayer  = [];
    %  
        dzii    = dzs(ii);
        depthii = depths(ii);
    %    
        znode   = linspace(dzii/2, depthii, (depthii-dzii)/dzii+1);
        dz      = ones(1,length(znode))*dzii;
        zlayer  = znode + dz/2;
    %    
        if (ii==1)
            znode_all   = [znode_all, znode];
            zlayer_all  = [zlayer_all, zlayer];
        else
            znode_all   = [znode_all, znode+zlayer_all(end)];
            zlayer_all  = [zlayer_all, zlayer+zlayer_all(end)];
        end
        dz_all  = [dz_all, dz];    
    end
%    
    nl_soil     = length(zlayer_all);
%
%    
    % Make Column Vectors
    znode_all   = znode_all(:);
    dz_all      = dz_all(:);
    zlayer_all  = zlayer_all(:);
%
%
%:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::%
%% <<<<<<<<<<<<<<<<<<<<<<<<< END OF FUNCTION >>>>>>>>>>>>>>>>>>>>>>>>>>>>%%
%:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::%          
              
          