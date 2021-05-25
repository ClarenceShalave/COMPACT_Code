file_counter=1:5;
file_N=size(file_counter,2);
file_basename='psf';
peak_percent=0.0001;

step_size=5;%um
wavelength=0.93;%um
n=1.33;
img=imread([file_basename,num2str(file_counter(1),'%01d'),'.tiff']);
img_size=size(img(:),1);
mean_number=floor(peak_percent*img_size);
threshold=mean(mean(img(1:10,1:10)));
file_distance=(0:step_size:step_size*(file_N-1))';
peak_intensity=zeros(file_N,1);
peak_N=1;
for j=file_counter
    img=imread([file_basename,num2str(j,'%01d'),'.tiff']);
    %     peak_intensity(j)=max(max(img))-threshold;
    peak_sort=sort(img(:),'descend');
    peak_intensity(peak_N)=mean(peak_sort(1:mean_number))-threshold;
    peak_N=peak_N+1;
end
f_gauss=fit(file_distance,peak_intensity,'gauss1');
figure;plot(f_gauss,file_distance,peak_intensity);
file_NA=sqrt(n^2-(n-0.532*wavelength/(f_gauss.c1*sqrt(2)))^2);
title(['2photon FWHM=',num2str(2*sqrt(log(2))*f_gauss.c1),'\mum NA=',num2str(file_NA)])
