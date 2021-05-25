%% set up galvo control;
s = daq.createSession('ni');
s.Rate=1e3;
addAnalogOutputChannel(s,'Dev1', 'ao0', 'Voltage');% x;
addAnalogOutputChannel(s,'Dev1', 'ao1', 'Voltage');% y;
%% initialize the daq
s1 = daq.createSession('ni');
s1.Rate = 1e3;
addAnalogInputChannel(s1,'Dev2','ai1','Voltage');
s1.NumberOfScans=50;
daqrange=10;
s1.Channels(1).Range=[-daqrange daqrange];
% dev2 ai1
%%
s.outputSingleScan([-0.7,0.75]);
%% initialize DVI control
window2 = Screen('OpenWindow',2);
%% set up image acquisition;
vid = videoinput('winvideo', 2, 'Y800_640x480');
src = getselectedsource(vid);
src.GainMode = 'manual';
src.ExposureMode='manual';
src.Gain = 4;
src.Exposure = -12;
% src.FrameRate='52.37';
%vid.ROIPosition = [700 370 1700 1300];
%% import voltage array data;
load('G:\Meng\Data\20181117SLM\voltagearray930nm.mat');
load('G:\Meng\Data\20181117SLM\slmphase930nm.mat');
%% prepare modulation matrix;
nx=792;
ny=600;
blocknx=36;
blockny=30;
phase=zeros(blockny,blocknx, blocknx*blockny*4/2);
ModulatePhase=zeros(blockny,blocknx/2, blocknx*blockny*4/2);
phasestep=linspace(0,2*pi, blocknx*blockny*4/2+1);
phasestep(end)=[];
phasestep=phasestep(blocknx*blockny/2+1:blocknx*blockny);
phasestep=reshape(phasestep,blockny, blocknx/2);
for k=1:blocknx*blockny*4/2
    ModulatePhase(:,:,k)=(k-1)*phasestep;
end
% for k=1:blocknx*blockny*4/2
%     imagesc(angle(exp(1i*ModulatePhase(:,:,k))));colormap gray;
%     drawnow;pause(0.05);
% end

%%
cx=389;
cy=171;
r=3;
x=1:640;
y=1:480;
[X,Y]=meshgrid(x,y);
mask=X.*0;
id=find((X-cx).^2+(Y-cy).^2<=r^2);
mask(id)=1;
q=double(getsnapshot(vid));
m2=q.*mask;
figure;
imagesc(m2);
pixel=sum(mask(:));
%% start modulation;
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
finalphase=zeros(blockny,blocknx);% initial phase of the SLM;
finalamp=zeros(blockny,blocknx);
% cx=302;
% cy=196;
r=6;
x=1:640;
y=1:480;
[X,Y]=meshgrid(x,y);
mask=X.*0;
id=find((X-cx).^2+(Y-cy).^2<=r^2);
mask(id)=1;
mask1=mask;
pixel=sum(mask(:));
reference=double(getsnapshot(vid));
for roundn=1:1
    %first half;
%    src.Exposure=-12;pause(0.1);
    phase(:,1:blocknx/2, :)=ModulatePhase;
    phase(:,blocknx/2+1:blocknx, :)=repmat(finalphase(:,blocknx/2+1:blocknx),[1,1,size(phase,3)]);
    signal=zeros(size(phase,3),1);
    for k=1:size(phase,3)
        % display phase on SLM here;
%         if(rem(k,100)==0)
%             referencephase=-1*slmphase;
%             referencephase=angle(exp(1i*referencephase))+1.1*pi;% shift minimum to above 0;
%             for k1=1:10
%                 for k2=1:12
%                     phaseblock=referencephase((k1-1)*60+1:(k1-1)*60+60,(k2-1)*66+1:(k2-1)*66+66);
%                     vblock=voltagearray(k1,k2,1)*phaseblock.^6 + voltagearray(k1,k2,2)*phaseblock.^5 + voltagearray(k1,k2,3)*phaseblock.^4 + voltagearray(k1,k2,4)*phaseblock.^3+voltagearray(k1,k2,5)*phaseblock.^2+voltagearray(k1,k2,6)*phaseblock.^1;
%                     vout((k1-1)*60+1:(k1-1)*60+60,(k2-1)*66+1:(k2-1)*66+66)=vblock;
%                 end
%             end
%             vout=uint8(vout);
%             Screen(window2, 'PutImage',vout);Screen(window2,'Flip');
%             pause(0.2);
%             q=double(getsnapshot(vid));
%             ref=xcorr2(reference,q);
%             [id1,id2]=find(ref==max(max(ref)));
%             shift=[id1,id2]-size(q);
%             mask=circshift(mask1,-shift);
%         end
        m=squeeze(phase(:,:,k));
        outputphase=Expand(m, nx/blocknx, ny/blockny);
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
        pause(0.15);
        q=double(getsnapshot(vid));
        m2=q.*mask;
        signal(k)=sum(m2(:))/pixel;
    end
    SF=fft(signal);
    newphase=-1*angle(SF(blocknx*blockny/2+1:blocknx*blockny));
    newphase=reshape(newphase,blockny, blocknx/2);
    newamp=abs(SF(blocknx*blockny/2+1:blocknx*blockny));
    newamp=reshape(newamp, blockny, blocknx/2);
    finalamp(:,1:blocknx/2)=newamp;
    finalphase(:,1:blocknx/2)=newphase;
    
    % pause to decide continue or not
    figure;imagesc(finalphase);colormap hsv;
%     figure;imagesc(finalamp);colormap gray;
    promptMessage = sprintf('first half done,\ncontinue to second half?');
    titleBarCaption = 'Continue?';
    button = questdlg(promptMessage, titleBarCaption, 'Continue', 'Cancel', 'Continue');
    if strcmpi(button, 'Cancel')
        break; % or break, if you're in a loop
    end
    
    % second half;
%     src.Exposure=-12;pause(0.1);
    phase(:,blocknx/2+1:blocknx, :)=ModulatePhase;
    phase(:,1:blocknx/2, :)=repmat(finalphase(:,1:blocknx/2),[1,1,size(phase,3)]);
    signal=zeros(size(phase,3),1);
    for k=1:size(phase,3)
%         if(rem(k,100)==0)
%             referencephase=-1*slmphase;
%             referencephase=angle(exp(1i*referencephase))+1.1*pi;% shift minimum to above 0;
%             for k1=1:10
%                 for k2=1:12
%                     phaseblock=referencephase((k1-1)*60+1:(k1-1)*60+60,(k2-1)*66+1:(k2-1)*66+66);
%                     vblock=voltagearray(k1,k2,1)*phaseblock.^6 + voltagearray(k1,k2,2)*phaseblock.^5 + voltagearray(k1,k2,3)*phaseblock.^4 + voltagearray(k1,k2,4)*phaseblock.^3+voltagearray(k1,k2,5)*phaseblock.^2+voltagearray(k1,k2,6)*phaseblock.^1;
%                     vout((k1-1)*60+1:(k1-1)*60+60,(k2-1)*66+1:(k2-1)*66+66)=vblock;
%                 end
%             end
%             vout=uint8(vout);
%             Screen(window2, 'PutImage',vout);Screen(window2,'Flip');
%             pause(0.2);
%             q=double(getsnapshot(vid));
%             ref=xcorr2(reference,q);
%             [id1,id2]=find(ref==max(max(ref)));
%             shift=[id1,id2]-size(q);
%             mask=circshift(mask1,-shift);
%         end
        % display phase on SLM here;
        m=squeeze(phase(:,:,k));
        outputphase=Expand(m, nx/blocknx, ny/blockny);
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
        pause(0.15);
        q=double(getsnapshot(vid));
        m2=q.*mask;
        signal(k)=sum(m2(:))/pixel;
    end
    SF=fft(signal);
    newphase=-1*angle(SF(blocknx*blockny/2+1:blocknx*blockny));
    newphase=reshape(newphase,blockny, blocknx/2);
    newamp=abs(SF(blocknx*blockny/2+1:blocknx*blockny));
    newamp=reshape(newamp, blockny, blocknx/2);
    finalamp(:,blocknx/2+1:blocknx)=newamp;
    finalphase(:,blocknx/2+1:blocknx)=newphase;
end
%imagesc(angle(exp(1i*(finalphase+aberration))));colorbar;colormap hsv;
figure;imagesc(finalphase);colormap hsv;
figure;imagesc(finalamp);colormap gray;
%% apply final correction;
outputphase=Expand(finalphase, nx/blocknx, ny/blockny);
% imagesc(outputphase);
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
pause(0.2);
% figure;q=getsnapshot(vid);imagesc(q);colorbar;title(max(q(:)));
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
% figure;q=getsnapshot(vid);imagesc(q);colorbar;title(max(q(:)));

%% smooth the measured wavefront;
a=ones(600,792);
outputphase=Expand(finalphase, nx/blocknx, ny/blockny);
E=a.*exp(1i*outputphase);
E2=fftshift(fft2(E));
x=1:792;
y=1:600;
[X,Y]=meshgrid(x,y);
id=find((X-397).^2+(Y-301).^2<=15.^2);
fmask=0.*X;
fmask(id)=1;
E3=E2.*fmask;
E4=ifft2(ifftshift(E3));
finalphasesmooth=angle(E4);
imagesc(finalphasesmooth);colormap hsv;
outputphase=angle(exp(1i*(finalphasesmooth-slmphase)))+1.1*pi;% shift minimum to above 0;
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
% figure;q=getsnapshot(vid);imagesc(q);colorbar;title(max(q(:)));
%% add defocusing;
% each pixel is 20 micron;after relay, 40/3 micron;
x=1:792;
y=1:600;
centerx=374+0;
centery=300+0;
pixelsize=0.04/3;
hx=(x-centerx)*pixelsize;
hy=(y-centery)*pixelsize;
n=1.33;
f=180/20;
lambda=0.93;% unit micron;
xNA=hx/f;
yNA=hy/f;
[XNA, YNA]=meshgrid(xNA, yNA);
XYNA=sqrt(XNA.^2+YNA.^2);
theta=asin(XYNA/n);
defocus_distance=-16;% unit micron;
defocus_wavefront=defocus_distance*n*cos(theta)/lambda*2*pi;
outputphase=Expand(finalphase, nx/blocknx, ny/blockny);
if defocus_distance>0
    defocus_wavefront=defocus_wavefront-max(defocus_wavefront(:));
else
    defocus_wavefront=defocus_wavefront-min(defocus_wavefront(:));
end
outputphase=angle(exp(1i*(outputphase+defocus_wavefront-slmphase)))+1.1*pi;% shift minimum to above 0;
for k1=1:10
    for k2=1:12
        phaseblock=outputphase((k1-1)*60+1:(k1-1)*60+60,(k2-1)*66+1:(k2-1)*66+66);
        vblock=voltagearray(k1,k2,1)*phaseblock.^6 + voltagearray(k1,k2,2)*phaseblock.^5 + voltagearray(k1,k2,3)*phaseblock.^4 + voltagearray(k1,k2,4)*phaseblock.^3+voltagearray(k1,k2,5)*phaseblock.^2+voltagearray(k1,k2,6)*phaseblock.^1;
        vout((k1-1)*60+1:(k1-1)*60+60,(k2-1)*66+1:(k2-1)*66+66)=vblock;
    end
end
vout=uint8(vout);
Screen(window2, 'PutImage',vout);Screen(window2,'Flip');
%figure;imagesc(outputphase);
%% save image;
q=getsnapshot(vid);
imwrite(q,'image850_11.tif');
%% record zoom info;
s.outputSingleScan([-0.5, -0.7-0.4]);
q=getsnapshot(vid);
imwrite(q,'image250_zoom1.tif');
pause(0.2);
s.outputSingleScan([-0.5, -0.7+0.4]);
q=getsnapshot(vid);
imwrite(q,'image250_zoom2.tif');