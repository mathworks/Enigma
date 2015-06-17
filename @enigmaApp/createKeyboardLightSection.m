function createKeyboardLightSection(app)
% CREATEKEYBOARDLIGHTSECTION - Create keyboard and lights section

% part of the Enigma M3 Emulator
% Copyright 2015, The MathWorks Inc.

%% Add axes for clickable objects
app.keyboardAxes = axes('Parent',app.figure);
app.keyboardAxes.Units = 'Normalized';
app.keyboardAxes.Position = [0,0,1,1];
app.keyboardAxes.Color = 'None';
app.keyboardAxes.XLim  = [0,1];
app.keyboardAxes.YLim  = [0,1];
box(app.keyboardAxes,'Off');
app.keyboardAxes.XTick = [];
app.keyboardAxes.YTick = [];

hold(app.keyboardAxes,'on');

%% Create lights
set(app.keyboardAxes,'DefaultLineMarkerSize',25)
set(app.keyboardAxes,'DefaultLineMarkerEdgeColor','y')
set(app.keyboardAxes,'DefaultLineLineWidth',2)
set(app.keyboardAxes,'DefaultLineVisible','Off')
set(app.keyboardAxes,'DefaultLineButtonDownFcn','');

for i = 1:size(app.lightKeyLoc,1)
    app.lightKeys(i) = line(app.lightKeyLoc{i,2},app.lightKeyLoc{i,3},...
                            'Parent',app.keyboardAxes,'Marker','o');
    setappdata(app.lightKeys(i),'index',i);
    
end

%% Create keys
set(app.keyboardAxes,'DefaultLineMarkerSize',25)
set(app.keyboardAxes,'DefaultLineMarkerEdgeColor','k')
set(app.keyboardAxes,'DefaultLineLineWidth',1)
set(app.keyboardAxes,'DefaultLineVisible','On')
set(app.keyboardAxes,'DefaultLineButtonDownFcn',@(h,e) catchMouseClickOnKeys(app,h));
    
for i = 1:size(app.pushKeyLoc,1)
    app.pushKeys(i) = line(app.pushKeyLoc{i,2},app.pushKeyLoc{i,3},...
                           'Parent',app.keyboardAxes,'Marker','o');
    setappdata(app.pushKeys(i),'lightObj',app.lightKeys(i));
    setappdata(app.pushKeys(i),'char',app.pushKeyLoc{i,1});
end


hold(app.keyboardAxes,'off');
