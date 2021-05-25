%% coeff path and file name
coeff_folder_name='7';
coefficients_path='G:\COMPACT\coefficients\';
coeff_full_path=[coefficients_path,coeff_folder_name,'\'];
mkdir(coeff_full_path);
%% pico_positions.mat
pico_positions=[13050];
pico_D=[150];
pico_id_position_matrix=[(50:500)',[ones(451,1)]];

% save([coeff_full_path,'pico_positions.mat'],'pico_positions','pico_D','pico_id_position_matrix');
%% xy_offset.mat
offset_x=[0];
offset_y=[0];

% save([coeff_full_path,'xy_offset.mat'],'offset_x','offset_y');
%% f_zoom.mat
wd=[100;200;300;400];
zoom=[249/249;273/249;302/249;326/249];
f_zoom=fit(wd,zoom,'poly1');
% save([coeff_full_path,'f_zoom.mat'],'f_zoom');
%% defocus_scale.mat
wd=[50;149;150;249;250;349;350;449];
defocusscale=[-50/30;50/-27;-50/27;50/-20;-50/20;50/-18;-50/16;50/-16];
f_defocusscale=fit(wd,defocusscale,'linearinterp');
% save([coeff_full_path,'defocus_scale.mat'],'f_defocusscale');
%% f_power
wd=[50;100;150;200;250;300;350;400;450];
power=[6;6;6;6;7;8;8;10;14];
power=power/min(power);
f_power=fit(wd,power,'linearinterp');