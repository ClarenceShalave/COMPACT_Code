%% initialize DVI control
window2 = Screen('OpenWindow',2);
%% import voltage array data;
load('G:\Meng\Data\20181117SLM\voltagearray930nm.mat');
load('G:\Meng\Data\20181117SLM\slmphase930nm.mat');
%% create video object;
vidc = videoinput('winvideo', 1, 'Y800_1280x960');
srcc = getselectedsource(vidc);
srcc.ExposureMode = 'manual';
srcc.GainMode = 'manual';
srcc.Gain = 10;
srcc.Exposure = -2;
%% apply test image;
%%
M=ones(600,792)*0;
M(1:200,1:200)=pi;
%%
M=ones(600,792)*0;
M(400:600,1:200)=pi;
%%
M=ones(600,792)*0;
M(400:600,600:792)=pi;
%%
M=ones(600,792)*0;
M(1:200,600:792)=pi;
%%
% M=ones(1024,1280)*255;
% M(900:1024,1:100)=0;
%
% M=ones(1024,1280)*255;
% M(900:1024,1100:1280)=0;
%
% M=ones(1024,1280)*255;
% M(1:100,1100:1280)=0;
%%
outputphase=angle(exp(1i*(M-slmphase)))+1.1*pi;% shift minimum to above 0;
for k1=1:10
    
    for k2=1:12
        phaseblock=outputphase((k1-1)*60+1:(k1-1)*60+60,(k2-1)*66+1:(k2-1)*66+66);
        vblock=voltagearray(k1,k2,1)*phaseblock.^6 + voltagearray(k1,k2,2)*phaseblock.^5 + voltagearray(k1,k2,3)*phaseblock.^4 + voltagearray(k1,k2,4)*phaseblock.^3+voltagearray(k1,k2,5)*phaseblock.^2+voltagearray(k1,k2,6)*phaseblock.^1;
        vout((k1-1)*60+1:(k1-1)*60+60,(k2-1)*66+1:(k2-1)*66+66)=vblock;
    end
end
vout=uint8(vout);
Screen(window2, 'PutImage',vout);Screen(window2,'Flip');
pause(0.15);
%%
q=getsnapshot(vidc);q=double(q);figure;imagesc(q);colormap gray;
% M=uint8(M);Screen(window2, 'PutImage',M);Screen(window2,'Flip');
% SLMimage is a 600x792 matrix of uint8 format to be displayed on SLM

%% projective image transformation;
dx=0;
dy=0;
tform = maketform('projective',[470-dx  575+dy; 473-dx 402-dy; 812+dx 400-dy; 814+dx 574+dy],[ 200 200;  200  400;  600 400; 600 200]);
%tform = maketform('projective',[119  130; 121 900; 1094 889; 1092 120],[ 100 100;  100  900;  1100 900; 1100 100]);
%tform = maketform('projective',[  79 111;  850 114;  839 1095;  69 1094],[ 100 100;    900 100;   900 1100;  100 1100]);
%tform = maketform('projective',[160 169; 153 1080; 762 1080; 769 175],[ 100 100;  100 700;  500 700; 500 100]);
q=getsnapshot(vidc);q=double(q);
[B,xdata,ydata] = imtransform(q, tform);
imagesc(xdata, ydata, B);%colormap jet;
[x1,y1]=meshgrid(linspace(min(xdata), max(xdata), size(B,2)),linspace(min(ydata), max(ydata), size(B,1)));
%[x2,y2]=meshgrid(-20:1272,1:1024);
[x2,y2]=meshgrid(1:792,1:600);
C=interp2(x1,  y1,B,  x2, y2);
imagesc(C);
%% record images;
q0=double(getsnapshot(vidc));
q1=double(getsnapshot(vidc));
q2=double(getsnapshot(vidc));
q=double(getsnapshot(vidc));
q3=q-q1-q2+q0;
%%
[B,xdata,ydata] = imtransform(double(q3), tform);
imagesc(xdata, ydata, B);%colormap jet;
[x1,y1]=meshgrid(linspace(min(xdata), max(xdata), size(B,2)),linspace(min(ydata), max(ydata), size(B,1)));
%[x2,y2]=meshgrid(-20:1272,1:1024);
[x2,y2]=meshgrid(1:792,1:600);
C=interp2(x1,  y1,B,  x2, y2);
imagesc(C);
%% define amp mask;
[x,y]=meshgrid(1:792,1:600);
mask=0.*x;
id=find((x-392).^2+(y-288).^2<=335.^2);
mask(id)=1;
m2=mask.*C;
imagesc(m2);
%% fourier domain processing;
fm=fft2(m2);
imagesc(log(abs(fm)));colorbar;
maskf=0.*x;
fcx=749;
fcy=27;
fr=27;
id=find((x-fcx).^2+(y-fcy).^2<=fr^2);
maskf(id)=1;
fm2=fm.*maskf;
fm3=circshift(fm2,-[fcy,fcx]);
imagesc(log(abs(fm3)));
m3=ifft2(fm3).*mask;
imagesc(angle(m3));colormap hsv;
%imagesc(w);colormap hsv;
title(['fileN cx, cy, r, fcx, fcy, fr = ',filenumber,'  ',num2str([cx, cy, r, fcx, fcy, fr])]);
w=angle(m3);
%% phase shifting;
a=ones(600,792);
n=3;
psm=[];
for k=0:n-1
    M=a.*k.*(2*pi/n);
    outputphase=angle(exp(1i*(M-slmphase)))+1.1*pi;% shift minimum to above 0;
    for k1=1:10
        
        for k2=1:12
            phaseblock=outputphase((k1-1)*60+1:(k1-1)*60+60,(k2-1)*66+1:(k2-1)*66+66);
            vblock=voltagearray(k1,k2,1)*phaseblock.^6 + voltagearray(k1,k2,2)*phaseblock.^5 + voltagearray(k1,k2,3)*phaseblock.^4 + voltagearray(k1,k2,4)*phaseblock.^3+voltagearray(k1,k2,5)*phaseblock.^2+voltagearray(k1,k2,6)*phaseblock.^1;
            vout((k1-1)*60+1:(k1-1)*60+60,(k2-1)*66+1:(k2-1)*66+66)=vblock;
        end
    end
    vout=uint8(vout);
    psm=cat(3, psm, vout);
end
%% acquire data;
data=[];
tic;
for k=0:n-1
    vout=psm(:,:,k+1);
    Screen(window2, 'PutImage',vout);Screen(window2,'Flip');
    pause(0.15);
    q=getsnapshot(vidc);
    data=cat(3, data, q);
end
toc;
%% data processing;
cdata=[];
for k=0:n-1
    m=double(data(:,:,k+1));
    [B,xdata,ydata] = imtransform(m, tform);
    imagesc(xdata, ydata, B);%colormap jet;
    [x1,y1]=meshgrid(linspace(min(xdata), max(xdata), size(B,2)),linspace(min(ydata), max(ydata), size(B,1)));
    %[x2,y2]=meshgrid(-20:1272,1:1024);
    [x2,y2]=meshgrid(1:792,1:600);
    C=interp2(x1,  y1,B,  x2, y2);
    imagesc(C);drawnow; %pause(1);
    cdata=cat(3, cdata, C);
end
cdataF=fft(cdata, [], 3);
cdataF2=cdataF(:,:,2);
cphase=angle(cdataF2);
imagesc(cphase);colormap hsv;
%% test correction;
outputphase=angle(exp(1i*(-cphase_avg-slmphase)))+1.1*pi;% shift minimum to above 0;
for k1=1:10
    
    for k2=1:12
        phaseblock=outputphase((k1-1)*60+1:(k1-1)*60+60,(k2-1)*66+1:(k2-1)*66+66);
        vblock=voltagearray(k1,k2,1)*phaseblock.^6 + voltagearray(k1,k2,2)*phaseblock.^5 + voltagearray(k1,k2,3)*phaseblock.^4 + voltagearray(k1,k2,4)*phaseblock.^3+voltagearray(k1,k2,5)*phaseblock.^2+voltagearray(k1,k2,6)*phaseblock.^1;
        vout((k1-1)*60+1:(k1-1)*60+60,(k2-1)*66+1:(k2-1)*66+66)=vblock;
    end
end
vout=uint8(vout);
Screen(window2, 'PutImage',vout);Screen(window2,'Flip');
pause(0.15);
%% compare;
outputphase=-1*slmphase;
outputphase=angle(exp(1i*outputphase))+1.1*pi;% shift minimum to above 0;
for k1=1:10
    
    for k2=1:12
        phaseblock=outputphase((k1-1)*60+1:(k1-1)*60+60,(k2-1)*66+1:(k2-1)*66+66);
        vblock=voltagearray(k1,k2,1)*phaseblock.^6 + voltagearray(k1,k2,2)*phaseblock.^5 + voltagearray(k1,k2,3)*phaseblock.^4 + voltagearray(k1,k2,4)*phaseblock.^3+voltagearray(k1,k2,5)*phaseblock.^2+voltagearray(k1,k2,6)*phaseblock.^1;
        vout((k1-1)*60+1:(k1-1)*60+60,(k2-1)*66+1:(k2-1)*66+66)=vblock;
    end
end
vout=uint8(vout);
Screen(window2, 'PutImage',vout);Screen(window2,'Flip');
pause(0.2);
%%
cphase_unwarp=[];
for j=1:5
    cdata=[];
    data=[];
    for k=0:n-1
        vout=psm(:,:,k+1);
        Screen(window2, 'PutImage',vout);Screen(window2,'Flip');
        pause(0.15);
        q=double(getsnapshot(vidc));
        data=cat(3, data, q);
    end
    for k=0:n-1
        m=double(data(:,:,k+1));
        [B,xdata,ydata] = imtransform(m, tform);
        imagesc(xdata, ydata, B);%colormap jet;
        [x1,y1]=meshgrid(linspace(min(xdata), max(xdata), size(B,2)),linspace(min(ydata), max(ydata), size(B,1)));
        %[x2,y2]=meshgrid(-20:1272,1:1024);
        [x2,y2]=meshgrid(1:792,1:600);
        C=interp2(x1,  y1,B,  x2, y2);
        imagesc(C);drawnow; %pause(1);
        cdata=cat(3, cdata, C);
    end
    cdataF=fft(cdata, [], 3);
    cdataF2=cdataF(:,:,2);
    cphase=angle(cdataF2);
    cphase_unwarp_temp=unwrap_L2Norm(cphase.*mask);
    cphase_unwarp=cat(3,cphase_unwarp,cphase_unwarp_temp);
end
cphase_avg=angle(exp(1i*mean(cphase_unwarp,3)));
figure;imagesc(cphase_avg);colormap hsv
%%
outputphase=zeros(600,792);
outputphase(1:300,1:792/2)=0;
outputphase(1:300,792/2+1:792)=pi;
outputphase(301:600,1:792/2)=pi;
outputphase(301:600,792/2+1:792)=0;
outputphase=angle(exp(1i*(outputphase-slmphase)))+1.1*pi;% shift minimum to above 0;
for k1=1:10
    
    for k2=1:12
        phaseblock=outputphase((k1-1)*60+1:(k1-1)*60+60,(k2-1)*66+1:(k2-1)*66+66);
        vblock=voltagearray(k1,k2,1)*phaseblock.^6 + voltagearray(k1,k2,2)*phaseblock.^5 + voltagearray(k1,k2,3)*phaseblock.^4 + voltagearray(k1,k2,4)*phaseblock.^3+voltagearray(k1,k2,5)*phaseblock.^2+voltagearray(k1,k2,6)*phaseblock.^1;
        vout((k1-1)*60+1:(k1-1)*60+60,(k2-1)*66+1:(k2-1)*66+66)=vblock;
    end
end
vout=uint8(vout);
Screen(window2, 'PutImage',vout);Screen(window2,'Flip');
%%
m_test=unwrap_L2Norm(cphase_avg.*mask);
m=m_test;
m1=m(287,102:426);
m_phase=zeros(600,792);
center_phase_x=287;
center_phase_y=426;
radius=325;
for i=1:600
    for j=1:792
        distance=sqrt((i-center_phase_x)^2+(j-center_phase_y)^2);
        if distance<radius+0.1
            m_phase(i,j)=fit_m(distance);
        end
    end
end