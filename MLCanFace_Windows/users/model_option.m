function varargout = model_option(varargin)
% MODEL_OPTION M-file for model_option.fig
%      MODEL_OPTION, by itself, creates a new MODEL_OPTION or raises the existing
%      singleton*.
%
%      H = MODEL_OPTION returns the handle to a new MODEL_OPTION or the handle to
%      the existing singleton*.
%
%      MODEL_OPTION('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in MODEL_OPTION.M with the given input arguments.
%
%      MODEL_OPTION('Property','Value',...) creates a new MODEL_OPTION or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before model_option_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to model_option_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help model_option

% Last Modified by GUIDE v2.5 19-May-2010 23:33:07

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @model_option_OpeningFcn, ...
                   'gui_OutputFcn',  @model_option_OutputFcn, ...
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
% End initialization code - DO NOT EDIT


% --- Executes just before model_option is made visible.
function model_option_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to model_option (see VARARGIN)

% Choose default command line output for model_option
handles.output = hObject;

load './Temps/temporary.mat' 'working_name';
load ('./Temps/temp_variable.mat', 'ph_type', 'Turbulence', 'HR', 'RHC', 'Soil_heat', 'CO2_Elev', 'CO2_Elev_con', 'rnm');

set(handles.rad_but_C3,'Value',ph_type);
set(handles.rad_rhc_linear,'Value',RHC);
set(handles.rad_CO2_elev_on,'Value',CO2_Elev);
set(handles.rad_txt_CO2_ele,'String',CO2_Elev_con);

set(handles.rad_rnm_implicit,'Value',rnm);

set(handles.chk_soilheat,'Value',Soil_heat);
set(handles.chk_Turbulence,'Value',Turbulence);
set(handles.chk_HR,'Value',HR);

% Nutrient model is not include in this 1st version
% set(handles.chk_carbon,'Value',carbon);
% set(handles.chk_nitrogen,'Value',nitrogen);

if CO2_Elev == 1
    set(handles.rad_txt_CO2_ele,'Enable','on');
else
    set(handles.rad_txt_CO2_ele,'Enable','off');
end
% Update handles structure
guidata(hObject, handles);

% UIWAIT makes model_option wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = model_option_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


function axes1_CreateFcn(hObject, eventdata, handles)
optioniconsmall = imread('./users/icons/option_small.png');
image(optioniconsmall);
axis off
%imshow('./users/icons/option_small.png');


function mod_option_ok_Callback(hObject, eventdata, handles)
load './Temps/temporary.mat' 'working_name';

ph_type     = get(handles.rad_but_C3,'Value');
RHC         = get(handles.rad_rhc_linear,'Value');
CO2_Elev    = get(handles.rad_CO2_elev_on,'Value');
rnm         = get(handles.rad_rnm_implicit,'Value');

Soil_heat   = get(handles.chk_soilheat,'Value');
Turbulence  = get(handles.chk_Turbulence,'Value');
HR          = get(handles.chk_HR,'Value');

CO2_Elev_con_str    = get(handles.rad_txt_CO2_ele,'String');
CO2_Elev_con        = str2num(CO2_Elev_con_str);

% Nutrient model is not include in this 1st version
% carbon      = get(handles.chk_carbon,'Value');
% nitrogen    = get(handles.chk_nitrogen,'Value');

save './Temps/temp_variable.mat' 'ph_type' 'Turbulence' 'HR' 'RHC'...
        'Soil_heat' 'CO2_Elev' 'CO2_Elev_con' 'rnm' -append;

close


function figure1_CreateFcn(hObject, eventdata, handles)


function mod_option_cancel_Callback(hObject, eventdata, handles)
close


function rad_but_C3_CreateFcn(hObject, eventdata, handles)


function edit1_Callback(hObject, eventdata, handles)


function edit1_CreateFcn(hObject, eventdata, handles)

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function rad_txt_CO2_ele_Callback(hObject, eventdata, handles)


function rad_txt_CO2_ele_CreateFcn(hObject, eventdata, handles)

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function chk_soilheat_Callback(hObject, eventdata, handles)


function chk_Turbulence_Callback(hObject, eventdata, handles)


function chk_HR_Callback(hObject, eventdata, handles)


function chk_carbon_Callback(hObject, eventdata, handles)


function chk_nitrogen_Callback(hObject, eventdata, handles)


function uipanel8_SelectionChangeFcn(hObject, eventdata, handles)
handles = guidata(hObject); 
 
switch get(eventdata.NewValue,'Tag')   % Get Tag of selected object
    case 'rad_CO2_elev_off'
        set(handles.rad_txt_CO2_ele,'Enable','off');
    case 'rad_CO2_elev_on'
        set(handles.rad_txt_CO2_ele,'Enable','on');
    otherwise
end
%updates the handles structure
guidata(hObject, handles);


function rad_CO2_elev_off_CreateFcn(hObject, eventdata, handles)


function rad_CO2_elev_on_CreateFcn(hObject, eventdata, handles)
