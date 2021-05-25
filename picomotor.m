
%% set up the serial communication;
spico = serial('COM1','BaudRate',19200,'DataBits',8,'Parity', 'NONE','StopBits', 1);
fopen(spico);
spico.Terminator = 'CR';
%% turn on motor; enable closed loop control;
fprintf(spico,'mon');% motor on;
pause (1);
fprintf(spico,'SER a1');% enable close loop, otherwise, ABS is relative motion;
%% define motor speed;
fprintf(spico,'vel a1 2000');% set speed;
% ask acceleration;
pause(0.2);
fprintf(spico,'acc');out = fscanf(spico);disp(out);
% ask velocity;
fprintf(spico,'vel a1');out = fscanf(spico);disp(out);
%% define current position;This is very importatn;
%without this step, the position can be huge number;
% FLI and RLI commands can be used to move the motor to forward and reverse limit;
fprintf(spico,'POS a1 0'); % set current position;
%% execute absolute motion
fprintf(spico,'ABS a1=9800 g');% go to abs position;
%% if urgent stop is needed;
fprintf(spico,'sto a1');% stop motor;
fprintf(spico,'hal a1');% smooth stop;
%% ask position;
fprintf(spico,'POS a1');out = fscanf(spico);disp(out);
%% how long is 1 unit? we can do a measurement;
%63.6nm is 1 unit;