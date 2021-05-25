clear;% add shot noise;
% add constrain to smooth the amp and phase;
filename='m10';
load (filename);
q=double(datam(:,:,14));
q=q(:,2:2:1000);
q=imresize(q,[500,1000]);
qbackground=repmat(mean(q(1:50,:)),500,1 );
q=q-qbackground;
threshold=0.1;
id=find(q<threshold);
q(id)=0;
imagesc(q);%colormap gray; drawnow;
[M,I]=max(q);
[M,xc]=max(M)
yc=I(xc);
%% define the sampling and NA;
lambda=0.93;
NA=0.5;
n=1.3;
N=121;
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
%% define amplitude profile and phase aberration;

ampMask=exp(-0.01*KR.^2/kmax.^2);
phaseMask=(sin(KR/kmax*2*pi)*2*pi*0.3+sin(KX/kmax*2*pi)*0.7)*0.01;
EKaberration=kmask.*ampMask.*exp(1i*phaseMask);
KZ=KZ.*kmask;

%% record 4 images;
%zrange=[-3,-1,1,3];
zrange=(-2:2)*10;
% Idata=[];
% photonNtotal=1000;
% for z=zrange
%     Ef=EKaberration.*exp(1i*KZ*z);
%     E=fftshift(fft2(Ef));
%     %imagesc(x,y,abs(E).^2);drawnow;
%     I=abs(E).^2;
%     I=I./sum(I(:))*photonNtotal;
%     I=imnoise(I*1e-12,'poisson')*1e12;
%     imagesc(x,y,I);drawnow;
%     %pause(0.02);
%     Idata=cat(3,Idata,I);
% end
%% load recorded data;
Idata=[];
filen=8:2:18;
dataidx=(-N/2:(N/2-1))+xc;
dataidy=(-N/2:(N/2-1))+yc;
Idata=[];
for k=filen
    q=double(datam(:,:,k));
    q=q(:,2:2:1000);
    q=imresize(q,[500,1000]);
    qbackground=repmat(mean(q(1:50,:)),500,1 );
    q=q-qbackground;
    threshold=0.1;
    id=find(q<threshold);
    q(id)=0;
    Idata=cat(3,Idata,q(dataidy,dataidx));
end
%% phase retrieval;
ampGuess=kmask;
phaseGuess=0.*kmask;

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
    title([filename, ' phase amplitude for loop  ',num2str(loopN)]);drawnow;
    
%     subplot(2,2,3);
%     imagesc(ampMask.*kmask);title('original amplitude');drawnow;
%     subplot(2,2,4);
    subplot(1,2,2);
    imagesc(ampGuess);colorbar;
    title(['current pupil amplitude for loop  ',num2str(loopN)]);drawnow;
end
