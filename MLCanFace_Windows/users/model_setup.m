function varargout = model_setup(varargin)
%:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::%
%%                        FUNCTION CODE INTERFACE                        %%
%%                              MODEL SETUP                              %%
%:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::%
%-------------------------------------------------------------------------%
% This interface is used to call an interface for setting up and entering % 
% crop, geographic, number of layers information that will be assigned    %
% to the MLCan model                                                      %
%                                                                         %
%-------------------------------------------------------------------------%
% MODEL_SETUP M-file for model_setup.fig                                  %
%-------------------------------------------------------------------------%
%   Created by      : Phong Le                                            %
%   Date            : May 21, 2010                                        %
%   Last Modified   : May 23, 2010                                        %
%:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::%
%-------------------------------------------------------------------------%
%% Begin initialization code - DO NOT EDIT                               %%
%-------------------------------------------------------------------------%
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @model_setup_OpeningFcn, ...
                   'gui_OutputFcn',  @model_setup_OutputFcn, ...
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


% --- Executes just before model_setup is made visible.
function model_setup_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to model_setup (see VARARGIN)

% Choose default command line output for model_setup
handles.output = hObject;

load  './Temps/temporary.mat' 'working_name';
load ('./Temps/temp_variable.mat',...
        'crop_name'     , 'lat_face'    , 'long_face'   , 'LAImin_face' ,   ...
        'elev_face'     , 'num_can'     , 'num_root'    , 'num_root_eqn',   ...
        'opt_root'      , 'num_LAD'     );
set(handles.txt_crop_name,'String',crop_name);
set(handles.txt_lat,'String',lat_face);
set(handles.txt_long,'String',long_face);
set(handles.txt_elevation,'String',elev_face);
set(handles.txt_LAImin,'String',LAImin_face);
set(handles.txt_canopy_layer,'String',num_can);
set(handles.txt_LAD_layer,'String',num_LAD);
set(handles.model_setup,'Color',[0.941 0.941 0.941]);

if opt_root == 1
    set(handles.txt_root_layer,'String',num_root);
else
    set(handles.txt_root_layer,'String',num_root_eqn);
end

% Update handles structure
guidata(hObject, handles);
%-------------------------------------------------------------------------%
% UIWAIT makes main_MLCan wait for user response (see UIRESUME)           %
% uiwait(handles.Main);                                                   %
%-------------------------------------------------------------------------%


% --- Outputs from this function are returned to the command line.
function varargout = model_setup_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in set_mod_ok.
function set_mod_ok_Callback(hObject, eventdata, handles)
%
load './Temps/temp_variable.mat' 'canopy_systems' 'root_systems'
%
% Read string data
crop_name       = get(handles.txt_crop_name,'String');
lat_str         = get(handles.txt_lat,'String');
long_str        = get(handles.txt_long,'String');
elev_str        = get(handles.txt_elevation,'String');
LAImin_str      = get(handles.txt_LAImin,'String');
num_can_str     = get(handles.txt_canopy_layer,'String');
num_LAD_str     = get(handles.txt_LAD_layer,'String');
num_root_str    = get(handles.txt_root_layer,'String');
%
% Convert string to number;
lat_face      	= str2num(lat_str);
long_face     	= str2num(long_str);
elev_face      	= str2num(elev_str);
LAImin_face    	= str2num(LAImin_str);
num_can         = str2num(num_can_str);
num_LAD         = str2num(num_LAD_str);
num_root        = str2num(num_root_str);
%
% Check empty entering information
if (isempty(crop_name) || isempty(lat_str) || isempty(long_str)|| isempty(LAImin_str)||...
    isempty(num_can_str)|| isempty(num_LAD_str)|| isempty(num_root_str))
    msgbox('Please enter enough information ','MLCan Error: Empty information','error');
    return
else % Check numeric entering information
    if (isempty(lat_face)   == 1 || isempty(long_face)  == 1 || isempty(LAImin_face)== 1 || isempty(elev_face) == 1 ||...
        isempty(num_can)    == 1 || isempty(num_LAD)    == 1 || isempty(num_root)   == 1)
            msgbox('Numbers must be in numeric ','MLCan Error: Data type','error');
            return
    else
        if (mod(num_can,1) ~= 0 || mod(num_LAD,1) ~= 0 || mod(num_root,1) ~= 0 ||...
            num_can <= 0 || num_LAD <= 0 || num_root <= 0)
            msgbox ('Layer numbers must be positive integer (> 0) ','MLCan Error: Data type','error');
            return
        else
            if (lat_face < -90 || lat_face > 90 || long_face < -180 || long_face > 180)
                msgbox ('Latitude must be in [-90 90] degree and Longitude in [-180 180] degree', 'MLCan Error: Geographic','error');
                return;
            else
                %{
                if num_can > length(canopy_systems(:,1))
                    canopy_systems = [canopy_systems;zeros(num_can-length(canopy_systems(:,1)+1))];
                else
                    canopy_systems = canopy_systems(1:num_can,:);
                end
                %}
                canopy_systems  = zeros(num_can, 3);
                root_systems    = zeros(num_root,3);
                save './Temps/temp_variable.mat'...
                        'crop_name'         'lat_face'    	'long_face'     'LAImin_face'...
                        'num_can'           'num_LAD'       'num_root'      'canopy_systems'...
                        'root_systems'      'elev_face'    	-append;
                close;
            end
        end
    end
end



% --- Executes on button press in set_mod_cancel.
function set_mod_cancel_Callback(hObject, eventdata, handles)
close



function txt_crop_name_Callback(hObject, eventdata, handles)
% hObject    handle to txt_crop_name (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of txt_crop_name as text
%        str2double(get(hObject,'String')) returns contents of txt_crop_name as a double


% --- Executes during object creation, after setting all properties.
function txt_crop_name_CreateFcn(hObject, eventdata, handles)
% hObject    handle to txt_crop_name (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function txt_lat_Callback(hObject, eventdata, handles)
% hObject    handle to txt_lat (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of txt_lat as text
%        str2double(get(hObject,'String')) returns contents of txt_lat as a double


% --- Executes during object creation, after setting all properties.
function txt_lat_CreateFcn(hObject, eventdata, handles)
% hObject    handle to txt_lat (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function txt_long_Callback(hObject, eventdata, handles)
% hObject    handle to txt_long (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of txt_long as text
%        str2double(get(hObject,'String')) returns contents of txt_long as a double


% --- Executes during object creation, after setting all properties.
function txt_long_CreateFcn(hObject, eventdata, handles)
% hObject    handle to txt_long (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function txt_canopy_layer_Callback(hObject, eventdata, handles)
% hObject    handle to txt_canopy_layer (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of txt_canopy_layer as text
%        str2double(get(hObject,'String')) returns contents of txt_canopy_layer as a double


% --- Executes during object creation, after setting all properties.
function txt_canopy_layer_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function txt_root_layer_Callback(hObject, eventdata, handles)


% --- Executes during object creation, after setting all properties.
function txt_root_layer_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit6_Callback(hObject, eventdata, handles)



% --- Executes during object creation, after setting all properties.
function edit6_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function axes1_CreateFcn(hObject, eventdata, handles)
modeliconsmall = imread('./users/icons/wheat_small.png');
image(modeliconsmall);
axis off
%imshow('./users/icons/wheat_small.png');


function axes2_CreateFcn(hObject, eventdata, handles)
guifig = imread('./users/GUI_Fig.jpg');
image(guifig);
axis off
%imshow('./users/GUI_Fig.jpg');
axis image

%-------------------------------------------------------------------------%
% Call root profile function for entering root profile information        %
%-------------------------------------------------------------------------%
function set_mod_but_root_Callback(hObject, eventdata, handles)
num_root = get(handles.txt_root_layer,'String');
if (isempty(num_root) == 1 || isempty(str2num(num_root)) == 1)
    msgbox('Root number can not be a blank or string','MLCan error', 'error');
    return
else
    if (mod(str2num(num_root),1) ~= 0 || str2num(num_root) <= 0)
        msgbox ('Root layer number must be an positive integer','MLCan error', 'error');
        return
    else
        save './Temps/temp_variable.mat' 'num_root' -append;
        setup_root_profile;
    end
end

%-------------------------------------------------------------------------%
% Call LAD profile function for entering LAD profile information          %
%-------------------------------------------------------------------------%
function set_mod_but_LAD_Callback(hObject, eventdata, handles)
num_LAD = get(handles.txt_LAD_layer,'String');
if (isempty(num_LAD) == 1 || isempty(str2num(num_LAD)) == 1)
    msgbox('LAD layer number can not be a blank or string','MLCan error', 'error');
    return
else
    if (mod(str2num(num_LAD),1) ~= 0 || str2num(num_LAD) <= 0)
        msgbox ('LAD layer number must be an positive integer','MLCan error','error');
        return
    else
        save './Temps/temp_variable.mat' 'num_LAD' -append;
        setup_LAD_profile;
    end
end

function txt_LAD_layer_Callback(hObject, eventdata, handles)


function txt_LAD_layer_CreateFcn(hObject, eventdata, handles)

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function txt_LAImin_Callback(hObject, eventdata, handles)


function txt_LAImin_CreateFcn(hObject, eventdata, handles)

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function txt_elevation_Callback(hObject, eventdata, handles)


function txt_elevation_CreateFcn(hObject, eventdata, handles)

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
