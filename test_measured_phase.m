%%
phase0=zeros(50);
for i=1:50
    for j=1:50
        phase0(i,j)=mean(mean(finalphase((i-1)*20+1:i*20,(j-1)*20+1:j*20)));
    end
end
finalphase=phase0;
%%
shift_x=0;
shift_y=0;
rotate_angle=250;
phase1=finalphase(2:44,6:48);
phase2=imrotate(phase1,rotate_angle);
r_size=floor(size(phase2,1)/2)+1;
phase2=phase2(r_size-21:r_size+21,r_size-21:r_size+21);
phase2=Expand(phase2,11,11);
phase2=imresize(phase2,[450 450]);
% apply;
outputphase=zeros(600,792);
outputphase(80:79+size(phase2,1),20:19+size(phase2,2))=phase2;
outputphase=angle(exp(1i*(circshift(outputphase,[shift_x,shift_y])-slmphase)))+1.1*pi;% shift minimum to above 0;
for k1=1:10
    
    for k2=1:12
        phaseblock=outputphase((k1-1)*60+1:(k1-1)*60+60,(k2-1)*66+1:(k2-1)*66+66);
        vblock=voltagearray(k1,k2,1)*phaseblock.^6 + voltagearray(k1,k2,2)*phaseblock.^5 + voltagearray(k1,k2,3)*phaseblock.^4 + voltagearray(k1,k2,4)*phaseblock.^3+voltagearray(k1,k2,5)*phaseblock.^2+voltagearray(k1,k2,6)*phaseblock.^1;
        vout((k1-1)*60+1:(k1-1)*60+60,(k2-1)*66+1:(k2-1)*66+66)=vblock;
    end
end
vout=uint8(vout);
Screen(window2, 'PutImage',vout);Screen(window2,'Flip');

%% compare;
outputphase=-1*slmphase;
outputphase=angle(exp(1i*outputphase))+1.1*pi;% shift minimum to above 0;
for k1=1:10
    
    for k2=1:12
        phaseblock=outputphase((k1-1)*60+1:(k1-1)*60+60,(k2-1)*66+1:(k2-1)*66+66);
        vblock=voltagearray(k1,k2,1)*phaseblock.^6 + voltagearray(k1,k2,2)*phaseblock.^5 + voltagearray(k1,k2,3)*phaseblock.^4 + voltagearray(k1,k2,4)*phaseblock.^3+voltagearray(k1,k2,5)*phaseblock.^2+voltagearray(k1,k2,6)*phaseblock.^1;
        vout((k1-1)*60+1:(k1-1)*60+60,(k2-1)*66+1:(k2-1)*66+66)=vblock;
    end
end
vout=uint8(vout);
Screen(window2, 'PutImage',vout);Screen(window2,'Flip');
