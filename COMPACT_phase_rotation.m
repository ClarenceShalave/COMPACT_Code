phase_to_be_rotated=cphase_avg_1; %change cphase_avg_1 with variable to be rotated. output phase name is 'newphase'
y_center=300; %600 direction'
x_center=403; %792 direction
phase_diameter=664;
y_shift=0; %600 direction
x_shift=0; %792 direction
rotation_angle=86.4;%counter clockwise
mask0=zeros(size(phase_to_be_rotated));
for ii=1:600
    for jj=1:792
        if (ii-y_center)^2+(jj-x_center)^2<(phase_diameter/2)^2
            mask0(ii,jj)=1;
        end
    end
end
phase_unwrap= unwrap_L2Norm(phase_to_be_rotated.*mask0);
phase_temp=phase_unwrap(:,x_center-phase_diameter/2:x_center+phase_diameter/2);
newphase_unwrap=zeros(size(phase_to_be_rotated));
newphase_unwrap(:,x_center-phase_diameter/2:x_center+phase_diameter/2)=imrotate(phase_temp,rotation_angle,'nearest','crop');
newphase_unwrap=circshift(newphase_unwrap,[y_shift x_shift]);
newphase=angle(exp(-1i*newphase_unwrap));
imagesc(newphase);colormap hsv;