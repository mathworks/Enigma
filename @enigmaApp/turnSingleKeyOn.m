function turnSingleKeyOn(app,str)
% TURNSINGLEKEYON - turn single key on

% part of the Enigma M3 Emulator
% Copyright 2015, The MathWorks Inc


% Find corresponding press key
keyPushVals = app.pushKeyLoc(:,1);
keyInd  = strcmp(str,keyPushVals);
keyPushObj = app.pushKeys(keyInd);

% Turn off all current lit keys
set(app.pushKeys,'LineWidth',1);
set(app.pushKeys,'MarkerEdgeColor','k');

% Set key pressed on
keyPushObj.LineWidth = 2;
keyPushObj.MarkerEdgeColor = 'r';

% Set reset callbacks
app.figure.WindowButtonUpFcn   = @(h,e) turnAllLightsKeysOff(app);
app.figure.WindowKeyReleaseFcn = @(h,e) turnAllLightsKeysOff(app);
