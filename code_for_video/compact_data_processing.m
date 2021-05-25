%% COMPACT processing
%% open tiff, xcorr to stack
file_prefix='EGFP_';
rot_start=0;
rot_end=0;
rot_step=7.5;
wd_start=380;
wd_end=490;
wd_step=10;

img_size_x=1024;
img_size_y=1024;

max_value=8192;

rot_num=((rot_end-rot_start)/rot_step+1);
wd_num=((wd_end-wd_start)/wd_step+1);
IMG=zeros(img_size_x,img_size_y,wd_num);

xcorr_threshold=10;

% cd(file_path);
for rot_j=1:rot_num
    rot_k=rot_start+(rot_j-1)*rot_step;
    img=double(imread([file_prefix,num2str(rot_k*100),'_',num2str(wd_start),'.tif']));
    IMG(:,:,1)=img;
    for wd_j=2:wd_num
        wd_k=wd_start+(wd_j-1)*wd_step;
        img=double(imread([file_prefix,num2str(rot_k*100),'_',num2str(wd_k),'.tif']));
%         R=Xcorr2FFT(img,IMG(:,:,wd_j-1));
%         [m,I]=max(R(:));
%         [Ix,Iy]=ind2sub(size(R),I);
%         if abs(Ix)<xcorr_threshold && abs(Iy)<xcorr_threshold
%             img=circshift(img,[-Ix -Iy]);
%         end
        IMG(:,:,wd_j)=img;
    end
    imwrite(max(IMG,[],3)/max_value,['MIP_',num2str(rot_k),'.tif']);
    % img=imrotate(max(IMG,[],3)/max_value,171);
    % imwrite(img,['MIP_',num2str(rot_k),'.tif']);
end
%% GCAMP stack xcorr and MIP
xcorr_threshold=10;
max_value=8192*2;
for k=5:66
    img=[];
    FileTif=['GCAMP_electrode_2_',num2str(k,'%03d'),'.tif'];
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
    m=double(m);
    IMG=zeros(size(m));
    IMG(:,:,1)=m(:,:,1);
    for j=2:size(m,3)
        img=m(:,:,j);
%         R=Xcorr2FFT(img,IMG(:,:,j-1));
%         [m1,I]=max(R(:));
%         [Ix,Iy]=ind2sub(size(R),I);
%         if abs(Ix)<xcorr_threshold && abs(Iy)<xcorr_threshold
%             img=circshift(img,[-Ix -Iy]);
%         end
        IMG(:,:,j)=img;
    end
    imwrite(max(IMG,[],3)/max_value,['MIP0_',FileTif]);
end
%% MIP
% file_path='G:\COMPACT\data\20190521\newEGFP_stack\zm1d0394_zoom4_power20';
file_prefix='egfp_';
rot_start=330;
rot_end=330;
rot_step=5;
wd_start=390;
wd_end=500;
wd_step=10;

img_size_x=512;
img_size_y=512;

max_value=16384;

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
    % img=imrotate(max(IMG,[],3)/max_value,171);
    % imwrite(img,['MIP_',num2str(rot_k),'.tif']);
end

%% single frame intensity
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
xs=1;
ys=1;
F_slopex=repmat(linspace(xs,1,1024),1024,1);
F_slopey=repmat(linspace(ys,1,1024)',1,1024);
F_adjust=F_slopex.*F_slopey.*F_gaussian;
% figure;imagesc(IMG)
% figure;imagesc(IMG./F_adjust)
%%
file_prefix='EGFP_';
rot_start=0;
rot_end=120;
rot_step=20;
wd_start=350;
wd_end=490;
wd_step=10;

img_size_x=1024;
img_size_y=1024;

% max_value=8188;

rot_num=((rot_end-rot_start)/rot_step+1);
wd_num=((wd_end-wd_start)/wd_step+1);
IMG=zeros(img_size_x,img_size_y,wd_num);

wd_slope=0.5;
wd_coeff=linspace(1,wd_slope,wd_num);

xcorr_I1_list=0;
xcorr_I2_list=0;
for rot_j=1:rot_num
    rot_k=rot_start+(rot_j-1)*rot_step;
    for wd_j=1:wd_num
        wd_k=wd_start+(wd_j-1)*wd_step;
        img=double(imread([file_prefix,num2str(rot_k*100),'_',num2str(wd_k),'.tif']))./F_adjust/wd_coeff(wd_j);
        IMG(:,:,wd_j)=img;
    end
    
    %     for wd_j=2:wd_num
    %         R=Xcorr2FFT(IMG(:,:,wd_j-1),IMG(:,:,wd_j-1));
    %         [m,I]=max(R(:));[I1, I2] = ind2sub(size(R),I);
    %         xcorr_I1_list=[xcorr_I1_list,I1];
    %         xcorr_I2_list=[xcorr_I2_list,I2];
    %         IMG(:,:,wd_j)=circshift(IMG(:,:,wd_j),[sum(xcorr_I1_list)-img_size_x sum(xcorr_I2_list)-img_size_y]);
    %     end
    imwrite(uint16(max(IMG,[],3)),['MIP_',num2str(rot_k),'.tif']);
end
