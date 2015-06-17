function createNotepadBackground(app)
% CREATENOTEPADBACKGROUND - Create notepad background

% part of the Enigma M3 Emulator
% Copyright 2015, The MathWorks Inc.

% Read in the background Image
notepadBG.Image          = imread(app.notepadImageFile);
notepadBG.Height         = size(notepadBG.Image,1);
notepadBG.Width          = size(notepadBG.Image,2);
notepadBG.AspectRatioW2H = notepadBG.Width/notepadBG.Height;
scaledWidth              = app.enigmaImageStruct.Height*notepadBG.AspectRatioW2H;
notepadBG.XStart         = app.enigmaImageStruct.Width / (app.enigmaImageStruct.Width + scaledWidth);
app.notepadImageStruct   = notepadBG;

% Add figure width for new section
set(app.figure.Children,'Units','Pixels')
scaledDiaryWidth       = app.figure.Position(4)*app.notepadImageStruct.AspectRatioW2H;
app.figure.Position(3) = app.figure.Position(3) + scaledDiaryWidth;

% Create figure background
app.notepadAxes          = axes('Parent',app.figure);
app.notepadAxes.Units    = 'Normalized';
app.notepadAxes.Position = [app.notepadImageStruct.XStart 0 1-app.notepadImageStruct.XStart 1];

img = imread('@enigmaApp\images\notepad3.png');
h = imagesc(rot90(img),'Parent',app.notepadAxes);
% imagesc(app.notepadImageStruct.Image,'Parent',app.notepadAxes);
box(app.notepadAxes,'Off');

app.notepadAxes.XTick    = [];
app.notepadAxes.YTick    = [];

