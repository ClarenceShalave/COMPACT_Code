rotateangle=4;
phase1=zeros(600,792);
% phase2=zeros(600,792);
temp=imrotate(zernike(:,:,5),rotateangle);
[row,col]=size(temp);
phase1(:,405-299:405+300)=temp(round(row/2)-299:round(row/2)+300,round(col/2)-299:round(col/2)+300);
%%
coeff1=5.5;
% coeff2=0;
astigmatism_aberration=coeff1*phase1;
%% apply final correction;
outputphase=Expand(finalphase, nx/blocknx, ny/blockny);
% imagesc(outputphase);
outputphase=angle(exp(1i*(circshift(outputphase,[0,0])-1*astigmatism_aberration-slmphase)))+1.1*pi;% shift minimum to above 0;
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
centerx=404+0;
centery=299+0;
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
defocus_distance=1*4.2;% unit micron;
defocus_wavefront=defocus_distance*n*cos(theta)/lambda*2*pi;
if defocus_distance>0
    defocus_wavefront=defocus_wavefront-max(defocus_wavefront(:));
else
    defocus_wavefront=defocus_wavefront-min(defocus_wavefront(:));
end
aberration=Expand(finalphase, nx/blocknx, ny/blockny);
outputphase=angle(exp(1i*(aberration-astigmatism_aberration+defocus_wavefront-slmphase)))+1.1*pi;% shift minimum to above 0;
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