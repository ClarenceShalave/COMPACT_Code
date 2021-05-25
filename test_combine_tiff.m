file_path='G:\COMPACT\data\20190522\YFP_stack\z5d3704_zoom4_power30';
file_prefix='EGFP_';
rot_start=240;
rot_end=520;
rot_step=20;
wd_start=280;
wd_end=460;
wd_step=10;

img_size_x=1024;
img_size_y=1024;

rot_num=((rot_end-rot_start)/rot_step+1);
wd_num=((wd_end-wd_start)/wd_step+1);
IMG=zeros(img_size_x,img_size_y*rot_num,wd_num);

cd(file_path);
for rot_j=1:rot_num
    rot_k=rot_start+(rot_j-1)*rot_step;
    for wd_j=1:wd_num
        wd_k=wd_start+(wd_j-1)*wd_step;
        img=double(imread([file_prefix,num2str(rot_k*100),'_',num2str(wd_k),'.tif']));
        IMG(:,((rot_j-1)*img_size_y+1):(rot_j*img_size_y),wd_j)=img;
    end
end
%%
max_value=max(IMG(:));
imwrite((IMG(:,:,1))/max_value,'test.tif');
for j=2:wd_num
imwrite((IMG(:,:,j))/max_value,'test.tif','WriteMode','append');
end
