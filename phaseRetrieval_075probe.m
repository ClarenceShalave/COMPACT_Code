%% load data
image_path='G:\COMPACT\data\20190311\bead_NA\';
base_name='bead_';
N_stack=10;
bead_stack=zeros(512,512,N_stack);
for i=1:N_stack
    bead_stack(:,:,i)=sqrt(double(imread([image_path,base_name,num2str(i,'%03d'),'.tif'])));
end
%% record image range
zrange=(-4:5)*5;
%% select area
pixel=121;
background=mean(mean(bead_stack(1:100,1:100,1)));
bead_stack=bead_stack-background;
threshold=7;
id=find(bead_stack<threshold);
bead_stack(id)=0;
[centerX,centerY]=find(bead_stack(:,:,floor(N_stack/2))==max(max(bead_stack(:,:,floor(N_stack/2)))));
Idata=bead_stack(centerX-floor(pixel/2):centerX+floor(pixel/2),centerY-floor(pixel/2):centerY+floor(pixel/2),:);
%% define the sampling and NA;
lambda=0.93;
NA=0.3;
n=1.33;
N=floor(pixel/2)*2+1;
xamp=0.1681;%0.198;
%x=linspace(-xamp,xamp,N);
x=(-N/2+1:N/2)*xamp;
y=x;
[X,Y]=meshgrid(x,y);
dk=2*pi./(max(x)-min(x));
kx=(-N/2+1:N/2)*dk;
ky=kx;
[KX,KY]=meshgrid(kx,ky);
KR=sqrt(KX.^2+KY.^2);
KZ=sqrt((2*pi/lambda*n)^2-KX.^2-KY.^2);
kmask=0.*KX;
kmax=2*pi/lambda*NA;
kmin=2*pi/lambda*NA*0.0;
id=(KR<=kmax & KR>=kmin) | KR<=kmax*0.0;
%id=KR<=kmax & abs(KX)>=kmax*0.1 & abs(KY)<kmax*0.05;
%id=KR<=kmax & abs(KX)>=kmax*0.6 & abs(KY)<kmax*0.05;
%id=KR<=kmax & KR>kmax*0.88 & abs(KX)>=kmax*0.85 & abs(KX)<=kmax*0.9;
kmask(id)=1;
imagesc(kmask);
E=fftshift(fft2(kmask));
imagesc(x,y,abs(E).^2);
% I2=abs(E(N/2+1,:)).^2;
% f=fit(x(:),I2(:),'gauss1');
% plot(x,I2,x,f(x));title(['FWHM = ',num2str(f.c1*2*sqrt(log(2)))]);

%% phase retrieval;
ampGuess=kmask;
phaseGuess=0.*kmask;
figure;
for loopN=1:50
    newEf=[];
    for q=1:length(zrange)
        z=zrange(q);
        Ef=ampGuess.*exp(1i*phaseGuess).*exp(1i*KZ*z);
        EGuess=fftshift(fft2(Ef));
        % from measurement;
        Eabs=sqrt(Idata(:,:,q));
        Eupdate=Eabs.*exp(1i*angle(EGuess));
        EfUpdate=ifft2(ifftshift(Eupdate)).*exp(1i*KZ*-z).*kmask;
        newEf=cat(3, newEf, EfUpdate);
        %imagesc(abs(EfUpdate));drawnow;
    end
    newEf=mean(newEf,3);
    newEf=newEf.*kmask;
    
    ampGuess=abs(newEf);
    phaseGuess=angle(newEf);
    
    %     subplot(2,2,1);
    %     imagesc(phaseMask.*kmask);title('original phase');drawnow;
    %     subplot(2,2,2);
    subplot(1,2,1);
    imagesc(phaseGuess);colorbar;
    title([' phase amplitude for loop  ',num2str(loopN)]);drawnow;
    
    %     subplot(2,2,3);
    %     imagesc(ampMask.*kmask);title('original amplitude');drawnow;
    %     subplot(2,2,4);
    subplot(1,2,2);
    imagesc(ampGuess);colorbar;
    title(['current pupil amplitude for loop  ',num2str(loopN)]);drawnow;
end
%% expand phase
phase=phaseGuess(51:70,51:70);
% phase=fliplr(phase);
% phase=flipud(phase);
% phase=imrotate(phase,90);
outputphase=Expand(phase, 20, 20);
totalsize=size(outputphase);
phase_retrieval=zeros(600,792);
centerx=280;
centery=300;
%
phase_retrieval(centerx-floor(totalsize(1))/2+1:centerx+floor(totalsize(1))/2,centery-floor(totalsize(1))/2+1:centery+floor(totalsize(1))/2)=outputphase;
outputphase=angle(exp(1i*(circshift(-phase_retrieval,[0,0])-slmphase)))+1.1*pi;% shift minimum to above 0;
for k1=1:10
    for k2=1:12
        phaseblock=outputphase((k1-1)*60+1:(k1-1)*60+60,(k2-1)*66+1:(k2-1)*66+66);
        vblock=voltagearray(k1,k2,1)*phaseblock.^6 + voltagearray(k1,k2,2)*phaseblock.^5 + voltagearray(k1,k2,3)*phaseblock.^4 + voltagearray(k1,k2,4)*phaseblock.^3+voltagearray(k1,k2,5)*phaseblock.^2+voltagearray(k1,k2,6)*phaseblock.^1;
        vout((k1-1)*60+1:(k1-1)*60+60,(k2-1)*66+1:(k2-1)*66+66)=vblock;
    end
end
vout=uint8(vout);
Screen(window2, 'PutImage',vout);Screen(window2,'Flip');
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
%% expand phase
for i=-100:10:100
    for j=-100:10:100
        
        phase=phaseGuess(51:70,51:70);
        % phase=fliplr(phase);
        % phase=flipud(phase);
        % phase=imrotate(phase,90);
        outputphase=Expand(phase, 20, 20);
        totalsize=size(outputphase);
        phase_retrieval=zeros(600,792);
        centerx=216;
        centery=311;
        %
        phase_retrieval(centerx-floor(totalsize(1))/2+1:centerx+floor(totalsize(1))/2,centery-floor(totalsize(1))/2+1:centery+floor(totalsize(1))/2)=outputphase;
        outputphase=angle(exp(1i*(circshift(phase_retrieval,[i,j])-slmphase)))+1.1*pi;% shift minimum to above 0;
        for k1=1:10
            for k2=1:12
                phaseblock=outputphase((k1-1)*60+1:(k1-1)*60+60,(k2-1)*66+1:(k2-1)*66+66);
                vblock=voltagearray(k1,k2,1)*phaseblock.^6 + voltagearray(k1,k2,2)*phaseblock.^5 + voltagearray(k1,k2,3)*phaseblock.^4 + voltagearray(k1,k2,4)*phaseblock.^3+voltagearray(k1,k2,5)*phaseblock.^2+voltagearray(k1,k2,6)*phaseblock.^1;
                vout((k1-1)*60+1:(k1-1)*60+60,(k2-1)*66+1:(k2-1)*66+66)=vblock;
            end
        end
        vout=uint8(vout);
        Screen(window2, 'PutImage',vout);Screen(window2,'Flip');
        pause(2);
        i
        j
    end
end