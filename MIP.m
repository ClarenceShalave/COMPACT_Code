% file_path='G:\COMPACT\data\20190521\newEGFP_stack\zm1d0394_zoom4_power20';
file_prefix='EGFP_';
rot_start=0;
rot_end=100;
rot_step=20;
wd_start=340;
wd_end=490;
wd_step=10;

img_size_x=1024;
img_size_y=1024;

max_value=8188;

rot_num=((rot_end-rot_start)/rot_step+1);
wd_num=((wd_end-wd_start)/wd_step+1);
IMG=zeros(img_size_x,img_size_y,wd_num);

% cd(file_path);
for rot_j=1:rot_num
    rot_k=rot_start+(rot_j-1)*rot_step;
    for wd_j=1:wd_num
        wd_k=wd_start+(wd_j-1)*wd_step;
        img=double(imread([file_prefix,num2str(rot_k*100),'_',num2str(wd_k),'.tif']));
        IMG(:,:,wd_j)=img;
    end
    imwrite(max(IMG,[],3)/max_value,['MIP_',num2str(rot_k),'.tif']);
end