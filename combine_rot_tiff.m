rot_step=600;
%%
for rot_ang=0:rot_step:6000
    for wd=250:20:410
        img=imread(['GFP_',num2str(rot_ang),'_',num2str(wd),'.tif']);
        img=double(img);
        img=img/max(max(img));
        imwrite(img,['norm',num2str(rot_ang),'.tif'],'WriteMode','append')
    end
end
%%
for rot_ang=0:rot_step:36000
    FileTif=[num2str(rot_ang),'.tif'];
    InfoImage=imfinfo(FileTif);
    mImage=InfoImage(1).Width;
    nImage=InfoImage(1).Height;
    NumberImages=length(InfoImage);
    m=zeros(nImage,mImage,NumberImages,'uint16');
    TifLink = Tiff(FileTif, 'r');
    for q=1:NumberImages
        TifLink.setDirectory(q);
        m(:,:,q)=TifLink.read();
    end
    TifLink.close();
    warning off;
    M{(rot_ang/rot_step)+1}=double(m);
end

%%
addpath('G:\COMPACT\code')
img_size=512;
N_frame=2;
X=[];
Y=[];
for j=1:60
    img1=M{j}(:,:,N_frame);
    img2=M{rem(j,61)+1}(:,:,N_frame);
    xcorr_result=xcorr2_fft(img1,img2);
    maxvalue = max(max(xcorr_result(350:600,660:860)));
    [x,y]=find(xcorr_result==maxvalue);
    x=x-img_size;
    y=y-img_size;
    X=[X;x];
    Y=[Y;y];
end
plot(X);hold on;plot(Y);hold off;
%%
delta_X=max(abs(X));
delta_Y=max(abs(Y));
N_img=60;
IMG=zeros(img_size+delta_X*(N_img-1),img_size+delta_Y*(N_img-1),3);
x=img_size+delta_X*(N_img-1);
y=img_size+delta_Y*(N_img-1);
IMG((x-img_size+1):x,(y-img_size+1):y,2)=M{1}(:,:,N_frame);
for j=2:N_img
    x=x+X(j-1);
    y=y+Y(j-1);
    IMG((x-img_size+1):x,(y-img_size+1):y,rem(j,2)+1)=M{j}(:,:,N_frame);
end
IMG=IMG/max(max(max(IMG)));
IMG_gray=sum(IMG,3);
IMG_grayy=sum(IMG_gray,1);
IMG_grayx=sum(IMG_gray,2);
Ix=find(IMG_grayx>0);
Ix=Ix(1);
Iy=find(IMG_grayy>0);
Iy=Iy(1);
IMG=IMG(Ix:end,Iy:end,:);
imwrite(IMG,'test0.tif');
%%
IMG(1:512,1025:1536,1)=M{1}(:,:,8);
IMG(116:627,793:1304,2)=M{2}(:,:,8);
IMG(237:748,545:1056,3)=M{3}(:,:,8);
IMG=IMG/max(max(max(IMG)));
imwrite(IMG,'test.jpg');