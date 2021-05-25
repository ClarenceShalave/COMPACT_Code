parpool;% prepare the parfor;
%% initialize DVI control
window2 = Screen('OpenWindow',2);
%% set up image acquisition;
%vid = videoinput('tisimaq_r2013',1,'Y800 (2560x1920)');
%vid = videoinput('winvideo', 1, 'Y800_2048x1536');
%vid = videoinput('winvideo', 1, 'RGB32_2048x1536');
%vid = videoinput('tisimaq_r2013', 1, 'RGB32 (2048x1536)');
vid = videoinput('winvideo', 1, 'Y800_2048x1536');
src = getselectedsource(vid);
src.ExposureMode = 'manual';
src.Exposure = -10;
src.GainMode = 'manual';
src.Gain = 4;
% vid_src = getselectedsource(vid);
% vid_src.GainAuto='Off';
% vid_src.ExposureAuto='Off';
% vid_src.ExposureMode='manual';
% vid_src.GainMode='manual';
% vid_src.Gain=8;
% vid_src.Exposure=0.0004;
%vid_src.FrameRate='5';
q=getsnapshot(vid);imagesc(q(:,:));
%vid.ROIPosition = [250 150 1520 1280];
%% apply test image;
M=ones(600,800)*255;
M(1:100,1:100)=100;

M=ones(600,800)*255;
M(500:600,1:100)=100;

M=ones(600,800)*255;
M(500:600,700:800)=100;

M=ones(600,800)*255;
M(1:100,700:800)=100;

% M=ones(1024,1280)*255;
% M(900:1024,1:100)=0;
%
% M=ones(1024,1280)*255;
% M(900:1024,1100:1280)=0;
%
% M=ones(1024,1280)*255;
% M(1:100,1100:1280)=0;

M=uint8(M);Screen(window2, 'PutImage',M);Screen(window2,'Flip');
% SLMimage is a 600x792 matrix of uint8 format to be displayed on SLM

%% projective image transformation;
dx=7;
dy=-8;
tform = maketform('projective',[1632-dx  270+dy; 1627-dx 1156-dy; 301+dx 1154-dy; 305+dx 273+dy],[ 100 100;  100  500;  700 500; 700 100]);
%tform = maketform('projective',[119  130; 121 900; 1094 889; 1092 120],[ 100 100;  100  900;  1100 900; 1100 100]);
%tform = maketform('projective',[  79 111;  850 114;  839 1095;  69 1094],[ 100 100;    900 100;   900 1100;  100 1100]);
%tform = maketform('projective',[160 169; 153 1080; 762 1080; 769 175],[ 100 100;  100 700;  500 700; 500 100]);
q=getsnapshot(vid);q=double(q);
[B,xdata,ydata] = imtransform(q, tform);
imagesc(xdata, ydata, B);%colormap jet;
[x1,y1]=meshgrid(linspace(min(xdata), max(xdata), size(B,2)),linspace(min(ydata), max(ydata), size(B,1)));
%[x2,y2]=meshgrid(-20:1272,1:1024);
[x2,y2]=meshgrid(-59:792,1:600);
C=interp2(x1,  y1,B,  x2, y2);
imagesc(C);
%% start calibration;
M=0*ones(600,800);M=uint8(M);
Screen(window2, 'PutImage',M);Screen(window2,'Flip');
pause(0.3);
data=[];
for k=0:5:255
    M=k*ones(600,800);M=uint8(M);
    Screen(window2, 'PutImage',M);Screen(window2,'Flip');
    pause(0.3);
    q=getsnapshot(vid);q=double(q);
    data=cat(3, data,q);
    disp(k);
end
q1=double(getsnapshot(vid));%q1=q1(:,:,3);% slm beam;
q2=double(getsnapshot(vid));%q2=q2(:,:,3);% mirror beam;
q3=double(getsnapshot(vid));%q3=q3(:,:,3);% no beam;
% preview data;
for k=1:size(data,3)
    imagesc(data(:,:,k));
    drawnow;
    pause(0.1);
end
%% process data;
offset=q1+q2-q3;
phasedata=zeros(600,792,52);
mask=zeros(600,792);
centery=-577;
centerx=-25;
centerR=15;
mask(abs(centery)-centerR:abs(centery)+centerR, abs(centerx)-centerR:abs(centerx)+centerR)=1;
parfor k=1:52
    m=data(:,:,k)-offset;
    [B,xdata,ydata] = imtransform(m, tform);
    C=interp2(x1,  y1,B,  x2, y2);
    base=C(:,1:60);
    basef=fft2(base);
    %basef(:,1:10)=0;    basef(513:1024,:)=0;
    basephase=angle(basef(577,3));
    C(:,1:60)=[];
    fC=fft2(C);
    %fC(:,1:636)=0;    fC(513:end,:)=0;
    fC=fC.*mask;
    newc=circshift(fC,[ centery,centerx]);
    newc=ifft2(newc);
    slmphase=angle(newc.*exp(-1i*basephase));
    phasedata(:,:,k)=slmphase;
end
%% process data; check phase range for each pixel;
phaserange=zeros(600,792);
parfor k1=1:600
    for k2=1:792
        g=unwrap(squeeze(phasedata(k1,k2,:)));
        phaserange(k1,k2)=g(1)-g(end);
    end
end
imagesc(phaserange);
%% determine the fitting curve in 6x8 blocks;
%% replace bad region with neighbor pixels;
%phasedata(:,1:8,:)=phasedata(:,9:16,:);phasedata(:,390:408,:)=phasedata(:,409:427,:);phasedata(:,790:792,:)=phasedata(:,787:789,:);
phasedata(:,1:15,:)=phasedata(:,16:30,:);
phasedata(594:600,:,:)=phasedata(587:593,:,:);
%phasedata(237:315,1264:1268,:)=phasedata(237:315,(1264:1268)-5,:);
%% work on each block;
v=0:5:255;
phasearray=zeros(10,12,52);
for k1=1:10
    for k2=1:12
        m=phasedata((k1-1)*60+1:(k1-1)*60+60,(k2-1)*66+1:(k2-1)*66+66,:);
        m=unwrap(m,[],3);
        m=squeeze(mean(m,1));
        m=squeeze(mean(m,1));
        f=fit(v',m','poly4');
        nm=f.p1*v.^4 + f.p2*v.^3 + f.p3*v.^2 + f.p4*v + f.p5;
        phasearray(k1,k2,:)=nm;
        plot(v,m,v,nm);title(num2str([k1, k2]));drawnow;
    end
end
%% get voltage array;
voltagearray=zeros(10,12,6);
for k1=1:10
    for k2=1:12
        nm=squeeze(phasearray(k1,k2,:));
        %nm=max(nm)-nm;
        nm=nm-min(nm);
        ft = fittype( 'poly6' );
        opts = fitoptions( 'Method', 'LinearLeastSquares' );
        opts.Lower = [-Inf -Inf -Inf -Inf -Inf -Inf -1e-09];
        opts.Upper = [Inf Inf Inf Inf Inf Inf 1e-09];
        [f, gof] = fit( nm, v', ft, opts );
        nv=f.p1*nm.^6 + f.p2*nm.^5 + f.p3*nm.^4 + f.p4*nm.^3+f.p5*nm.^2+f.p6*nm.^1;
        voltagearray(k1,k2,:)=[f.p1,f.p2,f.p3,f.p4,f.p5,f.p6];
        plot(nm,v-nv');ylim([-20,20]);title(num2str([k1, k2]));drawnow;
        pause(0.2);
    end
end
%% use the voltage array to flatten the interference;
% see if we need a second iteration to make it better;
M=zeros(600,792);M=uint8(M);Screen(window2, 'PutImage',M);Screen(window2,'Flip');
pause(0.4);
outputphase=zeros(600,792);
vout=zeros(600,792);
for roundn=1:3
    q=getsnapshot(vid);q=double(q);
    m=q-offset;
    [B,xdata,ydata] = imtransform(m, tform);
    C=interp2(x1,  y1,B,  x2, y2);
    C(:,1:60)=[];
    fC=fft2(C);
    %fC(:,1:636)=0;    fC(513:end,:)=0;
    fC=fC.*mask;
    newc=circshift(fC,[ centery,centerx]);
    newc=ifft2(newc);
    slmphase=angle(newc);
    imagesc(slmphase);colorbar;
    title(num2str(std(slmphase(:))));    drawnow;
    outputphase=outputphase-slmphase;
    outputphase=angle(exp(1i*outputphase))+1.4*pi;% shift minimum to above 0;
    for k1=1:10
        for k2=1:12
            phaseblock=outputphase((k1-1)*60+1:(k1-1)*60+60,(k2-1)*66+1:(k2-1)*66+66);
            vblock=voltagearray(k1,k2,1)*phaseblock.^6 + voltagearray(k1,k2,2)*phaseblock.^5 + voltagearray(k1,k2,3)*phaseblock.^4 + voltagearray(k1,k2,4)*phaseblock.^3+voltagearray(k1,k2,5)*phaseblock.^2+voltagearray(k1,k2,6)*phaseblock.^1;
            vout((k1-1)*60+1:(k1-1)*60+60,(k2-1)*66+1:(k2-1)*66+66)=vblock;
        end
    end
    vout=uint8(vout);
    Screen(window2, 'PutImage',vout);Screen(window2,'Flip');
    pause(0.5);
end

q=getsnapshot(vid);q=double(q);
m=q-offset;
[B,xdata,ydata] = imtransform(m, tform);
C=interp2(x1,  y1,B,  x2, y2);
C(:,1:60)=[];
fC=fft2(C);
%fC(:,1:636)=0;    fC(513:end,:)=0;
fC=fC.*mask;
newc=circshift(fC,[ centery,centerx]);
newc=ifft2(newc);
slmphase=angle(newc);
imagesc(slmphase);colorbar;
title(num2str(std(slmphase(:))));    drawnow;