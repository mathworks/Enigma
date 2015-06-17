function createMachineSection(app)
% CREATEMACHINESECTION - Creates the section of the application that 
% contains the macine. This is the image, rotors, keyboard and lights

% part of the Enigma M3 Emulator
% Copyright 2015, The MathWorks Inc.

% Read in Enigma Machine background
enigmaBG.Image          = imread(app.machineImageFile);
enigmaBG.Height         = size(enigmaBG.Image,1);
enigmaBG.Width          = size(enigmaBG.Image,2);
enigmaBG.AspectRatioW2H = enigmaBG.Width/enigmaBG.Height;
app.enigmaImageStruct   = enigmaBG;

createFigure(app);
createMachineBackground(app);
createRotorSection(app);
createKeyboardLightSection(app);
createSettingsIcon(app);