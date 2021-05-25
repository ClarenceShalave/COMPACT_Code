range=1;

state.files.savePath=['F:\scanimage_rotation_test'];
state.files.baseName=['test_1_'];
state.files.fullFileName=['F:\scanimage_rotation_test\test_1_'];


state.acq.acquiringChannel1=1;
state.acq.acquiringChannel2=0;
state.acq.acquiringChannel3=0;
state.acq.acquiringChannel4=0;
state.acq.numberOfChannelsSave=1;
state.acq.numberOfChannelsImage=1;
state.acq.numberOfChannelsAcquire=1;
state.acq.savingChannel=[1 0 0 0];
state.acq.imagingChannel=[1 0 0 0];
state.acq.inputVoltageRange1=range;
state.acq.inputVoltageInvert1=0;
state.acq.inputVoltageRange2=range;
state.acq.inputVoltageInvert2=0;
state.acq.inputVoltageRange3=range;
state.acq.inputVoltageInvert3=0;
state.acq.inputVoltageRange4=range;
state.acq.inputVoltageInvert4=0;
state.acq.savingChannel1 = 1;
state.acq.imagingChannel1 = 1;
state.acq.acquiringChannel1 = 1;
state.acq.savingChannel2 = 0;
state.acq.imagingChannel2 = 0;
state.acq.acquiringChannel2 = 0;
state.acq.savingChannel3 = 0;
state.acq.imagingChannel3 = 0;
state.acq.acquiringChannel3 = 0;
state.acq.savingChannel4 = 0;
state.acq.imagingChannel4 = 0;
state.acq.acquiringChannel4 = 0;
updateGUIByGlobal('state.acq.savingChannel1');
updateGUIByGlobal('state.acq.imagingChannel1');
updateGUIByGlobal('state.acq.acquiringChannel1');
updateGUIByGlobal('state.acq.savingChannel2');
updateGUIByGlobal('state.acq.imagingChannel2');
updateGUIByGlobal('state.acq.acquiringChannel2');
updateGUIByGlobal('state.acq.savingChannel3');
updateGUIByGlobal('state.acq.imagingChannel3');
updateGUIByGlobal('state.acq.acquiringChannel3');
updateGUIByGlobal('state.acq.savingChannel4');
updateGUIByGlobal('state.acq.imagingChannel4');
updateGUIByGlobal('state.acq.acquiringChannel4');
updateNumberOfChannels;
applyChannelSettings;
applyConfigurationSettings;
n=1;
for angle=0:30:330
    state.files.fileCounter=n;
    state.acq.scanRotation=angle;
    updateGUIByGlobal('state.acq.scanRotation');
    updateAcquisitionParameters
    setScanProps(gh)
    updateRSPs();
    executeGrabOneCallback(gh.mainControls.grabOneButton);
    n=n+1;
    pause(5);
end
