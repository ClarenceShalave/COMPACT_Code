file_path_1='H:\COMPACT\compact_video_inventor\side_view\';
file_prefix_1='Assembly2';
file_path_2='H:\COMPACT\compact_video_inventor\top_view\';
file_prefix_2='Assembly2_with_beads';
file_path_3='H:\COMPACT\bead_stack\';
folder_base_name='zoom6_power20_z';
folder_start=1;
folder_step=1;
folder_end=9;
file_prefix_3='bead_';
wd_list=240:20:600;
wd_num=size(wd_list,2);
depth_num=9;
rot_ang_list=0:12:348;
rot_ang_num=size(rot_ang_list,2);
threshold=500;
video_frame_write_path='H:\COMPACT\video\bead_video2\';
%%
A=[];
for i=0:12:348
    A=[A;i*ones(19,1)];A=[A;0];
end
B=repmat([(240:20:600)';0],30,1);
bead_file_list=[];
for i=1:9
    bead_file_list=[bead_file_list;i*ones(600,1),A,B];
    bead_file_list=[bead_file_list;zeros(20,3)];
end
bead_file_list=bead_file_list(1:5560,:);
%%
h = fspecial('disk', 5);
%%
for i=1:5560
    img=uint8(255*ones(1080,1080,3));
    img1=imread([file_path_1,file_prefix_1,num2str((i),'%04d'),'.png']);
    img1=img1(1:1080,703:1224,:);
    img2=imread([file_path_2,file_prefix_2,num2str((i),'%04d'),'.png']);
    img2=imresize(img2(71:1070,491:1490,:),[512 512]);
    if bead_file_list(i,3)==0
        img3=zeros(512,512);
    else
        img3=imread([file_path_3,folder_base_name,num2str(bead_file_list(i,1)),'\',...
            file_prefix_3,num2str(bead_file_list(i,2)*100),'_',num2str(bead_file_list(i,3)),'.tif']);
        img3=double(img3);
        img3(img3<threshold)=0;
        img3=filter2(h,img3);
        img3=img3/mean(maxk(img3(:),100))*255;
    end
    img3=cat(3,img3,img3,zeros(512));
    img3=uint8(img3);
    img(:,1:522,:)=img1;
    img(1:512,546:1057,:)=img2;
    img(546:1057,546:1057,:)=img3;
%     imwrite(img,[video_frame_write_path,'stack.tif'],'WriteMode','append');
    imwrite(img,[video_frame_write_path,num2str(i,'%04d'),'.tif']);
    i
end