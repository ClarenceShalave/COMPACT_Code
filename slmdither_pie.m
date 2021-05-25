%% import voltage array data;
load('G:\Meng\Data\20181117SLM\voltagearray930nm.mat');
load('G:\Meng\Data\20181117SLM\slmphase930nm.mat');
phaseblock=linspace(0,2.5*pi,100);
vdata=0*phaseblock;
for k1=1:10
    for k2=1:12
        vblock=voltagearray(k1,k2,1)*phaseblock.^6 + voltagearray(k1,k2,2)*phaseblock.^5 + voltagearray(k1,k2,3)*phaseblock.^4 + voltagearray(k1,k2,4)*phaseblock.^3+voltagearray(k1,k2,5)*phaseblock.^2+voltagearray(k1,k2,6)*phaseblock.^1;
        vdata=vdata+vblock;
    end
end
vdata=vdata/9/15;
f=fit(phaseblock(:), vdata(:),'poly5');
nvarray(1)=f.p1;
nvarray(2)=f.p2;
nvarray(3)=f.p3;
nvarray(4)=f.p4;
nvarray(5)=f.p5;
nvarray(6)=f.p6;
%% prepare modulation matrix;
% datafolder='G:\COMPACT\data\20190409';
% filen=1;
% pause_time=0.035;
reference=double(state.acq.acquiredData{1,1}{4,1});
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
%%

alx=792;% original slm size;
aly=600;
slmblank=zeros(aly,alx);
%offset ROI;
ox=118;
oy=0;
% define sub region for fast measurement;
outputphase=zeros(ny,nx);
nx=600;
ny=600;
blocknx=20;
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

% use Rn as the layer number;
% use Pn as the pizza slice number;
% get id matrix (idM), outside loop;
DiameterPixel=600;
Rn=20;
Pn=20;
x=linspace(-1,1,DiameterPixel);
y=x;
[X,Y]=meshgrid(x,y);
[theta,rho] = cart2pol(X,Y);
[R,I]=sort(rho(:),'descend');
nOutside=round(length(R)*(1-pi/4));
R(1:nOutside)=[];
I(1:nOutside)=[];
p=0.*X;
for q=1:Rn
    p(round(I((q-1)*length(I)/Rn+1:q*length(I)/Rn)))=q;
    warning off;
end
[t,I]=sort(theta(:));
for q=1:Pn
    p(round(I((q-1)*length(I)/Pn+1:q*length(I)/Pn)))=p(round(I((q-1)*length(I)/Pn+1:q*length(I)/Pn)))+q*(Rn+1);
    warning off;
end
idM={Rn, Pn};
for k1=1:Rn
    for k2=1:Pn
        idM{k1,k2}=find(p==(Rn+1)*k2+k1);
    end
end
m=0.*X;
% m=0.*X;
% c=0;
% % use this inside loop;
% tic;
% for k1=1:Rn
%     for k2=1:Pn
%         m(idM{k1,k2})=c;
%         c=c+1;
%     end
% end
% toc;
% vout(oy+(1:ny), ox+(1:nx))=m;
%% test slmphase
% slmphase2=slmphase(oy+(1:ny), ox+(1:nx));
% slmphase2=imresize(slmphase2,[blockny,blocknx]);
%% start modulation;
finalphase=zeros(blockny,blocknx);% initial phase of the SLM;
finalamp=zeros(blockny,blocknx);
% q=getsnapshot(vid);q=double(q);imagesc(q);
% cx=82;
% cy=100;
% r=3;
% x=1:size(q,2);
% y=1:size(q,1);
% [X,Y]=meshgrid(x,y);
% mask=X.*0;
% id=find((X-cx).^2+(Y-cy).^2<=r^2);
% % id=find(abs(X-cx)<=r & abs(Y-cy)<=3*r);
% mask(id)=1;
% %imagesc(mask);
% pixel=sum(mask(:));
for roundn=1:1
    %first half;
%      src.Exposure = -12;
    %vid_src.Exposure=-5;pause(0.1);
    phase(:,1:blocknx/2, :)=ModulatePhase;
    phase(:,blocknx/2+1:blocknx, :)=repmat(finalphase(:,blocknx/2+1:blocknx),[1,1,size(phase,3)]);
    signal=zeros(size(phase,3),1);
    vout=uint8(slmblank);
    for k=1:size(phase,3)
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
            BUFF=double(state.acq.acquiredData{1,1}{4,1});
            ref=xcorr2(reference,BUFF);
            %             position=[position;ref];
            [id1,id2]=find(ref==max(max(ref)));
            shift=[id1,id2]-size(BUFF);
%             position=[position;shift];
            mask=circshift(mask1,-shift);
        end
        % display phase on SLM here;
%         m=squeeze(phase(:,:,k));
%         m=Expand(m, nx/blocknx, ny/blockny);
%         m2=zeros(aly,alx);
%         m2(oy+(1:ny), ox+(1:nx))=m;
%         m2=m2-slmphase;
%         m=angle(exp(1i*m2))+1.1*pi;
%         mv=nvarray(1)*m.^5 + nvarray(2)*m.^4+nvarray(3)*m.^3+nvarray(4)*m.^2+nvarray(5)*m+nvarray(6);
%         mv=uint8(mv);
%         vout=mv;
        m=squeeze(phase(:,:,k));
        m=angle(exp(1i*(m)))+1.1*pi;
        mv=nvarray(1)*m.^5 + nvarray(2)*m.^4+nvarray(3)*m.^3+nvarray(4)*m.^2+nvarray(5)*m+nvarray(6);
        mv=uint8(mv);
        for k1=1:Rn
            for k2=1:Pn
                outputphase(idM{k1,k2})=mv(k1,k2);
%                 c=c+1;
            end
        end
        vout(oy+(1:ny), ox+(1:nx))=uint8(outputphase);
        
        
        
%         vout=uint8(vout);
       Screen(window2, 'PutImage',vout);Screen(window2,'Flip');
        pause(0.2);
        BUFF=double(state.acq.acquiredData{1,1}{4,1});
        m2=BUFF.*mask;
%         q=double(getsnapshot(vid));
%         m2=q.*mask;
%         s.queueOutputData([galvox,galvoy]);
%         [data,time]=s.startForeground;
%         n=sort(data,'descend');
        signal(k)=mean(m2(:));
    end
    SF=fft(signal);
    
    newphase=-1*angle(SF(blocknx*blockny/2+1:blocknx*blockny));
    newphase=reshape(newphase,blockny, blocknx/2);
    newamp=abs(SF(blocknx*blockny/2+1:blocknx*blockny));
    newamp=reshape(newamp, blockny, blocknx/2);
    finalamp(:,1:blocknx/2)=newamp;
    finalphase(:,1:blocknx/2)=newphase;
    
%     second half;
%     src.Exposure = src.Exposure;
    
    % vid_src.Exposure=-7;pause(0.1);
    phase(:,blocknx/2+1:blocknx, :)=ModulatePhase;
    phase(:,1:blocknx/2, :)=repmat(finalphase(:,1:blocknx/2),[1,1,size(phase,3)]);
    signal=zeros(size(phase,3),1);
    for k=1:size(phase,3)
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
            BUFF=double(state.acq.acquiredData{1,1}{4,1});
            ref=xcorr2(reference,BUFF);
            %             position=[position;ref];
            [id1,id2]=find(ref==max(max(ref)));
            shift=[id1,id2]-size(BUFF);
%             position=[position;shift];
            mask=circshift(mask1,-shift);
        end
        % display phase on SLM here;
        %         m=squeeze(phase(:,:,k));
        %         m=Expand(m, nx/blocknx, ny/blockny);
        %         m2=zeros(aly,alx);
        %         m2(oy+(1:ny), ox+(1:nx))=m;
        %         m2=m2-slmphase;
        %         m=angle(exp(1i*m2))+1.1*pi;
        %         mv=nvarray(1)*m.^5 + nvarray(2)*m.^4+nvarray(3)*m.^3+nvarray(4)*m.^2+nvarray(5)*m+nvarray(6);
        %         mv=uint8(mv);
        %         vout=mv;
%         m=squeeze(phase(:,:,k));
%         m=angle(exp(1i*(m)))+1.1*pi;
%         mv=nvarray(1)*m.^5 + nvarray(2)*m.^4+nvarray(3)*m.^3+nvarray(4)*m.^2+nvarray(5)*m+nvarray(6);
%         mv=uint8(mv);
%         vout(oy+(1:ny), ox+(1:nx))=Expand(mv, nx/blocknx, ny/blockny);
          m=squeeze(phase(:,:,k));
        m=angle(exp(1i*(m)))+1.1*pi;
        mv=nvarray(1)*m.^5 + nvarray(2)*m.^4+nvarray(3)*m.^3+nvarray(4)*m.^2+nvarray(5)*m+nvarray(6);
%         mv=uint8(mv);
        
        for k1=1:Rn
            for k2=1:Pn
                outputphase(idM{k1,k2})=mv(k1,k2);
%                 c=c+1;
            end
        end
        vout(oy+(1:ny), ox+(1:nx))=uint8(outputphase);
        
        
        Screen(window2, 'PutImage',vout);Screen(window2,'Flip');
        pause(0.2);
        BUFF=double(state.acq.acquiredData{1,1}{4,1});
        m2=BUFF.*mask;
%         q=double(getsnapshot(vid));
%         m2=q.*mask;
%         s.queueOutputData([galvox,galvoy]);
%         [data,time]=s.startForeground;
%         n=sort(data,'descend');
        signal(k)=mean(m2(:));
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
figure;imagesc(finalphase);colormap hsv;%plot(finalphase);
figure;imagesc(finalamp);colormap gray;
% save data;
% save([datafolder,'\finalphase_',num2str(filen),'.mat'],'finalphase');
% save([datafolder,'\finalamp_',num2str(filen),'.mat'],'finalamp');
%% apply final correction;
outputphase=Expand(finalphase, nx/blocknx, ny/blockny);
% imagesc(outputphase);
% expand ROI to full SLM size;
slmblank(oy+(1:ny), ox+(1:nx))=outputphase;
outputphase=slmblank;

outputphase=angle(exp(1i*(circshift(outputphase,[0,0]))))+1.1*pi;% shift minimum to above 0;
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
%% compare;
outputphase=0;
% outputphase=0*aberration;
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

%% smooth the measured wavefront;
a=ones(1152,1920);
outputphase=Expand(finalphase, nx/blocknx, ny/blockny);
E=a.*exp(1i*outputphase);
E2=fftshift(fft2(E));
x=1:1920;
y=1:1152;
[X,Y]=meshgrid(x,y);
id=find((X-960).^2+(Y-576).^2<=50.^2);
fmask=0.*X;
fmask(id)=1;
E3=E2.*fmask;
E4=ifft2(ifftshift(E3));
finalphasesmooth=angle(E4);
imagesc(finalphasesmooth);colormap hsv;
outputphase=angle(exp(1i*(outputphase-slmphase)))+1.1*pi;% shift minimum to above 0;
for k1=1:9
    for k2=1:15
        phaseblock=outputphase((k1-1)*128+1:(k1-1)*128+128,(k2-1)*128+1:(k2-1)*128+128);
        vblock=voltagearray(k1,k2,1)*phaseblock.^6 + voltagearray(k1,k2,2)*phaseblock.^5 + voltagearray(k1,k2,3)*phaseblock.^4 + voltagearray(k1,k2,4)*phaseblock.^3+voltagearray(k1,k2,5)*phaseblock.^2+voltagearray(k1,k2,6)*phaseblock.^1+voltagearray(k1,k2,7);
        vout((k1-1)*128+1:(k1-1)*128+128,(k2-1)*128+1:(k2-1)*128+128)=vblock;
    end
end
vout=uint8(vout);
% Screen(window2, 'PutImage',vout);Screen(window2,'Flip');
calllib('Blink_C_wrapper', 'Write_image', board_number,flip(vout'), width*height, wait_For_Trigger, external_Pulse, timeout_ms);
calllib('Blink_C_wrapper', 'ImageWriteComplete', board_number, timeout_ms);
% pause(0.2);
pause(0.01);
% figure;q=getsnapshot(vid);imagesc(q);colorbar;title(max(q(:)));
%% add defocusing;
% each pixel is 20 micron;after relay, 40/3 micron;
x=1:792;
y=1:600;
centerx=340+0;
centery=230+0;
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

for k1=1:9
    for k2=1:15
        phaseblock=outputphase((k1-1)*128+1:(k1-1)*128+128,(k2-1)*128+1:(k2-1)*128+128);
        vblock=voltagearray(k1,k2,1)*phaseblock.^6 + voltagearray(k1,k2,2)*phaseblock.^5 + voltagearray(k1,k2,3)*phaseblock.^4 + voltagearray(k1,k2,4)*phaseblock.^3+voltagearray(k1,k2,5)*phaseblock.^2+voltagearray(k1,k2,6)*phaseblock.^1+voltagearray(k1,k2,7);
        vout((k1-1)*128+1:(k1-1)*128+128,(k2-1)*128+1:(k2-1)*128+128)=vblock;
    end
end
vout=uint8(vout);
% Screen(window2, 'PutImage',vout);Screen(window2,'Flip');
calllib('Blink_C_wrapper', 'Write_image', board_number,flip(vout'), width*height, wait_For_Trigger, external_Pulse, timeout_ms);
calllib('Blink_C_wrapper', 'ImageWriteComplete', board_number, timeout_ms);
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

