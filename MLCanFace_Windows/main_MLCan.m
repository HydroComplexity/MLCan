function varargout = main_MLCan(varargin)
%:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::%
%%                       MAIN INTERFACE PROGRAM                          %%
%%           Canopy-Root-Soil-Atmosphere Exchange Model                  %%
%:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::%
%-------------------------------------------------------------------------%
% This interface is used to connect and facilitate the MLCan matlab code  % 
% written by Darren Drewry. See Drewry et al, 2010.                    	  %
%                                                                         %
% This interface include the following components:                        %
%   + Model Setup   : Used for setting up model information               %
%   + Option        : Used for choosing sub-models                        %
%   + Forcings / Initial conditions                                       %
%                   : Used for creating/choosing forcings and initital    %      
%                     conditions for sub-models                           %
%   + Parameters    : Used for entering parameters values                 %
%   + Results       : Showing plot and results from files                 %
%-------------------------------------------------------------------------%
% MAIN_MLCAN M-file for main_MLCan.fig                                    %
%-------------------------------------------------------------------------%
%   Created by      : Phong Le                                            %
%   Date            : May 20, 2010                                        %
%   Last Modified   : May 23, 2010                                        %
%:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::%
%-------------------------------------------------------------------------%
%% Begin initialization code - DO NOT EDIT                               %%
%-------------------------------------------------------------------------%
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @main_MLCan_OpeningFcn, ...
                   'gui_OutputFcn',  @main_MLCan_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
%-------------------------------------------------------------------------%
%% End initialization code - DO NOT EDIT                                 %%
%-------------------------------------------------------------------------%

% --- Executes just before main_MLCan is made visible.
function main_MLCan_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to main_MLCan (see VARARGIN)

% Choose default command line output for main_MLCan

% Add Users directory to call sub-interface
addpath('./users/');
workpath = pwd;
setappdata(0,'workpath',workpath);

handles.output = hObject;
set(handles.mnu_model,'Enable','off');
set(handles.mnu_result,'Enable','off');
set(handles.mnu_save,'Enable','off');
set(handles.mnu_saveas,'Enable','off');
set(handles.toolbar_save,'Enable','off');

set(handles.pan_start_screen,'Visible','on');
set(handles.button_setup_model,'Visible','off');
set(handles.pan_layer,'Visible','off');
set(handles.txt_model_mlcan,'Visible','off');
set(handles.txt_model_full_name,'Visible','off');
set(handles.Main,'Color',[0.502 0.502 0.502]);

% Update handles structure
guidata(hObject, handles);
%-------------------------------------------------------------------------%
% UIWAIT makes main_MLCan wait for user response (see UIRESUME)           %
% uiwait(handles.Main);                                                   %
%-------------------------------------------------------------------------%


% --- Outputs from this function are returned to the command line.
function varargout = main_MLCan_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --------------------------------------------------------------------
function mnu_file_Callback(hObject, eventdata, handles)
% hObject    handle to mnu_file (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function mnu_edit_Callback(hObject, eventdata, handles)
% hObject    handle to mnu_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function mnu_model_Callback(hObject, eventdata, handles)
% hObject    handle to mnu_model (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function mnu_result_Callback(hObject, eventdata, handles)
% hObject    handle to mnu_result (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function mnu_help_sub_Callback(hObject, eventdata, handles)
% hObject    handle to mnu_help_sub (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
model_help()

% --------------------------------------------------------------------
function mnu_undo_Callback(hObject, eventdata, handles)
% hObject    handle to mnu_undo (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function mnu_redo_Callback(hObject, eventdata, handles)
% hObject    handle to mnu_redo (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function mnu_copy_Callback(hObject, eventdata, handles)
% hObject    handle to mnu_copy (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function mnu_cut_Callback(hObject, eventdata, handles)
% hObject    handle to mnu_cut (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function mnu_paste_Callback(hObject, eventdata, handles)



%-------------------------------------------------------------------------%
% New in menu editor connected to "New function"                          %
%-------------------------------------------------------------------------%
function mnu_new_Callback(hObject, eventdata, handles)
button_new_main_Callback(hObject, eventdata, handles)


%-------------------------------------------------------------------------%
% Open in menu editor connected to "Open function"                        %
%-------------------------------------------------------------------------%
function mnu_open_Callback(hObject, eventdata, handles)
button_open_main_Callback(hObject, eventdata, handles)


%-------------------------------------------------------------------------%
% "Save function" - Save all variables to the current working files       %
%-------------------------------------------------------------------------%
function mnu_save_Callback(hObject, eventdata, handles)
load './Temps/temporary.mat' 'working_name';
copyfile('./Temps/temp_variable.mat', working_name,'f');


%-------------------------------------------------------------------------%
% "Save as function" - Save all variables to the other files              %
%-------------------------------------------------------------------------%
function mnu_saveas_Callback(hObject, eventdata, handles)
[filename,pathname] = uiputfile('*.mat','Save your files');
if pathname == 0 %if the user pressed cancelled, then we exit this callback
    return
end

fullpath_filename = [pathname, filename];
workpath = getappdata(0,'workpath');
rem_path = strrep(fullpath_filename,workpath,'');
if strcmp(rem_path,fullpath_filename) == 1
    Msgbox('Do NOT save files outside the working folder, please save the file again','MLCan Error');
    return
else
    working_name = ['.',rem_path];
    hgsave(working_name);
    copyfile('./Temps/temp_variable.mat', fullpath_filename,'f');
end


%-------------------------------------------------------------------------%
% "Exit function" - Close the program and exit                            %
%-------------------------------------------------------------------------%
function mnu_exit_Callback(hObject, eventdata, handles)
close


% -------------------------------------------------------------------------
function mnu_print_Callback(hObject, eventdata, handles)


%-------------------------------------------------------------------------%
% "Run function" - Connect and run Darren Drewry model                    %
%-------------------------------------------------------------------------%
function mnu_run_Callback(hObject, eventdata, handles)
DRIVER_CROP_1_0;


% -------------------------------------------------------------------------
function mnu_forcings_condition_Callback(hObject, eventdata, handles)
button_group_condition_Callback(hObject, eventdata, handles)

%-------------------------------------------------------------------------%
% Call parameter interface and connect the model                          %
%-------------------------------------------------------------------------%
function mnu_parameters_Callback(hObject, eventdata, handles)
model_parameters();                                                       

% -------------------------------------------------------------------------
function Context_test_Callback(hObject, eventdata, handles)



% -------------------------------------------------------------------------
function toolbar_print_ClickedCallback(hObject, eventdata, handles)



% -------------------------------------------------------------------------
function toolbar_open_ClickedCallback(hObject, eventdata, handles)
button_open_main_Callback(hObject, eventdata, handles)


% --- Executes during object creation, after setting all properties.
function axe_start_screen_CreateFcn(hObject, eventdata, handles)
background = imread('./users/background.jpg');       
image(background);
axis off

%imshow('./users/background.jpg');                                                   % Load image background in axes


%-------------------------------------------------------------------------%
% NEW BUTTON ON START SCREEN TO CREATE NEW FILES...                       %
%-------------------------------------------------------------------------%
function button_new_main_Callback(hObject, eventdata, handles)
[filename, pathname] = uiputfile('*.mat', 'Create new files');
if pathname == 0 %if the user pressed cancelled, then we exit this callback
    return
else
    fullpath_filename = [pathname, filename];
    workpath = getappdata(0,'workpath');
    rem_path = strrep(fullpath_filename,workpath,'');
    if strcmp(rem_path,fullpath_filename) == 1
        Msgbox('Do NOT creat project files outside the working folder','MLCan Error');
        return
    else
        working_name = ['.',rem_path];

        set(handles.pan_start_screen,'Visible','off');
        set(handles.Main,'Color',[0.941 0.941 0.941]);
        set(handles.pan_layer,'Visible','on');
        main_menu_enable(hObject, eventdata, handles);
        save './Temps/temporary.mat' 'working_name';

        % Empty information used for model setup form.
        crop_name   = '';
        lat_face    = '';
        long_face   = '';
        LAImin_face = '';
        elev_face   = '';
        num_can     = '';
        num_root    = '';
        num_LAD     = '';
        opt_root    = 1;
        dat_LAD     = zeros(3,2);
        dat_root    = zeros(3,2);

        set_para_root   = {...
            ' Maximum depth'    , 1     ,   ; ...
            ' z50'              , 0.2   ,   ; ...
            ' z95'              , 0.8         ...
        };
        set_root_func = {...
            0.05    , 0.1       , 0.2   ;   ...
            0.2     , 0.3       , 0.8       ...
        }';    

        %Empty information used for option.
        ph_type     = 1;
        Turbulence  = 0;
        HR          = 0;
        RHC         = 1;
        Soil_heat   = 0;
        CO2_Elev    = 0;
        CO2_Elev_con= 550;
        rnm         = 0;
        carbon      = 0;
        nitrogen    = 0;

        %Empty information used for initial conditions
        root_init    = zeros(3,3);
        root_name       = {'Depth', 'Moisture', 'Temperature'};

        %Empty information used for parameters.
        fullpath_forcings   = '';
        working_forcings    = '';

        %Empty information used for parameters.
        emp_cell = zeros(-1);
        para_leaf = {...
        ' Latent Heat production from 1 or both sides of leaf'                  , emp_cell  , 1     , '          unitless';...
        ' Sensible Heat production from 1 or both sides of leaf'                , emp_cell  , 2     , '          unitless';...
        ' Longwave production from 1 or both sides of leaf'                     , emp_cell  , 2     , '          unitless';...
        ' Leaf Type: 1-Broad leaf or 2-Needle leaf'                             , emp_cell  , 1     , '          unitless';...
        };

        para_canopy = {...
        ' Canopy height'                                                        , emp_cell  , 2.5   , '              m   ';...
        ' Flux tower observation height'                                        , emp_cell  , 10    , '              m   ';...
        ' Leaf width or needle diameter'                                        , emp_cell  , 0.01  , '              m   ';...
        ' Shoot diameter for conifers or leaf width for broad leaf'             , emp_cell  , 0.01  , '              m   ';...
        ' Maximum wetted fraction'                                              , emp_cell  , 0.2   , '          unitless';...
        ' Rainfall interception factor'                                         , emp_cell  , 0.2   , '          unitless';...
        };

        para_radiation = {...
        ' Atmospheric transmissivity'                                           , emp_cell  , 0.65  , '          unitless';...
        ' Vegetation emissivity'                                                , emp_cell  , 0.94  , '          unitless';...
        ' Soil emissivity'                                                      , emp_cell  , 0.90  , '          unitless';...
        ' Atmospheric emissivity'                                               , emp_cell  , 0.80  , '          unitless';...
        ' Leaf angle distribution parameter'                                    , emp_cell  , 1.64  , '          unitless';...
        ' Leaf clumping parameter'                                              , emp_cell  , 1.0   , '          unitless';...
        ' Extinction coefficient for diffuse'                                   , emp_cell  , 0.7   , '          unitless';...
        ' Leaf absorptivity to Photosynthetically Active Radiation'             , emp_cell  , 0.85  , '          unitless';...
        ' Leaf absorptivity to Near Infrared'                                   , emp_cell  , 0.20  , '          unitless';...
        };

        para_soil = {...
        ' Percent of sand'                                                      , emp_cell  , 5     , '          unitless';...
        ' Percent of clay'                                                      , emp_cell  , 25    , '          unitless';...
        ' Soil drag coefficient'                                                , emp_cell  , 0.90  , '          unitless';...
        ' Soil surface roughness length'                                        , emp_cell  , 0.005 , '              m   ';...
        };

        para_photosynthesisC4 = {...
        ' Maximum Rubisco capacity Vmax'                                        , emp_cell  , 45    , '   mol / (sq m. s)'; ...
        ' Leaf respiration Rd'                                                  , emp_cell  , 0.8   , '   mol / (sq m. s)'; ...
        ' Temperature sensitivity Q10'                                          , emp_cell  , 0.57  , '          unitless'; ...
        ' Initial slope of CO2 response'                                        , emp_cell  , 0.7   , '   mol / (sq m. s)'; ...
        ' Curvature factor theta'                                               , emp_cell  , 0.83  , '          unitless'; ...
        ' Curvature factor beta'                                                , emp_cell  , 0.93  , '          unitless'; ...
        ' Intrisic quantum yield of C4 photosynthesis - alpha'                  , emp_cell  , 0.04  , '          unitless'; ...
        ' Vertical distribution of Photosynthetic capacity'                     , emp_cell  , 0.14  , '          unitless'; ...
        };

        para_photosynthesisC3 = {...
        ' Fraction absorbed Q available to photosystem II'                      , emp_cell  , 0.5   , '          unitless'; ...
        ' Maximum rate of Rubisco-limited carbonxylation at 25 C - Vcmax'       , emp_cell  , 100   , '   mol / (sq m. s)'; ...
        ' Maximum electron transport rate - Jmax'                               , emp_cell  , 180   , '  mmol / (sq m. s)'; ...
        ' Vertical distribution of Photosynthetic capacity'                     , emp_cell  , 0.14  , '          unitless'; ...

        };

        para_respiration = {...
        ' Respiration Ro'                                                       , emp_cell  , 1.2   , '   mol / (sq m. s)'; ...
        ' Respiration Q10'                                                      , emp_cell  , 2.0   , '   mol / (sq m. s)'; ...
        };

        para_conductance = {...
        ' Slope parameter in Ball-Berry model, m'                               , emp_cell  , 8     , '          unitless'; ...
        ' Intercepts in Ball Berry model, b'                                    , emp_cell  , 0.008 , '   mol / (sq m. s)'; ...
        ' Sensitivity parameter for initial decrease in leaf potential'         , emp_cell  , 5     , '         unitless '; ...
        ' Leaf potential at which half of the hydraulic conductance is lost'    , emp_cell  , -.04  , '              MPa '; ...
        ' Parameter, Rp'                                                        , emp_cell  , 8     , '          unitless'; ...
        };

        para_microenvironment = {...
        ' Drag coefficient, Cd'                                                 , emp_cell  , 0.1   , '          unitless';  ...
        };

        % save empty information for new project-------------------------------
        save (fullpath_filename, ...
                        'crop_name'             , 'lat_face'            , 'long_face'           , 'LAImin_face'         ,   ...
                        'num_can'               , 'num_LAD'             , 'num_root'            , 'ph_type'             ,   ...
                        'Turbulence'            , 'HR'                  , 'RHC'                 , 'Soil_heat'           ,   ...
                        'CO2_Elev'              , 'CO2_Elev_con'        , 'rnm'                 , 'elev_face'           ,   ...
                        'para_leaf'             , 'para_canopy'         , 'para_radiation'      , 'para_soil'           ,	...
                        'para_photosynthesisC3' ,'para_photosynthesisC4', 'para_respiration'    , 'para_conductance'    ,   ...
                        'para_microenvironment' , 'root_init'           , 'root_name'           , 'dat_LAD'             ,	...
                        'dat_root'              , 'opt_root'            , 'set_para_root'       , 'set_root_func'       ,   ...
                        'working_forcings'      , 'fullpath_forcings'   );

        % save to temporary files.---------------------------------------------    
        save ('./Temps/temp_variable.mat',...
                        'crop_name'             , 'lat_face'            , 'long_face'           , 'LAImin_face'         ,   ...
                        'num_can'               , 'num_LAD'             , 'num_root'            , 'ph_type'             ,   ...
                        'Turbulence'            , 'HR'                  , 'RHC'                 , 'Soil_heat'           ,   ...
                        'CO2_Elev'              , 'CO2_Elev_con'        , 'rnm'                 , 'elev_face'           ,   ...
                        'para_leaf'             , 'para_canopy'         , 'para_radiation'      , 'para_soil'           ,	...
                        'para_photosynthesisC3' ,'para_photosynthesisC4', 'para_respiration'    , 'para_conductance'    ,   ...
                        'para_microenvironment' , 'root_init'           , 'root_name'           , 'dat_LAD'             ,   ...
                        'dat_root'              , 'opt_root'            , 'set_para_root'       , 'set_root_func'       ,   ...
                        'working_forcings'      , 'fullpath_forcings'   );

    end
end

%-------------------------------------------------------------------------%
% OPEN BUTTON ON START SCREEN TO OPEN FILES...                            %
%-------------------------------------------------------------------------%
function button_open_main_Callback(hObject, eventdata, handles)
[filename, pathname] = uigetfile('*.mat', 'Open MLCan files');
if pathname == 0 %if the user pressed cancelled, then we exit this callback
    return
else
	fullpath_filename = [pathname, filename];
    workpath = getappdata(0,'workpath');
    rem_path = strrep(fullpath_filename,workpath,'');
    if strcmp(rem_path,fullpath_filename) == 1
        Msgbox('Please copy project files inside the working folder before loading','MLCan Error');
        return
    else
        working_name = ['.',rem_path];
        try
            load(working_name, 'crop_name', 'lat_face', 'long_face', 'LAImin_face', 'num_can', 'num_LAD', 'num_root');
            save './Temps/temporary.mat' 'working_name';
            copyfile(fullpath_filename,'./Temps/temp_variable.mat','f');
            set(handles.pan_start_screen,'Visible','off');
            set(handles.Main,'Color',[0.941 0.941 0.941]);
            set(handles.pan_layer,'Visible','on');
            main_menu_enable(hObject, eventdata, handles);
        catch exception
            msgbox('Incorrect input file','MLCan: Error');
            return
        end
    end
end


%-------------------------------------------------------------------------%
% EXIT BUTTON...                                                          %
%-------------------------------------------------------------------------%
function button_exit_main_Callback(hObject, eventdata, handles)
close


% --------------------------------------------------------------------
function mnu_about_Callback(hObject, eventdata, handles)
% hObject    handle to mnu_about (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
model_about()


%-------------------------------------------------------------------------%
% Enable some menu in the main screen                                     %
%-------------------------------------------------------------------------%
function main_menu_enable(hObject, eventdata, handles)
set(handles.mnu_model,'Enable','on');
set(handles.mnu_result,'Enable','on');
set(handles.mnu_save,'Enable','on');
set(handles.mnu_saveas,'Enable','on');
set(handles.toolbar_save,'Enable','on');
set(handles.button_setup_model,'Visible','on');
set(handles.txt_model_mlcan,'Visible','on');
set(handles.txt_model_full_name,'Visible','on');


%-------------------------------------------------------------------------%
% Call MODEL SETUP interface from button in main screen                   %
%-------------------------------------------------------------------------%
function button_group_setup_Callback(hObject, eventdata, handles)
model_setup;

%-------------------------------------------------------------------------%
% Call OPTIONS interface from button in main screen                       %
%-------------------------------------------------------------------------%
function button_group_option_Callback(hObject, eventdata, handles)
model_option;

%-------------------------------------------------------------------------%
% Call FORCINGS/INITIAL CONDITONS interface from button in main screen    %
%-------------------------------------------------------------------------%
function button_group_condition_Callback(hObject, eventdata, handles)
load './Temps/temp_variable.mat' 'root_init' 'num_root' 'dat_root'
try
    dat_length = length(root_init(:,1));
    root_num = num_root;
    if dat_length > root_num
        root_init = root_init(1:root_num,:);
    elseif dat_length < root_num
        root_init_add = zeros(root_num-dat_length,3);
        root_init = [root_init; root_init_add];
    end
    root_init = [dat_root(:,1),root_init(:,2:3)];
    model_forcings;
catch exception
    msgbox( 'Please input ROOT PROFILE first: Go back to MODEL SETUP - Click on Add/Edit Input root profile',   ...
            'MLCan Error','Error');
    return
end

%-------------------------------------------------------------------------%
% Call PARAMETERS interface from button in main screen                    %
%-------------------------------------------------------------------------%
function button_group_parameters_Callback(hObject, eventdata, handles)
model_parameters;


%-------------------------------------------------------------------------%
% Call RESULTS interface from button in main screen                       %
%-------------------------------------------------------------------------%
function button_group_result_Callback(hObject, eventdata, handles)
model_results;
%-------------------------------------------------------------------------%
% Loading icon for buttons in main interface                              %

function axes3_CreateFcn(hObject, eventdata, handles)
modelicon = imread('./users/icons/wheat.png');
image(modelicon)
axis off
%imshow('./users/icons/wheat.png');

function axes4_CreateFcn(hObject, eventdata, handles)
optionicon = imread('./users/icons/option.png');
image(optionicon)
axis off
%imshow('./users/icons/option.png');

function axes5_CreateFcn(hObject, eventdata, handles)
forceicon = imread('./users/icons/forcings.png');
image(forceicon)
axis off
%imshow('./users/icons/forcings.png');

function axes6_CreateFcn(hObject, eventdata, handles)
paraicon = imread('./users/icons/parameter.png');
image(paraicon)
axis off
%imshow('./users/icons/parameter.png');

function axes7_CreateFcn(hObject, eventdata, handles)
resulticon = imread('./users/icons/result.png');
image(resulticon)
axis off
%imshow('./users/icons/result.png');

% End of loading icon                                                     %
%-------------------------------------------------------------------------%



%-------------------------------------------------------------------------%
% Toolbar functions                                                       %
%-------------------------------------------------------------------------%
function toolbar_new_ClickedCallback(hObject, eventdata, handles)
button_new_main_Callback(hObject, eventdata, handles)

function toolbar_save_ClickedCallback(hObject, eventdata, handles)
mnu_save_Callback(hObject, eventdata, handles)

function mnu_setup_model_Callback(hObject, eventdata, handles)
button_group_setup_Callback(hObject, eventdata, handles)

function mnu_options_Callback(hObject, eventdata, handles)
button_group_option_Callback(hObject, eventdata, handles)

function mnu_result_viewer_Callback(hObject, eventdata, handles)
button_group_result_Callback(hObject, eventdata, handles)


% --- If Enable == 'on', executes on mouse press in 5 pixel border.
% --- Otherwise, executes on mouse press in 5 pixel border or over button_group_parameters.
function button_group_parameters_ButtonDownFcn(hObject, eventdata, handles)
% hObject    handle to button_group_parameters (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function mnu_help_Callback(hObject, eventdata, handles)
% hObject    handle to mnu_help (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
