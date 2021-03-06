function createMachineSection(app)
% CREATEMACHINESECTION - Creates the section of the application that 
% contains the macine. This is the image, rotors, keyboard and lights

% part of the Enigma M3 Emulator
% Copyright 2015, The MathWorks Inc.

% Read in Enigma Machine background
[~,filebase,ext]=fileparts(app.machineImageFile);
[basedir,~,~]=fileparts(mfilename('fullpath'));
enigmaBG.Image          = imread(fullfile(basedir,'images',[filebase,ext]));
enigmaBG.Height         = size(enigmaBG.Image,1);
enigmaBG.Width          = size(enigmaBG.Image,2);
enigmaBG.AspectRatioW2H = enigmaBG.Width/enigmaBG.Height;
app.enigmaImageStruct   = enigmaBG;

createFigure(app);
createMachineBackground(app);
createRotorSection(app);
createKeyboardLightSection(app);
createSettingsIcon(app);