%% set up image acquisition;
vid = videoinput('winvideo', 1, 'Y800_640x480');
src = getselectedsource(vid);
src.GainMode = 'manual';
src.ExposureMode='manual';
src.Gain = 4;
src.Exposure = -11;
src.FrameRate='15.0000';
%%
preview(vid)
%%
m=getsnapshot(vid);
m=double(m);
% m=double(psf_xy);
radius=10;
[max_m,I]=max(m(:));
[I_row, I_col] = ind2sub(size(m),I);
m=m(I_row-radius:I_row+radius,I_col-radius:I_col+radius);

[cx,cy,sx,sy,PeakOD] = Gaussian2D(m,0.1);

% [sizey sizex] = size(m);
% [x,y] = meshgrid(1:sizex,1:sizey);
% fitfigure = abs(PeakOD)*(exp(-0.5*(x-cx).^2./(sx^2)-0.5*(y-cy).^2./(sy^2)));

sx/sy
%%
2*sqrt(log(2))*sx*2.2/20
2*sqrt(log(2))*sy*2.2/20
%%
m=getsnapshot(vid);m=double(m);
max(m(:))