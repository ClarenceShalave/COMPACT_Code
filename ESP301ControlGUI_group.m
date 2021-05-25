function varargout = ESP301ControlGUI_group(varargin)
% ESP301CONTROLGUI_GROUP MATLAB code for ESP301ControlGUI_group.fig
%      ESP301CONTROLGUI_GROUP, by itself, creates a new ESP301CONTROLGUI_GROUP or raises the existing
%      singleton*.
%
%      H = ESP301CONTROLGUI_GROUP returns the handle to a new ESP301CONTROLGUI_GROUP or the handle to
%      the existing singleton*.
%
%      ESP301CONTROLGUI_GROUP('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in ESP301CONTROLGUI_GROUP.M with the given input arguments.
%
%      ESP301CONTROLGUI_GROUP('Property','Value',...) creates a new ESP301CONTROLGUI_GROUP or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before ESP301ControlGUI_group_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to ESP301ControlGUI_group_OpeningFcn via varargi,n.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help ESP301ControlGUI_group

% Last Modified by GUIDE v2.5 29-Oct-2018 15:12:57

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
    'gui_Singleton',  gui_Singleton, ...
    'gui_OpeningFcn', @ESP301ControlGUI_group_OpeningFcn, ...
    'gui_OutputFcn',  @ESP301ControlGUI_group_OutputFcn, ...
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


% --- Executes just before ESP301ControlGUI_group is made visible.
function ESP301ControlGUI_group_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to ESP301ControlGUI_group (see VARARGIN)

% Choose default command line output for ESP301ControlGUI_group
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes ESP301ControlGUI_group wait for user response (see UIRESUME)
% uiwait(handles.figure1);
%% set up motor connection;
global s2 waitabit motorX motorY motorZ rAngle dz dr zlim;
zlim=-20;% in mm;
rAngle=0;% in degree;
dz=0.05;% in mm;
dr=0.05;% in mm;
s2 = serial('COM6');
fopen(s2);
s2.ReadAsyncMode = 'continuous';
s2.BaudRate=19200;
s2.Timeout=0.05;
s2.Terminator='CR';
waitabit=0.1;
fprintf(s2,'1mo;2mo;3mo;');
pause(waitabit);
fprintf(s2,'EX JOYSTICK OFF');
pause(waitabit);
warning off;
%% ask for current locations;
fprintf(s2,'1PA?\n');pause(waitabit);
while s2.BytesAvailable>0
    out = char(fread(s2));out=out';out=str2num(out);out=out(1);
    motorX=out;
end
fprintf(s2,'2PA?\n');pause(waitabit);
while s2.BytesAvailable>0
    out = char(fread(s2));out=out';out=str2num(out);out=out(1);
    motorY=out;
end
fprintf(s2,'3PA?\n');pause(waitabit);
while s2.BytesAvailable>0
    out = char(fread(s2));out=out';out=str2num(out);out=out(1);
    motorZ=out;
end

%% update xyz positions;
set(handles.xPosition,'String',num2str(motorX,'%6.4f'));
set(handles.yPosition,'String',num2str(motorY,'%6.4f'));
set(handles.zPosition,'String',num2str(motorZ,'%6.4f'));

set(handles.zstep,'String',num2str(dz,'%6.4f'));
set(handles.rstep,'String',num2str(dr,'%6.4f'));

set(handles.rotation,'String',num2str(rAngle,'%6.1f'));

set(handles.zlim,'String',num2str(zlim,'%6.1f'));

% --- Outputs from this function are returned to the command line.
function varargout = ESP301ControlGUI_group_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;



function xPosition_Callback(hObject, eventdata, handles)
% hObject    handle to xPosition (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of xPosition as text
%        str2double(get(hObject,'String')) returns contents of xPosition as a double
global motorX s2 waitabit;
motorX=str2double(get(hObject,'String'));
if motorX>=0
    p=num2str(motorX,'%6.4f');
    fprintf(s2,['1pa+',p,';1ws;']);
else
    p=num2str(-motorX,'%6.4f');
    fprintf(s2,['1pa-',p,';1ws;']);
end
pause(waitabit);

% --- Executes during object creation, after setting all properties.
function xPosition_CreateFcn(hObject, eventdata, handles)
% hObject    handle to xPosition (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function yPosition_Callback(hObject, eventdata, handles)
% hObject    handle to yPosition (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of yPosition as text
%        str2double(get(hObject,'String')) returns contents of yPosition as a double
global motorY s2 waitabit;
motorY=str2double(get(hObject,'String'));
if motorY>=0
    p=num2str(motorY,'%6.4f');
    fprintf(s2,['2pa+',p,';2ws;']);
else
    p=num2str(-motorY,'%6.4f');
    fprintf(s2,['2pa-',p,';2ws;']);
end
pause(waitabit);
% --- Executes during object creation, after setting all properties.
function yPosition_CreateFcn(hObject, eventdata, handles)
% hObject    handle to yPosition (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function zPosition_Callback(hObject, eventdata, handles)
% hObject    handle to zPosition (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of zPosition as text
%        str2double(get(hObject,'String')) returns contents of zPosition as a double
global motorZ s2 waitabit zlim;
motorZ=str2double(get(hObject,'String'));
if motorZ>=zlim
    if motorZ>=0
        p=num2str(motorZ,'%6.4f');
        fprintf(s2,['3pa+',p,';3ws;']);
    else
        p=num2str(-motorZ,'%6.4f');
        fprintf(s2,['3pa-',p,';3ws;']);
    end
    pause(waitabit);
else
    motorZ=zlim;
    msgbox('zlimit error!');
    set(handles.zPosition,'String',num2str(motorZ,'%6.4f'));
end


% --- Executes during object creation, after setting all properties.
function zPosition_CreateFcn(hObject, eventdata, handles)
% hObject    handle to zPosition (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function rotation_Callback(hObject, eventdata, handles)
% hObject    handle to rotation (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of rotation as text
%        str2double(get(hObject,'String')) returns contents of rotation as a double
global rAngle;
rAngle=str2double(get(hObject,'String'));

% --- Executes during object creation, after setting all properties.
function rotation_CreateFcn(hObject, eventdata, handles)
% hObject    handle to rotation (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in CloseRS232.
function CloseRS232_Callback(hObject, eventdata, handles)
% hObject    handle to CloseRS232 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global s2;
fprintf(s2,'1HX');
fclose(s2);
fclose('all');


% --- Executes on button press in Up.
function Up_Callback(hObject, eventdata, handles)
% hObject    handle to Up (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%% update motor position and display;
global s2 dz motorZ waitabit zlim;
motorZ=motorZ+dz; %sample up is to reduce z value;
set(handles.zPosition,'String',num2str(motorZ,'%6.4f'));
%% move motor;
if motorZ>=zlim
    if motorZ>=0
        p=num2str(motorZ,'%6.4f');
        fprintf(s2,['3pa+',p,';3ws;']);
    else
        p=num2str(-motorZ,'%6.4f');
        fprintf(s2,['3pa-',p,';3ws;']);
    end
    pause(waitabit);
else
    motorZ=zlim;
    set(handles.zPosition,'String',num2str(motorZ,'%6.4f'));
    msgbox('zlimit error!');
end
% --- Executes on button press in Up.
function Down_Callback(hObject, eventdata, handles)
% hObject    handle to Up (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

%% update motor position and display;
global s2 dz motorZ waitabit zlim;
motorZ=motorZ-dz; %sample down is to reduce z value;
set(handles.zPosition,'String',num2str(motorZ,'%6.4f'));
%% move motor;
if motorZ>=zlim
    if motorZ>=0
        p=num2str(motorZ,'%6.4f');
        fprintf(s2,['3pa+',p,';3ws;']);
    else
        p=num2str(-motorZ,'%6.4f');
        fprintf(s2,['3pa-',p,';3ws;']);
    end
    pause(waitabit);
else
    motorZ=zlim;
    set(handles.zPosition,'String',num2str(motorZ,'%6.4f'));
    msgbox('zlimit error!');
end

% --- Executes on button press in West.
function West_Callback(hObject, eventdata, handles)
% hObject    handle to West (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

%% update motor position and display;
global s2 dr motorX motorY rAngle waitabit;
motorX=motorX-dr*cos(rAngle/180*pi);
motorY=motorY-dr*sin(rAngle/180*pi);
set(handles.xPosition,'String',num2str(motorX,'%6.4f'));
set(handles.yPosition,'String',num2str(motorY,'%6.4f'));
%% move motor;
if motorX>=0
    p=num2str(motorX,'%6.4f');
    fprintf(s2,['1pa+',p,';1ws;']);
else
    p=num2str(-motorX,'%6.4f');
    fprintf(s2,['1pa-',p,';1ws;']);
end
pause(waitabit);

if motorY>=0
    p=num2str(motorY,'%6.4f');
    fprintf(s2,['2pa+',p,';2ws;']);
else
    p=num2str(-motorY,'%6.4f');
    fprintf(s2,['2pa-',p,';2ws;']);
end
pause(waitabit);



% --- Executes on button press in North.
function North_Callback(hObject, eventdata, handles)
% hObject    handle to North (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%% update motor position and display;
global s2 dr motorX motorY rAngle waitabit;
motorX=motorX-dr*sin(rAngle/180*pi);
motorY=motorY+dr*cos(rAngle/180*pi);
set(handles.xPosition,'String',num2str(motorX,'%6.4f'));
set(handles.yPosition,'String',num2str(motorY,'%6.4f'));
%% move motor;
if motorX>=0
    p=num2str(motorX,'%6.4f');
    fprintf(s2,['1pa+',p,';1ws;']);
else
    p=num2str(-motorX,'%6.4f');
    fprintf(s2,['1pa-',p,';1ws;']);
end
pause(waitabit);

if motorY>=0
    p=num2str(motorY,'%6.4f');
    fprintf(s2,['2pa+',p,';2ws;']);
else
    p=num2str(-motorY,'%6.4f');
    fprintf(s2,['2pa-',p,';2ws;']);
end
pause(waitabit);


% --- Executes on button press in South.
function South_Callback(hObject, eventdata, handles)
% hObject    handle to South (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%% update motor position and display;
global s2 dr motorX motorY rAngle waitabit;
motorX=motorX+dr*sin(rAngle/180*pi);
motorY=motorY-dr*cos(rAngle/180*pi);
set(handles.xPosition,'String',num2str(motorX,'%6.4f'));
set(handles.yPosition,'String',num2str(motorY,'%6.4f'));
%% move motor;
if motorX>=0
    p=num2str(motorX,'%6.4f');
    fprintf(s2,['1pa+',p,';1ws;']);
else
    p=num2str(-motorX,'%6.4f');
    fprintf(s2,['1pa-',p,';1ws;']);
end
pause(waitabit);

if motorY>=0
    p=num2str(motorY,'%6.4f');
    fprintf(s2,['2pa+',p,';2ws;']);
else
    p=num2str(-motorY,'%6.4f');
    fprintf(s2,['2pa-',p,';2ws;']);
end
pause(waitabit);

% --- Executes on button press in East.
function East_Callback(hObject, eventdata, handles)
% hObject    handle to East (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%% update motor position and display;
global s2 dr motorX motorY rAngle waitabit;
motorX=motorX+dr*cos(rAngle/180*pi);
motorY=motorY+dr*sin(rAngle/180*pi);
set(handles.xPosition,'String',num2str(motorX,'%6.4f'));
set(handles.yPosition,'String',num2str(motorY,'%6.4f'));
%% move motor;
if motorX>=0
    p=num2str(motorX,'%6.4f');
    fprintf(s2,['1pa+',p,';1ws;']);
else
    p=num2str(-motorX,'%6.4f');
    fprintf(s2,['1pa-',p,';1ws;']);
end
pause(waitabit);

if motorY>=0
    p=num2str(motorY,'%6.4f');
    fprintf(s2,['2pa+',p,';2ws;']);
else
    p=num2str(-motorY,'%6.4f');
    fprintf(s2,['2pa-',p,';2ws;']);
end
pause(waitabit);


function zstep_Callback(hObject, eventdata, handles)
% hObject    handle to zstep (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of zstep as text
%        str2double(get(hObject,'String')) returns contents of zstep as a double
global dz;
dz=str2double(get(hObject,'String'));

% --- Executes during object creation, after setting all properties.
function zstep_CreateFcn(hObject, eventdata, handles)
% hObject    handle to zstep (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function rstep_Callback(hObject, eventdata, handles)
% hObject    handle to rstep (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of rstep as text
%        str2double(get(hObject,'String')) returns contents of rstep as a double
global dr;
dr=str2double(get(hObject,'String'));

% --- Executes during object creation, after setting all properties.
function rstep_CreateFcn(hObject, eventdata, handles)
% hObject    handle to rstep (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in manualOn.
function manualOn_Callback(hObject, eventdata, handles)
% hObject    handle to manualOn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global s2;
fprintf(s2,'EX JOYSTICK ON');

% --- Executes on button press in manualOff.
function manualOff_Callback(hObject, eventdata, handles)
% hObject    handle to manualOff (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global s2;
fprintf(s2,'EX JOYSTICK OFF');



function zlim_Callback(hObject, eventdata, handles)
% hObject    handle to zlim (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of zlim as text
%        str2double(get(hObject,'String')) returns contents of zlim as a double
global zlim;
zlim=str2double(get(hObject,'String'));

% --- Executes during object creation, after setting all properties.
function zlim_CreateFcn(hObject, eventdata, handles)
% hObject    handle to zlim (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in update_XYZ.
function update_XYZ_Callback(hObject, eventdata, handles)
% hObject    handle to update_XYZ (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% --- Executes on button press in updatexyz.
global s2 waitabit motorX motorY motorZ;
%% ask for current locations;
fprintf(s2,'1PA?\n');pause(waitabit);
while s2.BytesAvailable>0
    out = char(fread(s2));out=out';out=str2num(out);out=out(1);
    motorX=out;
end
fprintf(s2,'2PA?\n');pause(waitabit);
while s2.BytesAvailable>0
    out = char(fread(s2));out=out';out=str2num(out);out=out(1);
    motorY=out;
end
fprintf(s2,'3PA?\n');pause(waitabit);
while s2.BytesAvailable>0
    out = char(fread(s2));out=out';out=str2num(out);out=out(1);
    motorZ=out;
end

%% update xyz positions;
set(handles.xPosition,'String',num2str(motorX,'%6.4f'));
set(handles.yPosition,'String',num2str(motorY,'%6.4f'));
set(handles.zPosition,'String',num2str(motorZ,'%6.4f'));


% --- Executes on button press in group_on.
function group_on_Callback(hObject, eventdata, handles)
% hObject    handle to group_on (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global s2 waitabit
fprintf(s2,'1HN1,2,3');pause(waitabit);
fprintf(s2,'1HV0.2');pause(waitabit);
fprintf(s2,'1HA0.8');pause(waitabit);
fprintf(s2,'1HD0.8');pause(waitabit);
fprintf(s2,'1HN?');pause(waitabit);
t=fscanf(s2);
if size(t,2)==1 || isempty(t)
    set(handles.group_status,'String','Off');
else
    set(handles.group_status,'String','On');
end


% --- Executes on button press in group_off.
function group_off_Callback(hObject, eventdata, handles)
% hObject    handle to group_off (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global s2 waitabit
fprintf(s2,'1HX');pause(waitabit);
fprintf(s2,'1HN?');pause(waitabit);
t=fscanf(s2);
if size(t,2)==1 || isempty(t)
    set(handles.group_status,'String','Off');
else
    set(handles.group_status,'String','On');
end


function group_dx_Callback(hObject, eventdata, handles)
% hObject    handle to group_dx (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of group_dx as text
%        str2double(get(hObject,'String')) returns contents of group_dx as a double


% --- Executes during object creation, after setting all properties.
function group_dx_CreateFcn(hObject, eventdata, handles)
% hObject    handle to group_dx (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function group_dy_Callback(hObject, eventdata, handles)
% hObject    handle to group_dy (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of group_dy as text
%        str2double(get(hObject,'String')) returns contents of group_dy as a double


% --- Executes during object creation, after setting all properties.
function group_dy_CreateFcn(hObject, eventdata, handles)
% hObject    handle to group_dy (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function group_dz_Callback(hObject, eventdata, handles)
% hObject    handle to group_dz (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of group_dz as text
%        str2double(get(hObject,'String')) returns contents of group_dz as a double


% --- Executes during object creation, after setting all properties.
function group_dz_CreateFcn(hObject, eventdata, handles)
% hObject    handle to group_dz (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in group_up.
function group_up_Callback(hObject, eventdata, handles)
% hObject    handle to group_up (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global s2 waitabit;
fprintf(s2,'1HP?');pause(waitabit);
gx=str2double(fscanf(s2));
gy=str2double(fscanf(s2));
gz=str2double(fscanf(s2));
dx=str2double(get(handles.group_dx,'String'));
dy=str2double(get(handles.group_dy,'String'));
dz=str2double(get(handles.group_dz,'String'));
dL=str2double(get(handles.group_l,'String'));
dgx=dL*dx/sqrt(dx^2+dy^2+dz^2);
dgy=dL*dy/sqrt(dx^2+dy^2+dz^2);
dgz=dL*dz/sqrt(dx^2+dy^2+dz^2);
if abs(dgx)<0.0002 || abs(dgy)<0.0002 || abs(dgz)<0.0002
    dL=dL/min([abs(dgx),abs(dgy),abs(dgz)])*0.0002;
    set(handles.group_l,'String',num2str(dL,'%6.4f'));
    dgx=dL*dx/sqrt(dx^2+dy^2+dz^2);
    dgy=dL*dy/sqrt(dx^2+dy^2+dz^2);
    dgz=dL*dz/sqrt(dx^2+dy^2+dz^2);
end
gx=gx+dgx;
gy=gy+dgy;
gz=gz+dgz;
fprintf(s2,['1HL',num2str(gx),',',num2str(gy),',',num2str(gz)]);
pause(waitabit);


% --- Executes on button press in group_down.
function group_down_Callback(hObject, eventdata, handles)
% hObject    handle to group_down (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global s2 waitabit;
fprintf(s2,'1HP?');pause(waitabit);
gx=str2double(fscanf(s2));
gy=str2double(fscanf(s2));
gz=str2double(fscanf(s2));
dx=str2double(get(handles.group_dx,'String'));
dy=str2double(get(handles.group_dy,'String'));
dz=str2double(get(handles.group_dz,'String'));
dL=str2double(get(handles.group_l,'String'));
dgx=dL*dx/sqrt(dx^2+dy^2+dz^2);
dgy=dL*dy/sqrt(dx^2+dy^2+dz^2);
dgz=dL*dz/sqrt(dx^2+dy^2+dz^2);
if abs(dgx)<0.0002 || abs(dgy)<0.0002 || abs(dgz)<0.0002
    dL=dL/min([abs(dgx),abs(dgy),abs(dgz)])*0.0002;
    set(handles.group_l,'String',num2str(dL,'%6.4f'));
    dgx=dL*dx/sqrt(dx^2+dy^2+dz^2);
    dgy=dL*dy/sqrt(dx^2+dy^2+dz^2);
    dgz=dL*dz/sqrt(dx^2+dy^2+dz^2);
end
gx=gx-dgx;
gy=gy-dgy;
gz=gz-dgz;
fprintf(s2,['1HL',num2str(gx),',',num2str(gy),',',num2str(gz)]);
pause(waitabit);



function group_l_Callback(hObject, eventdata, handles)
% hObject    handle to group_l (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of group_l as text
%        str2double(get(hObject,'String')) returns contents of group_l as a double


% --- Executes during object creation, after setting all properties.
function group_l_CreateFcn(hObject, eventdata, handles)
% hObject    handle to group_l (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in group_move.
function group_move_Callback(hObject, eventdata, handles)
% hObject    handle to group_move (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global s2 waitabit;
gx=get(handles.group_x,'String');
gy=get(handles.group_y,'String');
gz=get(handles.group_z,'String');
fprintf(s2,['1HL',num2str(gx),',',num2str(gy),',',num2str(gz)]);
pause(waitabit);



function group_x_Callback(hObject, eventdata, handles)
% hObject    handle to group_x (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of group_x as text
%        str2double(get(hObject,'String')) returns contents of group_x as a double


% --- Executes during object creation, after setting all properties.
function group_x_CreateFcn(hObject, eventdata, handles)
% hObject    handle to group_x (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function group_y_Callback(hObject, eventdata, handles)
% hObject    handle to group_y (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of group_y as text
%        str2double(get(hObject,'String')) returns contents of group_y as a double


% --- Executes during object creation, after setting all properties.
function group_y_CreateFcn(hObject, eventdata, handles)
% hObject    handle to group_y (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function group_z_Callback(hObject, eventdata, handles)
% hObject    handle to group_z (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of group_z as text
%        str2double(get(hObject,'String')) returns contents of group_z as a double


% --- Executes during object creation, after setting all properties.
function group_z_CreateFcn(hObject, eventdata, handles)
% hObject    handle to group_z (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in group_stop.
function group_stop_Callback(hObject, eventdata, handles)
% hObject    handle to group_stop (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global s2 waitabit;
fprintf(s2,'1HS');pause(waitabit);
