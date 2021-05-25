%% stage connection
global waitabit motorX motorY motorZ rAngle dz dr zlimH zlimL gx gy gz;
global IP Port TimeOut socketID;
global group positioner1 positioner2 positioner3; % parameters for controlling
%%
pico=5320;
load([coefficients_path,'pico_current_position.mat']);
pico_movedistance=picoStepSize*(pico-pico_current_position);
pico_move_direction=sign(pico_movedistance);
fprintf(spico,['ABS a1=',num2str(pico),' g']);
move_distance_step=150*picoStepSize;
N_pico_move=floor(abs(pico_movedistance)/move_distance_step);
for j=1:N_pico_move
    dgx=move_distance_step*gx/gz*pico_move_direction;
    dgy=move_distance_step*gy/gz*pico_move_direction;
    dgz=move_distance_step*pico_move_direction;
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
pico_current_position=pico;
save([coefficients_path,'pico_current_position.mat'],'pico_current_position');