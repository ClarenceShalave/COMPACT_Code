%% set up galvo control;
% s = daq.createSession('ni');
% s.Rate=1e3;
% addAnalogOutputChannel(s,'Dev1', 'ao0', 'Voltage');% x;
% addAnalogOutputChannel(s,'Dev1', 'ao1', 'Voltage');% y;
% addAnalogInputChannel(s,'Dev1','ai3','Voltage');
% %% galvo at;
% gx=0;
% gy=0;
% %%
% galvox=repmat(gx,[50,1]);
% galvoy=repmat(gy,[50,1]);
% for i=1:10
%     s.queueOutputData([galvox,galvoy]);
%     [data,time]=s.startForeground;
%     test(i)=mean(data);
% end
% test
%% galvo search mode;
% searchRange=0.1;
% scandata=linspace(-searchRange,searchRange, NumberOfScans);
%% galvo stay mode;
% staydata=ones(NumberOfScans,1);
%% galvo at;
% gx=0;
% gy=0;
%% set up power contro;
% s1 = daq.createSession('ni');
% addAnalogOutputChannel(s1,'Dev2', 'ao0', 'Voltage');% x;
% vmax=0.9;
% %%
% power=0.1;% power in percentage;
% EOv=acos(1-2*power)*vmax/pi;
% if EOv<=vmax
%     s1.outputSingleScan(EOv);
% else
%     disp('EO voltage too high');
% end
%% prepare scan waveform;
% % search for x;
% aox=gx+scandata;
% aoy=gy*staydata;
% s.queueOutputData([aox(:),aoy(:)]);
% [data,time]=s.startForeground;
% plot(data);
% [C,I]=max(data);
% fitn=20;
% d2=data(I-fitn:I+fitn);
% id=-fitn:fitn;
% moveby=sum(d2.*id')/sum(d2)+I;
% 
% gx=gx+scandata(round(moveby));
%% prepare the waveform;
% rate=4e5;% set daq rate, for 40 dB photodiode setting, we need at least 300k Hz sampling;
% s.Rate=rate;
% recordtime=1/4;% image recording time;
% dataN=rate*recordtime;
% lineN=40;
% dataPerline=dataN/lineN;
% pixelPerline=100;
% averageN=dataPerline/pixelPerline;% need to low pass filter the data (too many samplings/ micron) to reduce noise;
% amp=0.1;
% x=linspace(-amp, amp, dataPerline);
% xdata=repmat(x(:), lineN)+gx;
% xdata=xdata(:,1);
% ydata=linspace(-amp,amp,dataN)+gy;
% %%
% % plot(ydata,xdata);
% s.queueOutputData([xdata,ydata']);
% [data,time]=s.startForeground;
% d2=mean(reshape(data, averageN, dataN/averageN));% first low pass the recorded data;
% d2=reshape(d2, pixelPerline, lineN)';
% d2=d2(:,4:end);
% % need to get rid of the fly back data;
% imagesc(d2);
% %%
% reference=d2;
%%
% s.outputSingleScan([0,0]);
%% initialize DVI control
window2 = Screen('OpenWindow',2);
%% set up image acquisition;
% vid = videoinput('winvideo', 1, 'Y800_640x480');
% src = getselectedsource(vid);
% src.GainMode = 'manual';
% src.ExposureMode='manual';
% src.Gain = 260;
% src.Exposure = -12;
% src.FrameRate='15.0000';
%vid.ROIPosition = [700 370 1700 1300];
%% import voltage array data;
load('G:\Meng\Data\20181117SLM\voltagearray930nm.mat');
load('G:\Meng\Data\20181117SLM\slmphase930nm.mat');
%% prepare modulation matrix;
reference=double(state.acq.acquiredData{1,1}{1,1});
% filecounter=1;
% position=zeros(1,2);
[cy,cx]=find(reference==max(reference(:)));
% cx=32;
% cy=34;
r=3;
x=1:64;
y=1:64;
[X,Y]=meshgrid(x,y);
mask=X.*0;
id=find((X-cx).^2+(Y-cy).^2<=r^2);
mask(id)=1;
mask1=mask;
pixel=sum(mask(:));
nx=792;
ny=600;
blocknx=24;
blockny=20;
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
reference=double(state.acq.acquiredData{1,1}{1,1});

finalphase=zeros(blockny,blocknx);% initial phase of the SLM;
finalamp=zeros(blockny,blocknx);
%aberration=repmat(sin((1:24)/12*pi), 20,1)*1;
%aberration=rand(20,24)*2*pi;
% cx=154;
% cy=107;
% r=7;
% x=1:640;
% y=1:480;
% [X,Y]=meshgrid(x,y);
% mask=X.*0;
% id=find((X-cx).^2+(Y-cy).^2<=r^2);
% mask(id)=1;
% pixel=sum(mask(:));
% focusX=241:257;% focusY=217:236;
% focusY=284:303;% focusX=332:350;
for roundn=1:1
    %first half;
    %vid_src.Exposure=-5;pause(0.1);
%     power=0.15;% power in percentage;
%     EOv=acos(1-2*power)*vmax/pi;
%     if EOv<=vmax
%     s1.outputSingleScan(EOv);
%     else
%     disp('EO voltage too high');
%     end
    % set up power
    
    phase(:,1:blocknx/2, :)=ModulatePhase;
    phase(:,blocknx/2+1:blocknx, :)=repmat(finalphase(:,blocknx/2+1:blocknx),[1,1,size(phase,3)]);
    signal=zeros(size(phase,3),1);
    
    for k=1:size(phase,3)
        % display phase on SLM here;
        if(rem(k,100)==0)
%             s.Rate=rate;
            referencephase=-1*slmphase;
            referencephase=angle(exp(1i*referencephase))+1.1*pi;% shift minimum to above 0;
                for k1=1:10
                    for k2=1:12
                        phaseblock=referencephase((k1-1)*60+1:(k1-1)*60+60,(k2-1)*66+1:(k2-1)*66+66);
                        vblock=voltagearray(k1,k2,1)*phaseblock.^6 + voltagearray(k1,k2,2)*phaseblock.^5 + voltagearray(k1,k2,3)*phaseblock.^4 + voltagearray(k1,k2,4)*phaseblock.^3+voltagearray(k1,k2,5)*phaseblock.^2+voltagearray(k1,k2,6)*phaseblock.^1;
                        vout((k1-1)*60+1:(k1-1)*60+60,(k2-1)*66+1:(k2-1)*66+66)=vblock;
                    end
                end
            vout=uint8(vout);
            Screen(window2, 'PutImage',vout);Screen(window2,'Flip');
            pause(0.2);
            %add the slm phase
%             s.queueOutputData([xdata,ydata']);
%             [data,time]=s.startForeground;
%             d2=mean(reshape(data, averageN, dataN/averageN));% first low pass the recorded data;
%             d2=reshape(d2, pixelPerline, lineN)';
%             d2=d2(:,4:end);
%             %record image
%             ref=xcorr2(reference,d2);
%             [id1,id2]=find(ref==max(max(ref)));
%             shift=[id1,id2]-size(d2);
%             %2D xcorr
%             gx=-shift(2)/100*2*amp;
%             gy=-shift(1)/40*2*amp;
%             galvox=repmat(gx,[50,1]);
%             galvoy=repmat(gy,[50,1]);
%             %galvo shift
%             s.Rate=1e3;
            %set frequence to 1kHz
            BUFF=double(state.acq.acquiredData{1,1}{1,1});
            ref=xcorr2(reference,BUFF);
            %             position=[position;ref];
            [id1,id2]=find(ref==max(max(ref)));
            shift=[id1,id2]-size(BUFF);
%             position=[position;shift];
            mask=circshift(mask1,-shift);
        end
        % using xcorr to adjust the Galvo position
        
        
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
        pause(0.2);
        BUFF=double(state.acq.acquiredData{1,1}{1,1});
        m2=BUFF.*mask;
%         q=double(getsnapshot(vid));
%         m2=q.*mask;
%         s.queueOutputData([galvox,galvoy]);
%         [data,time]=s.startForeground;
%         n=sort(data,'descend');
        signal(k)=mean(m2(:));
        %         signal(k)=mean(startForeground(s));
        
%         disp(signal(k));
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
    figure;imagesc(finalamp);colormap gray;
    promptMessage = sprintf('first half done,\ncontinue to second half?');
    titleBarCaption = 'Continue?';
    button = questdlg(promptMessage, titleBarCaption, 'Continue', 'Cancel', 'Continue');
    if strcmpi(button, 'Cancel')
        break; % or break, if you're in a loop
    end
    
    % second half;
    % vid_src.Exposure=-7;pause(0.1);
%     power=0.15;% power in percentage;
%     EOv=acos(1-2*power)*vmax/pi;
%     if EOv<=vmax
%     s1.outputSingleScan(EOv);
%     else
%     disp('EO voltage too high');
%     end
    phase(:,blocknx/2+1:blocknx, :)=ModulatePhase;
    phase(:,1:blocknx/2, :)=repmat(finalphase(:,1:blocknx/2),[1,1,size(phase,3)]);
    signal=zeros(size(phase,3),1);
    for k=1:size(phase,3)
        % display phase on SLM here;
        if(rem(k,100)==0)
%             s.Rate=rate;
            referencephase=-1*slmphase;
            referencephase=angle(exp(1i*referencephase))+1.1*pi;% shift minimum to above 0;
                for k1=1:10
                    for k2=1:12
                        phaseblock=referencephase((k1-1)*60+1:(k1-1)*60+60,(k2-1)*66+1:(k2-1)*66+66);
                        vblock=voltagearray(k1,k2,1)*phaseblock.^6 + voltagearray(k1,k2,2)*phaseblock.^5 + voltagearray(k1,k2,3)*phaseblock.^4 + voltagearray(k1,k2,4)*phaseblock.^3+voltagearray(k1,k2,5)*phaseblock.^2+voltagearray(k1,k2,6)*phaseblock.^1;
                        vout((k1-1)*60+1:(k1-1)*60+60,(k2-1)*66+1:(k2-1)*66+66)=vblock;
                    end
                end
            vout=uint8(vout);
            Screen(window2, 'PutImage',vout);Screen(window2,'Flip');
            pause(0.2);
            %add the slm phase
%             s.queueOutputData([xdata,ydata']);
%             [data,time]=s.startForeground;
%             d2=mean(reshape(data, averageN, dataN/averageN));% first low pass the recorded data;
%             d2=reshape(d2, pixelPerline, lineN)';
%             d2=d2(:,4:end);
%             %record image
%             ref=xcorr2(reference,d2);
%             [id1,id2]=find(ref==max(max(ref)));
%             shift=[id1,id2]-size(d2);
%             %2D xcorr
%             gx=-shift(2)/100*2*amp;
%             gy=-shift(1)/40*2*amp;
%             galvox=repmat(gx,[50,1]);
%             galvoy=repmat(gy,[50,1]);
%             %galvo shift
%             s.Rate=1e3;
            %galvo shift
            BUFF=double(state.acq.acquiredData{1,1}{1,1});
            ref=xcorr2(reference,BUFF);
            %             position=[position;ref];
            [id1,id2]=find(ref==max(max(ref)));
            shift=[id1,id2]-size(BUFF);
%             position=[position;shift];
            mask=circshift(mask1,-shift);
        end
        % using xcorr to adjust the Galvo position
        
        
        
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
%         pause(0.15);
%         q=double(getsnapshot(vid));
%         m2=q.*mask;
        pause(0.2);
        BUFF=double(state.acq.acquiredData{1,1}{1,1});
        m2=BUFF.*mask;
%         q=double(getsnapshot(vid));
%         m2=q.*mask;
%         s.queueOutputData([galvox,galvoy]);
%         [data,time]=s.startForeground;
%         n=sort(data,'descend');
        signal(k)=mean(m2(:));
        %         signal(k)=mean(startForeground(s));
        
%         disp(signal(k));
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
outputphase=angle(exp(1i*(circshift(outputphase,[0,0])-slmphase)))+1.1*pi;% shift minimum to above 0;
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
outputphase=angle( exp(1i*outputphase))+1.1*pi;% shift minimum to above 0;
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
imagesc(finalphasesmooth);
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
%% add defocusing;
% each pixel is 20 micron;after relay, 40/3 micron;
x=1:792;
y=1:600;
centerx=330+0;
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
defocus_distance=0;% unit micron;
defocus_wavefront=defocus_distance*n*cos(theta)/lambda*2*pi;
if defocus_distance>0
    defocus_wavefront=defocus_wavefront-max(defocus_wavefront(:));
else
    defocus_wavefront=defocus_wavefront-min(defocus_wavefront(:));
end
aberration=Expand(finalphase, nx/blocknx, ny/blockny);
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