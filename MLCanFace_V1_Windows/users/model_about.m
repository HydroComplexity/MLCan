function varargout = model_about(varargin)
% MODEL_ABOUT MATLAB code for model_about.fig
%      MODEL_ABOUT, by itself, creates a new MODEL_ABOUT or raises the existing
%      singleton*.
%
%      H = MODEL_ABOUT returns the handle to a new MODEL_ABOUT or the handle to
%      the existing singleton*.
%
%      MODEL_ABOUT('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in MODEL_ABOUT.M with the given input arguments.
%
%      MODEL_ABOUT('Property','Value',...) creates a new MODEL_ABOUT or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before model_about_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to model_about_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help model_about

% Last Modified by GUIDE v2.5 11-Jul-2012 17:12:45

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @model_about_OpeningFcn, ...
                   'gui_OutputFcn',  @model_about_OutputFcn, ...
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


% --- Executes just before model_about is made visible.
function model_about_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to model_about (see VARARGIN)

% Choose default command line output for model_about
handles.output = hObject;

intro_txt = ['This Multi-Layer Canopy-Root-Soil (MLCan) model is developed at the University of Illinois at Urbana-Champaign by Professor Praveen Kumar?s research group [http://www.hydrocomplexity.net] in the Department of Civil and Environmental Engineering. At present this code is made available for educational use, and for research only under a collaborative agreement. Unauthorized use, distribution or redistribution, or commercial use of this model in its entirety or its components is strictly prohibited. The authors assume no liability arising from the use of this model or its components. The development of this model was funded by the National Science Foundation (Grant number ATM 06-28687).'];

pub_intro_txt = ['The details of the model and its application are available in the following publications that should be referenced in the context of this model:'];

pub0_txt = ['Phong V. V. Le, P. Kumar, D. T. Drewry, and J. C. Quijano, A graphical user interface for numerical modeling of acclimation responses of vegetation to climate change, to appear in Computers and Geosciences, 2012.'];

pub1_txt = ['D. T. Drewry, P. Kumar, S. Long, C. Bernacchi, X. Z. Liang, and M. Sivapalan (2010), Ecohydrological responses of '...
            'dense canopies to environmental variability: 1. Interplay between vertical structure and photosynthetic pathway, ',...
            'J. Geophys. Res., 115, G04022, doi:10.1029/2010JG001340.'];
pub2_txt = ['D. T. Drewry, P. Kumar, S. Long, C. Bernacchi, X. Z. Liang, and M. Sivapalan (2010), Ecohydrological responses of ',...
            'dense canopies to environmental variability: 2. Role of acclimation under elevated CO2, ',...
            'J. Geophys. Res., 115, G04023, doi:10.1029/2010JG001341.'];         
pub3_txt = ['Phong V. V. Le, P. Kumar, D. T. Drewry, Implications for the hydrologic cycle under climate change due to the ',...
            'expansion of bioenergy crops in the Midwestern United States , Proc. of the National Academy of Sciences, ',...
            '108 (37) 15085-15090, 2011, doi:10.1073/pnas.1107177108.'];         
     
set(handles.txt_intro,'String',intro_txt);  
set(handles.txt_pubintro,'String',pub_intro_txt);  
set(handles.txt_pub0,'String',pub0_txt);  
set(handles.txt_pub1,'String',pub1_txt);  
set(handles.txt_pub2,'String',pub2_txt);  
set(handles.txt_pub3,'String',pub3_txt);  

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes model_about wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = model_about_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes when figure1 is resized.
function figure1_ResizeFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes during object creation, after setting all properties.
function axes1_CreateFcn(hObject, eventdata, handles)
MLCanLogo = imread('./users/icons/MLCanLogo.png');
image(MLCanLogo);
axis off
