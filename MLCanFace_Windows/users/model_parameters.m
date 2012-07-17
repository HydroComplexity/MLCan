function varargout = model_parameters(varargin)
% MODEL_PARAMETERS M-file for model_parameters.fig
%      MODEL_PARAMETERS, by itself, creates a new MODEL_PARAMETERS or raises the existing
%      singleton*.
%
%      H = MODEL_PARAMETERS returns the handle to a new MODEL_PARAMETERS or the handle to
%      the existing singleton*.
%
%      MODEL_PARAMETERS('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in MODEL_PARAMETERS.M with the given input arguments.
%
%      MODEL_PARAMETERS('Property','Value',...) creates a new MODEL_PARAMETERS or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before model_parameters_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to model_parameters_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help model_parameters

% Last Modified by GUIDE v2.5 05-Jun-2010 23:38:31

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @model_parameters_OpeningFcn, ...
                   'gui_OutputFcn',  @model_parameters_OutputFcn, ...
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


% --- Executes just before model_parameters is made visible.
function model_parameters_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to model_parameters (see VARARGIN)

% Choose default command line output for model_parameters
handles.output = hObject;
load    './Temps/temporary.mat' 'working_name';
load (  './Temps/temp_variable.mat',...
        'ph_type'       , 'para_leaf'       , 'para_canopy'     , 'para_radiation'  , 'para_soil'       ,   ...
        'para_photosynthesisC3'             , 'para_photosynthesisC4'               , 'para_respiration',   ...
        'para_conductance'                  , 'para_microenvironment');
    
set(handles.para_tab_leaf,'Data',para_leaf);
set(handles.para_tab_canopy,'Data',para_canopy);
set(handles.para_tab_radiation,'Data',para_radiation);
set(handles.para_tab_soil,'Data',para_soil);
set(handles.para_tab_respiration,'Data',para_respiration);
set(handles.para_tab_conductance,'Data',para_conductance);
set(handles.para_tab_microenvironment,'Data',para_microenvironment);
if ph_type == 0
    set(handles.para_tab_photosynthesisC4,'Enable','on');
    set(handles.para_tab_photosynthesisC3,'Enable','off');
    set(handles.para_tab_photosynthesisC4,'Data',para_photosynthesisC4);
else
    set(handles.para_tab_photosynthesisC3,'Enable','on');
    set(handles.para_tab_photosynthesisC4,'Enable','off');
    set(handles.para_tab_photosynthesisC3,'Data',para_photosynthesisC3);
end

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes model_parameters wait for user response (see UIRESUME)
% uiwait(handles.model_parameters);


% --- Outputs from this function are returned to the command line.
function varargout = model_parameters_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;

% --- Executes on button press in parameter_but_photosynthesis.
function tab_photosynthesis_Callback(hObject, eventdata, handles)
% hObject    handle to parameter_but_photosynthesis (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of parameter_but_photosynthesis
set(handles.parameter_pan_leafcanopy,'Visible','off');
set(handles.pan2,'Visible','off');


% --- Executes on button press in radiobutton1.
function radiobutton1_Callback(hObject, eventdata, handles)
% hObject    handle to radiobutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of radiobutton1


% --- Executes on button press in checkbox1.
function checkbox1_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox1


% --- Executes on selection change in listbox1.
function listbox1_Callback(hObject, eventdata, handles)
% hObject    handle to listbox1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns listbox1 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from listbox1


% --- Executes during object creation, after setting all properties.
function listbox1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to listbox1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- If Enable == 'on', executes on mouse press in 5 pixel border.
% --- Otherwise, executes on mouse press in 5 pixel border or over parameter_but_leafcanopy.
function parameter_but_leafcanopy_ButtonDownFcn(hObject, eventdata, handles)
% hObject    handle to parameter_but_leafcanopy (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on key press with focus on parameter_but_leafcanopy and none of its controls.
function parameter_but_leafcanopy_KeyPressFcn(hObject, eventdata, handles)
% hObject    handle to parameter_but_leafcanopy (see GCBO)
% eventdata  structure with the following fields (see UICONTROL)
%	Key: name of the key that was pressed, in lower case
%	Character: character interpretation of the key(s) that was pressed
%	Modifier: name(s) of the modifier key(s) (i.e., control, shift) pressed
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on key press with focus on parameter_but_soilradiation and none of its controls.
function parameter_but_soilradiation_KeyPressFcn(hObject, eventdata, handles)
% hObject    handle to parameter_but_soilradiation (see GCBO)
% eventdata  structure with the following fields (see UICONTROL)
%	Key: name of the key that was pressed, in lower case
%	Character: character interpretation of the key(s) that was pressed
%	Modifier: name(s) of the modifier key(s) (i.e., control, shift) pressed
% handles    structure with handles and user data (see GUIDATA)



% --- If Enable == 'on', executes on mouse press in 5 pixel border.
% --- Otherwise, executes on mouse press in 5 pixel border or over parameter_but_soilradiation.


% --- Executes during object creation, after setting all properties.
function axes2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to axes2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: place code in OpeningFcn to populate axes2


% --- Executes when selected cell(s) is changed in para_tab_canopy.
function para_tab_canopy_CellSelectionCallback(hObject, eventdata, handles)
% hObject    handle to para_tab_canopy (see GCBO)
% eventdata  structure with the following fields (see UITABLE)
%	Indices: row and column indices of the cell(s) currently selecteds
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in parameter_but_leafcanopy.
function parameter_but_leafcanopy_Callback(hObject, eventdata, handles)
set(handles.parameter_pan_soilradiation,'Visible','off');
set(handles.parameter_pan_photosynthesis,'Visible','off');
set(handles.parameter_pan_respiration_conductance,'Visible','off');
set(handles.parameter_pan_leafcanopy,'Visible','on');


% --- Executes on button press in parameter_but_soilradiation.
function parameter_but_soilradiation_Callback(hObject, eventdata, handles)
set(handles.parameter_pan_leafcanopy,'Visible','off');
set(handles.parameter_pan_photosynthesis,'Visible','off');
set(handles.parameter_pan_respiration_conductance,'Visible','off');
set(handles.parameter_pan_soilradiation,'Visible','on');

function parameter_but_photosynthesis_Callback(hObject, eventdata, handles)
set(handles.parameter_pan_leafcanopy,'Visible','off');
set(handles.parameter_pan_respiration_conductance,'Visible','off');
set(handles.parameter_pan_soilradiation,'Visible','off');
set(handles.parameter_pan_photosynthesis,'Visible','on');


function parameter_but_respiration_conductance_Callback(hObject, eventdata, handles)
set(handles.parameter_pan_leafcanopy,'Visible','off');
set(handles.parameter_pan_soilradiation,'Visible','off');
set(handles.parameter_pan_photosynthesis,'Visible','off');
set(handles.parameter_pan_respiration_conductance,'Visible','on');


% --- Executes during object creation, after setting all properties.
function parameter_but_soilradiation_CreateFcn(hObject, eventdata, handles)
% hObject    handle to parameter_but_soilradiation (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called


% --- Executes during object creation, after setting all properties.
function parameter_but_leafcanopy_CreateFcn(hObject, eventdata, handles)
% hObject    handle to parameter_but_leafcanopy (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called


function parameter_but_photosynthesis_CreateFcn(hObject, eventdata, handles)


function parameter_but_respiration_conductance_CreateFcn(hObject, eventdata, handles)


function parameter_but_photosynthesis_DeleteFcn(hObject, eventdata, handles)


function parameter_but_OK_Callback(hObject, eventdata, handles)
load ('./Temps/temp_variable.mat', 'ph_type');
para_leaf               = get(handles.para_tab_leaf,'Data');
para_microenvironment   = get(handles.para_tab_microenvironment,'Data');
para_conductance        = get(handles.para_tab_conductance,'Data');
para_respiration        = get(handles.para_tab_respiration,'Data');
para_soil               = get(handles.para_tab_soil,'Data');
para_canopy             = get(handles.para_tab_canopy,'Data');
para_radiation          = get(handles.para_tab_radiation,'Data');
para_photosynthesisC4   = get(handles.para_tab_photosynthesisC4,'Data');
para_photosynthesisC3   = get(handles.para_tab_photosynthesisC3,'Data');
if ph_type == 0
    para_photosynthesis     = para_photosynthesisC4;
else
    para_photosynthesis     = para_photosynthesisC3;
end

save './Temps/temp_variable.mat'...
    'para_leaf' 'para_conductance' 'para_respiration' 'para_photosynthesisC3'...
    'para_photosynthesisC4' 'para_soil' 'para_radiation' 'para_canopy' 'para_microenvironment' -append;

if (isempty(para_leaf) || isempty(para_conductance) || isempty(para_respiration)|| isempty(para_photosynthesis)||...
                          isempty(para_soil)|| isempty(para_radiation)|| isempty(para_canopy)|| isempty(para_microenvironment))
    msgbox('Please enter enough information','Error');
    return
else
    close;
end


function parameter_but_cancel_Callback(hObject, eventdata, handles)
close

function parameter_but_photosynthesis_ButtonDownFcn(hObject, eventdata, handles)


function axes1_CreateFcn(hObject, eventdata, handles)
paraiconsmall = imread('./users/icons/parameter_small.png'); 
image(paraiconsmall);
axis off
%imshow('./users/icons/parameter_small.png'); 


function para_tab_microenvironment_CellEditCallback(hObject, eventdata, handles)


function para_tab_conductance_CellSelectionCallback(hObject, eventdata, handles)


function para_tab_respiration_CellSelectionCallback(hObject, eventdata, handles)


function para_tab_photosynthesisC4_CellEditCallback(hObject, eventdata, handles)


function para_tab_soil_CellSelectionCallback(hObject, eventdata, handles)


function para_tab_radiation_CellEditCallback(hObject, eventdata, handles)


function para_tab_leaf_CellEditCallback(hObject, eventdata, handles)


function para_tab_canopy_CellEditCallback(hObject, eventdata, handles)


function uipanel4_SelectionChangeFcn(hObject, eventdata, handles)
