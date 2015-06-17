function catchMouseMotion(app,src)
% CATCHMOUSEMOTION - Catch motion of mouse to determine mouse icon

% part of the Enigma M3 Emulator
% Copyright 2015, The MathWorks Inc.

% Determine location of mouse
src.Units = 'Normalized';
curPoint = src.CurrentPoint;
src.Units = 'Pixels';


% If over any wheel, change to scroll icon
for iWheel = app.rotorWheels
    posWheel1 = iWheel.Position;

    insideX = curPoint(1) >= posWheel1(1) && curPoint(1) <= posWheel1(1)+posWheel1(3);
    insideY = curPoint(2) >= posWheel1(2) && curPoint(2) <= posWheel1(2)+posWheel1(4);
    insideBoth = insideX && insideY;

    if (insideBoth)
        setMouseIconScroll(app);
        app.figure.WindowButtonDownFcn = @(s,e)setCallbackToDragMode(app,s);
        return;
    end
end

% If over any key, change to click icon
curPointAxes = app.keyboardAxes.CurrentPoint(1,1:2);
thresh = 0.02*0.9;

for iKey = app.pushKeys
    posKey1 = [iKey.XData iKey.YData];
    
    insideX = curPointAxes(1) >= posKey1(1)-thresh && curPointAxes(1) <= posKey1(1)+thresh;
    insideY = curPointAxes(2) >= posKey1(2)-thresh && curPointAxes(2) <= posKey1(2)+thresh;
    insideBoth = insideX && insideY;

    if (insideBoth)
        setMouseIconClick(app);
        app.figure.WindowButtonDownFcn = @(s,e)resetCallbackToHoverMode(app);
        return;
    end
end

% If over the settings gear, change to click icon
curPointSettingsAxes = app.settingsAxes.CurrentPoint(1,1:2);
thresh = 0.02*0.9;

axLim = axis(app.settingsAxes);

insideX = curPointSettingsAxes(1) >= axLim(1)-thresh && curPointSettingsAxes(1) <= axLim(2)+thresh;
insideY = curPointSettingsAxes(2) >= axLim(3)-thresh && curPointSettingsAxes(2) <= axLim(4)+thresh;
insideBoth = insideX && insideY;

if (insideBoth)
    setMouseIconClick(app);
    return;
end


% Otherwise, reset to arrow icon
resetMouseIcon(app);
app.figure.WindowButtonDownFcn = @(s,e)resetCallbackToHoverMode(app);

function setMouseIconScroll(app)

app.figure.Pointer = 'custom';
app.figure.PointerShapeCData = app.scrollIconData;
app.figure.PointerShapeHotSpot = [8 8];

function setMouseIconClick(app)

app.figure.Pointer = 'hand';
app.figure.PointerShapeHotSpot = [1 1];

function resetMouseIcon(app)

app.figure.Pointer = 'arrow';
app.figure.PointerShapeHotSpot = [1 1];

function setCallbackToDragMode(app,s)

% Extract current position
originalPos = s.CurrentPoint;

% Set unclick to not drag
app.figure.WindowButtonUpFcn = @(s,e)resetCallbackToHoverMode(app);

% Set motion to catch drag
app.figure.WindowButtonMotionFcn = @(s,e)catchDrag(app,originalPos,s);


function resetCallbackToHoverMode(app)

% Set motion to catch mouse motion
app.figure.WindowButtonMotionFcn = @(s,e)catchMouseMotion(app,s);


