%% bead file info
wd_list=240:20:600;
wd_num=size(wd_list,2);
depth_num=9;
rot_ang_list=0:12:348;
rot_ang_num=size(rot_ang_list,2);
%% create circle anime
circle_r=45;
circle_R=55;
beam_width=3;
beam_length=40;
I=zeros(512,512);
for i=1:512
    for j=1:512
        if sqrt((i-256.5)^2+(j-256.5)^2)<circle_R && sqrt((i-256.5)^2+(j-256.5)^2)>circle_r
            I(i,j)=192;
        end
    end
end
img=zeros(512,512,3,26);
for i=1:wd_num
    img(:,:,1,i)=I;
    img(:,:,2,i)=I;
    img(:,:,3,i)=I;
    img((250-circle_R-5*i-beam_width):(250-circle_R-5*i),256-beam_length/2:256+beam_length/2,1,i)=255;
end
%% write circle anime
for rot_ang=0:12:348
    for i=1:wd_num
        img_temp=imrotate(img(:,:,:,i),rot_ang);
        img_size=floor(size(img_temp,1)/2);
        imwrite(img_temp(img_size-255:img_size+256,img_size-255:img_size+256,:),'test.tif','WriteMode','append');
    end
end
%% part 2a large image info
base_path='C:\Users\Meng\Desktop\COMPACT\bead_stack\';
folder_base_name='zoom6_power20_z';
folder_start=1;
folder_step=1;
folder_end=9;
rot_step=1200;
%% 2b
Img=zeros(512,depth_num*rot_ang_num*512,wd_num);
%% 2c
N=1;
for folder_name=folder_start:folder_step:folder_end
    cd([base_path,folder_base_name,num2str(folder_name)]);
    for rot_ang=rot_ang_list*100
        for wd=wd_list
            img=imread(['bead_',num2str(rot_ang),'_',num2str(wd),'.tif']);
            img=double(img);
            %img=img/mean(maxk(img(:),100));
            [N1,edges]=histcounts(img);
            [m_N1,I_N1]=max(N1);
            if edges(I_N1)==0
                I_N1=I_N1+1;
            end
            img=img/edges(I_N1)*0.0036;
            Img(:,(N-1)*512+1:N*512,((wd-wd_list(1))/20)+1)=img;
        end
        N=N+1
    end
end
cd(base_path);
%% 2d
IMG=zeros(depth_num*2*512,rot_ang_num/2*512,wd_num);
for i=1:(depth_num*2)
    IMG((i-1)*512+1:i*512,:,:)=Img(:,rot_ang_num/2*(i-1)*512+1:rot_ang_num/2*i*512,:);
    i
end
%% 2e
width=10;
Img=ones(depth_num*2*512+width*(depth_num*2-2),rot_ang_num/2*512+width*(rot_ang_num/2-2),wd_num)*0.5;
for i=1:depth_num*2
    for j=1:rot_ang_num/2
        Img((i-1)*(512+width)+1:i*(512+width)-width,(j-1)*(512+width)+1:j*(512+width)-width,:)=IMG((i-1)*512+1:i*512,(j-1)*512+1:j*512,:);
    end
    i
end
%% 2f write tiff
for i=1:wd_num
    imwrite(Img(:,:,i),'testIII.tif','WriteMode','append')
    i
end