function respondToLightOnEvent(app)
% RESPONDTOLIGHTONEVENT - Respond to events to turn lights on

% part of the Enigma M3 Emulator
% Copyright 2015, The MathWorks Inc

% Get machine logs
inputStr    = app.enigmaObj.InputLog;
outputStr   = app.enigmaObj.OutputLog;

% Trigger lights on
turnSingleKeyOn(app,inputStr(end));
turnSingleLightOn(app,outputStr(end));