function varargout = setup_LAD_profile(varargin)
% SETUP_LAD_PROFILE M-file for setup_LAD_profile.fig
%      SETUP_LAD_PROFILE, by itself, creates a new SETUP_LAD_PROFILE or raises the existing
%      singleton*.
%
%      H = SETUP_LAD_PROFILE returns the handle to a new SETUP_LAD_PROFILE or the handle to
%      the existing singleton*.
%
%      SETUP_LAD_PROFILE('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in SETUP_LAD_PROFILE.M with the given input arguments.
%
%      SETUP_LAD_PROFILE('Property','Value',...) creates a new SETUP_LAD_PROFILE or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before setup_LAD_profile_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to setup_LAD_profile_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help setup_LAD_profile

% Last Modified by GUIDE v2.5 26-May-2010 15:43:00

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @setup_LAD_profile_OpeningFcn, ...
                   'gui_OutputFcn',  @setup_LAD_profile_OutputFcn, ...
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


% --- Executes just before setup_LAD_profile is made visible.
function setup_LAD_profile_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to setup_LAD_profile (see VARARGIN)

% Choose default command line output for setup_LAD_profile
handles.output = hObject;

load './Temps/temp_variable.mat' 'num_can' 'num_LAD' 'dat_LAD'
dat_length = length(dat_LAD(:,1));
LAD_num = str2num(num_LAD);

if dat_length > LAD_num
    dat_LAD = dat_LAD(1:LAD_num,:);
else
	dat_LAD_add = zeros(LAD_num-dat_length,2);
	dat_LAD = [dat_LAD; dat_LAD_add];
end

set(handles.setup_LAD_tab,'Data',dat_LAD)
xlabel(handles.axes_LAD_plot,'\bf Leaf Area Index [m^2 m^{-2}]');
ylabel(handles.axes_LAD_plot,'\bf Canopy height [m]');
grid on;
setup_LAD_tab_CellEditCallback(hObject, eventdata, handles)
% Update handles structure
guidata(hObject, handles);

% UIWAIT makes setup_LAD_profile wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = setup_LAD_profile_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


function but_LAD_load_Callback(hObject, eventdata, handles)
[filename, pathname] = uigetfile(...
    {'*.xls;*.xlsx'     , 'Microsoft Excel Files (*.xls,*.xlsx)';   ...
    '*.csv'             , 'CSV - comma delimited (*.csv)'       ;   ... 
    '*.txt'             , 'Text (Tab Delimited (*.txt)'         ;   ...
    '*.*'               , 'All Files (*.*)'                     },  ...
    'Load LAD from files');
    
if pathname == 0 %if the user pressed cancelled, then we exit this callback
    return
else
	load './Temps/temp_variable.mat' 'num_LAD'
    str_file = regexp(filename, '\.', 'split');
    if (strcmp(str_file(end),'xls') == 1 || strcmp(str_file(end),'xlsx') == 1)
        LAD_data_table = xlsread([pathname,filename]);      
    elseif strcmp(str_file(end),'csv') == 1
        LAD_data_table = csvread([pathname,filename], 1, 0);      
    elseif strcmp(str_file(end),'txt') == 1
        LAD_data_table = dlmread([pathname,filename], '\t', 1, 0);      
    else
        msgbox('The file extension is unrecognized, please choose another file','MLCan Error','Error');
        return
    end
    
    if length(LAD_data_table(:,1)) ~= str2num(num_LAD)
        numstr=num2str(length(LAD_data_table(:,1)));
        notice = ['Number of LAD (',num_LAD,') must be equal to data in imported file (',numstr,')'];
        msgbox(notice, 'MLCan Error: Different data length','Error');
        return        
    else
        if length(LAD_data_table(1,:)) ~= 2
            msgbox ('Incorrect format or input file''MLcan Error','Error')
            return
        else
            set(handles.setup_LAD_tab,'Data',LAD_data_table);   
            setup_LAD_tab_CellEditCallback(hObject, eventdata, handles);
        end
    end
end

function but_LAD_cancel_Callback(hObject, eventdata, handles)
close

function but_LAD_ok_Callback(hObject, eventdata, handles)
dat_LAD = get(handles.setup_LAD_tab,'Data');
save './Temps/temp_variable.mat' 'dat_LAD' -append
close;


function setup_LAD_tab_CellEditCallback(hObject, eventdata, handles)
dat_LAD         = get(handles.setup_LAD_tab,'Data');
canopy_height   = dat_LAD(:,1);
LAI             = dat_LAD(:,2);

plot(handles.axes_LAD_plot,LAI,canopy_height,'Color', 'b',...
        'LineStyle','--','LineWidth',2,'Marker','s','MarkerEdgeColor','k',...
        'MarkerFaceColor','g','MarkerSize',6);
axis(handles.axes_LAD_plot,[0 max(LAI)*1.2+0.1 min(canopy_height)/1.2 max(canopy_height)*1.1+0.1]);
xlabel(handles.axes_LAD_plot,'\bf Leaf Area Index [m^2 m^{-2}]');
ylabel(handles.axes_LAD_plot,'\bf Canopy height [m]');
legend(handles.axes_LAD_plot,'LAD profile');
grid on;
