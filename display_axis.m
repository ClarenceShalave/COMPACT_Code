%% set up camera
vid1 = videoinput('winvideo', 1, 'Y800_2592x1944');
src1 = getselectedsource(vid1);
src1.ExposureMode = 'manual';
src1.GainMode = 'manual';
src1.Gain = 4;
src1.Exposure = -10;
src1.FrameRate = '5.9870';

vid2 = videoinput('winvideo', 2, 'Y800_1920x1200');
src2 = getselectedsource(vid2);
src2.ExposureMode = 'manual';
src2.GainMode = 'manual';
src2.Gain = 0;
src2.Exposure = -12;
src2.FrameRate = '30.0000';
%% preview
preview(vid1)
preview(vid2)
%%
src1.Exposure = -8;
src2.Exposure = -9;
%%
% camera1_view1=600;
% camera1_view2=950;
%
% camera2_view1=400;
% camera2_view2=700;

camera1_view1=1;
camera1_view2=1944;

camera2_view1=1;
camera2_view2=1200;

axis1_offset=0-camera1_view1;
axis2_offset=0-camera2_view1;
width1=290;
width2=120;

x1=v1id1:v1id2;
y1=v1axisid+axis1_offset;
f1=fit(x1.',y1,'poly1');
y1up=y1+width1/2;
y1lo=y1-width1/2;
f1up=fit(x1.',y1up,'poly1');
f1lo=fit(x1.',y1lo,'poly1');

x2=v2id1:v2id2;
y2=v2axisid+axis2_offset;
f2=fit(x2.',y2,'poly1');
y2up=y2+width2/2;
y2lo=y2-width2/2;
f2up=fit(x2.',y2up,'poly1');
f2lo=fit(x2.',y2lo,'poly1');

%
f1=f1(1:2592);
f1up=f1up(1:2592);
f1lo=f1lo(1:2592);
f2=f2(1:1920);
f2up=f2up(1:1920);
f2lo=f2lo(1:1920);
%

figure(100);
ButtonHandle = uicontrol('Style', 'PushButton', 'String', 'Stop loop','Callback', 'delete(gcbf)');
while 1
    q1=getsnapshot(vid1);
    subplot(2,1,1);
    imagesc(q1(camera1_view1:camera1_view2,:));colormap gray;
    hold on;
    
    %     plot(f1);
    %     plot(f1up);
    %     plot(f1lo);
    %     legend off;
    plot(1:2592,f1,1:2592,f1up,1:2592,f1lo);
    hold off; drawnow;
    
    q2=getsnapshot(vid2);
    
    subplot(2,1,2);
    imagesc(q2(camera2_view1:camera2_view2,:));colormap gray;
    hold on;
    
    %     plot(f2);
    %     plot(f2up);
    %     plot(f2lo);
    %     legend off;
    plot(1:1920,f2,1:1920,f2up,1:1920,f2lo);
    hold off; drawnow;
    
    if ~ishandle(ButtonHandle)
        figure(100);
        disp('Loop stopped by user');
        break;
    end
end
%%
figure(100);
ButtonHandle = uicontrol('Style', 'PushButton', 'String', 'Stop loop','Callback', 'delete(gcbf)');
while 1
    q1=getsnapshot(vid1);
    imagesc(q1(camera1_view1:camera1_view2,:));colormap gray;
    hold on;
    
    %     plot(f1);
    %     plot(f1up);
    %     plot(f1lo);
    %     legend off;
    plot(1:2592,f1,1:2592,f1up,1:2592,f1lo);
    hold off; drawnow;
    
    if ~ishandle(ButtonHandle)
        figure(100);
        disp('Loop stopped by user');
        break;
    end
end
%%
figure(100);
ButtonHandle = uicontrol('Style', 'PushButton', 'String', 'Stop loop','Callback', 'delete(gcbf)');
while 1
    
    q2=getsnapshot(vid2);
    imagesc(q2(camera2_view1:camera2_view2,:));colormap gray;
    hold on;
    
    %     plot(f2);
    %     plot(f2up);
    %     plot(f2lo);
    %     legend off;
    plot(1:1920,f2,1:1920,f2up,1:1920,f2lo);
    hold off; drawnow;
    
    if ~ishandle(ButtonHandle)
        figure(100);
        disp('Loop stopped by user');
        break;
    end
end

%% find and display needle axis
q1_xrange=1280:2592;
q1_yrange=990:1944;
q2_xrange=530:1050;
q2_yrange=600:750;

q1_cutoff=20;
q2_cutoff=25;

x1=v1id1:v1id2;
y1=v1axisid+axis1_offset;
f1=fit(x1.',y1,'poly1');

x2=v2id1:v2id2;
y2=v2axisid+axis2_offset;
f2=fit(x2.',y2,'poly1');

figure(100);
ButtonHandle = uicontrol('Style', 'PushButton', 'String', 'Stop loop','Callback', 'delete(gcbf)');
while 1
    q1=getsnapshot(vid1);
    subplot(1,2,1);
    img1=q1(q1_yrange,q1_xrange)-q1_cutoff;
    [row,col]=find(img1>0);
    f=fit(col,row,'poly1');
    imagesc(q1(q1_yrange,q1_xrange));colormap gray;
    axis off
    title(['we need ', num2str(f1.p1),' axis is ', num2str(f.p1)]);
    set(gca, 'fontsize',18);
    hold on;
    plot(f)
    legend off
    hold off; drawnow;
    
    pause(0.5)
    q2=getsnapshot(vid2);
    
    subplot(1,2,2);
    img2=q2(q2_yrange,q2_xrange)-q2_cutoff;
    [row,col]=find(img2>0);
    f=fit(col,row,'poly1');
    imagesc(q2(q2_yrange,q2_xrange));colormap gray;
    axis off
    title(['we need ', num2str(f2.p1),' axis is ', num2str(f.p1)]);
    set(gca, 'fontsize',18);
    hold on;
    plot(f)
    legend off
    hold off; drawnow;
    
    pause(0.5)
    
    if ~ishandle(ButtonHandle)
        figure(100);
        disp('Loop stopped by user');
        break;
    end
end
