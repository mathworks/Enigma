function createFigure(app)
% CREATEFIGURE - Create figure for app

% part of the Enigma M3 Emulator
% Copyright 2015, The MathWorks Inc.

imWidth  = app.enigmaImageStruct.Width;
imHeight = app.enigmaImageStruct.Height;

% Create app window
app.figure                  = figure('Visible','Off');
app.figure.ToolBar          = 'None';
app.figure.MenuBar          = 'None';
app.figure.Color            = [1,1,1];
app.figure.Units            = 'Pixels';
app.figure.Position(3:4)    = [imWidth imHeight];
app.figure.Interruptible    = 'off';
app.figure.NumberTitle      = 'off';
app.figure.Resize           = 'off';
app.figure.HandleVisibility	= 'off';
app.figure.Name             = 'Enigma Machine';

% Check if window was resized to be larger than the screen height
screenSize = get(groot,'ScreenSize');
if( app.figure.OuterPosition(4) > screenSize(4) )
    app.figure.OuterPosition(2) = 1;
    app.figure.OuterPosition(4) = screenSize(4);
    app.figure.Position(3) = app.figure.Position(4)*imWidth/imHeight;
    drawnow('limitrate','nocallbacks')
end

setappdata(app.figure,'CurrentHeight',app.figure.Position(4));

movegui(app.figure,'west')

% Add callbacks
app.figure.WindowKeyPressFcn        = @(~,evt) catchTypedKeys(app,evt);
app.figure.WindowScrollWheelFcn     = @(src,evt) catchMouseScroll(app,src,evt);
app.figure.WindowButtonMotionFcn    = @(src,~) catchMouseMotion(app,src);