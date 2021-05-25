%%
FileTif=['GCAMP_electrode_2_053.tif'];

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
