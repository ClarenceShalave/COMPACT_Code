%% rotation stack recording;
startangle=-54.64;
base_path='G:\COMPACT\data\';
folder_name='20181221\bead_test5';
mkdir([base_path,folder_name]);
file_name=['bt'];
pause_time=1.2;
rotate_time=0.8;
for wd=660:20:840
    for spinby=0:7.5:360
        Controller.MOV(axisname,21603*0.074+21603/360*spinby);pause(rotate_time);
%         scanimage_angle=startangle+spinby;
%         
%         state.acq.scanRotation=scanimage_angle;
%         updateGUIByGlobal('state.acq.scanRotation');
%         updateAcquisitionParameters;
%         setScanProps(gh);
%         updateRSPs();
%         
%         
%         state.files.savePath=[base_path,folder_name];
%         state.files.baseName=[file_name,'_',num2str(spinby*100),'_'];
%         state.files.fullFileName=[base_path,folder_name,'\',file_name,'_',num2str(spinby*100),'_'];
%         state.files.fileCounter=wd;
%         
%         %     setZoomValue(3*f_zoom(wd));
%         
%         load([coefficients_path,'pico_current_position.mat']);
%         current_pico_id=find(pico_positions==pico_current_position);
%         pico_id=floor((wd-50)/200);
%         if pico_id==current_pico_id
%         else
%             diff_sign=sign(pico_id-current_pico_id);
%             for pico_n=(current_pico_id+diff_sign):diff_sign:pico_id
%                 pico_movedistance=picoStepSize*(pico_positions(pico_n)-pico_positions(current_pico_id));
%                 fprintf(spico,['ABS a1=',num2str(pico_positions(pico_n)),' g']);
%                 pico_current_position=pico_positions(pico_n);
%                 current_pico_id=find(pico_positions==pico_current_position);
%                 
%                 pause(5);
%                 
%                 dgx=pico_movedistance*gx/gz;
%                 dgy=pico_movedistance*gy/gz;
%                 dgz=pico_movedistance;
%                 if (motorZ+dgz)>=zlimL &&  (motorZ+dgz)<=zlimH
%                     motorX=motorX-dgx;
%                     motorY=motorY-dgy;
%                     motorZ=motorZ-dgz;
%                     [errorCode] = GroupMoveAbsolute(socketID, group, [motorX,motorY,motorZ]) ;
%                     if (errorCode ~= 0)
%                         disp (['Error ' num2str(errorCode) ' occurred while doing GroupMoveAbsolute ! ']) ;
%                         return ;
%                     end
%                     pause(waitabit);
%                 else
%                     msgbox('zlimit error!');
%                 end
%             end
%             save([coefficients_path,'pico_current_position.mat'],'pico_current_position');
%             current_pico_id=pico_id;
%         end
%         defocus_distance=round((wd-pico_D(pico_id))/f_defocusscale(wd));
%         aberration=Maberration(:,:,pico_id);
%         centerx=centerx0+offset_x(pico_id)+0;
%         centery=centery0+offset_y(pico_id)+0;
%         hx=(x-centerx)*pixelsize;
%         hy=(y-centery)*pixelsize;
%         xNA=hx/f;
%         yNA=hy/f;
%         [XNA, YNA]=meshgrid(xNA, yNA);
%         XYNA=sqrt(XNA.^2+YNA.^2);
%         theta=asin(XYNA/n);
%         defocus_wavefront=defocus_distance*n*cos(theta)/lambda*2*pi;
%         if defocus_distance>0
%             defocus_wavefront=defocus_wavefront-max(defocus_wavefront(:));
%         else
%             defocus_wavefront=defocus_wavefront-min(defocus_wavefront(:));
%         end
%         outputphase=angle(exp(1i*(aberration+defocus_wavefront-slmphase)))+1.1*pi;% shift minimum to above 0;
%         for k1=1:10
%             for k2=1:12
%                 phaseblock=outputphase((k1-1)*60+1:(k1-1)*60+60,(k2-1)*66+1:(k2-1)*66+66);
%                 vblock=voltagearray(k1,k2,1)*phaseblock.^6 + voltagearray(k1,k2,2)*phaseblock.^5 + voltagearray(k1,k2,3)*phaseblock.^4 + voltagearray(k1,k2,4)*phaseblock.^3+voltagearray(k1,k2,5)*phaseblock.^2+voltagearray(k1,k2,6)*phaseblock.^1;
%                 vout((k1-1)*60+1:(k1-1)*60+60,(k2-1)*66+1:(k2-1)*66+66)=vblock;
%             end
%         end
%         vout=uint8(vout);
%         Screen(window2, 'PutImage',vout);Screen(window2,'Flip');
%         
%         executeGrabOneCallback(gh.mainControls.grabOneButton);
        pause(pause_time);
    end
end

for wd=460:20:640
    for spinby=360:7.5:720
        Controller.MOV(axisname,21603*0.074+21603/360*spinby);pause(rotate_time);
        scanimage_angle=startangle+spinby;
        
        state.acq.scanRotation=scanimage_angle;
        updateGUIByGlobal('state.acq.scanRotation');
        updateAcquisitionParameters;
        setScanProps(gh);
        updateRSPs();
        
        
        state.files.savePath=[base_path,folder_name];
        state.files.baseName=[file_name,'_',num2str(spinby*100),'_'];
        state.files.fullFileName=[base_path,folder_name,'\',file_name,'_',num2str(spinby*100),'_'];
        state.files.fileCounter=wd;
        
        %     setZoomValue(3*f_zoom(wd));
        
        load([coefficients_path,'pico_current_position.mat']);
        current_pico_id=find(pico_positions==pico_current_position);
        pico_id=floor((wd-50)/200);
        if pico_id==current_pico_id
        else
            diff_sign=sign(pico_id-current_pico_id);
            for pico_n=(current_pico_id+diff_sign):diff_sign:pico_id
                pico_movedistance=picoStepSize*(pico_positions(pico_n)-pico_positions(current_pico_id));
                fprintf(spico,['ABS a1=',num2str(pico_positions(pico_n)),' g']);
                pico_current_position=pico_positions(pico_n);
                current_pico_id=find(pico_positions==pico_current_position);
                
                pause(5);
                
                dgx=pico_movedistance*gx/gz;
                dgy=pico_movedistance*gy/gz;
                dgz=pico_movedistance;
                if (motorZ+dgz)>=zlimL &&  (motorZ+dgz)<=zlimH
                    motorX=motorX-dgx;
                    motorY=motorY-dgy;
                    motorZ=motorZ-dgz;
                    [errorCode] = GroupMoveAbsolute(socketID, group, [motorX,motorY,motorZ]) ;
                    if (errorCode ~= 0)
                        disp (['Error ' num2str(errorCode) ' occurred while doing GroupMoveAbsolute ! ']) ;
                        return ;
                    end
                    pause(waitabit);
                else
                    msgbox('zlimit error!');
                end
            end
            save([coefficients_path,'pico_current_position.mat'],'pico_current_position');
            current_pico_id=pico_id;
        end
        defocus_distance=round((wd-pico_D(pico_id))/f_defocusscale(wd));
        aberration=Maberration(:,:,pico_id);
        centerx=centerx0+offset_x(pico_id)+0;
        centery=centery0+offset_y(pico_id)+0;
        hx=(x-centerx)*pixelsize;
        hy=(y-centery)*pixelsize;
        xNA=hx/f;
        yNA=hy/f;
        [XNA, YNA]=meshgrid(xNA, yNA);
        XYNA=sqrt(XNA.^2+YNA.^2);
        theta=asin(XYNA/n);
        defocus_wavefront=defocus_distance*n*cos(theta)/lambda*2*pi;
        if defocus_distance>0
            defocus_wavefront=defocus_wavefront-max(defocus_wavefront(:));
        else
            defocus_wavefront=defocus_wavefront-min(defocus_wavefront(:));
        end
        outputphase=angle(exp(1i*(aberration+defocus_wavefront-slmphase)))+1.1*pi;% shift minimum to above 0;
        for k1=1:10
            for k2=1:12
                phaseblock=outputphase((k1-1)*60+1:(k1-1)*60+60,(k2-1)*66+1:(k2-1)*66+66);
                vblock=voltagearray(k1,k2,1)*phaseblock.^6 + voltagearray(k1,k2,2)*phaseblock.^5 + voltagearray(k1,k2,3)*phaseblock.^4 + voltagearray(k1,k2,4)*phaseblock.^3+voltagearray(k1,k2,5)*phaseblock.^2+voltagearray(k1,k2,6)*phaseblock.^1;
                vout((k1-1)*60+1:(k1-1)*60+60,(k2-1)*66+1:(k2-1)*66+66)=vblock;
            end
        end
        vout=uint8(vout);
        Screen(window2, 'PutImage',vout);Screen(window2,'Flip');
        
        executeGrabOneCallback(gh.mainControls.grabOneButton);
        pause(pause_time);
    end
end

for wd=260:20:440
    for spinby=720:7.5:1080
        Controller.MOV(axisname,21603*0.074+21603/360*spinby);pause(rotate_time);
        scanimage_angle=startangle+spinby;
        
        state.acq.scanRotation=scanimage_angle;
        updateGUIByGlobal('state.acq.scanRotation');
        updateAcquisitionParameters;
        setScanProps(gh);
        updateRSPs();
        
        
        state.files.savePath=[base_path,folder_name];
        state.files.baseName=[file_name,'_',num2str(spinby*100),'_'];
        state.files.fullFileName=[base_path,folder_name,'\',file_name,'_',num2str(spinby*100),'_'];
        state.files.fileCounter=wd;
        
        %     setZoomValue(3*f_zoom(wd));
        
        load([coefficients_path,'pico_current_position.mat']);
        current_pico_id=find(pico_positions==pico_current_position);
        pico_id=floor((wd-50)/200);
        if pico_id==current_pico_id
        else
            diff_sign=sign(pico_id-current_pico_id);
            for pico_n=(current_pico_id+diff_sign):diff_sign:pico_id
                pico_movedistance=picoStepSize*(pico_positions(pico_n)-pico_positions(current_pico_id));
                fprintf(spico,['ABS a1=',num2str(pico_positions(pico_n)),' g']);
                pico_current_position=pico_positions(pico_n);
                current_pico_id=find(pico_positions==pico_current_position);
                
                pause(5);
                
                dgx=pico_movedistance*gx/gz;
                dgy=pico_movedistance*gy/gz;
                dgz=pico_movedistance;
                if (motorZ+dgz)>=zlimL &&  (motorZ+dgz)<=zlimH
                    motorX=motorX-dgx;
                    motorY=motorY-dgy;
                    motorZ=motorZ-dgz;
                    [errorCode] = GroupMoveAbsolute(socketID, group, [motorX,motorY,motorZ]) ;
                    if (errorCode ~= 0)
                        disp (['Error ' num2str(errorCode) ' occurred while doing GroupMoveAbsolute ! ']) ;
                        return ;
                    end
                    pause(waitabit);
                else
                    msgbox('zlimit error!');
                end
            end
            save([coefficients_path,'pico_current_position.mat'],'pico_current_position');
            current_pico_id=pico_id;
        end
        defocus_distance=round((wd-pico_D(pico_id))/f_defocusscale(wd));
        aberration=Maberration(:,:,pico_id);
        centerx=centerx0+offset_x(pico_id)+0;
        centery=centery0+offset_y(pico_id)+0;
        hx=(x-centerx)*pixelsize;
        hy=(y-centery)*pixelsize;
        xNA=hx/f;
        yNA=hy/f;
        [XNA, YNA]=meshgrid(xNA, yNA);
        XYNA=sqrt(XNA.^2+YNA.^2);
        theta=asin(XYNA/n);
        defocus_wavefront=defocus_distance*n*cos(theta)/lambda*2*pi;
        if defocus_distance>0
            defocus_wavefront=defocus_wavefront-max(defocus_wavefront(:));
        else
            defocus_wavefront=defocus_wavefront-min(defocus_wavefront(:));
        end
        outputphase=angle(exp(1i*(aberration+defocus_wavefront-slmphase)))+1.1*pi;% shift minimum to above 0;
        for k1=1:10
            for k2=1:12
                phaseblock=outputphase((k1-1)*60+1:(k1-1)*60+60,(k2-1)*66+1:(k2-1)*66+66);
                vblock=voltagearray(k1,k2,1)*phaseblock.^6 + voltagearray(k1,k2,2)*phaseblock.^5 + voltagearray(k1,k2,3)*phaseblock.^4 + voltagearray(k1,k2,4)*phaseblock.^3+voltagearray(k1,k2,5)*phaseblock.^2+voltagearray(k1,k2,6)*phaseblock.^1;
                vout((k1-1)*60+1:(k1-1)*60+60,(k2-1)*66+1:(k2-1)*66+66)=vblock;
            end
        end
        vout=uint8(vout);
        Screen(window2, 'PutImage',vout);Screen(window2,'Flip');
        
        executeGrabOneCallback(gh.mainControls.grabOneButton);
        pause(pause_time);
    end
end