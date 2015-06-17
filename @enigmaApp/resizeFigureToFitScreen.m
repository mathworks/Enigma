function resizeFigureToFitScreen(app)
% RESIZEFIGURETOFITSCREEN - Adjust size of app figure so it fits in screen

% part of the Enigma M3 Emulator
% Copyright 2015, The MathWorks Inc

% Disable SizeChagnedFcn
app.figure.SizeChangedFcn = [];

set(app.figure.Children,'Units','Normalized');

drawnow;

% Get necessary properties
screenSize      = getScreenSize(app);
screenHeight    = screenSize(1,4);
factor          = 0.9;
maxFigureHeight = screenHeight * factor;
markerSize      = app.keyMarkerSize;
figureHeight    = app.figure.OuterPosition(4);

% Check if window was resized to be larger than the screen height
isTooTall = figureHeight > maxFigureHeight;
if ( isTooTall )
    app.figure.OuterPosition(4) = maxFigureHeight;
    movegui(app.figure,'center');
    drawnow('limitrate','nocallbacks')
end


% TODO: Add code here to check if figure is too wide for the screen


% Copy height here to avoid extra tree traversals
posHeight = app.figure.Position(4);

% Adjust width to ensure aspect ratio is maintained
newEnigmaWidth         = round(posHeight*app.enigmaImageStruct.AspectRatioW2H);
newNotepadWidth        = round(posHeight*app.notepadImageStruct.AspectRatioW2H);
app.figure.Position(3) = newEnigmaWidth + newNotepadWidth;

% Adjust key marker sizes
newMarkerSize = round(markerSize*posHeight/app.enigmaImageStruct.Width);
for i = 1:numel(app.pushKeys)
     app.pushKeys(i).MarkerSize = newMarkerSize;
    app.lightKeys(i).MarkerSize = newMarkerSize;
end

% Adjust notepade text sizes
oldHeight = getappdata(app.figure,'CurrentHeight');
scaleChange = app.figure.Position(4) / oldHeight;
app.inputText.FontSize   = app.inputText.FontSize   * scaleChange;
app.outputText.FontSize  = app.outputText.FontSize  * scaleChange;
app.outputLabel.FontSize = app.outputLabel.FontSize * scaleChange;
app.inputLabel.FontSize  = app.inputLabel.FontSize  * scaleChange;

% Set current height
setappdata(app.figure,'CurrentHeight',app.figure.Position(4));

% Enable SizeChagnedFcn
app.figure.SizeChangedFcn = @(~,~) resizeFigureToFitScreen(app);

