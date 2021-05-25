%% bead file info
wd_list=240:20:600;
wd_num=size(wd_list,2);
depth_num=9;
rot_ang_list=0:12:348;
rot_ang_num=size(rot_ang_list,2);
base_path='E:\COMPACT\bead_stack\';
folder_base_name='zoom6_power20_z';
folder_start=1;
folder_step=1;
folder_end=9;
rot_step=1200;
threshold=500;
%%
for folder_name=folder_start:folder_step:folder_end
    cd([base_path,folder_base_name,num2str(folder_name)]);
    for rot_ang=rot_ang_list*100
        for wd=wd_list
            img=imread(['bead_',num2str(rot_ang),'_',num2str(wd),'.tif']);
            img=double(img);
            img(img<threshold)=0;
            img=img/mean(maxk(img(:),100));
            imwrite(img,['norm',num2str(rot_ang),'.tif'],'WriteMode','append')
        end
    end
end
%% delete
for folder_name=folder_start:folder_step:folder_end
    cd([base_path,folder_base_name,num2str(folder_name)]);
    for rot_ang=rot_ang_list*100
        delete(['norm',num2str(rot_ang),'.tif']);
    end
end