x=0:20;
y=unwrap(finalphase(22,28:48));
theta1=25.5*x/20;
theta2=asind(sin(theta1)/1.33);
y(2:end)=y(2:end)./theta1(2:end).*theta2(2:end);
fit_finalphase=fit(x.',y.','poly4');
%%
aberration=zeros(600,792);
centerX=240;
centerY=320;
Radius=240;
for i=1:600
    for j=1:792
        if( ((i-centerX)^2+(j-centerY)^2)<Radius^2)
            d=sqrt((i-centerX)^2+(j-centerY)^2)/10;
%             aberration(i,j)=f.p1*d^9 + f.p2*d^8 + f.p3*d^7 + f.p4*d^6 + f.p5*d^5 + f.p6*d^4 + f.p7*d^3 + f.p8*d^2 + f.p9*d + f.p10;
            aberration(i,j)=feval(fit_finalphase,d);
        end
    end
end
%%
figure;imagesc(aberration);colormap hsv
%%
outputphase=angle(exp(1i*(circshift(1*aberration,[0,0])-slmphase)))+1.1*pi;% shift minimum to above 0;
for k1=1:10
    for k2=1:12
        phaseblock=outputphase((k1-1)*60+1:(k1-1)*60+60,(k2-1)*66+1:(k2-1)*66+66);
        vblock=voltagearray(k1,k2,1)*phaseblock.^6 + voltagearray(k1,k2,2)*phaseblock.^5 + voltagearray(k1,k2,3)*phaseblock.^4 + voltagearray(k1,k2,4)*phaseblock.^3+voltagearray(k1,k2,5)*phaseblock.^2+voltagearray(k1,k2,6)*phaseblock.^1;
        vout((k1-1)*60+1:(k1-1)*60+60,(k2-1)*66+1:(k2-1)*66+66)=vblock;
    end
vout=uint8(vout);
Screen(window2, 'PutImage',vout);Screen(window2,'Flip');
end
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

