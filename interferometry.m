%% setup ao channels;
s = daq.createSession('ni');
s.Rate=1e3;
addAnalogOutputChannel(s,'Dev1', 'ao0', 'Voltage');% y;
addAnalogOutputChannel(s,'Dev1', 'ao1', 'Voltage');% x;
%% create video object;
vid = videoinput('winvideo', 2, 'Y800_2592x1944');
src = getselectedsource(vid);
src.ExposureMode = 'manual';
src.GainMode = 'manual';
src.Gain = 4;
src.Exposure = -1.5;
%% convert image to wavefront;
filenumber='-2-1250';
imagename=['image',filenumber,'.mat'];
filename=['w',filenumber,'.mat'];
q=double(getsnapshot(vid));
imagesc(q);colormap gray;
cx=1660;
cy=1121;
r=740;
x=1:2592;
y=1:1944;
[X,Y]=meshgrid(x,y);
m=X.*0;
id=find((X-cx).^2+(Y-cy).^2<=r^2);
m(id)=1;
m2=q.*m;
imagesc(m2);
fm=fft2(m2);
imagesc(log(abs(fm)));colorbar;

maskf=0.*X;
fcx=103;
fcy=62;
fr=15;
id=find((X-fcx).^2+(Y-fcy).^2<=fr^2);
maskf(id)=1;
fm2=fm.*maskf;
fm3=circshift(fm2,-[fcy,fcx]);
imagesc(log(abs(fm3)));
m3=ifft2(fm3).*m;
imagesc(angle(m3));colormap hsv;
%imagesc(w);colormap hsv;
title(['fileN cx, cy, r, fcx, fcy, fr = ',filenumber,'  ',num2str([cx, cy, r, fcx, fcy, fr])]);
w=angle(m3);
%% save file;
if exist(filename)
    disp('check file number');
else
    save(filename,'w');
end
if exist(imagename)
    disp('check file number');
else
    save(imagename,'q');
end
