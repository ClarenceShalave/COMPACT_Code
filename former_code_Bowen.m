%%
cd('C:\Users\labadmin\Desktop\find_center')

%% rotator initial
if(~exist('Controller'))
    Controller = PI_GCS_Controller();
end;
if(~isa(Controller,'PI_GCS_Controller'))
    Controller = PI_GCS_Controller();
end;
comPort = 2;
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
%% camera initial
vid1 = videoinput('winvideo', 1, 'Y800_1920x1200');
src1 = getselectedsource(vid1);
src1.ExposureMode = 'manual';
src1.GainMode = 'manual';
src1.Gain = 200;
src1.Exposure = -3;
vid2 = videoinput('winvideo', 2, 'Y800_1920x1200');
src2 = getselectedsource(vid2);
src2.ExposureMode = 'manual';
src2.GainMode = 'manual';
src2.Gain = 200;
src2.Exposure = -3;
%%
src1.Gain = 0;
src2.Gain = 0;
src1.Exposure = -3;
src2.Exposure = -3;
src1.FrameRate = '5.0000';
src2.FrameRate = '5.0000';
%%
filenumber='17';
Controller.MOV(axisname,0);
N=12;
for i=1:N
    Controller.MOV(axisname,(i-1)/N*21603);
    pause(1);
    q1=getsnapshot(vid1);
    pic1(:,:,i)=q1.';
    q2=getsnapshot(vid2);
    pic2(:,:,i)=rot90(q2);
end
pic1=double(pic1);
pic2=double(pic2);
save([filenumber,'.mat'],'pic1','pic2');
Controller.MOV(axisname,0);
%%
top1=200;
bottom1=1300;
top2=250;
bottom2=1450;
axis1=[];
axis2=[];
x_1=1:1920;
x_2=1:1920;
for i=1:12
    E1=edge(pic1(top1:bottom1,:,i),'Prewitt',30,'vertical');
    E2=edge(pic2(top2:bottom2,:,i),'Prewitt',30,'vertical');
    [x,y]=find(E1==1);
    k=boundary(x,y);
    x=x+top1;
    x1=[];
    y1=[];
    for n=1:size(k,1)
        if abs(x(k(n))-max(x(k)))>20 && abs(x(k(n))-min(x(k)))>20
            x1=[x1;x(k(n))];
            y1=[y1;y(k(n))];
        end
    end
    x1_1=[];
    y1_1=[];
    x1_2=[];
    y1_2=[];
    for j=1:size(x1)
        if y1(j)<(min(y1)+max(y1))/2
            x1_1=[x1_1;x1(j)];
            y1_1=[y1_1;y1(j)];
        else
            x1_2=[x1_2;x1(j)];
            y1_2=[y1_2;y1(j)];
        end
    end
    f1_1=fit(x1_1,y1_1,'poly1');
    f1_2=fit(x1_2,y1_2,'poly1');
    y_01=feval(f1_1,x_2);
    y_02=feval(f1_2,x_2);
    axis1=[axis1,(y_01+y_02)/2];
    [x,y]=find(E2==1);
    k=boundary(x,y);
    x=x+top2;
    x2=[];
    y2=[];
    for n=1:size(k,1)
        if abs(x(k(n))-max(x(k)))>20 && abs(x(k(n))-min(x(k)))>20
            x2=[x2;x(k(n))];
            y2=[y2;y(k(n))];
        end
    end
    x2_1=[];
    y2_1=[];
    x2_2=[];
    y2_2=[];
    for j=1:size(x2)
        if y2(j)<(min(y2)+max(y2))/2
            x2_1=[x2_1;x2(j)];
            y2_1=[y2_1;y2(j)];
        else
            x2_2=[x2_2;x2(j)];
            y2_2=[y2_2;y2(j)];
        end
    end
    f2_1=fit(x2_1,y2_1,'poly1');
    f2_2=fit(x2_2,y2_2,'poly1');
    y_01=feval(f2_1,x_2);
    y_02=feval(f2_2,x_2);
    axis2=[axis2,(y_01+y_02)/2];
end
axis1=mean(axis1,2);
axis2=mean(axis2,2);
%%
figure;
imagesc(pic1(:,:,1));colormap gray;hold on;plot(axis1,x_1);hold off
figure;
imagesc(pic2(:,:,1));colormap gray;hold on;plot(axis2,x_2);hold off
%%
top1=115;
bottom1=1300;
top2=250;
bottom2=1450;
figure;
ButtonHandle = uicontrol('Style', 'PushButton', ...
    'String', 'Stop loop', ...
    'Callback', 'delete(gcbf)');
while 1
    
    q1=getsnapshot(vid1);
    q2=getsnapshot(vid2);
    q1=double(q1);
    q2=double(q2);
    q1=q1.';
    q2=rot90(q2);
    E1=edge(q1(top1:bottom1,:),'Prewitt',20,'vertical');
    E2=edge(q2(top2:bottom2,:),'Prewitt',20,'vertical');
    [x,y]=find(E1==1);
    k=boundary(x,y);
    x=x+top1;
    x1=[];
    y1=[];
    for n=1:size(k,1)
        if abs(x(k(n))-max(x(k)))>20 && abs(x(k(n))-min(x(k)))>20
            x1=[x1;x(k(n))];
            y1=[y1;y(k(n))];
        end
    end
    x1_1=[];
    y1_1=[];
    x1_2=[];
    y1_2=[];
    for j=1:size(x1)
        if y1(j)<(min(y1)+max(y1))/2
            x1_1=[x1_1;x1(j)];
            y1_1=[y1_1;y1(j)];
        else
            x1_2=[x1_2;x1(j)];
            y1_2=[y1_2;y1(j)];
        end
    end
    subplot(2,1,1);
    imagesc(q1);colormap gray;hold on;plot(axis1,x_1);hold off
    title(['\fontsize{20} left=',num2str(mean(axis1(x1_1(1:11))-y1_1(1:11))),'   right=',num2str(mean(y1_2(1:11)-(axis1(x1_2(1:11))))),])
    
    [x,y]=find(E2==1);
    k=boundary(x,y);
    x=x+top2;
    x2=[];
    y2=[];
    for n=1:size(k,1)
        if abs(x(k(n))-max(x(k)))>20 && abs(x(k(n))-min(x(k)))>20
            x2=[x2;x(k(n))];
            y2=[y2;y(k(n))];
        end
    end
    x2_1=[];
    y2_1=[];
    x2_2=[];
    y2_2=[];
    for j=1:size(x2)
        if y2(j)<(min(y2)+max(y2))/2
            x2_1=[x2_1;x2(j)];
            y2_1=[y2_1;y2(j)];
        else
            x2_2=[x2_2;x2(j)];
            y2_2=[y2_2;y2(j)];
        end
    end
    subplot(2,1,2);
    imagesc(q2);colormap gray;hold on;plot(axis2,x_2);hold off;
    title(['\fontsize{20} left=',num2str(mean(axis2(x2_1(1:11))-y2_1(1:11))),'   right=',num2str(mean(y2_2(1:11)-(axis2(x2_2(1:11))))),])
    
    if ~ishandle(ButtonHandle)
        disp('Loop stopped by user');
        break;
    end
end
%%
top1=115;
bottom1=1300;
top2=250;
bottom2=1450;
figure;
ButtonHandle = uicontrol('Style', 'PushButton', ...
    'String', 'Stop loop', ...
    'Callback', 'delete(gcbf)');
while 1
    q1=getsnapshot(vid1);
    q2=getsnapshot(vid2);
    q1=double(q1);
    q2=double(q2);
    q1=q1.';
    q2=rot90(q2);
    E1=edge(q1(bottom1:end,:),'Prewitt',5,'vertical');
    E2=edge(q2(bottom2:end,:),'Prewitt',5,'vertical');
    [x,y]=find(E1==1);
    k=boundary(x,y);
    x=x+bottom1;
    x1=[];
    y1=[];
    for n=1:size(k,1)
        if abs(x(k(n))-max(x(k)))>50 && abs(x(k(n))-min(x(k)))>50
            x1=[x1;x(k(n))];
            y1=[y1;y(k(n))];
        end
    end
    x1_1=[];
    y1_1=[];
    x1_2=[];
    y1_2=[];
    for j=1:size(x1)
        if y1(j)<(min(y1)+max(y1))/2
            x1_1=[x1_1;x1(j)];
            y1_1=[y1_1;y1(j)];
        else
            x1_2=[x1_2;x1(j)];
            y1_2=[y1_2;y1(j)];
        end
    end
    [A,I]=sort(y1_1);
    x1_1=x1_1(I);
    y1_1=y1_1(I);
    [B,I]=sort(y1_2);
    x1_2=x1_2(I);
    y1_2=y1_2(I);
    subplot(2,1,1);
    imagesc(q1);colormap gray;hold on;plot(axis1,x_1);hold off;
    f_axis=fit(x_1.',axis1,'poly1');
%     f_tube1=fit(x1_1,y1_1,'poly1');
    f_tube2=fit(x1_2,y1_2,'poly1');
    title(['axis=',num2str(atand(f_axis.p1)),',tube=',num2str((0+atand(f_tube2.p1))/2)])
    
    [x,y]=find(E2==1);
    k=boundary(x,y);
    x=x+bottom2;
    x2=[];
    y2=[];
    for n=1:size(k,1)
        if abs(x(k(n))-max(x(k)))>50 && abs(x(k(n))-min(x(k)))>50
            x2=[x2;x(k(n))];
            y2=[y2;y(k(n))];
        end
    end
    x2_1=[];
    y2_1=[];
    x2_2=[];
    y2_2=[];
    for j=1:size(x2)
        if y2(j)<(min(y2)+max(y2))/2
            x2_1=[x2_1;x2(j)];
            y2_1=[y2_1;y2(j)];
        else
            x2_2=[x2_2;x2(j)];
            y2_2=[y2_2;y2(j)];
        end
    end
    [A,I]=sort(y2_1);
    x2_1=x2_1(I);
    y2_1=y2_1(I);
    [B,I]=sort(y2_2);
    x2_2=x2_2(I);
    y2_2=y2_2(I);
    subplot(2,1,2);
    imagesc(q2);colormap gray;hold on;plot(axis2,x_2);hold off;
    f_axis=fit(x_2.',axis2,'poly1');
%     f_tube1=fit(x2_1,y2_1,'poly1');
    f_tube2=fit(x2_2,y2_2,'poly1');
    title(['axis=',num2str(atand(f_axis.p1)),',tube=',num2str((0+atand(f_tube2.p1))/2)])
    
    if ~ishandle(ButtonHandle)
        disp('Loop stopped by user');
        break;
    end
end

%%
gap=1500;
top=585;
left=610;
right=870;
E=edge(img(top:gap,left:right),'Prewitt',10,'vertical');
[x,y]=find(E==1);
[m,I1]=max(y+x);
[m,I2]=min(y-x);
x1=x(I1)+top;
y1=y(I1)+left;
x2=x(I2)+top;
y2=y(I2)+left;
imagesc(img);colormap gray;hold on;
plot(y1,x1,'yo','MarkerSize',15);hold on;
plot(y2,x2,'yo','MarkerSize',15);hold off;
%%
E=edge(img(gap:end,left:right),'Prewitt',10,'vertical');
[x,y]=find(E==1);
[m,I1]=min(y+x);
[m,I2]=max(y-x);
x1=x(I1)+gap;
y1=y(I1)+left;
x2=x(I2)+gap;
y2=y(I2)+left;
imagesc(img);colormap gray;hold on;
plot(y1,x1,'yo','MarkerSize',15);hold on;
plot(y2,x2,'yo','MarkerSize',15);hold off;