function createSettingsIcon(app)
% CREATESETTINGSICON - Creates axes and adds gear image

% part of the Enigma M3 Emulator
% Copyright 2015, The MathWorks Inc

% Read in gear image
settingsImage           = fullfile('@enigmaApp','images','Gear.png');
[imageData,~,alphaData] = imread(settingsImage);
imSize                  = size(imageData);
normalizedHeight        = 0.1;
normalizedWidth         = normalizedHeight*imSize(2)/imSize(1);

% Create figure background
app.settingsAxes          = axes('Parent',app.figure);
app.settingsAxes.Units    = 'Pixels';
app.settingsAxes.Position = [0,0,size(imageData,2),size(imageData,1)];
app.settingsAxes.Units    = 'Normalized';
app.settingsAxes.Position = [0.875,0.875,normalizedWidth,normalizedHeight];

% Display gear in axes and set transparency
imHandle           = imshow(imageData,'Parent',app.settingsAxes);
imHandle.AlphaData = alphaData;

% Remove unnecessary axes options
box(app.settingsAxes,'Off');
app.settingsAxes.XTick = [];
app.settingsAxes.YTick = [];

% Add callback to launch configuration UI
imHandle.ButtonDownFcn = @(obj,eventdata) preferences(app);

