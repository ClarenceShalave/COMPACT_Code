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
%%
preview(vid1);
preview(vid2);
%%
src1.Exposure = -6;
src2.Exposure = -8;
%% take rotation shot;
start=0;
N=8+1;
a=linspace(0,21603,N)+start;
a(end)=[];
data1=[];
data2=[];
for k=a
    Controller.MOV(axisname,round(k));
    pause(3);
    
    q1=getsnapshot(vid1);
    q2=getsnapshot(vid2);
    data1=cat(3,data1,(double(q1)));
    data2=cat(3,data2,(double(q2)));
end
Controller.MOV(axisname,start);
%% data processing;
v1id1=73;
v1id2=1253;
v2id1=93;
v2id2=553;
camera_offset=15;
v1cutoff=4;
v2cutoff=4;
boundid1=[];
boundid2=[];
width1=[];width2=[];
for k=1:size(data1, 3)
    m2=data1(:,v1id1:v1id2,k)-camera_offset;
    id=find(m2>v1cutoff);
    m2=0.*m2;
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
        loid=[loid;size(m2,1)+1-a];
    end
    x=1:size(m2,2);
    f=fit(x(:),upid(:),'poly1');
    disp(['camera1 up angle:',num2str(f.p1)])
    upid2=f(x(:));
    f=fit(x(:),loid(:),'poly1');
    disp(['camera1 down angle:',num2str(f.p1)])
    loid2=f(x(:));
    imagesc(m2);hold on;
    plot(1:v1id2-v1id1+1, upid2,'-r.');
    plot(1:v1id2-v1id1+1, loid2,'-r.');
    hold off; drawnow;
    pause(0.5);
    boundid1=[boundid1,upid2,loid2];
    width1=[width1;mean(loid2-upid2)];
    
    m2=data2(:,v2id1:v2id2,k)-camera_offset;
    id=find(m2>v2cutoff);
    m2=0.*m2;
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
        loid=[loid;size(m2,1)+1-a];
    end
    x=1:size(m2,2);
    f=fit(x(:),upid(:),'poly1');
    disp(['camera2 up angle:',num2str(f.p1)])
    upid2=f(x(:));
    f=fit(x(:),loid(:),'poly1');
    disp(['camera2 down angle:',num2str(f.p1)])
    loid2=f(x(:));
    imagesc(m2);hold on;
    plot(1:v2id2-v2id1+1, upid2,'-r.');
    plot(1:v2id2-v2id1+1, loid2,'-r.');
    hold off; drawnow;
    pause(0.5);
    boundid2=[boundid2,upid2,loid2];
    width2=[width2;mean(loid2-upid2)];
end
v1axisid=mean(boundid1,2);
v2axisid=mean(boundid2,2);

%% live display;
ButtonHandle = uicontrol('Style', 'PushButton','String', 'Stop loop','Callback', 'delete(gcbf)');
while 1
    q1=getsnapshot(vid1);
    q2=getsnapshot(vid2);
    
    m1=double(q1(:,v1id1:v1id2))-camera_offset;
    
    
    id=find(m1>v1cutoff);
    m1=0.*m1;
    m1(id)=1;
    upid=[];
    for k2=1:size(m1,2)
        a=find(m1(:,k2), 1, 'first');
        upid=[upid;a];
    end
    loid=[];
    m3=flipud(m1);
    for k2=1:size(m3,2)
        a=find(m3(:,k2), 1, 'first');
        loid=[loid;size(m1,1)+1-a];
    end
    x=1:size(m1,2);
    f=fit(x(:),upid(:),'poly1');
    upid2=f(x(:));
    f=fit(x(:),loid(:),'poly1');
    loid2=f(x(:));
    aveWidth=mean(-upid2+loid2);
    aveCenter=mean(upid2+loid2)/2;
    %disp(aveWidth);
    subplot(1,2,1);
    imagesc(m1);
    title(['we need ', num2str(round(10*mean(v1axisid))),' average center is ', num2str(round(10*aveCenter))]);
    set(gca, 'fontsize',18);
    hold on;
    plot(1:size(m1,2), upid2,'-r.');
    plot(1:size(m1,2), loid2,'-r.');
    hold off; drawnow;
    
    m2=double(q2(:,v2id1:v2id2))-camera_offset;
    
    id=find(m2>v2cutoff);
    m2=0.*m2;
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
        loid=[loid;size(m2,1)+1-a];
    end
    x=1:size(m2,2);
    f=fit(x(:),upid(:),'poly1');
    upid2=f(x(:));
    f=fit(x(:),loid(:),'poly1');
    loid2=f(x(:));
    aveWidth=mean(-upid2+loid2);
    aveCenter=mean(upid2+loid2)/2;
    %disp(aveWidth);
    subplot(1,2,2);
    imagesc(m2);
    title(['we need ', num2str(round(10*mean(v2axisid))),' average center is ', num2str(round(10*aveCenter))]);
    set(gca, 'fontsize',18);
    hold on;
    plot(1:size(m2,2), upid2,'-r.');
    plot(1:size(m2,2), loid2,'-r.');
    hold off; drawnow;

    
    if ~ishandle(ButtonHandle)
        disp('Loop stopped by user');
        break;
    end
end