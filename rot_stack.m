scanimage_angle=138;

state.acq.scanRotation=scanimage_angle;
updateGUIByGlobal('state.acq.scanRotation');
updateAcquisitionParameters;
setScanProps(gh);
updateRSPs();

%% rotation stack recording;
startangle=138;
base_path='G:\COMPACT\data\';
folder_name='20190111\GFP_zoom10_zm4p4997_power45';
mkdir([base_path,folder_name]);
file_name=['GFP'];
pause_time=0.7*4;
for spinby=0:6:60
    Controller.MOV(axisname,21603/360*spinby);pause(0.6);
    scanimage_angle=startangle+spinby;
    
    state.acq.scanRotation=scanimage_angle;
    updateGUIByGlobal('state.acq.scanRotation');
    updateAcquisitionParameters;
    setScanProps(gh);
    updateRSPs();
    
    for wd=250:20:310
        state.files.savePath=[base_path,folder_name];
        state.files.baseName=[file_name,'_',num2str(spinby*100),'_'];
        state.files.fullFileName=[base_path,folder_name,'\',file_name,'_',num2str(spinby*100),'_'];
        state.files.fileCounter=wd;
        
        setZoomValue(10*f_zoom(wd));
        
        load([coefficients_path,'pico_current_position.mat']);
        current_pico_id=find(pico_positions==pico_current_position);
        pico_id=pico_id_position_matrix(find( pico_id_position_matrix==wd),2);
        if pico_id==current_pico_id
        else
            diff_sign=sign(pico_id-current_pico_id);
            for pico_n=(current_pico_id+diff_sign):diff_sign:pico_id
                pico_movedistance=picoStepSize*(pico_positions(pico_n)-pico_positions(current_pico_id));
                fprintf(spico,['ABS a1=',num2str(pico_positions(pico_n)),' g']);
                move_distance=pico_movedistance/15;
                for j=1:15
                    dgx=move_distance*gx/gz;
                    dgy=move_distance*gy/gz;
                    dgz=move_distance;
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
                    pause(0.1);
                end
                pico_current_position=pico_positions(pico_n);
                current_pico_id=find(pico_positions==pico_current_position);
                
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


Controller.MOV(axisname,0);pause(7);
% 
% for spinby=0:6:360
%     Controller.MOV(axisname,21603/360*spinby);pause(0.6);
%     scanimage_angle=startangle+spinby;
%     
%     state.acq.scanRotation=scanimage_angle;
%     updateGUIByGlobal('state.acq.scanRotation');
%     updateAcquisitionParameters;
%     setScanProps(gh);
%     updateRSPs();
%     
%     for wd=250:20:530
%         state.files.savePath=[base_path,folder_name];
%         state.files.baseName=[file_name,'_',num2str(spinby*100),'_'];
%         state.files.fullFileName=[base_path,folder_name,'\',file_name,'_',num2str(spinby*100),'_'];
%         state.files.fileCounter=wd;
%         
%         setZoomValue(10*f_zoom(wd));
%         
%         load([coefficients_path,'pico_current_position.mat']);
%         current_pico_id=find(pico_positions==pico_current_position);
%         pico_id=pico_id_position_matrix(find( pico_id_position_matrix==wd),2);
%         if pico_id==current_pico_id
%         else
%             diff_sign=sign(pico_id-current_pico_id);
%             for pico_n=(current_pico_id+diff_sign):diff_sign:pico_id
%                 pico_movedistance=picoStepSize*(pico_positions(pico_n)-pico_positions(current_pico_id));
%                 fprintf(spico,['ABS a1=',num2str(pico_positions(pico_n)),' g']);
%                 move_distance=pico_movedistance/15;
%                 for j=1:15
%                     dgx=move_distance*gx/gz;
%                     dgy=move_distance*gy/gz;
%                     dgz=move_distance;
%                     if (motorZ+dgz)>=zlimL &&  (motorZ+dgz)<=zlimH
%                         motorX=motorX-dgx;
%                         motorY=motorY-dgy;
%                         motorZ=motorZ-dgz;
%                         [errorCode] = GroupMoveAbsolute(socketID, group, [motorX,motorY,motorZ]) ;
%                         if (errorCode ~= 0)
%                             disp (['Error ' num2str(errorCode) ' occurred while doing GroupMoveAbsolute ! ']) ;
%                             return ;
%                         end
%                         pause(waitabit);
%                     else
%                         msgbox('zlimit error!');
%                     end
%                     pause(0.1);
%                 end
%                 pico_current_position=pico_positions(pico_n);
%                 current_pico_id=find(pico_positions==pico_current_position);
%                 
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
%         pause(pause_time);
%     end
% end
% 
% 
% Controller.MOV(axisname,0);pause(7);