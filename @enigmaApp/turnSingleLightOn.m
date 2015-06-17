function turnSingleLightOn(app,str)
% TURNSINGLELIGHTON - turn on one light and key

% part of the Enigma M3 Emulator
% Copyright 2015, The MathWorks Inc

% Find corresponding light key
keyVals = app.lightKeyLoc(:,1);
keyInd  = strcmp(str,keyVals);
keyObj  = app.lightKeys(keyInd);

% Turn off all current lit keys
set(app.lightKeys,'Visible','Off');

% Light up current key
keyObj.Visible = 'On';

drawnow;

% Set callback for releasing lights
app.figure.WindowButtonUpFcn   = @(h,e) turnAllLightsKeysOff(app);
app.figure.WindowKeyReleaseFcn = @(h,e) turnAllLightsKeysOff(app);
