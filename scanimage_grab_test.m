date_n=20180904;
mkdir(['E:\RAS3\data\',num2str(date_n),'\feedback']);
mkdir(['E:\RAS3\data\',num2str(date_n),'\bead']);
sortnum=1;
acqnum=1;
%%
state.acq.fastScanningX = 1;
state.acq.fastScanningY = 0;
updateGUIByGlobal('state.acq.fastScanningX');
saveCurrentConfig();
applyConfigurationSettings;

range=5;

% state.files.savePath=['C:\Users\install\Desktop'];
state.files.savePath=['E:\RAS3\data\',num2str(date_n),'\feedback'];
state.files.baseName=['position_sensor_positive_x_',num2str(sortnum),'_'];
% state.files.fullFileName=['C:\Users\install\Desktop\x_feedback_positive_',num2str(sortnum),'_'];
state.files.fullFileName=['E:\RAS3\data\',num2str(date_n),'\feedback\position_sensor_positive_x_',num2str(sortnum),'_'];

state.files.fileCounter=acqnum;
state.acq.acquiringChannel1=1;
state.acq.acquiringChannel2=1;
state.acq.acquiringChannel3=1;
state.acq.acquiringChannel4=0;
state.acq.numberOfChannelsSave=3;
state.acq.numberOfChannelsImage=3;
state.acq.numberOfChannelsAcquire=3;
state.acq.savingChannel=[1 1 1 0];
state.acq.imagingChannel=[1 1 1 0];
state.acq.inputVoltageRange1=range;  
state.acq.inputVoltageInvert1=0;  
state.acq.inputVoltageRange2=range;  
state.acq.inputVoltageInvert2=0;  
state.acq.inputVoltageRange3=range;  
state.acq.inputVoltageInvert3=0;  
state.acq.savingChannel1 = 1;
state.acq.imagingChannel1 = 1;
state.acq.acquiringChannel1 = 1;
state.acq.savingChannel2 = 1;
state.acq.imagingChannel2 = 1;
state.acq.acquiringChannel2 = 1;
state.acq.savingChannel3 = 1;
state.acq.imagingChannel3 = 1;
state.acq.acquiringChannel3 = 1;
updateGUIByGlobal('state.acq.savingChannel1');
updateGUIByGlobal('state.acq.imagingChannel1');
updateGUIByGlobal('state.acq.acquiringChannel1');
updateGUIByGlobal('state.acq.savingChannel2');
updateGUIByGlobal('state.acq.imagingChannel2');
updateGUIByGlobal('state.acq.acquiringChannel2');
updateGUIByGlobal('state.acq.savingChannel3');
updateGUIByGlobal('state.acq.imagingChannel3');
updateGUIByGlobal('state.acq.acquiringChannel3');
updateNumberOfChannels;
applyChannelSettings;
saveCurrentConfig();
applyConfigurationSettings;
executeGrabOneCallback(gh.mainControls.grabOneButton);  % grab the feedback
pause(45)


state.acq.fastScanningX = 1;
state.acq.fastScanningY = 0;
updateGUIByGlobal('state.acq.fastScanningX');
saveCurrentConfig();
applyConfigurationSettings;

range=5;

% state.files.savePath=['C:\Users\install\Desktop'];
state.files.savePath=['E:\RAS3\data\',num2str(date_n),'\feedback'];
state.files.baseName=['position_sensor_negative_x_',num2str(sortnum),'_'];
% state.files.fullFileName=['C:\Users\install\Desktop\y_feedback_positive_',num2str(sortnum),'_'];
state.files.fullFileName=['E:\RAS3\data\',num2str(date_n),'\feedback\position_sensor_negative_x_',num2str(sortnum),'_'];

state.files.fileCounter=acqnum;
state.acq.acquiringChannel1=1;
state.acq.acquiringChannel2=1;
state.acq.acquiringChannel3=1;
state.acq.acquiringChannel4=0;
state.acq.numberOfChannelsSave=3;
state.acq.numberOfChannelsImage=3;
state.acq.numberOfChannelsAcquire=3;
state.acq.savingChannel=[1 1 1 0];
state.acq.imagingChannel=[1 1 1 0];
state.acq.inputVoltageRange1=range;  
state.acq.inputVoltageInvert1=1;  
state.acq.inputVoltageRange2=range;  
state.acq.inputVoltageInvert2=1;  
state.acq.inputVoltageRange3=range;  
state.acq.inputVoltageInvert3=0;  
state.acq.savingChannel1 = 1;
state.acq.imagingChannel1 = 1;
state.acq.acquiringChannel1 = 1;
state.acq.savingChannel2 = 1;
state.acq.imagingChannel2 = 1;
state.acq.acquiringChannel2 = 1;
state.acq.savingChannel3 = 1;
state.acq.imagingChannel3 = 1;
state.acq.acquiringChannel3 = 1;
updateGUIByGlobal('state.acq.savingChannel1');
updateGUIByGlobal('state.acq.imagingChannel1');
updateGUIByGlobal('state.acq.acquiringChannel1');
updateGUIByGlobal('state.acq.savingChannel2');
updateGUIByGlobal('state.acq.imagingChannel2');
updateGUIByGlobal('state.acq.acquiringChannel2');
updateGUIByGlobal('state.acq.savingChannel3');
updateGUIByGlobal('state.acq.imagingChannel3');
updateGUIByGlobal('state.acq.acquiringChannel3');
updateNumberOfChannels;
applyChannelSettings;
saveCurrentConfig();
applyConfigurationSettings;
executeGrabOneCallback(gh.mainControls.grabOneButton);  % grab the feedback
pause(45)


state.acq.fastScanningX = 0;
state.acq.fastScanningY = 1;
updateGUIByGlobal('state.acq.fastScanningY');
saveCurrentConfig();
applyConfigurationSettings;

range=5;

% state.files.savePath=['C:\Users\install\Desktop'];
state.files.savePath=['E:\RAS3\data\',num2str(date_n),'\feedback'];
state.files.baseName=['position_sensor_positive_y_',num2str(sortnum),'_'];
% state.files.fullFileName=['C:\Users\install\Desktop\x_feedback_positive_',num2str(sortnum),'_'];
state.files.fullFileName=['E:\RAS3\data\',num2str(date_n),'\feedback\position_sensor_positive_y_',num2str(sortnum),'_'];

state.files.fileCounter=acqnum;
state.acq.acquiringChannel1=1;
state.acq.acquiringChannel2=1;
state.acq.acquiringChannel3=1;
state.acq.acquiringChannel4=0;
state.acq.numberOfChannelsSave=3;
state.acq.numberOfChannelsImage=3;
state.acq.numberOfChannelsAcquire=3;
state.acq.savingChannel=[1 1 1 0];
state.acq.imagingChannel=[1 1 1 0];
state.acq.inputVoltageRange1=range;  
state.acq.inputVoltageInvert1=0;  
state.acq.inputVoltageRange2=range;  
state.acq.inputVoltageInvert2=0;  
state.acq.inputVoltageRange3=range;  
state.acq.inputVoltageInvert3=0;  
state.acq.savingChannel1 = 1;
state.acq.imagingChannel1 = 1;
state.acq.acquiringChannel1 = 1;
state.acq.savingChannel2 = 1;
state.acq.imagingChannel2 = 1;
state.acq.acquiringChannel2 = 1;
state.acq.savingChannel3 = 1;
state.acq.imagingChannel3 = 1;
state.acq.acquiringChannel3 = 1;
updateGUIByGlobal('state.acq.savingChannel1');
updateGUIByGlobal('state.acq.imagingChannel1');
updateGUIByGlobal('state.acq.acquiringChannel1');
updateGUIByGlobal('state.acq.savingChannel2');
updateGUIByGlobal('state.acq.imagingChannel2');
updateGUIByGlobal('state.acq.acquiringChannel2');
updateGUIByGlobal('state.acq.savingChannel3');
updateGUIByGlobal('state.acq.imagingChannel3');
updateGUIByGlobal('state.acq.acquiringChannel3');
updateNumberOfChannels;
applyChannelSettings;
saveCurrentConfig();
applyConfigurationSettings;
executeGrabOneCallback(gh.mainControls.grabOneButton);  % grab the feedback
pause(45)


state.acq.fastScanningX = 0;
state.acq.fastScanningY = 1;
updateGUIByGlobal('state.acq.fastScanningY');
saveCurrentConfig();
applyConfigurationSettings;

range=5;

% state.files.savePath=['C:\Users\install\Desktop'];
state.files.savePath=['E:\RAS3\data\',num2str(date_n),'\feedback'];
state.files.baseName=['position_sensor_negative_y_',num2str(sortnum),'_'];
% state.files.fullFileName=['C:\Users\install\Desktop\y_feedback_positive_',num2str(sortnum),'_'];
state.files.fullFileName=['E:\RAS3\data\',num2str(date_n),'\feedback\position_sensor_negative_y_',num2str(sortnum),'_'];

state.files.fileCounter=acqnum;
state.acq.acquiringChannel1=1;
state.acq.acquiringChannel2=1;
state.acq.acquiringChannel3=1;
state.acq.acquiringChannel4=0;
state.acq.numberOfChannelsSave=3;
state.acq.numberOfChannelsImage=3;
state.acq.numberOfChannelsAcquire=3;
state.acq.savingChannel=[1 1 1 0];
state.acq.imagingChannel=[1 1 1 0];
state.acq.inputVoltageRange1=range;  
state.acq.inputVoltageInvert1=1;  
state.acq.inputVoltageRange2=range;  
state.acq.inputVoltageInvert2=1;  
state.acq.inputVoltageRange3=range;  
state.acq.inputVoltageInvert3=0;  
state.acq.savingChannel1 = 1;
state.acq.imagingChannel1 = 1;
state.acq.acquiringChannel1 = 1;
state.acq.savingChannel2 = 1;
state.acq.imagingChannel2 = 1;
state.acq.acquiringChannel2 = 1;
state.acq.savingChannel3 = 1;
state.acq.imagingChannel3 = 1;
state.acq.acquiringChannel3 = 1;
updateGUIByGlobal('state.acq.savingChannel1');
updateGUIByGlobal('state.acq.imagingChannel1');
updateGUIByGlobal('state.acq.acquiringChannel1');
updateGUIByGlobal('state.acq.savingChannel2');
updateGUIByGlobal('state.acq.imagingChannel2');
updateGUIByGlobal('state.acq.acquiringChannel2');
updateGUIByGlobal('state.acq.savingChannel3');
updateGUIByGlobal('state.acq.imagingChannel3');
updateGUIByGlobal('state.acq.acquiringChannel3');
updateNumberOfChannels;
applyChannelSettings;
saveCurrentConfig();
applyConfigurationSettings;
executeGrabOneCallback(gh.mainControls.grabOneButton);  % grab the feedback
pause(45)

%% 
state.acq.fastScanningX = 1;
state.acq.fastScanningY = 0;
updateGUIByGlobal('state.acq.fastScanningX');
saveCurrentConfig();
applyConfigurationSettings;

range=2;

% state.files.savePath=['C:\Users\install\Desktop'];
state.files.savePath=['E:\RAS3\data\',num2str(date_n),'\feedback'];
state.files.baseName=['y_feedback_negative_',num2str(sortnum),'_'];
% state.files.fullFileName=['C:\Users\install\Desktop\y_feedback_negative_',num2str(sortnum),'_'];
state.files.fullFileName=['E:\RAS3\data\',num2str(date_n),'\feedback\y_feedback_negative_',num2str(sortnum),'_'];

state.files.fileCounter=acqnum;
state.acq.acquiringChannel1=0;
state.acq.acquiringChannel2=1;
state.acq.acquiringChannel3=0;
state.acq.acquiringChannel4=0;
state.acq.numberOfChannelsSave=1;
state.acq.numberOfChannelsImage=1;
state.acq.numberOfChannelsAcquire=1;
state.acq.savingChannel=[0 1 0 0];
state.acq.imagingChannel=[0 1 0 0];
state.acq.inputVoltageRange2=range;  % the range of channel 2
state.acq.inputVoltageInvert2=1;  % 0 is positive and 1 is negative
state.acq.savingChannel1 = 0;
state.acq.imagingChannel1 = 0;
state.acq.acquiringChannel1 = 0;
state.acq.savingChannel2 = 1;
state.acq.imagingChannel2 = 1;
state.acq.acquiringChannel2 = 1;
state.acq.savingChannel3 = 0;
state.acq.imagingChannel3 = 0;
state.acq.acquiringChannel3 = 0;
updateGUIByGlobal('state.acq.savingChannel1');
updateGUIByGlobal('state.acq.imagingChannel1');
updateGUIByGlobal('state.acq.acquiringChannel1');
updateGUIByGlobal('state.acq.savingChannel2');
updateGUIByGlobal('state.acq.imagingChannel2');
updateGUIByGlobal('state.acq.acquiringChannel2');
updateGUIByGlobal('state.acq.savingChannel3');
updateGUIByGlobal('state.acq.imagingChannel3');
updateGUIByGlobal('state.acq.acquiringChannel3');
updateNumberOfChannels;
applyChannelSettings;
executeGrabOneCallback(gh.mainControls.grabOneButton);  % grab the feedback
pause(45)


state.acq.fastScanningX = 1;
state.acq.fastScanningY = 0;
updateGUIByGlobal('state.acq.fastScanningX');
saveCurrentConfig();
applyConfigurationSettings;

range=2;

% state.files.savePath=['C:\Users\install\Desktop'];
state.files.savePath=['E:\RAS3\data\',num2str(date_n),'\feedback'];
state.files.baseName=['y_feedback_positive_',num2str(sortnum),'_'];
% state.files.fullFileName=['C:\Users\install\Desktop\y_feedback_positive_',num2str(sortnum),'_'];
state.files.fullFileName=['E:\RAS3\data\',num2str(date_n),'\feedback\y_feedback_positive_',num2str(sortnum),'_'];

state.files.fileCounter=acqnum;
state.acq.acquiringChannel1=0;
state.acq.acquiringChannel2=1;
state.acq.acquiringChannel3=0;
state.acq.acquiringChannel4=0;
state.acq.numberOfChannelsSave=1;
state.acq.numberOfChannelsImage=1;
state.acq.numberOfChannelsAcquire=1;
state.acq.savingChannel=[0 1 0 0];
state.acq.imagingChannel=[0 1 0 0];
state.acq.inputVoltageRange2=range;  % the range of channel 2
state.acq.inputVoltageInvert2=0;  % 0 is positive and 1 is negative
state.acq.savingChannel1 = 0;
state.acq.imagingChannel1 = 0;
state.acq.acquiringChannel1 = 0;
state.acq.savingChannel2 = 1;
state.acq.imagingChannel2 = 1;
state.acq.acquiringChannel2 = 1;
state.acq.savingChannel3 = 0;
state.acq.imagingChannel3 = 0;
state.acq.acquiringChannel3 = 0;
updateGUIByGlobal('state.acq.savingChannel1');
updateGUIByGlobal('state.acq.imagingChannel1');
updateGUIByGlobal('state.acq.acquiringChannel1');
updateGUIByGlobal('state.acq.savingChannel2');
updateGUIByGlobal('state.acq.imagingChannel2');
updateGUIByGlobal('state.acq.acquiringChannel2');
updateGUIByGlobal('state.acq.savingChannel3');
updateGUIByGlobal('state.acq.imagingChannel3');
updateGUIByGlobal('state.acq.acquiringChannel3');
updateNumberOfChannels;
applyChannelSettings;
executeGrabOneCallback(gh.mainControls.grabOneButton);  % grab the feedback
pause(45)


state.acq.fastScanningX = 0;
state.acq.fastScanningY = 1;
updateGUIByGlobal('state.acq.fastScanningY');
saveCurrentConfig();
applyConfigurationSettings;

range=2;

% state.files.savePath=['C:\Users\install\Desktop'];
state.files.savePath=['E:\RAS3\data\',num2str(date_n),'\feedback'];
state.files.baseName=['x_feedback_negative_',num2str(sortnum),'_'];
% state.files.fullFileName=['C:\Users\install\Desktop\x_feedback_negative_',num2str(sortnum),'_'];
state.files.fullFileName=['E:\RAS3\data\',num2str(date_n),'\feedback\x_feedback_negative_',num2str(sortnum),'_'];

state.files.fileCounter=acqnum;
state.acq.acquiringChannel1=1;
state.acq.acquiringChannel2=0;
state.acq.acquiringChannel3=0;
state.acq.acquiringChannel4=0;
state.acq.numberOfChannelsSave=1;
state.acq.numberOfChannelsImage=1;
state.acq.numberOfChannelsAcquire=1;
state.acq.savingChannel=[1 0 0 0];
state.acq.imagingChannel=[1 0 0 0];
state.acq.inputVoltageRange1=range;  % the range of channel 2
state.acq.inputVoltageInvert1=1;  % 0 is positive and 1 is negative
state.acq.savingChannel1 = 1;
state.acq.imagingChannel1 = 1;
state.acq.acquiringChannel1 = 1;
state.acq.savingChannel2 = 0;
state.acq.imagingChannel2 = 0;
state.acq.acquiringChannel2 = 0;
state.acq.savingChannel3 = 0;
state.acq.imagingChannel3 = 0;
state.acq.acquiringChannel3 = 0;
updateGUIByGlobal('state.acq.savingChannel1');
updateGUIByGlobal('state.acq.imagingChannel1');
updateGUIByGlobal('state.acq.acquiringChannel1');
updateGUIByGlobal('state.acq.savingChannel2');
updateGUIByGlobal('state.acq.imagingChannel2');
updateGUIByGlobal('state.acq.acquiringChannel2');
updateGUIByGlobal('state.acq.savingChannel3');
updateGUIByGlobal('state.acq.imagingChannel3');
updateGUIByGlobal('state.acq.acquiringChannel3');
updateNumberOfChannels;
applyChannelSettings;
executeGrabOneCallback(gh.mainControls.grabOneButton);  % grab the feedback
pause(45)


state.acq.fastScanningX = 0;
state.acq.fastScanningY = 1;
updateGUIByGlobal('state.acq.fastScanningY');
saveCurrentConfig();
applyConfigurationSettings;

range=2;

% state.files.savePath=['C:\Users\install\Desktop'];
state.files.savePath=['E:\RAS3\data\',num2str(date_n),'\feedback'];
state.files.baseName=['x_feedback_positive_',num2str(sortnum),'_'];
% state.files.fullFileName=['C:\Users\install\Desktop\x_feedback_positive_',num2str(sortnum),'_'];
state.files.fullFileName=['E:\RAS3\data\',num2str(date_n),'\feedback\x_feedback_positive_',num2str(sortnum),'_'];

state.files.fileCounter=acqnum;
state.acq.acquiringChannel1=1;
state.acq.acquiringChannel2=0;
state.acq.acquiringChannel3=0;
state.acq.acquiringChannel4=0;
state.acq.numberOfChannelsSave=1;
state.acq.numberOfChannelsImage=1;
state.acq.numberOfChannelsAcquire=1;
state.acq.savingChannel=[1 0 0 0];
state.acq.imagingChannel=[1 0 0 0];
state.acq.inputVoltageRange1=range;  % the range of channel 2
state.acq.inputVoltageInvert1=0;  % 0 is positive and 1 is negative
state.acq.savingChannel1 = 1;
state.acq.imagingChannel1 = 1;
state.acq.acquiringChannel1 = 1;
state.acq.savingChannel2 = 0;
state.acq.imagingChannel2 = 0;
state.acq.acquiringChannel2 = 0;
state.acq.savingChannel3 = 0;
state.acq.imagingChannel3 = 0;
state.acq.acquiringChannel3 = 0;
updateGUIByGlobal('state.acq.savingChannel1');
updateGUIByGlobal('state.acq.imagingChannel1');
updateGUIByGlobal('state.acq.acquiringChannel1');
updateGUIByGlobal('state.acq.savingChannel2');
updateGUIByGlobal('state.acq.imagingChannel2');
updateGUIByGlobal('state.acq.acquiringChannel2');
updateGUIByGlobal('state.acq.savingChannel3');
updateGUIByGlobal('state.acq.imagingChannel3');
updateGUIByGlobal('state.acq.acquiringChannel3');
updateNumberOfChannels;
applyChannelSettings;
executeGrabOneCallback(gh.mainControls.grabOneButton);  % grab the feedback
pause(45)

%%
s = daq.createSession('ni');

% x channel
addAnalogInputChannel(s,'Dev1', 'ai0', 'Voltage');%x position
addAnalogOutputChannel(s,'Dev1', 'ao0', 'Voltage');%output voltage to x axis

% y channel
addAnalogInputChannel(s,'Dev1', 'ai1', 'Voltage');%y position
addAnalogOutputChannel(s,'Dev1', 'ao1', 'Voltage');%output voltage to y axis

% daq parameter
DetectionRange=5;
Daq_Rate=1e4*100;
s.Rate=Daq_Rate;
s.Channels(1).Range=[-DetectionRange,DetectionRange];
s.Channels(3).Range=[-DetectionRange,DetectionRange];
outputSingleScan(s,[-8 -8]);
pause(5e-4);
x_out_feedback=zeros(161,1);
y_out_feedback=zeros(161,1);
n=1;
for i=-8:0.1:8
    outputSingleScan(s,[i,i]);
    pause(2e-4);
    queueOutputData(s,[i*ones(Daq_Rate/100,1) i*ones(Daq_Rate/100,1)]);
    [acquiredData,time] = startForeground(s);
    x_out_feedback(n)=mean(acquiredData(:,1));
    y_out_feedback(n)=mean(acquiredData(:,2));
    n=n+1;
end
out=-8:0.1:8;
x_out_feedback_fit=fit(out.',x_out_feedback,'poly1');
y_out_feedback_fit=fit(out.',y_out_feedback,'poly1');

P1x=x_out_feedback_fit.p1;
P2x=x_out_feedback_fit.p2;
P1y=y_out_feedback_fit.p1;
P2y=y_out_feedback_fit.p2;
release(s);

filepath=['E:\RAS3\data\',num2str(date_n),'\feedback'];
cd(filepath)
warning off

maxpixel=1024;
scanimage_feedback_range=2;
white_feedback=65536;

x_feedback_negative=double(imread(['x_feedback_negative_',num2str(sortnum),'_00',num2str(acqnum),'.tif']));
x_feedback_positive=double(imread(['x_feedback_positive_',num2str(sortnum),'_00',num2str(acqnum),'.tif']));
y_feedback_negative=double(imread(['y_feedback_negative_',num2str(sortnum),'_00',num2str(acqnum),'.tif']));
y_feedback_positive=double(imread(['y_feedback_positive_',num2str(sortnum),'_00',num2str(acqnum),'.tif']));

x_feedback_whole=x_feedback_positive-x_feedback_negative;
y_feedback_whole=y_feedback_positive-y_feedback_negative;


x_feedback_voltage=mean(x_feedback_whole.'*scanimage_feedback_range/white_feedback);
y_feedback_voltage=mean(y_feedback_whole.'*scanimage_feedback_range/white_feedback);

%fitting, x_fit(x) = P1x*x + P2x, y_fit(x) = P1y*x + P2y
fitting_c=100;
fitting=fitting_c:maxpixel-fitting_c;
x_fit=fit(fitting.',x_feedback_voltage(fitting_c:maxpixel-fitting_c).','poly1');
y_fit=fit(fitting.',y_feedback_voltage(fitting_c:maxpixel-fitting_c).','poly1');
P1_f_x=x_fit.p1;
P2_f_x=x_fit.p2;
P1_f_y=y_fit.p1;
P2_f_y=y_fit.p2;

FileTif=['position_sensor_negative_x_',num2str(sortnum),'_00',num2str(acqnum),'.tif'];

InfoImage=imfinfo(FileTif);
mImage=InfoImage(1).Width;
nImage=InfoImage(1).Height;
NumberImages=length(InfoImage);
m_x_n=zeros(nImage,mImage,NumberImages,'uint16');

TifLink = Tiff(FileTif, 'r');
for q=1:NumberImages
    TifLink.setDirectory(q);
    m_x_n(:,:,q)=TifLink.read();
end
TifLink.close();
warning off;

m_x_n=double(m_x_n);

FileTif=['position_sensor_negative_y_',num2str(sortnum),'_00',num2str(acqnum),'.tif'];

InfoImage=imfinfo(FileTif);
mImage=InfoImage(1).Width;
nImage=InfoImage(1).Height;
NumberImages=length(InfoImage);
m_y_n=zeros(nImage,mImage,NumberImages,'uint16');

TifLink = Tiff(FileTif, 'r');
for q=1:NumberImages
    TifLink.setDirectory(q);
    m_y_n(:,:,q)=TifLink.read();
end
TifLink.close();
warning off;

m_y_n=double(m_y_n);

FileTif=['position_sensor_positive_x_',num2str(sortnum),'_00',num2str(acqnum),'.tif'];

InfoImage=imfinfo(FileTif);
mImage=InfoImage(1).Width;
nImage=InfoImage(1).Height;
NumberImages=length(InfoImage);
m_x_p=zeros(nImage,mImage,NumberImages,'uint16');

TifLink = Tiff(FileTif, 'r');
for q=1:NumberImages
    TifLink.setDirectory(q);
    m_x_p(:,:,q)=TifLink.read();
end
TifLink.close();
warning off;

m_x_p=double(m_x_p);

FileTif=['position_sensor_positive_y_',num2str(sortnum),'_00',num2str(acqnum),'.tif'];

InfoImage=imfinfo(FileTif);
mImage=InfoImage(1).Width;
nImage=InfoImage(1).Height;
NumberImages=length(InfoImage);
m_y_p=zeros(nImage,mImage,NumberImages,'uint16');

TifLink = Tiff(FileTif, 'r');
for q=1:NumberImages
    TifLink.setDirectory(q);
    m_y_p(:,:,q)=TifLink.read();
end
TifLink.close();
warning off;

m_y_p=double(m_y_p);
m=zeros(nImage,mImage,2);
m(:,:,1)=m_x_p(:,:,2)./m_x_p(:,:,3)-m_x_n(:,:,2)./m_x_n(:,:,3);
m(:,:,2)=m_y_p(:,:,1)./m_y_p(:,:,3)-m_y_n(:,:,1)./m_y_n(:,:,3);
nx=m(:,:,2);
ny=m(:,:,1);
% nx=nx.';
% ny=fliplr(ny);
ny=ny.';
para_filename=[filepath,'\','parameter_',num2str(sortnum),'_00',num2str(acqnum),'.mat'];
save(para_filename,'P1x','P1y','P2x','P2y','P1_f_x','P1_f_y','P2_f_x','P2_f_y','nx','ny');

clear s Daq_Rate DetectionRange FileTif InfoImage NumberImages P1_f_x P1_f_y P2_f_x P2_f_y P1x P1y P2x P2y TifLink acquiredData fitting fitting_c i m mImage m_x_n m_x_p m_y_n m_y_p maxpixel n nImage nx ny out para_filename q range scanimage_feedback_range time white_feedback x_feedback_negative y_feedback_negative x_feedback_positive y_feedback_positive x_feedback_voltage x_feedback_whole y_feedback_voltage y_feedback_whole x_out_feedback x_out_feedback_fit y_out_feedback y_out_feedback_fit x_fit y_fit


