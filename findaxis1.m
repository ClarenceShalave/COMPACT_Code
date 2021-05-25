%% set up camera
vid1 = videoinput('winvideo', 1, 'Y800_1920x1200');
src1 = getselectedsource(vid1);
src1.ExposureMode = 'manual';
src1.GainMode = 'manual';
src1.Gain = 0;
src1.Exposure = -7;
src1.FrameRate = '5.0000';
%% take rotation shot;
N=12+1;
a=linspace(0,21603,N);
a(end)=[];
data=[];
for k=a
    Controller.MOV(axisname,round(k));
    pause(3);
    q=getsnapshot(vid1);
    data=cat(3,data,(double(q)));
end
Controller.MOV(axisname,0);
%% data processing;
v1id1=261;
v1id2=290;
camera_offset=15;
v1cutoff=3;
boundid=[];
centerdata=[];
for k=1:size(data, 3)
    m=data(:,v1id1:v1id2,k)-camera_offset;
    id=find(m>v1cutoff);
    m2=0.*m;
    m2(id)=1;
    upid=[];
    for k2=1:size(m2,2)
        a=find(m2(:,k2), 1, 'first');
        upid=[upid;a];
    end
    loid=[];
    m3=flipud(m2);
    for k2=1:size(m3,2)
        a=find(m3(:,k2), 1, 'first');
        loid=[loid;1201-a];
    end
    x=1:size(m2,2);
    f=fit(x(:),upid(:),'poly1');
    upid2=f(x(:));
    f=fit(x(:),loid(:),'poly1');
    loid2=f(x(:));
    aveWidth=mean(-upid2+loid2);
    centerat=mean(upid2+loid2)/2;
    centerdata=[centerdata;centerat];
    disp([aveWidth, centerat]);
    imagesc(m2);
    title(['average width is ', num2str(aveWidth)]);
    hold on;
    plot(1:size(m2,2), upid2,'-r.');
    plot(1:size(m2,2), loid2,'-r.');
    hold off; drawnow;
    boundid=[boundid,upid2,loid2];
end
v1axisid=mean(boundid,2);
disp(['mean axis id ',num2str(mean(v1axisid))]);
%% live display;
ButtonHandle = uicontrol('Style', 'PushButton','String', 'Stop loop','Callback', 'delete(gcbf)');
while 1
    q=getsnapshot(vid1);
    m=double(q(:,v1id1:v1id2))-camera_offset;
    
    id=find(m>v1cutoff);
    m2=0.*m;
    m2(id)=1;
    upid=[];
    for k2=1:size(m2,2)
        a=find(m2(:,k2), 1, 'first');
        upid=[upid;a];
    end
    loid=[];
    m3=flipud(m2);
    for k2=1:size(m3,2)
        a=find(m3(:,k2), 1, 'first');
        loid=[loid;1201-a];
    end
    x=1:size(m2,2);
    f=fit(x(:),upid(:),'poly1');
    upid2=f(x(:));
    f=fit(x(:),loid(:),'poly1');
    loid2=f(x(:));
    aveWidth=mean(-upid2+loid2);
    aveCenter=mean(upid2+loid2)/2;
    %disp(aveWidth);
    imagesc(m2);
    title(['we need ', num2str(round(10*mean(v1axisid))),' average center is ', num2str(round(10*aveCenter))]);
    set(gca, 'fontsize',36);
    hold on;
    plot(1:size(m2,2), upid2,'-r.');
    plot(1:size(m2,2), loid2,'-r.');
    hold off; drawnow;

    
    if ~ishandle(ButtonHandle)
        disp('Loop stopped by user');
        break;
    end
end
