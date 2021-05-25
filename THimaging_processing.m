FileTif=['thalamus_imaging.tif'];
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
%%
Ix=[];
Iy=[];
for ii=2:500
    C=Xcorr2FFT(m(:,:,1),m(:,:,ii));
    [M,I]=max(C(:));
    [I_row, I_col] = ind2sub(size(C),I);
    Ix=[Ix;I_row];
    Iy=[Iy;I_col];
end
%%
Ix=Ix-size(m,1);
Iy=Iy-size(m,2);
imwrite(uint16(m(:,:,1)),'myMultipageFile.tif');
for ii=2:500
    imwrite(uint16(circshift(m(:,:,ii),[Ix(ii-1),Iy(ii-1)])),'myMultipageFile.tif','WriteMode','append');
end
%%
for file_ID=2:26
    file_str=num2str(file_ID,'%03d');
    FileTif=['GCAMP_',file_str,'.tif'];
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
    
    Ix=[];
    Iy=[];
    for ii=2:500
        C=Xcorr2FFT(m(:,:,1),m(:,:,ii));
        [M,I]=max(C(:));
        [I_row, I_col] = ind2sub(size(C),I);
        Ix=[Ix;I_row];
        Iy=[Iy;I_col];
    end
    
    Ix=Ix-size(m,1);
    Iy=Iy-size(m,2);
    imwrite(uint16(m(:,:,1)),['xcorr_',file_str,'.tif']);
    for ii=2:500
        imwrite(uint16(circshift(m(:,:,ii),[Ix(ii-1),Iy(ii-1)])),['xcorr_',file_str,'.tif'],'WriteMode','append');
    end
end
%%
m0 = double(imread(['xcorr_',file_str,'.tif']));
for file_ID=2:26
    file_str=num2str(file_ID,'%03d');
    m = double(imread(['GCAMP_',file_str,'.tif']));
    C=Xcorr2FFT(m0,m);
    [M,I]=max(C(:));
    [I_row, I_col] = ind2sub(size(C),I);
    I_row=I_row-size(m,1);
    I_col=I_col-size(m,2);
    FileTif=['xcorr_',file_str,'.tif'];
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
    
    imwrite(uint16(circshift(m(:,:,1),[I_row,I_col])),['xcorr2_',file_str,'.tif']);
    for ii=2:500
        imwrite(uint16(circshift(m(:,:,ii),[I_row,I_col])),['xcorr2_',file_str,'.tif'],'WriteMode','append');
    end
end
%%
im=zeros(512,512,13000);
for file_ID=1:26
    file_str=num2str(file_ID,'%03d');
    FileTif=['xcorr2_',file_str,'.tif'];
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
    im(:,:,1+500*(file_ID-1):500*file_ID)=m;
end