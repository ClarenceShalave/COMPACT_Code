function varargout = wd_rot_GUI(varargin)
% WD_ROT_GUI MATLAB code for wd_rot_GUI.fig
%      WD_ROT_GUI, by itself, creates a new WD_ROT_GUI or raises the existing
%      singleton*.
%
%      H = WD_ROT_GUI returns the handle to a new WD_ROT_GUI or the handle to
%      the existing singleton*.
%
%      WD_ROT_GUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in WD_ROT_GUI.M with the given input arguments.
%
%      WD_ROT_GUI('Property','Value',...) creates a new WD_ROT_GUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before wd_rot_GUI_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to wd_rot_GUI_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help wd_rot_GUI

% Last Modified by GUIDE v2.5 10-Jan-2019 15:18:22

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
    'gui_Singleton',  gui_Singleton, ...
    'gui_OpeningFcn', @wd_rot_GUI_OpeningFcn, ...
    'gui_OutputFcn',  @wd_rot_GUI_OutputFcn, ...
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


% --- Executes just before wd_rot_GUI is made visible.
function wd_rot_GUI_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to wd_rot_GUI (see VARARGIN)

% Choose default command line output for wd_rot_GUI
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes wd_rot_GUI wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = wd_rot_GUI_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;



function wd_Callback(hObject, eventdata, handles)
% hObject    handle to wd (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of wd as text
%        str2double(get(hObject,'String')) returns contents of wd as a double
%%
coefficients_path='G:\COMPACT\coefficients\';
probe_number=3;
%% prepare defocusing wavefront;
x=1:792;
y=1:600;
pixelsize=0.04/3;
n=1.33;
f=180/20;
lambda=0.93;% unit micron;
centerx0=340;
centery0=230;
%% import voltage array data;
load([coefficients_path,'voltagearray930nm.mat']);
load([coefficients_path,'slmphase930nm.mat']);
load([coefficients_path,'probe',num2str(probe_number),'\','pico_positions.mat']);
load([coefficients_path,'probe',num2str(probe_number),'\','defocus_scale.mat']);
load([coefficients_path,'probe',num2str(probe_number),'\','xy_offset.mat']);
load([coefficients_path,'probe',num2str(probe_number),'\','f_zoom.mat']);
%% stage connection
global waitabit motorX motorY motorZ rAngle dz dr zlimH zlimL gx gy gz;
global IP Port TimeOut socketID;
global group positioner1 positioner2 positioner3; % parameters for controlling
%%
global wd
global Maberration
global window2
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
%%
coefficients_path='G:\COMPACT\coefficients\';
probe_number=3;
%% prepare defocusing wavefront;
x=1:792;
y=1:600;
pixelsize=0.04/3;
n=1.33;
f=180/20;
lambda=0.93;% unit micron;
centerx0=340;
centery0=230;
%% import voltage array data;
load([coefficients_path,'voltagearray930nm.mat']);
load([coefficients_path,'slmphase930nm.mat']);
load([coefficients_path,'probe',num2str(probe_number),'\','pico_positions.mat']);
load([coefficients_path,'probe',num2str(probe_number),'\','defocus_scale.mat']);
load([coefficients_path,'probe',num2str(probe_number),'\','xy_offset.mat']);
load([coefficients_path,'probe',num2str(probe_number),'\','f_zoom.mat']);
%% stage connection
global waitabit motorX motorY motorZ rAngle dz dr zlimH zlimL gx gy gz;
global IP Port TimeOut socketID;
global group positioner1 positioner2 positioner3; % parameters for controlling
%%
global wd
global Maberration
global window2
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
%%
coefficients_path='G:\COMPACT\coefficients\';
probe_number=3;
%% prepare defocusing wavefront;
x=1:792;
y=1:600;
pixelsize=0.04/3;
n=1.33;
f=180/20;
lambda=0.93;% unit micron;
centerx0=340;
centery0=230;
%% import voltage array data;
load([coefficients_path,'voltagearray930nm.mat']);
load([coefficients_path,'slmphase930nm.mat']);
load([coefficients_path,'probe',num2str(probe_number),'\','pico_positions.mat']);
load([coefficients_path,'probe',num2str(probe_number),'\','defocus_scale.mat']);
load([coefficients_path,'probe',num2str(probe_number),'\','xy_offset.mat']);
load([coefficients_path,'probe',num2str(probe_number),'\','f_zoom.mat']);
%% stage connection
global waitabit motorX motorY motorZ rAngle dz dr zlimH zlimL gx gy gz;
global IP Port TimeOut socketID;
global group positioner1 positioner2 positioner3; % parameters for controlling
%%
global wd
global Maberration
global window2
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
