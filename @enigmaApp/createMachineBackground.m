function createMachineBackground(app)
% CREATEMACHINEBACKGROUND - Creates axes and adds machine image

% part of the Enigma M3 Emulator
% Copyright 2015, The MathWorks Inc.

% Create figure background
app.machineAxes          = axes('Parent',app.figure);
app.machineAxes.Units    = 'Normalized';
app.machineAxes.Position = [0,0,1,1];

imagesc(app.enigmaImageStruct.Image,'Parent',app.machineAxes);
box(app.machineAxes,'Off');

app.machineAxes.XTick    = [];
app.machineAxes.YTick    = [];