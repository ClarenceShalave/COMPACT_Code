function varargout = xpsCOMPACT(varargin)
% XPSCOMPACT MATLAB code for xpsCOMPACT.fig
%      XPSCOMPACT, by itself, creates a new XPSCOMPACT or raises the existing
%      singleton*.
%
%      H = XPSCOMPACT returns the handle to a new XPSCOMPACT or the handle to
%      the existing singleton*.
%
%      XPSCOMPACT('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in XPSCOMPACT.M with the given input arguments.
%
%      XPSCOMPACT('Property','Value',...) creates a new XPSCOMPACT or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before xpsCOMPACT_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to xpsCOMPACT_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help xpsCOMPACT

% Last Modified by GUIDE v2.5 24-Jul-2020 10:53:44

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
    'gui_Singleton',  gui_Singleton, ...
    'gui_OpeningFcn', @xpsCOMPACT_OpeningFcn, ...
    'gui_OutputFcn',  @xpsCOMPACT_OutputFcn, ...
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


% --- Executes just before xpsCOMPACT is made visible.
function xpsCOMPACT_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to xpsCOMPACT (see VARARGIN)

% Choose default command line output for xpsCOMPACT
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes xpsCOMPACT wait for user response (see UIRESUME)
% uiwait(handles.figure1);
global coefficients_path
coefficients_path='G:\COMPACT\coefficients\';
%% set up motor connection;
addpath('G:\COMPACT\code\xpsmotor2\Matlabxps64bit')
xps_load_drivers;
global waitabit motorX motorY motorZ rAngle dz dr zlimH zlimL;
waitabit=0.1;
zlimL=-10;% in mm;
zlimH=12.5; % in mm;
rAngle=0;% in degree;
dz=0.02;% in mm;
dr=0.02;% in mm;
% establish communicatino with the controller;
global IP Port TimeOut socketID;  % parameters for connection
%IP = '128.46.90.231' ;
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

% use the updated name shown in the controller on 6/12/17;
group = 'XYZ' ;
positioner1 = 'XYZ.X' ;
positioner2 = 'XYZ.Y' ;
positioner3 = 'XYZ.Z' ;

% get current position
% x
[errorCode, currentPosition] = GroupPositionCurrentGet(socketID, positioner1, 1) ;
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

set(handles.zlimH,'String',num2str(zlimH,'%6.1f'));
set(handles.zlimL,'String',num2str(zlimL,'%6.1f'));

% --- Outputs from this function are returned to the command line.
function varargout = xpsCOMPACT_OutputFcn(hObject, eventdata, handles)
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
global motorZ waitabit zlimH zlimL socketID positioner3;
motorZ=str2double(get(hObject,'String'));
if motorZ>=zlimL &&  motorZ<=zlimH
    [errorCode] = GroupMoveAbsolute(socketID, positioner3, motorZ) ;
    if (errorCode ~= 0)
        disp (['Error ' num2str(errorCode) ' occurred while doing GroupMoveAbsolute ! ']) ;
        return ;
    end
    pause(waitabit);
else
    %motorZ=zlim;
    msgbox('zlimit error!');
    %set(handles.zPosition,'String',num2str(motorZ,'%6.4f'));
    %     [errorCode] = GroupMoveAbsolute(socketID, positioner3, motorZ) ;
    %     if (errorCode ~= 0)
    %         disp (['Error ' num2str(errorCode) ' occurred while doing GroupMoveAbsolute ! ']) ;
    %         return ;
    %     end
    %     pause(waitabit);
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



% --- Executes on button press in Up.
function Up_Callback(hObject, eventdata, handles)
% hObject    handle to Up (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%% update motor position and display;
global dz motorZ waitabit zlimH zlimL socketID positioner3;
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
    %motorZ=zlim;
    msgbox('zlimit error!');
    %set(handles.zPosition,'String',num2str(motorZ,'%6.4f'));
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
    %motorZ=zlim;
    msgbox('zlimit error!');
    %set(handles.zPosition,'String',num2str(motorZ,'%6.4f'));
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
global dr motorX motorY rAngle waitabit socketID positioner1 positioner2;
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



function gx_Callback(hObject, eventdata, handles)
% hObject    handle to gx (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of gx as text
%        str2double(get(hObject,'String')) returns contents of gx as a double
global gx;
gx=str2double(get(hObject,'String'));


% --- Executes during object creation, after setting all properties.
function gx_CreateFcn(hObject, eventdata, handles)
% hObject    handle to gx (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function gy_Callback(hObject, eventdata, handles)
% hObject    handle to gy (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of gy as text
%        str2double(get(hObject,'String')) returns contents of gy as a double
global gy;
gy=str2double(get(hObject,'String'));


% --- Executes during object creation, after setting all properties.
function gy_CreateFcn(hObject, eventdata, handles)
% hObject    handle to gy (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function gz_Callback(hObject, eventdata, handles)
% hObject    handle to gz (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of gz as text
%        str2double(get(hObject,'String')) returns contents of gz as a double
global gz;
gz=str2double(get(hObject,'String'));


% --- Executes during object creation, after setting all properties.
function gz_CreateFcn(hObject, eventdata, handles)
% hObject    handle to gz (see GCBO)
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
global gx gy gz dL motorX motorY motorZ waitabit zlimL zlimH socketID group;
dgx=dL*gx/sqrt(gx^2+gy^2+gz^2);
dgy=dL*gy/sqrt(gx^2+gy^2+gz^2);
dgz=dL*gz/sqrt(gx^2+gy^2+gz^2);
if (motorZ-dgz)>=zlimL &&  (motorZ-dgz)<=zlimH
    motorX=motorX-dgx;
    motorY=motorY-dgy;
    motorZ=motorZ-dgz;
    [errorCode] = GroupMoveAbsolute(socketID, group, [motorX,motorY,motorZ]) ;
    if (errorCode ~= 0)
        disp (['Error ' num2str(errorCode) ' occurred while doing GroupMoveAbsolute ! ']) ;
        return ;
    end
    pause(waitabit);
    set(handles.xPosition,'String',num2str(motorX,'%6.4f'));
    set(handles.yPosition,'String',num2str(motorY,'%6.4f'));
    set(handles.zPosition,'String',num2str(motorZ,'%6.4f'));
else
    msgbox('zlimit error!');
end


% --- Executes on button press in group_down.
function group_down_Callback(hObject, eventdata, handles)
% hObject    handle to group_down (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global gx gy gz dL motorX motorY motorZ waitabit zlimL zlimH socketID group;
dgx=dL*gx/sqrt(gx^2+gy^2+gz^2);
dgy=dL*gy/sqrt(gx^2+gy^2+gz^2);
dgz=dL*gz/sqrt(gx^2+gy^2+gz^2);
if (motorZ+dgz)>=zlimL &&  (motorZ+dgz)<=zlimH
    motorX=motorX+dgx;
    motorY=motorY+dgy;
    motorZ=motorZ+dgz;
    [errorCode] = GroupMoveAbsolute(socketID, group, [motorX,motorY,motorZ]) ;
    if (errorCode ~= 0)
        disp (['Error ' num2str(errorCode) ' occurred while doing GroupMoveAbsolute ! ']) ;
        return ;
    end
    pause(waitabit);
    set(handles.xPosition,'String',num2str(motorX,'%6.4f'));
    set(handles.yPosition,'String',num2str(motorY,'%6.4f'));
    set(handles.zPosition,'String',num2str(motorZ,'%6.4f'));
else
    msgbox('zlimit error!');
end



function dL_Callback(hObject, ~, handles)
% hObject    handle to dL (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of dL as text
%        str2double(get(hObject,'String')) returns contents of dL as a double
global dL;
dL=str2double(get(hObject,'String'));


% --- Executes during object creation, after setting all properties.
function dL_CreateFcn(hObject, eventdata, handles)
% hObject    handle to dL (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in stop.
function stop_Callback(hObject, eventdata, handles)
% hObject    handle to stop (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global socketID group waitabit;
[errorCode] = GroupMoveAbort(socketID, group);
if (errorCode ~= 0)
    disp (['Error ' num2str(errorCode) ' occurred while doing GroupMoveAbort ! ']) ;
    return ;
end
pause(waitabit);


% --- Executes on button press in close.
function close_Callback(hObject, eventdata, handles)
% hObject    handle to close (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% global socketID
% TCP_CloseSocket(socketID) ;


% --- Executes on button press in window2_ini.
function window2_ini_Callback(hObject, eventdata, handles)
% hObject    handle to window2_ini (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global window2
window2 = Screen('OpenWindow',2);


% --- Executes on button press in rotstage_ini.
function rotstage_ini_Callback(hObject, eventdata, handles)
% hObject    handle to rotstage_ini (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%% set up grin rotation stage;
global Controller axisname
if(~exist('Controller'))
    Controller = PI_GCS_Controller();
end;
if(~isa(Controller,'PI_GCS_Controller'))
    Controller = PI_GCS_Controller();
end;
comPort = 4;
% to change the baud rate, need to restart the controller. (power off, on);
if(~Controller.IsConnected)
    Controller = Controller.ConnectRS232(comPort,115200);
    Controller = Controller.InitializeController();
end
% query controller identification
disp(Controller.qIDN());
% query axes
availableaxes = Controller.qSAI_ALL();
if(isempty(availableaxes))
    return;
end
axisname = availableaxes(1);
% connect a stage
disp(Controller.qCST(axisname));
% switch on servo and search reference switch to reference stage
Controller.SVO(axisname,1);
disp( Controller.qSVO(axisname));
Controller.FRF(axisname);
% wait for Referencing to finish
bReferencing=1;
while(bReferencing)
    pause(0.1);
    bReferencing = (Controller.qFRF(axisname)==0);
end
msgbox('done');

% --- Executes on button press in pico_ini.
function pico_ini_Callback(hObject, eventdata, handles)
% hObject    handle to pico_ini (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%% set up picomotor;
global spico picoStepSize
spico = serial('COM1','BaudRate',19200,'DataBits',8,'Parity', 'NONE','StopBits', 1);
fopen(spico);pause(0.5);
spico.Terminator = 'CR';
% turn on motor; enable closed loop control;
fprintf(spico,'mon');% motor on;
pause (1);
fprintf(spico,'SER a1');% enable close loop, otherwise, ABS is relative motion;
% define motor speed;
pause (0.5);
fprintf(spico,'vel a1 2000');% set speed;
% ask acceleration;
pause(0.5);
fprintf(spico,'acc');out = fscanf(spico);disp(out);
pause(0.5);
% ask velocity;
fprintf(spico,'vel a1');out = fscanf(spico);disp(out);
pause(0.5);

% load([coefficients_path,'pico_current_position.mat']);
% fprintf(spico,['POS a1 ',num2str(pico_current_position)]); % set current position;
% current_pico_id=find(pico_positions==pico_current_position);
pause(0.5);
fprintf(spico,'POS a1');out = fscanf(spico);disp(out);
picoStepSize=0.0635e-3;% unit mm;
msgbox('done');

% --- Executes on button press in coeff_ini.
function coeff_ini_Callback(hObject, eventdata, handles)
% hObject    handle to coeff_ini (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global coefficients_path probe_number slmphase voltagearray f_defocusscale pico_D pico_id_position_matrix pico_positions offset_x offset_y Maberration
global x y pixelsize n f centerx0 centery0 lambda
%% import voltage array data;
load([coefficients_path,'voltagearray930nm.mat']);
load([coefficients_path,'slmphase930nm.mat']);
load([coefficients_path,'probe',num2str(probe_number),'\','pico_positions.mat']);
load([coefficients_path,'probe',num2str(probe_number),'\','defocus_scale.mat']);
load([coefficients_path,'probe',num2str(probe_number),'\','xy_offset.mat']);
% load([coefficients_path,'probe',num2str(probe_number),'\','f_zoom.mat']);
guidata(hObject, handles);
%% load the base phase and correction phase;
nx=size(slmphase,2);
ny=size(slmphase,1);
Maberration=[];

% blocknx=24;
% blockny=20;
% for q=100:100:100
%     load([coefficients_path,'probe',num2str(probe_number),'\','finalphase',num2str(q),'.mat']);
%     aberration=Expand(finalphase, nx/blocknx, ny/blockny);
%     aberration=finalphase;
%     Maberration=cat(3,Maberration, aberration);
% end

load([coefficients_path,'probe',num2str(probe_number),'\','finalphase','.mat']);
blocknx=size(finalphase,2);
blockny=size(finalphase,1);
for q=1:size(finalphase,3)
    aberration=Expand(finalphase(:,:,q), nx/blocknx, ny/blockny);
    Maberration=cat(3,Maberration, aberration);
end

%% prepare defocusing wavefront;
x=1:792;
y=1:600;
pixelsize=0.04/3;
n=1.33;
f=180/20;
lambda=0.93;% unit micron;
centerx0=386;
centery0=302;
msgbox('done');
% --- Executes on button press in open_scanimage.
function open_scanimage_Callback(hObject, eventdata, handles)
% hObject    handle to open_scanimage (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
scanimage



function wd_Callback(hObject, eventdata, handles)
% hObject    handle to wd (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of wd as text
%        str2double(get(hObject,'String')) returns contents of wd as a double
global waitabit motorX motorY motorZ rAngle dz dr zlimH zlimL gx gy gz;
global IP Port TimeOut socketID;
global group positioner1 positioner2 positioner3; % parameters for controlling
global coefficients_path probe_number slmphase voltagearray f_defocusscale pico_D pico_id_position_matrix pico_positions offset_x offset_y Maberration
global x y pixelsize n f centerx0 centery0 lambda
global wd spico picoStepSize
global window2
global outputphase
wd=str2double(get(handles.wd,'String'));
wd_limit1=str2double(get(handles.wd_limit1,'String'));
wd_limit2=str2double(get(handles.wd_limit2,'String'));
wd_step=str2double(get(handles.wd_step,'String'));
if wd>=wd_limit1 &&  wd<=wd_limit2
    load([coefficients_path,'pico_current_position.mat']);
    current_pico_id=find(pico_positions==pico_current_position);
    pico_id=pico_id_position_matrix(find( pico_id_position_matrix==wd),2);
    if pico_id==current_pico_id
    else
        diff_sign=sign(pico_id-current_pico_id);
        for pico_n=(current_pico_id+diff_sign):diff_sign:pico_id
            pico_movedistance=picoStepSize*(pico_positions(pico_n)-pico_positions(current_pico_id));
            fprintf(spico,['ABS a1=',num2str(pico_positions(pico_n)),' g']);
            move_distance=pico_movedistance/15;
            for j=1:15
                dgx=move_distance*gx/gz;
                dgy=move_distance*gy/gz;
                dgz=move_distance;
                if (motorZ+dgz)>=zlimL &&  (motorZ+dgz)<=zlimH
                    motorX=motorX-dgx;
                    motorY=motorY-dgy;
                    motorZ=motorZ-dgz;
                    [errorCode] = GroupMoveAbsolute(socketID, group, [motorX,motorY,motorZ]) ;
                    if (errorCode ~= 0)
                        disp (['Error ' num2str(errorCode) ' occurred while doing GroupMoveAbsolute ! ']) ;
                        return ;
                    end
                    pause(waitabit);
                else
                    msgbox('zlimit error!');
                end
                pause(0.1);
                
            end
            pico_current_position=pico_positions(pico_n);
            current_pico_id=find(pico_positions==pico_current_position);
            
        end
        save([coefficients_path,'pico_current_position.mat'],'pico_current_position');
        current_pico_id=pico_id;
    end
    defocus_distance=round((wd-pico_D(pico_id))/f_defocusscale(wd));
    aberration=Maberration(:,:,pico_id);
    centerx=centerx0+offset_x(pico_id)+0;
    centery=centery0+offset_y(pico_id)+0;
    hx=(x-centerx)*pixelsize;
    hy=(y-centery)*pixelsize;
    xNA=hx/f;
    yNA=hy/f;
    [XNA, YNA]=meshgrid(xNA, yNA);
    XYNA=sqrt(XNA.^2+YNA.^2);
    theta=asin(XYNA/n);
    defocus_wavefront=defocus_distance*n*cos(theta)/lambda*2*pi;
    if defocus_distance>0
        defocus_wavefront=defocus_wavefront-max(defocus_wavefront(:));
    else
        defocus_wavefront=defocus_wavefront-min(defocus_wavefront(:));
    end
    outputphase=angle(exp(1i*(aberration+defocus_wavefront-slmphase)))+1.1*pi;% shift minimum to above 0;
    for k1=1:10
        for k2=1:12
            phaseblock=outputphase((k1-1)*60+1:(k1-1)*60+60,(k2-1)*66+1:(k2-1)*66+66);
            vblock=voltagearray(k1,k2,1)*phaseblock.^6 + voltagearray(k1,k2,2)*phaseblock.^5 + voltagearray(k1,k2,3)*phaseblock.^4 + voltagearray(k1,k2,4)*phaseblock.^3+voltagearray(k1,k2,5)*phaseblock.^2+voltagearray(k1,k2,6)*phaseblock.^1;
            vout((k1-1)*60+1:(k1-1)*60+60,(k2-1)*66+1:(k2-1)*66+66)=vblock;
        end
    end
    vout=uint8(vout);
    Screen(window2, 'PutImage',vout);Screen(window2,'Flip');
else
    msgbox('wd error!');
end


% --- Executes during object creation, after setting all properties.
function wd_CreateFcn(hObject, eventdata, handles)
% hObject    handle to wd (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in wd_plus.
function wd_plus_Callback(hObject, eventdata, handles)
% hObject    handle to wd_plus (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global waitabit motorX motorY motorZ rAngle dz dr zlimH zlimL gx gy gz;
global IP Port TimeOut socketID;
global group positioner1 positioner2 positioner3; % parameters for controlling
global coefficients_path probe_number slmphase voltagearray f_defocusscale pico_D pico_id_position_matrix pico_positions offset_x offset_y Maberration
global x y pixelsize n f centerx0 centery0 lambda
global wd spico picoStepSize
global window2
global outputphase
wd=str2double(get(handles.wd,'String'));
wd_limit1=str2double(get(handles.wd_limit1,'String'));
wd_limit2=str2double(get(handles.wd_limit2,'String'));
wd_step=str2double(get(handles.wd_step,'String'));
if wd+wd_step>=wd_limit1 &&  wd+wd_step<=wd_limit2
    wd=wd+wd_step;
    load([coefficients_path,'pico_current_position.mat']);
    current_pico_id=find(pico_positions==pico_current_position);
    pico_id=pico_id_position_matrix(find( pico_id_position_matrix==wd),2);
    if pico_id==current_pico_id
    else
        diff_sign=sign(pico_id-current_pico_id);
        for pico_n=(current_pico_id+diff_sign):diff_sign:pico_id
            pico_movedistance=picoStepSize*(pico_positions(pico_n)-pico_positions(current_pico_id));
            fprintf(spico,['ABS a1=',num2str(pico_positions(pico_n)),' g']);
            move_distance=pico_movedistance/15;
            for j=1:15
                dgx=move_distance*gx/gz;
                dgy=move_distance*gy/gz;
                dgz=move_distance;
                if (motorZ+dgz)>=zlimL &&  (motorZ+dgz)<=zlimH
                    motorX=motorX-dgx;
                    motorY=motorY-dgy;
                    motorZ=motorZ-dgz;
                    [errorCode] = GroupMoveAbsolute(socketID, group, [motorX,motorY,motorZ]) ;
                    if (errorCode ~= 0)
                        disp (['Error ' num2str(errorCode) ' occurred while doing GroupMoveAbsolute ! ']) ;
                        return ;
                    end
                    pause(waitabit);
                else
                    msgbox('zlimit error!');
                end
                pause(0.1);
                
            end
            pico_current_position=pico_positions(pico_n);
            current_pico_id=find(pico_positions==pico_current_position);
            
        end
        save([coefficients_path,'pico_current_position.mat'],'pico_current_position');
        current_pico_id=pico_id;
    end
    defocus_distance=round((wd-pico_D(pico_id))/f_defocusscale(wd));
    aberration=Maberration(:,:,pico_id);
    centerx=centerx0+offset_x(pico_id)+0;
    centery=centery0+offset_y(pico_id)+0;
    hx=(x-centerx)*pixelsize;
    hy=(y-centery)*pixelsize;
    xNA=hx/f;
    yNA=hy/f;
    [XNA, YNA]=meshgrid(xNA, yNA);
    XYNA=sqrt(XNA.^2+YNA.^2);
    theta=asin(XYNA/n);
    defocus_wavefront=defocus_distance*n*cos(theta)/lambda*2*pi;
    if defocus_distance>0
        defocus_wavefront=defocus_wavefront-max(defocus_wavefront(:));
    else
        defocus_wavefront=defocus_wavefront-min(defocus_wavefront(:));
    end
    outputphase=angle(exp(1i*(aberration+defocus_wavefront-slmphase)))+1.1*pi;% shift minimum to above 0;
    for k1=1:10
        for k2=1:12
            phaseblock=outputphase((k1-1)*60+1:(k1-1)*60+60,(k2-1)*66+1:(k2-1)*66+66);
            vblock=voltagearray(k1,k2,1)*phaseblock.^6 + voltagearray(k1,k2,2)*phaseblock.^5 + voltagearray(k1,k2,3)*phaseblock.^4 + voltagearray(k1,k2,4)*phaseblock.^3+voltagearray(k1,k2,5)*phaseblock.^2+voltagearray(k1,k2,6)*phaseblock.^1;
            vout((k1-1)*60+1:(k1-1)*60+60,(k2-1)*66+1:(k2-1)*66+66)=vblock;
        end
    end
    vout=uint8(vout);
    Screen(window2, 'PutImage',vout);Screen(window2,'Flip');
    set(handles.wd,'String',num2str(wd));
    guidata(hObject,handles);
else
    msgbox('wd error!');
end


% --- Executes on button press in wd_minus.
function wd_minus_Callback(hObject, eventdata, handles)
% hObject    handle to wd_minus (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global waitabit motorX motorY motorZ rAngle dz dr zlimH zlimL gx gy gz;
global IP Port TimeOut socketID;
global group positioner1 positioner2 positioner3; % parameters for controlling
global coefficients_path probe_number slmphase voltagearray f_defocusscale pico_D pico_id_position_matrix pico_positions offset_x offset_y Maberration
global x y pixelsize n f centerx0 centery0 lambda
global wd spico picoStepSize
global window2
global outputphase
wd=str2double(get(handles.wd,'String'));
wd_limit1=str2double(get(handles.wd_limit1,'String'));
wd_limit2=str2double(get(handles.wd_limit2,'String'));
wd_step=str2double(get(handles.wd_step,'String'));
if wd-wd_step>=wd_limit1 &&  wd-wd_step<=wd_limit2
    wd=wd-wd_step;
    load([coefficients_path,'pico_current_position.mat']);
    current_pico_id=find(pico_positions==pico_current_position);
    pico_id=pico_id_position_matrix(find( pico_id_position_matrix==wd),2);
    if pico_id==current_pico_id
    else
        diff_sign=sign(pico_id-current_pico_id);
        for pico_n=(current_pico_id+diff_sign):diff_sign:pico_id
            pico_movedistance=picoStepSize*(pico_positions(pico_n)-pico_positions(current_pico_id));
            fprintf(spico,['ABS a1=',num2str(pico_positions(pico_n)),' g']);
            move_distance=pico_movedistance/15;
            for j=1:15
                dgx=move_distance*gx/gz;
                dgy=move_distance*gy/gz;
                dgz=move_distance;
                if (motorZ+dgz)>=zlimL &&  (motorZ+dgz)<=zlimH
                    motorX=motorX-dgx;
                    motorY=motorY-dgy;
                    motorZ=motorZ-dgz;
                    [errorCode] = GroupMoveAbsolute(socketID, group, [motorX,motorY,motorZ]) ;
                    if (errorCode ~= 0)
                        disp (['Error ' num2str(errorCode) ' occurred while doing GroupMoveAbsolute ! ']) ;
                        return ;
                    end
                    pause(waitabit);
                else
                    msgbox('zlimit error!');
                end
                pause(0.1);
                
            end
            pico_current_position=pico_positions(pico_n);
            current_pico_id=find(pico_positions==pico_current_position);
            
        end
        save([coefficients_path,'pico_current_position.mat'],'pico_current_position');
        current_pico_id=pico_id;
    end
    defocus_distance=round((wd-pico_D(pico_id))/f_defocusscale(wd));
    aberration=Maberration(:,:,pico_id);
    centerx=centerx0+offset_x(pico_id)+0;
    centery=centery0+offset_y(pico_id)+0;
    hx=(x-centerx)*pixelsize;
    hy=(y-centery)*pixelsize;
    xNA=hx/f;
    yNA=hy/f;
    [XNA, YNA]=meshgrid(xNA, yNA);
    XYNA=sqrt(XNA.^2+YNA.^2);
    theta=asin(XYNA/n);
    defocus_wavefront=defocus_distance*n*cos(theta)/lambda*2*pi;
    if defocus_distance>0
        defocus_wavefront=defocus_wavefront-max(defocus_wavefront(:));
    else
        defocus_wavefront=defocus_wavefront-min(defocus_wavefront(:));
    end
    outputphase=angle(exp(1i*(aberration+defocus_wavefront-slmphase)))+1.1*pi;% shift minimum to above 0;
    for k1=1:10
        for k2=1:12
            phaseblock=outputphase((k1-1)*60+1:(k1-1)*60+60,(k2-1)*66+1:(k2-1)*66+66);
            vblock=voltagearray(k1,k2,1)*phaseblock.^6 + voltagearray(k1,k2,2)*phaseblock.^5 + voltagearray(k1,k2,3)*phaseblock.^4 + voltagearray(k1,k2,4)*phaseblock.^3+voltagearray(k1,k2,5)*phaseblock.^2+voltagearray(k1,k2,6)*phaseblock.^1;
            vout((k1-1)*60+1:(k1-1)*60+60,(k2-1)*66+1:(k2-1)*66+66)=vblock;
        end
    end
    vout=uint8(vout);
    Screen(window2, 'PutImage',vout);Screen(window2,'Flip');
    set(handles.wd,'String',num2str(wd));
    guidata(hObject,handles);
else
    msgbox('wd error!');
end




function wd_step_Callback(hObject, eventdata, handles)
% hObject    handle to wd_step (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of wd_step as text
%        str2double(get(hObject,'String')) returns contents of wd_step as a double


% --- Executes during object creation, after setting all properties.
function wd_step_CreateFcn(hObject, eventdata, handles)
% hObject    handle to wd_step (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function wd_limit1_Callback(hObject, eventdata, handles)
% hObject    handle to wd_limit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of wd_limit1 as text
%        str2double(get(hObject,'String')) returns contents of wd_limit1 as a double


% --- Executes during object creation, after setting all properties.
function wd_limit1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to wd_limit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function wd_limit2_Callback(hObject, eventdata, handles)
% hObject    handle to wd_limit2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of wd_limit2 as text
%        str2double(get(hObject,'String')) returns contents of wd_limit2 as a double


% --- Executes during object creation, after setting all properties.
function wd_limit2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to wd_limit2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function rot_angle_Callback(hObject, eventdata, handles)
% hObject    handle to rot_angle (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of rot_angle as text
%        str2double(get(hObject,'String')) returns contents of rot_angle as a double
global Controller axisname
global rot_angle
rot_angle=str2double(get(handles.rot_angle,'String'));
rot_limit1=str2double(get(handles.rot_limit1,'String'));
rot_limit2=str2double(get(handles.rot_limit2,'String'));
if rot_angle>=rot_limit1 &&  rot_angle<=rot_limit2
    Controller.MOV(axisname,21603/360*rot_angle);
else
    msgbox('rotation error!');
end


% --- Executes during object creation, after setting all properties.
function rot_angle_CreateFcn(hObject, eventdata, handles)
% hObject    handle to rot_angle (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in rot_plus.
function rot_plus_Callback(hObject, eventdata, handles)
% hObject    handle to rot_plus (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global Controller axisname
global rot_angle
rot_angle=str2double(get(handles.rot_angle,'String'));
rot_limit1=str2double(get(handles.rot_limit1,'String'));
rot_limit2=str2double(get(handles.rot_limit2,'String'));
rot_step=str2double(get(handles.rot_step,'String'));
if rot_angle+rot_step>=rot_limit1 &&  rot_angle+rot_step<=rot_limit2
    rot_angle=rot_angle+rot_step;
    Controller.MOV(axisname,21603/360*rot_angle);
    set(handles.rot_angle,'String',num2str(rot_angle));
    guidata(hObject,handles);
else
    msgbox('rotation error!');
end


% --- Executes on button press in rot_minus.
function rot_minus_Callback(hObject, eventdata, handles)
% hObject    handle to rot_minus (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global Controller axisname
global rot_angle
rot_angle=str2double(get(handles.rot_angle,'String'));
rot_limit1=str2double(get(handles.rot_limit1,'String'));
rot_limit2=str2double(get(handles.rot_limit2,'String'));
rot_step=str2double(get(handles.rot_step,'String'));
if rot_angle-rot_step>=rot_limit1 &&  rot_angle-rot_step<=rot_limit2
    rot_angle=rot_angle-rot_step;
    Controller.MOV(axisname,21603/360*rot_angle);
    set(handles.rot_angle,'String',num2str(rot_angle));
    guidata(hObject,handles); 
else
    msgbox('rotation error!');
end



function rot_step_Callback(hObject, eventdata, handles)
% hObject    handle to rot_step (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of rot_step as text
%        str2double(get(hObject,'String')) returns contents of rot_step as a double


% --- Executes during object creation, after setting all properties.
function rot_step_CreateFcn(hObject, eventdata, handles)
% hObject    handle to rot_step (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function rot_limit1_Callback(hObject, eventdata, handles)
% hObject    handle to rot_limit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of rot_limit1 as text
%        str2double(get(hObject,'String')) returns contents of rot_limit1 as a double


% --- Executes during object creation, after setting all properties.
function rot_limit1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to rot_limit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function rot_limit2_Callback(hObject, eventdata, handles)
% hObject    handle to rot_limit2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of rot_limit2 as text
%        str2double(get(hObject,'String')) returns contents of rot_limit2 as a double


% --- Executes during object creation, after setting all properties.
function rot_limit2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to rot_limit2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function pico_Callback(hObject, eventdata, handles)
% hObject    handle to pico (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of pico as text
%        str2double(get(hObject,'String')) returns contents of pico as a double
global waitabit motorX motorY motorZ rAngle dz dr zlimH zlimL gx gy gz;
global IP Port TimeOut socketID;
global group positioner1 positioner2 positioner3; % parameters for controlling
global coefficients_path picoStepSize spico
pico=str2double(get(handles.pico,'String'));
pico_limit1=str2double(get(handles.pico_limit1,'String'));
pico_limit2=str2double(get(handles.pico_limit2,'String'));
pico_step=str2double(get(handles.pico_step,'String'));
if pico>=pico_limit1 &&  pico<=pico_limit2
    load([coefficients_path,'pico_current_position.mat']);
    pico_movedistance=picoStepSize*(pico-pico_current_position);
    pico_move_direction=sign(pico_movedistance);
    fprintf(spico,['ABS a1=',num2str(pico),' g']);
    move_distance_step=150*picoStepSize;
    N_pico_move=floor(abs(pico_movedistance)/move_distance_step);
    for j=1:N_pico_move
        dgx=move_distance_step*gx/gz*pico_move_direction;
        dgy=move_distance_step*gy/gz*pico_move_direction;
        dgz=move_distance_step*pico_move_direction;
        if (motorZ+dgz)>=zlimL &&  (motorZ+dgz)<=zlimH
            motorX=motorX-dgx;
            motorY=motorY-dgy;
            motorZ=motorZ-dgz;
            [errorCode] = GroupMoveAbsolute(socketID, group, [motorX,motorY,motorZ]) ;
            if (errorCode ~= 0)
                disp (['Error ' num2str(errorCode) ' occurred while doing GroupMoveAbsolute ! ']) ;
                return ;
            end
            pause(waitabit);
        else
            msgbox('zlimit error!');
        end
        pause(0.1);
        
    end
    pico_current_position=pico;
    save([coefficients_path,'pico_current_position.mat'],'pico_current_position');
    set(handles.pico,'String',num2str(pico));
    guidata(hObject,handles);
else
    msgbox('pico error!');
end

% --- Executes during object creation, after setting all properties.
function pico_CreateFcn(hObject, eventdata, handles)
% hObject    handle to pico (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pico_plus.
function pico_plus_Callback(hObject, eventdata, handles)
% hObject    handle to pico_plus (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global waitabit motorX motorY motorZ rAngle dz dr zlimH zlimL gx gy gz;
global IP Port TimeOut socketID;
global group positioner1 positioner2 positioner3; % parameters for controlling
global coefficients_path picoStepSize spico
pico=str2double(get(handles.pico,'String'));
pico_limit1=str2double(get(handles.pico_limit1,'String'));
pico_limit2=str2double(get(handles.pico_limit2,'String'));
pico_step=str2double(get(handles.pico_step,'String'));
if pico+pico_step>=pico_limit1 &&  pico+pico_step<=pico_limit2
    pico=pico+pico_step;
    fprintf(spico,['ABS a1=',num2str(pico),' g']);
    dgx=pico_step*picoStepSize*gx/gz;
    dgy=pico_step*picoStepSize*gy/gz;
    dgz=pico_step*picoStepSize;
    if (motorZ+dgz)>=zlimL &&  (motorZ+dgz)<=zlimH
        motorX=motorX-dgx;
        motorY=motorY-dgy;
        motorZ=motorZ-dgz;
        [errorCode] = GroupMoveAbsolute(socketID, group, [motorX,motorY,motorZ]) ;
        if (errorCode ~= 0)
            disp (['Error ' num2str(errorCode) ' occurred while doing GroupMoveAbsolute ! ']) ;
            return ;
        end
        pause(waitabit);
    else
        msgbox('zlimit error!');
    end
    pico_current_position=pico;
    save([coefficients_path,'pico_current_position.mat'],'pico_current_position');
    set(handles.pico,'String',num2str(pico));
    guidata(hObject,handles);
else
    msgbox('pico error!');
end

% --- Executes on button press in pico_minus.
function pico_minus_Callback(hObject, eventdata, handles)
% hObject    handle to pico_minus (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global waitabit motorX motorY motorZ rAngle dz dr zlimH zlimL gx gy gz;
global IP Port TimeOut socketID;
global group positioner1 positioner2 positioner3; % parameters for controlling
global coefficients_path picoStepSize spico
pico=str2double(get(handles.pico,'String'));
pico_limit1=str2double(get(handles.pico_limit1,'String'));
pico_limit2=str2double(get(handles.pico_limit2,'String'));
pico_step=str2double(get(handles.pico_step,'String'));
if pico-pico_step>=pico_limit1 &&  pico-pico_step<=pico_limit2
    pico=pico-pico_step;
    fprintf(spico,['ABS a1=',num2str(pico),' g']);
    dgx=-pico_step*picoStepSize*gx/gz;
    dgy=-pico_step*picoStepSize*gy/gz;
    dgz=-pico_step*picoStepSize;
    if (motorZ+dgz)>=zlimL &&  (motorZ+dgz)<=zlimH
        motorX=motorX-dgx;
        motorY=motorY-dgy;
        motorZ=motorZ-dgz;
        [errorCode] = GroupMoveAbsolute(socketID, group, [motorX,motorY,motorZ]) ;
        if (errorCode ~= 0)
            disp (['Error ' num2str(errorCode) ' occurred while doing GroupMoveAbsolute ! ']) ;
            return ;
        end
        pause(waitabit);
    else
        msgbox('zlimit error!');
    end
    pico_current_position=pico;
    save([coefficients_path,'pico_current_position.mat'],'pico_current_position');
    set(handles.pico,'String',num2str(pico));
    guidata(hObject,handles);
else
    msgbox('pico error!');
end


function pico_step_Callback(hObject, eventdata, handles)
% hObject    handle to pico_step (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of pico_step as text
%        str2double(get(hObject,'String')) returns contents of pico_step as a double


% --- Executes during object creation, after setting all properties.
function pico_step_CreateFcn(hObject, eventdata, handles)
% hObject    handle to pico_step (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function pico_limit1_Callback(hObject, eventdata, handles)
% hObject    handle to pico_limit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of pico_limit1 as text
%        str2double(get(hObject,'String')) returns contents of pico_limit1 as a double


% --- Executes during object creation, after setting all properties.
function pico_limit1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to pico_limit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function pico_limit2_Callback(hObject, eventdata, handles)
% hObject    handle to pico_limit2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of pico_limit2 as text
%        str2double(get(hObject,'String')) returns contents of pico_limit2 as a double


% --- Executes during object creation, after setting all properties.
function pico_limit2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to pico_limit2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in ask_pico_pisition.
function ask_pico_pisition_Callback(hObject, eventdata, handles)
% hObject    handle to ask_pico_pisition (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global spico coefficients_path
fprintf(spico,'POS a1');out = fscanf(spico);
% msgbox(num2str(out));
pico_current_position=str2num(out(6:end-1));
save([coefficients_path,'pico_current_position.mat'],'pico_current_position');
msgbox(['pico_current_position=',num2str(pico_current_position)])
set(handles.pico,'String',num2str(pico_current_position));
guidata(hObject,handles);



function probe_number_Callback(hObject, eventdata, handles)
% hObject    handle to probe_number (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of probe_number as text
%        str2double(get(hObject,'String')) returns contents of probe_number as a double
global probe_number
probe_number=str2double(get(hObject,'String'));


% --- Executes during object creation, after setting all properties.
function probe_number_CreateFcn(hObject, eventdata, handles)
% hObject    handle to probe_number (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
