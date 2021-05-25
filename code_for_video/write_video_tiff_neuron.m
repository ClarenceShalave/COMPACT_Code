%%
file_path_1='H:\COMPACT\video\video_GRIN_neuron\';
file_prefix_1='Assembly2_neuron';
file_path_2='H:\COMPACT\video\video_GRIN\';
file_prefix_2='Assembly2_neuron';
file_path_3='H:\COMPACT\video\GCAMP\';
file_prefix_3='GCAMP_electrode_2_';
depth_num=5;
video_frame_write_path='H:\COMPACT\video\video_neuron_with_data\';
%% brightness parameter
img_size_x=512;
img_size_y=512;
threshold=img_size_x*img_size_y/5000;
%% file matrix
file_matrix=[ ...
    1,559,541,17;...
    1,579,561,19;...
    1,19,1,20;...
    1,39,21,21;...
    1,59,41,22;...
    2,600,1,0;...
    1,1179,541,31;...
    1,1199,561,30;...
    1,639,1,27;...
    1,659,21,25;...
    1,679,41,24;...
    2,1220,1,0;...
    1,1799,541,32;...
    1,1819,561,34;...
    1,1259,1,37;...
    1,1279,21,39;...
    1,1299,41,42;...
    2,1840,1,0;...
    1,2419,541,50;...
    1,2439,561,49;...
    1,1879,1,48;...
    1,1899,21,46;...
    1,1919,41,44;...
    2,2460,1,0;...
    1,3039,541,53;...
    1,3059,561,55;...
    1,2499,1,58;...
    1,2519,21,63;...
    1,2539,41,65;...
    ];
%%
for file_k=1:size(file_matrix,1)
    if file_matrix(file_k,1)==1
        file_number=file_k;
        file1_number=file_matrix(file_k,2);
        file2_number=file_matrix(file_k,3);
        file3_number=file_matrix(file_k,4);
        
        img=uint8(255*ones(1080,1080,3));
        img1=imread([file_path_1,file_prefix_1,num2str((file1_number),'%04d'),'.png']);
        img1=img1(1:1080,703:1224,:);
        img2=imread([file_path_2,file_prefix_2,num2str((file2_number),'%04d'),'.tif']);
        img2=imresize(img2(71:1070,451:1450,:),[512 512]);
        
        img1=insertText(img1,[0 0],'Side view','FontSize',30,'BoxOpacity',0,'TextColor','white');
        img2=insertText(img2,[0 0],'Top view','FontSize',30,'BoxOpacity',0,'TextColor','white');
        
        FileTif=[file_path_3,file_prefix_3,num2str((file3_number),'%03d'),'.tif'];
        InfoImage=imfinfo(FileTif);
        mImage=InfoImage(1).Width;
        nImage=InfoImage(1).Height;
        NumberImages=length(InfoImage);
        img3=zeros(nImage,mImage,3,NumberImages,'uint16');
        TifLink = Tiff(FileTif, 'r');
        for q=1:NumberImages
            TifLink.setDirectory(q);
%             img3(:,:,1,q)=TifLink.read();
%             img3(:,:,2,q)=img3(:,:,1,q);
%             img3(:,:,3,q)=img3(:,:,1,q);
                 img3(:,:,2,q)=TifLink.read();
        end
        TifLink.close();
        warning off;
        img_t=img3(:,:,2,1);
        [N,edges] = histcounts(img_t(:));
        % upper limit
        for j=1:size(N,2)
            if N(end-j+1)>threshold
                img_max=edges(end-j);
                break;
            end
        end
        % lower limit
        for j=1:size(N,2)
            if N(j)>threshold
                img_min=edges(j);
                break;
            end
        end
        img3=double(img3);
        img3(img3<img_min)=0;
        img3(img3>img_max)=img_max;
        img3=img3/img_max*255;
        img3=uint8(img3);
        
        for k=1:100
            img(:,1:522,:)=img1;
            img(1:512,546:1057,:)=img2;
            img3t=img3(:,:,:,k);
            img3t=insertText(img3t,[0 0],'AAV-Syn-GCaMP6s','FontSize',20,'BoxOpacity',0,'TextColor','white');
            img3t=insertText(img3t,[440 470],'10 um','FontSize',20,'BoxOpacity',0,'TextColor','white');
            img3t=insertText(img3t,[380 0],['Time(s): ',num2str(int16((k-1)/1.68))],'FontSize',20,'BoxOpacity',0,'TextColor','white');
            img3t(495:500,450:486,:)=255;
            img(546:1057,546:1057,:)=img3t;
            %     imwrite(img,[video_frame_write_path,'stack.tif'],'WriteMode','append');
            imwrite(img,[video_frame_write_path,num2str(file_number),'_',num2str(k,'%03d'),'.tif']);
        end
    end
    
    
    if file_matrix(file_k,1)==2
        file_number=file_k;
        file1_number=file_matrix(file_k,2);
        file2_number=file_matrix(file_k,3);
        
        img=uint8(255*ones(1080,1080,3));
        for k=1:20
            img1=imread([file_path_1,file_prefix_1,num2str((file1_number+k),'%04d'),'.png']);
            img1=img1(1:1080,703:1224,:);
            img2=imread([file_path_2,file_prefix_2,num2str((file2_number),'%04d'),'.tif']);
            img2=imresize(img2(71:1070,451:1450,:),[512 512]);
            img1=insertText(img1,[0 0],'Side view','FontSize',30,'BoxOpacity',0,'TextColor','white');
            img2=insertText(img2,[0 0],'Top view','FontSize',30,'BoxOpacity',0,'TextColor','white');
            img3=uint8(zeros(512,512,3));
            img(:,1:522,:)=img1;
            img(1:512,546:1057,:)=img2;
            img(546:1057,546:1057,:)=img3;
            imwrite(img,[video_frame_write_path,num2str(file_number),'_',num2str(k,'%03d'),'.tif']);
        end
    end
    file_k
end
%% write stack
clear;clc;
for j=1:29
    if rem(j,6)==0
        IMG=uint8(zeros(1080,1080,3,20));
        for k=1:20
            IMG(:,:,:,k)=imread([num2str(j),'_',num2str((k),'%03d'),'.tif']);
        end
        imwrite(IMG(:,:,:,1),[num2str(j),'.tif']);
        for k=2:20
            imwrite(IMG(:,:,:,k),[num2str(j),'.tif'],'WriteMode','append')
        end
    else
        IMG=uint8(zeros(1080,1080,3,100));
        for k=1:100
            IMG(:,:,:,k)=imread([num2str(j),'_',num2str((k),'%03d'),'.tif']);
        end
        imwrite(IMG(:,:,:,1),[num2str(j),'.tif']);
        for k=2:100
            imwrite(IMG(:,:,:,k),[num2str(j),'.tif'],'WriteMode','append')
        end
    end
end