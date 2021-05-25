if(~exist('Controller'))
	Controller = PI_GCS_Controller();
end;
if(~isa(Controller,'PI_GCS_Controller'))
	Controller = PI_GCS_Controller();
end;
comPort = 4;
% to change the baud rate, need to restart the controller. (power off, on);
if(~Controller.IsConnected)
	Controller = Controller.ConnectRS232(comPort,115200);
	Controller = Controller.InitializeController();
end
% query controller identification
disp(Controller.qIDN());
% query axes
availableaxes = Controller.qSAI_ALL();
if(isempty(availableaxes))
	return;
end
axisname = availableaxes(1);
% connect a stage
disp(Controller.qCST(axisname));
% switch on servo and search reference switch to reference stage
Controller.SVO(axisname,1);
disp( Controller.qSVO(axisname));
Controller.FRF(axisname);
% wait for Referencing to finish
bReferencing=1;
while(bReferencing)
	pause(0.1);
	bReferencing = (Controller.qFRF(axisname)==0);
end

%% move it;
Controller.MOV(axisname,21603);
%21603 is one round;
%% close the stage
%{
Controller.CloseConnection;
% if you want to unload the dll and destroy the class object
Controller.Destroy;
clear Controller;
%}