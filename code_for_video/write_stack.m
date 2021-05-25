file_prefix='Assembly2';
for i=1:5560
    img=imread([file_prefix,num2str((6*i-3),'%05d'),'.tif']);
    img=img(37:808,492:1263,:);
    imwrite(img,['stack3.tif'],'WriteMode','append');
    i
end