%%
file_path='E:\COMPACT\GCAMP_raw_data\20190702\';
FileTif=[file_path,'66.tif'];
image_path='E:\COMPACT\GCAMP_raw_data\20190702\motion correction\image\';
rawdata_path='E:\COMPACT\GCAMP_raw_data\20190702\motion correction\data\';
mkdir(image_path);
mkdir(rawdata_path);

symbol_radius=10;
symbol_color=[255 0 0];

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
roigui(m)
%%
img_MIP=max(m,[],3)/max(m(:))*255;
img_MIP=uint8(cat(3,img_MIP,img_MIP,img_MIP));
filename = FileTif(size(file_path,2)+1:end-4);
filename_xls=[filename,'.xlsx'];
DATA=zeros(size(ROI_list(1).fmean,1),size(ROI_list,2));
for i=1:size(ROI_list,2)
    DATA(:,i)= ROI_list(i).fmean;
    img_symbol=img_MIP;
    cxy=ROI_list(i).centerPos;
    for ix=1:512
        for iy=1:512
            if sqrt((ix-cxy(1))^2+(iy-cxy(2))^2)<symbol_radius
                img_symbol(ix,iy,1)= symbol_color(1);
                img_symbol(ix,iy,2)= symbol_color(2);
                img_symbol(ix,iy,3)= symbol_color(3);
            end
        end
    end
    imwrite(img_symbol,[image_path,filename,'_',num2str(i),'_',cell2mat(letters(i)),'.tif']);
end
xlswrite([rawdata_path,filename_xls],DATA)
handles.H1=figure(1);
close(handles.H1);
clc;
disp('all done!!!!!!!!!!!!!!!!!!!!!!!!');