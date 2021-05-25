function zernike=make_zernike_yiyong_SLM_NA1D1(zern_max)
%% define grid (MEMS size)
x = linspace(-1,1,400) ;
[X,Y] = meshgrid(x,x);
[theta,r] = cart2pol(X,Y);
idx = r<=1;
centerx=280;
centery=300;
%% generate Zernike polynomials
p = 1:zern_max; %number of orders start from order 1
z = zeros(size(X));
zernike=zeros(600,792,numel(p));
y = zernfun2(p,r(idx),theta(idx));
for k = 1:length(p)
    z(idx) = y(:,k);
    zernike(:,:,k)=circshift(padarray(z,[100 196]),[-(600/2-centery) -(792/2-centerx)]);
end