function [phase,mask]= unwrap_L2Norm(input,wgt,display)

% phase unwrapping algorithm
%
% T. Roesgen 27-11-2004

[m,n]= size (input);
kmax= min(m*n,100);
EPS= 1.e-7;

if nargin < 2
    % create weight matrix
    [dx,dy]= phasedifferences (input);
    dx= atan2(sin(dx),cos(dx));
    dy= atan2(sin(dy),cos(dy));
    dx2= dx(1:m-1,1:n-1) - dx(2:m,1:n-1);
    dx2(m,1:n)= 0;
    dy2= dy(1:m-1,2:n) - dy(1:m-1,1:n-1);
    dy2(1:m,n)= 0;
    dxy= dx2 + dy2;
    wgt= ones(m,n);
    ind= find (abs(dxy) > pi);
    wgt(ind)= 0;
end

mask= wgt;

if nargin < 3
    display= 1;
end

% compute weights for DCT solver
[dctwx,dctwy]= meshgrid (cos(pi*(0:n-1)/n),cos(pi*(0:m-1)/m)); % DCT weights based on discretized Laplacian
dctwgt= 2 * (dctwx + dctwy - 2);
% [dctwx,dctwy]= meshgrid (pi*(0:n-1)/n,pi*(0:m-1)/m); % DCT weights based on continuous Laplacian
% dctwgt= -(dctwx.^2 + dctwy.^2);
dctwgt(1,1)= 1;

% compute weights for "weighted Laplace" operator
wgt2= wgt.^2;

j=1:m; i=1:n-1; wx(j,i)= min(wgt2(j,i+1),wgt2(j,i));
wx(j,n)= zeros(m,1);

j=1:m-1; i=1:n; wy(j,i)= min(wgt2(j+1,i),wgt2(j,i));
wy(m,i)= zeros(1,n);

% initialize conjugate gradient iteratiuon
phase= zeros(m,n);
c= WeightedLaplacian (input,wx,wy,1);
err0= norm(c);
r=c;
p= zeros(m,n);
rz= 1;

% conjugate gradient iteration loop
k= 0;
err= err0;
while k<kmax & err > EPS
   
    k= k+1;

    % DCT solver step
    z= idct2(dct2(r)./dctwgt);

    % compute beta
    rzold= rz;
    rz= dot(r(:),z(:));
    beta= rz ./ rzold;
    
    % update p-vector
    p= z + beta*p;
    
    % compute alpha
    Qp= WeightedLaplacian(p,wx,wy,0);
    alpha= rz ./ dot(p(:),Qp(:));
    
    % update unwrapped phase stimate
    phase= phase + alpha*p;

    if display ~= 0
        figure (10);
        imshow (phase,[]);
        msg= sprintf ('Iteration %3d: current phase estimate',k);
        title (msg);
        colormap jet;
        drawnow;
    end
    
    % update conjugate vector
    r= r - alpha .* Qp;
    
    % compute error estimate
    err= norm(r)/err0
    
end


function Qp= WeightedLaplacian (p,wx,wy,wrapflag)

[m,n]= size(p);

% compute phase differences
[dx,dy]= phasedifferences (p);

% wrap phase differences into interval (-pi,pi]
if wrapflag ~= 0
    dx= atan2 (sin(dx),cos(dx));
    dy= atan2 (sin(dy),cos(dy));
end

j=1:m; i=1:n; Qp(j,i)= wx(j,i).*dx(j,i) + wy(j,i).*dy(j,i);
j=1:m; i=2:n; Qp(j,i)= Qp(j,i) - wx(j,i-1).*dx(j,i-1);
j=2:m; i=1:n; Qp(j,i)= Qp(j,i) - wy(j-1,i).*dy(j-1,i);


function [dx,dy]= phasedifferences (p);

[m,n]= size(p);
j=1:m; i=1:n-1; dx(j,i)= p(j,i+1)-p(j,i);
dx(j,n)= 0;
j=1:m-1; i=1:n; dy(j,i)= p(j+1,i)-p(j,i);
dy(m,i)= 0;




