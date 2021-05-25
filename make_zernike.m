function zernike=make_zernike(zern_p,centerx,centery,radius)
%% define grid (MEMS size)
x = linspace(-1,1,2*radius) ;
[X,Y] = meshgrid(x,x);
[theta,r] = cart2pol(X,Y);
idx = r<=1;
%% generate Zernike polynomials
% p = 1:zern_max; %number of orders start from order 1
p=zern_p;
z = zeros(size(X));
zernike=zeros(660,792,numel(p));
y = zernfun2(p,r(idx),theta(idx));
for k = 1:length(p)
    z(idx) = y(:,k);
    zernike(:,:,k)=circshift(padarray(z,[(660-size(z,1))/2 (792-size(z,2))/2]),[-(660/2-centery) -(792/2-centerx)]);
end