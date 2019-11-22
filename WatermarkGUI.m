function varargout = WatermarkGUI(varargin)
% WATERMARKGUI MATLAB code for WatermarkGUI.fig
%      WATERMARKGUI, by itself, creates a new WATERMARKGUI or raises the existing
%      singleton*.
%
%      H = WATERMARKGUI returns the handle to a new WATERMARKGUI or the handle to
%      the existing singleton*.
%
%      WATERMARKGUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in WATERMARKGUI.M with the given input arguments.
%
%      WATERMARKGUI('Property','Value',...) creates a new WATERMARKGUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before WatermarkGUI_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to WatermarkGUI_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help WatermarkGUI

% Last Modified by GUIDE v2.5 29-Nov-2016 18:47:27

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @WatermarkGUI_OpeningFcn, ...
                   'gui_OutputFcn',  @WatermarkGUI_OutputFcn, ...
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


% --- Executes just before WatermarkGUI is made visible.
function WatermarkGUI_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to WatermarkGUI (see VARARGIN)

% Choose default command line output for WatermarkGUI
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes WatermarkGUI wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = WatermarkGUI_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in pushbutton4.
function pushbutton4_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
audio = uigetfile('*.wav');

[AWO,fs] = audioread (audio);

axes(handles.axes10);
plot (AWO,'Color', 'Yellow');

setappdata(0, 'AWO', AWO);
setappdata(0, 'fs', fs);

% --- Executes on button press in pushbutton5.
function pushbutton5_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in pushbutton6.
function pushbutton6_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
A = getappdata(0,'A');

fs = getappdata(0,'fs');
%% Step 2 : DWT Level 1 with wavelet db 3

[Aa,Ad] = dwt(A,'db3');

% AI = idwt (Aa,Ad,'db3');

%% Step 3 : svd decomposition Ad
% Preparation before SVD Process into square matrix
lt = length (Ad);
d = sqrt (lt);
d = round(d);
Ad = Ad(1:d^2);
Aa = Aa(1:d^2);

% Reshape Matrix AD until square matrix
Adr = reshape(Ad,d,d);

[U_Ad,S_Ad,V_Ad] = svd (Adr);



%% -------------------------------%%
%% Step 1a;watermark Audio file

W = getappdata(0,'W');
% Equality dimensi W and A
la = length (A);
lw = length (W);

tmbah0 = zeros((la-lw),1);
W = [W ; tmbah0];

%% Step 2 a:  DWT Level 1 with wavelet db 3

[Wa,Wd] = dwt(W,'db3');

% AI = idwt (Aa,Ad,'db3');

%% svd decomposition Ad
% Preparation before SVC process
lt = length (Wd);
d = sqrt (lt);
d = round(d);
Wd = Wd(1:d^2);
Wa = Wa(1:d^2);

% Reshare matrix AD until become square matrix 
Wdr = reshape(Wd,d,d);

[U_Wd,S_Wd,V_Wd] = svd (Wdr);

% AWO
AWO = getappdata(0,'AWO');

%% DWT Level 1 with wavelet db 3

[AWOa,AWOd] = dwt(AWO,'db3');

% AI = idwt (Aa,Ad,'db3');

%% svd decomposition Ad
% Preparation before SVD process
lt = length (AWOd);
d = sqrt (lt);
d = round(d);
AWOd = AWOd(1:d^2);
AWOa = AWOa(1:d^2);

%% Reshape matrix AD until become square matrix
AWOdr = reshape(AWOd,d,d);
%% SVD
[U_AWOd,S_AWOd,V_AWOd] = svd (AWOdr);
S_Wd1 = (S_AWOd - S_Ad)/0.01;

Wd1 = U_Wd * S_Wd1 * V_Wd'; 
%% reshape
Wd1R = reshape (Wd1,d^2,1);

%% IDWT process

W1out =  idwt (Wa,Wd1R,'db3');
audiowrite( 'extractedWatermarked.wav',W1out,fs);

setappdata(0,'W1out',W1out);
%% Output Result
axes(handles.axes11);
plot (A, 'Color', 'red');

axes(handles.axes12)
plot(W1out,'Color', 'green');




% --- Executes on button press in pushbutton1.
function pushbutton1_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
audio = uigetfile('*.wav');

[A,fs] = audioread (audio);

axes(handles.axes1);
plot (A,'Color', 'red');

setappdata(0, 'A', A);
setappdata(0, 'fs', fs);

% --- Executes on button press in pushbutton2.
function pushbutton2_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
audio = uigetfile('*.wav');

[W,fs] = audioread (audio);

axes(handles.axes8);
plot (W,'Color', 'green');

setappdata(0, 'W', W);
setappdata(0, 'fs', fs);

% --- Executes on button press in pushbutton3.
function pushbutton3_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

%Tombol Proses
A = getappdata(0,'A');

fs = getappdata(0,'fs');
%% Step 2 : DWT Level 1 with wavelet db 3

[Aa,Ad] = dwt(A,'db3');

% AI = idwt (Aa,Ad,'db3');

%% Step 3 : svd decomposition Ad
% Preparation before svd process to become square matrix
lt = length (Ad);
d = sqrt (lt);
d = round(d);
Ad = Ad(1:d^2);
Aa = Aa(1:d^2);

% Reshape matrix Ad until become square matrix
Adr = reshape(Ad,d,d);

[U_Ad,S_Ad,V_Ad] = svd (Adr);



%% -------------------------------%%
%% Step 1a;watermark Audio file

W = getappdata(0,'W');
%Equality dimention W and A
la = length (A);
lw = length (W);

tmbah0 = zeros((la-lw),1);
W = [W ; tmbah0];

%% Step 2 a:  DWT Level 1 with wavelet db 3

[Wa,Wd] = dwt(W,'db3');

% AI = idwt (Aa,Ad,'db3');

%% svd decomposition Ad
% Preparation before SVD process
lt = length (Wd);
d = sqrt (lt);
d = round(d);
Wd = Wd(1:d^2);
Wa = Wa(1:d^2);

% Reshape matrix Ad until become square matrix
Wdr = reshape(Wd,d,d);

[U_Wd,S_Wd,V_Wd] = svd (Wdr);



%% Watermarking process

S_AW = S_Ad + (0.01*S_Wd);

AW = U_Ad * S_AW * V_Ad';

AWR = reshape (AW,(d*d),1);

%% invers IDWT to get output file

AWout = idwt (Aa,AWR,'db3');

audiowrite( 'AudioWatermarked.wav',AWout,fs);
axes(handles.axes9);
plot (AWout,'Color', 'Yellow');

setappdata(0,'AWout',AWout)

% --- Executes on button press in pushbutton7.
function pushbutton7_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
A = getappdata(0,'A');
fs = getappdata(0,'fs');

sound (A,fs);


% --- Executes on button press in pushbutton8.
function pushbutton8_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton8 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
W = getappdata(0,'W');
fs = getappdata(0,'fs');

sound (W,fs);


% --- Executes on button press in pushbutton9.
function pushbutton9_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton9 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
AWout = getappdata(0,'AWout');
fs = getappdata(0,'fs');

sound (AWout,fs);


% --- Executes on button press in pushbutton10.
function pushbutton10_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton10 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
AWO = getappdata(0,'AWO');
fs = getappdata(0,'fs');

sound (AWO,fs);

% --- Executes on button press in pushbutton11.
function pushbutton11_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton11 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
A = getappdata(0,'A');
fs = getappdata(0,'fs');

sound (A,fs);


% --- Executes on button press in pushbutton12.
function pushbutton12_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton12 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
W1out = getappdata(0,'W1out');
fs = getappdata(0,'fs');

sound (W1out,fs);
