%%
file_list1=reshape(repmat(3:7,126,1),[5*126,1]); %depth
file_list2=repmat(reshape(repmat(0:20:120,18,1),[126,1]),5,1); %angle
file_list3=repmat((320:10:490)',35,1); %wd
file_list4=repmat([541:558,561:578,581:598,1:18,21:38,41:58,61:78]',5,1)+...
    reshape(repmat(0:620:2480,126,1),[5*126,1]); %side view
file_list5=repmat([541:558,561:578,581:598,1:18,21:38,41:58,61:78]',5,1); %top view
%%
file_path_1='H:\COMPACT\video\video_GRIN_neuron\';
file_prefix_1='Assembly2_neuron';
file_path_2='H:\COMPACT\video\video_GRIN\';
file_prefix_2='Assembly2_neuron';
file_path_3='H:\COMPACT\video\EGFP\';
file_prefix_3='EGFP_';
depth_num=5;
video_frame_write_path='H:\COMPACT\video\video_egfp_with_data\';
%%
img_min=0;
img_max=8180/5;
%%
for k=1:size(file_list1,1)
    img=uint8(255*ones(1080,1080,3));
    img1=imread([file_path_1,file_prefix_1,num2str(file_list4(k),'%04d'),'.png']);
    img1=img1(1:1080,703:1224,:);
    img2=imread([file_path_2,file_prefix_2,num2str(file_list5(k),'%04d'),'.tif']);
    img2=imresize(img2(71:1070,451:1450,:),[512 512]);
    
    img1=insertText(img1,[0 0],'Side view','FontSize',30,'BoxOpacity',0,'TextColor','white');
    img2=insertText(img2,[0 0],'Top view','FontSize',30,'BoxOpacity',0,'TextColor','white');
    
    img3=imread([file_path_3,'depth',num2str(file_list1(k)),'\',file_prefix_3,num2str(file_list2(k)*100),'_',num2str(file_list3(k)),'.tif']);
    img3=double(img3);
    img3(img3<img_min)=0;
    img3(img3>img_max)=img_max;
    img3=img3/img_max*255;
    img3=imresize(img3, 0.5);
    img3=uint8(img3);
    img3t=zeros(512,512,3,'uint8');
    img3t(:,:,2)=img3;
    img3=img3t;
    
    img(:,1:522,:)=img1;
    img(1:512,546:1057,:)=img2;
    img3=insertText(img3,[0 0],'Thy1-eGFP','FontSize',20,'BoxOpacity',0,'TextColor','white');
    img3=insertText(img3,[440 470],'10 um','FontSize',20,'BoxOpacity',0,'TextColor','white');
    img3=insertText(img3,[380 0],['Wd(um): ',num2str(file_list3(k))],'FontSize',20,'BoxOpacity',0,'TextColor','white');
    img3(495:500,455:481,:)=255;
    img(546:1057,546:1057,:)=img3;
    %     imwrite(img,[video_frame_write_path,'stack.tif'],'WriteMode','append');
    imwrite(img,[video_frame_write_path,num2str(file_list1(k)),'_',num2str(file_list2(k)),'_',num2str(file_list3(k)),'.tif']);
end
%% write stack
for d=3:7
    for angle=0:20:120
        for wd=320:10:490
            img=imread([video_frame_write_path,num2str(d),'_',num2str(angle),'_',num2str(wd),'.tif']);
            imwrite(img,[video_frame_write_path,'C_',num2str(d),'.tif'],'WriteMode','append')
        end
    end
end