%% set up camera
vid = videoinput('winvideo', 1, 'Y800_744x480');
src = getselectedsource(vid);
src.ExposureMode = 'manual';
src.GainMode = 'manual';
src.Gain = 16;
src.Exposure = -8;
src.FrameRate = '30.0000';
preview(vid);
%% set up stage
global socketID positioner1 positioner2 positioner3 gx gy gz waitabit zlimL zlimH group
%%
tube_diameter=0.5; % mm
camera_x1=324;
camera_x2=536;
camera_y1=313;
camera_y2=394;
min_step=0.001;
move_up_d=3; % mm
coeff=0.5;

% % auto set threshold first
% threshold_list=[];
% qt=double(getsnapshot(vid));
% qt=qt(camera_y1:camera_y2,camera_x1:camera_x2);
% qt=qt/max(qt(:));
% for ii=1:100
%     q=double(getsnapshot(vid));
%     q=q(camera_y1:camera_y2,camera_x1:camera_x2);
%     q=q/max(q(:));
%     q_diff=abs(qt-q);
%     threshold_list=[threshold_list;sum(q_diff(:))];
%     qt=q;
% end
% threshold=max(threshold_list)*1.5

% set stage at the center first
[errorCode, currentPosition_x] = GroupPositionCurrentGet(socketID, positioner1, 1);
[errorCode, currentPosition_y] = GroupPositionCurrentGet(socketID, positioner2, 1);
% find x boundry 1
[errorCode] = GroupMoveAbsolute(socketID, positioner1, currentPosition_x+tube_diameter/2*coeff);
pause(0.5);
% auto set threshold first
threshold_list=[];
qt=double(getsnapshot(vid));
qt=qt(camera_y1:camera_y2,camera_x1:camera_x2);
qt=qt/max(qt(:));
for ii=1:100
    q=double(getsnapshot(vid));
    q=q(camera_y1:camera_y2,camera_x1:camera_x2);
    q=q/max(q(:));
    q_diff=abs(qt-q);
    threshold_list=[threshold_list;sum(q_diff(:))];
    qt=q;
end
threshold=max(threshold_list)*1.5

q0=double(getsnapshot(vid));
q0=q0(camera_y1:camera_y2,camera_x1:camera_x2);
q0=q0/max(q0(:));
img_diff=0;
N_max=(tube_diameter/2*0.3)/min_step;
N=1;
while img_diff<threshold && N<N_max
    [errorCode] = GroupMoveAbsolute(socketID, positioner1, currentPosition_x+tube_diameter/2*coeff+N*min_step);
    q=double(getsnapshot(vid));
    q=q(camera_y1:camera_y2,camera_x1:camera_x2);
    q=q/max(q(:));
    img_diff=sum(sum(abs(q-q0)));
    N=N+1;
end
N
x_boundry_1=currentPosition_x+tube_diameter/2*coeff+(N-1)*min_step;
[errorCode] = GroupMoveAbsolute(socketID, positioner1, currentPosition_x);
% find x boundry 2
[errorCode] = GroupMoveAbsolute(socketID, positioner1, currentPosition_x-tube_diameter/2*coeff);
pause(0.5);
% auto set threshold first
threshold_list=[];
qt=double(getsnapshot(vid));
qt=qt(camera_y1:camera_y2,camera_x1:camera_x2);
qt=qt/max(qt(:));
for ii=1:100
    q=double(getsnapshot(vid));
    q=q(camera_y1:camera_y2,camera_x1:camera_x2);
    q=q/max(q(:));
    q_diff=abs(qt-q);
    threshold_list=[threshold_list;sum(q_diff(:))];
    qt=q;
end
threshold=max(threshold_list)*1.5

q0=double(getsnapshot(vid));
q0=q0(camera_y1:camera_y2,camera_x1:camera_x2);
q0=q0/max(q0(:));
img_diff=0;
N_max=(tube_diameter/2*0.3)/min_step;
N=1;
while img_diff<threshold && N<N_max
    [errorCode] = GroupMoveAbsolute(socketID, positioner1, currentPosition_x-tube_diameter/2*coeff-N*min_step);
    q=double(getsnapshot(vid));
    q=q(camera_y1:camera_y2,camera_x1:camera_x2);
    q=q/max(q(:));
    img_diff=sum(sum(abs(q-q0)));
    N=N+1;
end
N
x_boundry_2=currentPosition_x-tube_diameter/2*coeff-(N-1)*min_step;
[errorCode] = GroupMoveAbsolute(socketID, positioner1, currentPosition_x);
% move to x center
x_center=(x_boundry_1+x_boundry_2)/2;
[errorCode] = GroupMoveAbsolute(socketID, positioner1, x_center);
% find y boundry 1
[errorCode] = GroupMoveAbsolute(socketID, positioner2, currentPosition_y+tube_diameter/2*coeff);
pause(0.5);
% auto set threshold first
threshold_list=[];
qt=double(getsnapshot(vid));
qt=qt(camera_y1:camera_y2,camera_x1:camera_x2);
qt=qt/max(qt(:));
for ii=1:100
    q=double(getsnapshot(vid));
    q=q(camera_y1:camera_y2,camera_x1:camera_x2);
    q=q/max(q(:));
    q_diff=abs(qt-q);
    threshold_list=[threshold_list;sum(q_diff(:))];
    qt=q;
end
threshold=max(threshold_list)*1.5

q0=double(getsnapshot(vid));
q0=q0(camera_y1:camera_y2,camera_x1:camera_x2);
q0=q0/max(q0(:));
img_diff=0;
N_max=(tube_diameter/2*0.3)/min_step;
N=1;
while img_diff<threshold && N<N_max
    [errorCode] = GroupMoveAbsolute(socketID, positioner2, currentPosition_y+tube_diameter/2*coeff+N*min_step);
    q=double(getsnapshot(vid));
    q=q(camera_y1:camera_y2,camera_x1:camera_x2);
    q=q/max(q(:));
    img_diff=sum(sum(abs(q-q0)));
    N=N+1;
end
N
y_boundry_1=currentPosition_y+tube_diameter/2*coeff+(N-1)*min_step;
[errorCode] = GroupMoveAbsolute(socketID, positioner2, currentPosition_y);
% find y boundry 2
[errorCode] = GroupMoveAbsolute(socketID, positioner2, currentPosition_y-tube_diameter/2*coeff);
pause(0.5);
% auto set threshold first
threshold_list=[];
qt=double(getsnapshot(vid));
qt=qt(camera_y1:camera_y2,camera_x1:camera_x2);
qt=qt/max(qt(:));
for ii=1:100
    q=double(getsnapshot(vid));
    q=q(camera_y1:camera_y2,camera_x1:camera_x2);
    q=q/max(q(:));
    q_diff=abs(qt-q);
    threshold_list=[threshold_list;sum(q_diff(:))];
    qt=q;
end
threshold=max(threshold_list)*1.5

q0=double(getsnapshot(vid));
q0=q0(camera_y1:camera_y2,camera_x1:camera_x2);
q0=q0/max(q0(:));
img_diff=0;
N_max=(tube_diameter/2*0.3)/min_step;
N=1;
while img_diff<threshold && N<N_max
    [errorCode] = GroupMoveAbsolute(socketID, positioner2, currentPosition_y-tube_diameter/2*coeff-N*min_step);
    q=double(getsnapshot(vid));
    q=q(camera_y1:camera_y2,camera_x1:camera_x2);
    q=q/max(q(:));
    img_diff=sum(sum(abs(q-q0)));
    N=N+1;
end
N
y_boundry_2=currentPosition_y-tube_diameter/2*coeff-(N-1)*min_step;
[errorCode] = GroupMoveAbsolute(socketID, positioner2, currentPosition_y);
% move to y center
y_center=(y_boundry_1+y_boundry_2)/2;
[errorCode] = GroupMoveAbsolute(socketID, positioner2, y_center);
% move up and repeat
[errorCode, currentPosition_x] = GroupPositionCurrentGet(socketID, positioner1, 1);
[errorCode, currentPosition_y] = GroupPositionCurrentGet(socketID, positioner2, 1);
[errorCode, currentPosition_z] = GroupPositionCurrentGet(socketID, positioner3, 1);
dgx=move_up_d*gx/sqrt(gx^2+gy^2+gz^2);
dgy=move_up_d*gy/sqrt(gx^2+gy^2+gz^2);
dgz=move_up_d*gz/sqrt(gx^2+gy^2+gz^2);
if (currentPosition_z-dgz)>=zlimL &&  (currentPosition_z-dgz)<=zlimH
    currentPosition_x=currentPosition_x-dgx;
    currentPosition_y=currentPosition_y-dgy;
    currentPosition_z=currentPosition_z-dgz;
    [errorCode] = GroupMoveAbsolute(socketID, group, [currentPosition_x,currentPosition_y,currentPosition_z]) ;
    if (errorCode ~= 0)
        disp (['Error ' num2str(errorCode) ' occurred while doing GroupMoveAbsolute ! ']) ;
        return ;
    end
else
    msgbox('zlimit error!');
end
pause(0.5);
%
[errorCode, currentPosition_x] = GroupPositionCurrentGet(socketID, positioner1, 1);
[errorCode, currentPosition_y] = GroupPositionCurrentGet(socketID, positioner2, 1);
% find x boundry 1
[errorCode] = GroupMoveAbsolute(socketID, positioner1, currentPosition_x+tube_diameter/2*coeff);
pause(0.5);
% auto set threshold first
threshold_list=[];
qt=double(getsnapshot(vid));
qt=qt(camera_y1:camera_y2,camera_x1:camera_x2);
qt=qt/max(qt(:));
for ii=1:100
    q=double(getsnapshot(vid));
    q=q(camera_y1:camera_y2,camera_x1:camera_x2);
    q=q/max(q(:));
    q_diff=abs(qt-q);
    threshold_list=[threshold_list;sum(q_diff(:))];
    qt=q;
end
threshold=max(threshold_list)*1.5

q0=double(getsnapshot(vid));
q0=q0(camera_y1:camera_y2,camera_x1:camera_x2);
q0=q0/max(q0(:));
img_diff=0;
N_max=(tube_diameter/2*0.3)/min_step;
N=1;
while img_diff<threshold && N<N_max
    [errorCode] = GroupMoveAbsolute(socketID, positioner1, currentPosition_x+tube_diameter/2*coeff+N*min_step);
    q=double(getsnapshot(vid));
    q=q(camera_y1:camera_y2,camera_x1:camera_x2);
    q=q/max(q(:));
    img_diff=sum(sum(abs(q-q0)));
    N=N+1;
end
N
x_boundry_1=currentPosition_x+tube_diameter/2*coeff+(N-1)*min_step;
[errorCode] = GroupMoveAbsolute(socketID, positioner1, currentPosition_x);
% find x boundry 2
[errorCode] = GroupMoveAbsolute(socketID, positioner1, currentPosition_x-tube_diameter/2*coeff);
pause(0.5);
% auto set threshold first
threshold_list=[];
qt=double(getsnapshot(vid));
qt=qt(camera_y1:camera_y2,camera_x1:camera_x2);
qt=qt/max(qt(:));
for ii=1:100
    q=double(getsnapshot(vid));
    q=q(camera_y1:camera_y2,camera_x1:camera_x2);
    q=q/max(q(:));
    q_diff=abs(qt-q);
    threshold_list=[threshold_list;sum(q_diff(:))];
    qt=q;
end
threshold=max(threshold_list)*1.5

q0=double(getsnapshot(vid));
q0=q0(camera_y1:camera_y2,camera_x1:camera_x2);
q0=q0/max(q0(:));
img_diff=0;
N_max=(tube_diameter/2*0.3)/min_step;
N=1;
while img_diff<threshold && N<N_max
    [errorCode] = GroupMoveAbsolute(socketID, positioner1, currentPosition_x-tube_diameter/2*coeff-N*min_step);
    q=double(getsnapshot(vid));
    q=q(camera_y1:camera_y2,camera_x1:camera_x2);
    q=q/max(q(:));
    img_diff=sum(sum(abs(q-q0)));
    N=N+1;
end
N
x_boundry_2=currentPosition_x-tube_diameter/2*coeff-(N-1)*min_step;
[errorCode] = GroupMoveAbsolute(socketID, positioner1, currentPosition_x);
% move to x center
x_center=(x_boundry_1+x_boundry_2)/2;
[errorCode] = GroupMoveAbsolute(socketID, positioner1, x_center);
% find y boundry 1
[errorCode] = GroupMoveAbsolute(socketID, positioner2, currentPosition_y+tube_diameter/2*coeff);
pause(0.5);
% auto set threshold first
threshold_list=[];
qt=double(getsnapshot(vid));
qt=qt(camera_y1:camera_y2,camera_x1:camera_x2);
qt=qt/max(qt(:));
for ii=1:100
    q=double(getsnapshot(vid));
    q=q(camera_y1:camera_y2,camera_x1:camera_x2);
    q=q/max(q(:));
    q_diff=abs(qt-q);
    threshold_list=[threshold_list;sum(q_diff(:))];
    qt=q;
end
threshold=max(threshold_list)*1.5

q0=double(getsnapshot(vid));
q0=q0(camera_y1:camera_y2,camera_x1:camera_x2);
q0=q0/max(q0(:));
img_diff=0;
N_max=(tube_diameter/2*0.3)/min_step;
N=1;
while img_diff<threshold && N<N_max
    [errorCode] = GroupMoveAbsolute(socketID, positioner2, currentPosition_y+tube_diameter/2*coeff+N*min_step);
    q=double(getsnapshot(vid));
    q=q(camera_y1:camera_y2,camera_x1:camera_x2);
    q=q/max(q(:));
    img_diff=sum(sum(abs(q-q0)));
    N=N+1;
end
N
y_boundry_1=currentPosition_y+tube_diameter/2*coeff+(N-1)*min_step;
[errorCode] = GroupMoveAbsolute(socketID, positioner2, currentPosition_y);
% find y boundry 2
[errorCode] = GroupMoveAbsolute(socketID, positioner2, currentPosition_y-tube_diameter/2*coeff);
pause(0.5);
% auto set threshold first
threshold_list=[];
qt=double(getsnapshot(vid));
qt=qt(camera_y1:camera_y2,camera_x1:camera_x2);
qt=qt/max(qt(:));
for ii=1:100
    q=double(getsnapshot(vid));
    q=q(camera_y1:camera_y2,camera_x1:camera_x2);
    q=q/max(q(:));
    q_diff=abs(qt-q);
    threshold_list=[threshold_list;sum(q_diff(:))];
    qt=q;
end
threshold=max(threshold_list)*1.5

q0=double(getsnapshot(vid));
q0=q0(camera_y1:camera_y2,camera_x1:camera_x2);
q0=q0/max(q0(:));
img_diff=0;
N_max=(tube_diameter/2*0.3)/min_step;
N=1;
while img_diff<threshold && N<N_max
    [errorCode] = GroupMoveAbsolute(socketID, positioner2, currentPosition_y-tube_diameter/2*coeff-N*min_step);
    q=double(getsnapshot(vid));
    q=q(camera_y1:camera_y2,camera_x1:camera_x2);
    q=q/max(q(:));
    img_diff=sum(sum(abs(q-q0)));
    N=N+1;
end
N
y_boundry_2=currentPosition_y-tube_diameter/2*coeff-(N-1)*min_step;
[errorCode] = GroupMoveAbsolute(socketID, positioner2, currentPosition_y);
% move to y center
y_center=(y_boundry_1+y_boundry_2)/2;
[errorCode] = GroupMoveAbsolute(socketID, positioner2, y_center);
% calculate angle diff
x_diff=x_center-currentPosition_x;
y_diff=y_center-currentPosition_y;
angle_x=atand(x_diff/move_up_d);
angle_y=atand(y_diff/move_up_d);
disp(['x:rotate clockwise ',num2str(angle_x),' rounds(',num2str(angle_x*25),'scale)'])
disp(['y:rotate clockwise ',num2str(angle_y),' rounds(',num2str(angle_y*25),'scale)'])
% move down
[errorCode, currentPosition_x] = GroupPositionCurrentGet(socketID, positioner1, 1);
[errorCode, currentPosition_y] = GroupPositionCurrentGet(socketID, positioner2, 1);
[errorCode, currentPosition_z] = GroupPositionCurrentGet(socketID, positioner3, 1);
dgx=move_up_d*gx/sqrt(gx^2+gy^2+gz^2);
dgy=move_up_d*gy/sqrt(gx^2+gy^2+gz^2);
dgz=move_up_d*gz/sqrt(gx^2+gy^2+gz^2);
if (currentPosition_z+dgz)>=zlimL &&  (currentPosition_z+dgz)<=zlimH
    currentPosition_x=currentPosition_x+dgx;
    currentPosition_y=currentPosition_y+dgy;
    currentPosition_z=currentPosition_z+dgz;
    [errorCode] = GroupMoveAbsolute(socketID, group, [currentPosition_x,currentPosition_y,currentPosition_z]) ;
    if (errorCode ~= 0)
        disp (['Error ' num2str(errorCode) ' occurred while doing GroupMoveAbsolute ! ']) ;
        return ;
    end
else
    msgbox('zlimit error!');
end