x=1:1024;
y=1:1024;
[X,Y]=meshgrid(x,y);
sigma_x=450;
sigma_y=450;
x0=512;
y0=512;
F_XY=zeros(1024,1024,2);
F_XY(:,:,1)=X;
F_XY(:,:,2)=Y;
for j=1:1024
    for k=1:1024
        F_gaussian(j,k)=exp(-((F_XY(j,k,1)-x0)^2/(2*sigma_x^2)+(F_XY(j,k,2)-y0)^2/(2*sigma_y^2)));
    end
end
xs=0.5;
xy=0.5;
F_slopex=repmat(linspace(xs,1,1024),1024,1);
F_slopey=repmat(linspace(xy,1,1024)',1,1024);
F_adjust=F_slopex.*F_slopey.*F_gaussian;
figure;imagesc(IMG)
figure;imagesc(IMG./F_adjust)
