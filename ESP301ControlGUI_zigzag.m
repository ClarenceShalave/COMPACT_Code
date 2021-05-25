function varargout = ESP301ControlGUI_zigzag(varargin)
% ESP301CONTROLGUI_ZIGZAG MATLAB code for ESP301ControlGUI_zigzag.fig
%      ESP301CONTROLGUI_ZIGZAG, by itself, creates a new ESP301CONTROLGUI_ZIGZAG or raises the existing
%      singleton*.
%
%      H = ESP301CONTROLGUI_ZIGZAG returns the handle to a new ESP301CONTROLGUI_ZIGZAG or the handle to
%      the existing singleton*.
%
%      ESP301CONTROLGUI_ZIGZAG('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in ESP301CONTROLGUI_ZIGZAG.M with the given input arguments.
%
%      ESP301CONTROLGUI_ZIGZAG('Property','Value',...) creates a new ESP301CONTROLGUI_ZIGZAG or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before ESP301ControlGUI_zigzag_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to ESP301ControlGUI_zigzag_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help ESP301ControlGUI_zigzag

% Last Modified by GUIDE v2.5 17-Dec-2020 16:55:37

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
    'gui_Singleton',  gui_Singleton, ...
    'gui_OpeningFcn', @ESP301ControlGUI_zigzag_OpeningFcn, ...
    'gui_OutputFcn',  @ESP301ControlGUI_zigzag_OutputFcn, ...
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


% --- Executes just before ESP301ControlGUI_zigzag is made visible.
function ESP301ControlGUI_zigzag_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to ESP301ControlGUI_zigzag (see VARARGIN)

% Choose default command line output for ESP301ControlGUI_zigzag
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes ESP301ControlGUI_zigzag wait for user response (see UIRESUME)
% uiwait(handles.figure1);
%% set up motor connection;
xps_load_drivers;
global waitabit motorX motorY motorZ rAngle dz dr zlimL zlimH;
waitabit=0.1;
zlimL=-12.5;% in mm;
zlimH=12.5;% in mm;
rAngle=0;% in degree;
dz=0.02;% in mm;
dr=0.02;% in mm;
% establish communicatino with the controller;
global IP Port TimeOut socketID;  % parameters for connection
IP = '10.163.192.64' ;
Port = 5001 ;
TimeOut = 60.0 ;
% Connect to XPS
socketID = TCP_ConnectToServer (IP, Port, TimeOut) ;
if socketID<0 % check connection
    error('Connection to XPS failed, check IP & Port');
else
    disp('Connection successful');
end
% control
global group positioner1 positioner2 positioner3; % parameters for controlling
% group1 = 'GROUP1' ;
% positioner1 = 'GROUP1.POSITIONER' ;
% group2 = 'GROUP2' ;
% positioner2 = 'GROUP2.POSITIONER' ;
% group3 = 'GROUP3' ;
% positioner3 = 'GROUP3.POSITIONER' ;
positioner1 = 'XYZ.X' ;
positioner2 = 'XYZ.Y' ;
positioner3 = 'XYZ.Z' ;
group = 'XYZ' ;
% get current position
[errorCode, currentPosition] = GroupPositionCurrentGet(socketID, positioner1, 1) ; % x
if errorCode~=0
    error(['Error ' num2str(errorCode) ' occurred while doing GroupPositionCurrentGet! ']);
else
    %set(handles.xPosition,'String',num2str(currentPosition));
    motorX=currentPosition;
end
[errorCode, currentPosition] = GroupPositionCurrentGet(socketID, positioner2, 1) ; % y
if errorCode~=0
    error(['Error ' num2str(errorCode) ' occurred while doing GroupPositionCurrentGet! ']);
else
    %set(handles.yPosition,'String',num2str(currentPosition));
    motorY=currentPosition;
end
[errorCode, currentPosition] = GroupPositionCurrentGet(socketID, positioner3, 1) ; % z
if errorCode~=0
    error(['Error ' num2str(errorCode) ' occurred while doing GroupPositionCurrentGet! ']);
else
    %set(handles.zPosition,'String',num2str(currentPosition));
    motorZ=currentPosition;
end
%% update xyz positions;
set(handles.xPosition,'String',num2str(motorX,'%6.4f'));
set(handles.yPosition,'String',num2str(motorY,'%6.4f'));
set(handles.zPosition,'String',num2str(motorZ,'%6.4f'));

set(handles.zstep,'String',num2str(dz,'%6.4f'));
set(handles.rstep,'String',num2str(dr,'%6.4f'));

set(handles.rotation,'String',num2str(rAngle,'%6.1f'));

% --- Outputs from this function are returned to the command line.
function varargout = ESP301ControlGUI_zigzag_OutputFcn(hObject, eventdata, handles)
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
global motorX waitabit socketID positioner1;

motorX=str2double(get(hObject,'String'));
[errorCode] = GroupMoveAbsolute(socketID, positioner1, motorX) ;
if (errorCode ~= 0)
disp (['Error ' num2str(errorCode) ' occurred while doing GroupMoveAbsolute ! ']) ;
return ;
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
global motorY waitabit socketID positioner2;
motorY=str2double(get(hObject,'String'));
[errorCode] = GroupMoveAbsolute(socketID, positioner2, motorY) ;
if (errorCode ~= 0)
disp (['Error ' num2str(errorCode) ' occurred while doing GroupMoveAbsolute ! ']) ;
return ;
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
global motorZ waitabit zlimL zlimH socketID positioner3;
motorZ=str2double(get(hObject,'String'));
if motorZ>=zlimL && motorZ<=zlimH
    [errorCode] = GroupMoveAbsolute(socketID, positioner3, motorZ) ;
    if (errorCode ~= 0)
        disp (['Error ' num2str(errorCode) ' occurred while doing GroupMoveAbsolute ! ']) ;
        return ;
    end
    pause(waitabit);
else
%     motorZ=zlim;
    msgbox('zlimit error!');
%     set(handles.zPosition,'String',num2str(motorZ,'%6.4f'));
%     [errorCode] = GroupMoveAbsolute(socketID, positioner3, motorZ) ;
%     if (errorCode ~= 0)
%         disp (['Error ' num2str(errorCode) ' occurred while doing GroupMoveAbsolute ! ']) ;
%         return ;
%     end
    pause(waitabit);
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
global socketID;
TCP_CloseSocket(socketID) ;
disp('socket closed')


% --- Executes on button press in Up.
function Up_Callback(hObject, eventdata, handles)
% hObject    handle to Up (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%% update motor position and display;
global dz motorZ waitabit zlimL zlimH socketID positioner3;
motorZ=motorZ-dz; %sample up is to reduce z value;
set(handles.zPosition,'String',num2str(motorZ,'%6.4f'));
%% move motor;
if motorZ>=zlimL &&  motorZ<=zlimH
    [errorCode] = GroupMoveAbsolute(socketID, positioner3, motorZ) ;
    if (errorCode ~= 0)
        disp (['Error ' num2str(errorCode) ' occurred while doing GroupMoveAbsolute ! ']) ;
        return ;
    end
    pause(waitabit);
else
%     motorZ=zlim;
%     set(handles.zPosition,'String',num2str(motorZ,'%6.4f'));
    msgbox('zlimit error!');
%     [errorCode] = GroupMoveAbsolute(socketID, positioner3, motorZ) ;
%     if (errorCode ~= 0)
%         disp (['Error ' num2str(errorCode) ' occurred while doing GroupMoveAbsolute ! ']) ;
%         return ;
%     end
%     pause(waitabit);
end
% --- Executes on button press in Down.
function Down_Callback(hObject, eventdata, handles)
% hObject    handle to Down (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

%% update motor position and display;
global dz motorZ waitabit zlimL zlimH socketID positioner3;
motorZ=motorZ+dz; %sample down is to reduce z value;
set(handles.zPosition,'String',num2str(motorZ,'%6.4f'));
%% move motor;
if motorZ>=zlimL &&  motorZ<=zlimH
    [errorCode] = GroupMoveAbsolute(socketID, positioner3, motorZ) ;
    if (errorCode ~= 0)
        disp (['Error ' num2str(errorCode) ' occurred while doing GroupMoveAbsolute ! ']) ;
        return ;
    end
    pause(waitabit);
else
%     motorZ=zlim;
%     set(handles.zPosition,'String',num2str(motorZ,'%6.4f'));
    msgbox('zlimit error!');
%     [errorCode] = GroupMoveAbsolute(socketID, positioner3, motorZ) ;
%     if (errorCode ~= 0)
%         disp (['Error ' num2str(errorCode) ' occurred while doing GroupMoveAbsolute ! ']) ;
%         return ;
%     end
%     pause(waitabit);
end

% --- Executes on button press in West.
function West_Callback(hObject, eventdata, handles)
% hObject    handle to West (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

%% update motor position and display;
global dr motorX motorY rAngle waitabit socketID positioner1 positioner2;
motorX=motorX-dr*cos(rAngle/180*pi);
motorY=motorY-dr*sin(rAngle/180*pi);
set(handles.xPosition,'String',num2str(motorX,'%6.4f'));
set(handles.yPosition,'String',num2str(motorY,'%6.4f'));
%% move motor;
[errorCode] = GroupMoveAbsolute(socketID, positioner1, motorX) ;
if (errorCode ~= 0)
    disp (['Error ' num2str(errorCode) ' occurred while doing GroupMoveAbsolute ! ']) ;
    return ;
end
pause(waitabit);

[errorCode] = GroupMoveAbsolute(socketID, positioner2, motorY) ;
if (errorCode ~= 0)
    disp (['Error ' num2str(errorCode) ' occurred while doing GroupMoveAbsolute ! ']) ;
    return ;
end
pause(waitabit);



% --- Executes on button press in North.
function North_Callback(hObject, eventdata, handles)
% hObject    handle to North (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%% update motor position and display;
global dr motorX motorY rAngle waitabit socketID positioner1 positioner2;
motorX=motorX-dr*sin(rAngle/180*pi);
motorY=motorY+dr*cos(rAngle/180*pi);
set(handles.xPosition,'String',num2str(motorX,'%6.4f'));
set(handles.yPosition,'String',num2str(motorY,'%6.4f'));
%% move motor;
[errorCode] = GroupMoveAbsolute(socketID, positioner1, motorX) ;
if (errorCode ~= 0)
    disp (['Error ' num2str(errorCode) ' occurred while doing GroupMoveAbsolute ! ']) ;
    return ;
end
pause(waitabit);

[errorCode] = GroupMoveAbsolute(socketID, positioner2, motorY) ;
if (errorCode ~= 0)
    disp (['Error ' num2str(errorCode) ' occurred while doing GroupMoveAbsolute ! ']) ;
    return ;
end
pause(waitabit);


% --- Executes on button press in South.
function South_Callback(hObject, eventdata, handles)
% hObject    handle to South (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%% update motor position and display;
global dr motorX motorY rAngle waitabit socketID positioner1 positioner2;
motorX=motorX+dr*sin(rAngle/180*pi);
motorY=motorY-dr*cos(rAngle/180*pi);
set(handles.xPosition,'String',num2str(motorX,'%6.4f'));
set(handles.yPosition,'String',num2str(motorY,'%6.4f'));
%% move motor;
[errorCode] = GroupMoveAbsolute(socketID, positioner1, motorX) ;
if (errorCode ~= 0)
    disp (['Error ' num2str(errorCode) ' occurred while doing GroupMoveAbsolute ! ']) ;
    return ;
end
pause(waitabit);

[errorCode] = GroupMoveAbsolute(socketID, positioner2, motorY) ;
if (errorCode ~= 0)
    disp (['Error ' num2str(errorCode) ' occurred while doing GroupMoveAbsolute ! ']) ;
    return ;
end
pause(waitabit);

% --- Executes on button press in East.
function East_Callback(hObject, eventdata, handles)
% hObject    handle to East (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%% update motor position and display;
global s2 dr motorX motorY rAngle waitabit socketID positioner1 positioner2;
motorX=motorX+dr*cos(rAngle/180*pi);
motorY=motorY+dr*sin(rAngle/180*pi);
set(handles.xPosition,'String',num2str(motorX,'%6.4f'));
set(handles.yPosition,'String',num2str(motorY,'%6.4f'));
%% move motor;
[errorCode] = GroupMoveAbsolute(socketID, positioner1, motorX) ;
if (errorCode ~= 0)
    disp (['Error ' num2str(errorCode) ' occurred while doing GroupMoveAbsolute ! ']) ;
    return ;
end
pause(waitabit);

[errorCode] = GroupMoveAbsolute(socketID, positioner2, motorY) ;
if (errorCode ~= 0)
    disp (['Error ' num2str(errorCode) ' occurred while doing GroupMoveAbsolute ! ']) ;
    return ;
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

%global s2;
%fprintf(s2,'EX JOYSTICK ON');
disp('empty for XPS controller');

% --- Executes on button press in manualOff.
function manualOff_Callback(hObject, eventdata, handles)
% hObject    handle to manualOff (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

%global s2;
%fprintf(s2,'EX JOYSTICK OFF');
disp('empty for XPS controller');



function zlimL_Callback(hObject, eventdata, handles)
% hObject    handle to zlimL (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of zlimL as text
%        str2double(get(hObject,'String')) returns contents of zlimL as a double
global zlimL;
zlimL=str2double(get(hObject,'String'));

% --- Executes during object creation, after setting all properties.
function zlimL_CreateFcn(hObject, eventdata, handles)
% hObject    handle to zlimL (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in updatexyz.
function updatexyz_Callback(hObject, eventdata, handles)
% hObject    handle to updatexyz (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

global waitabit motorX motorY motorZ socketID positioner1 positioner2 positioner3;
%% ask for current locations;
[errorCode, currentPosition] = GroupPositionCurrentGet(socketID, positioner1, 1) ;
if (errorCode ~= 0)
    disp (['Error ' num2str(errorCode) ' occurred while doing GroupPositionCurrentGet! ']) ;
    return ;
else
    motorX=currentPosition;
end

[errorCode, currentPosition] = GroupPositionCurrentGet(socketID, positioner2, 1) ;
if (errorCode ~= 0)
    disp (['Error ' num2str(errorCode) ' occurred while doing GroupPositionCurrentGet! ']) ;
    return ;
else
    motorY=currentPosition;
end

[errorCode, currentPosition] = GroupPositionCurrentGet(socketID, positioner3, 1) ;
if (errorCode ~= 0)
    disp (['Error ' num2str(errorCode) ' occurred while doing GroupPositionCurrentGet! ']) ;
    return ;
else
    motorZ=currentPosition;
end
%% update xyz positions;
set(handles.xPosition,'String',num2str(motorX,'%6.4f'));
set(handles.yPosition,'String',num2str(motorY,'%6.4f'));
set(handles.zPosition,'String',num2str(motorZ,'%6.4f'));



function deltaX_Callback(hObject, eventdata, handles)
% hObject    handle to deltaX (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of deltaX as text
%        str2double(get(hObject,'String')) returns contents of deltaX as a double
global deltaX;
deltaX=str2double(get(hObject,'String'));


% --- Executes during object creation, after setting all properties.
function deltaX_CreateFcn(hObject, eventdata, handles)
% hObject    handle to deltaX (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function deltaY_Callback(hObject, eventdata, handles)
% hObject    handle to deltaY (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of deltaY as text
%        str2double(get(hObject,'String')) returns contents of deltaY as a double
global deltaY;
deltaY=str2double(get(hObject,'String'));

% --- Executes during object creation, after setting all properties.
function deltaY_CreateFcn(hObject, eventdata, handles)
% hObject    handle to deltaY (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function Range_Callback(hObject, eventdata, handles)
% hObject    handle to Range (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Range as text
%        str2double(get(hObject,'String')) returns contents of Range as a double
global Range;
Range=str2double(get(hObject,'String'));

% --- Executes during object creation, after setting all properties.
function Range_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Range (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function Rounds_Callback(hObject, eventdata, handles)
% hObject    handle to Rounds (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Rounds as text
%        str2double(get(hObject,'String')) returns contents of Rounds as a double
global Rounds;
Rounds=str2double(get(hObject,'String'));

% --- Executes during object creation, after setting all properties.
function Rounds_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Rounds (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function deltaZ_Callback(hObject, eventdata, handles)
% hObject    handle to deltaZ (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of deltaZ as text
%        str2double(get(hObject,'String')) returns contents of deltaZ as a double
global deltaZ;
deltaZ=str2double(get(hObject,'String'));

% --- Executes during object creation, after setting all properties.
function deltaZ_CreateFcn(hObject, eventdata, handles)
% hObject    handle to deltaZ (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in zigzag_move.
function zigzag_move_Callback(hObject, eventdata, handles)
% hObject    handle to zigzag_move (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global deltaX deltaY deltaZ Range Rounds motorX motorY motorZ waitabit socketID zlimL zlimH group;
dgx=Range*deltaX/sqrt(deltaX^2+deltaY^2);
dgy=Range*deltaY/sqrt(deltaX^2+deltaY^2);
dgz=deltaZ/Rounds;
for ii=1:Rounds
    if rem(ii,2)==1
        if (motorZ-dgz)>=zlimL &&  (motorZ-dgz)<=zlimH
            motorX=motorX-dgx;
            motorY=motorY-dgy;
            motorZ=motorZ+dgz;
            [errorCode] = GroupMoveAbsolute(socketID, group, [motorX,motorY,motorZ]) ;
            if (errorCode ~= 0)
                disp (['Error ' num2str(errorCode) ' occurred while doing GroupMoveAbsolute ! ']) ;
                return ;
            end
%             pause(waitabit);
%             set(handles.xPosition,'String',num2str(motorX,'%6.4f'));
%             set(handles.yPosition,'String',num2str(motorY,'%6.4f'));
%             set(handles.zPosition,'String',num2str(motorZ,'%6.4f'));
        else
            msgbox('zlimit error!');
        end
    else
        if (motorZ-dgz)>=zlimL &&  (motorZ-dgz)<=zlimH
            motorX=motorX+dgx;
            motorY=motorY+dgy;
            motorZ=motorZ+dgz;
            [errorCode] = GroupMoveAbsolute(socketID, group, [motorX,motorY,motorZ]) ;
            if (errorCode ~= 0)
                disp (['Error ' num2str(errorCode) ' occurred while doing GroupMoveAbsolute ! ']) ;
                return ;
            end
%             pause(waitabit);
%             set(handles.xPosition,'String',num2str(motorX,'%6.4f'));
%             set(handles.yPosition,'String',num2str(motorY,'%6.4f'));
%             set(handles.zPosition,'String',num2str(motorZ,'%6.4f'));
        else
            msgbox('zlimit error!');
        end
    end
end
set(handles.xPosition,'String',num2str(motorX,'%6.4f'));
set(handles.yPosition,'String',num2str(motorY,'%6.4f'));
set(handles.zPosition,'String',num2str(motorZ,'%6.4f'));




function zlimH_Callback(hObject, eventdata, handles)
% hObject    handle to zlimH (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of zlimH as text
%        str2double(get(hObject,'String')) returns contents of zlimH as a double
global zlimH;
zlimH=str2double(get(hObject,'String'));

% --- Executes during object creation, after setting all properties.
function zlimH_CreateFcn(hObject, eventdata, handles)
% hObject    handle to zlimH (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
