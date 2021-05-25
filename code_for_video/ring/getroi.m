[cx,cy] = ginput(1);
cx=round(cx);
cy=round(cy);
%% compute ROI;
range=16;
m2=m(cy-range:cy+range,cx-range:cx+range);
x=-range:range;
y=x;
[X,Y]=meshgrid(x,y);
[THETA,RHO] = cart2pol(X,Y);
angleG=10;
mask=0.*m2;
for k=1:angleG
    id=find(THETA>=(k-1)*360/angleG & THETA<=(k)*360/angleG);
    a=RHO(id);
    b=m2(id);
end
    
    
    