function preferences(eApp)
% PREFERENCES UI to configure Enigma Machine preferences.

% part of the Enigma M3 Emulator
% Copyright 2015, The MathWorks Inc.


% Configure available menu choices
availRotorValues = {'Rotor I'   ;
    'Rotor II'  ;
    'Rotor III' ;
    'Rotor IV'  ;
    'Rotor V'   ;
    'Rotor VI'  ;
    'Rotor VII' ;
    'Rotor VIII'};

availReflectorValues = {'Reflector B';
    'Reflector C'};

availRingValues = cellstr(num2str((1:26)'));

% Heights for the various UI elements
labelY       = 0.92;
leftRotorY   = 0.85;
centerRotorY = 0.73;
rightRotorY  = 0.61;
reflectorY   = 0.49;
plugY        = 0.25;
buttonY      = 0.05;
buttonHeight = 0.10;


% Add enigmaApp structure to app
app.eApp = eApp;

% Create figure
app.figure                  = figure('Visible','Off');
app.figure.Name             = 'Enigma Machine Preferences';
app.figure.ToolBar          = 'None';
app.figure.MenuBar          = 'None';
app.figure.Color            = [1,1,1];
app.figure.Units            = 'Pixels';
app.figure.Position(3:4)    = [500 450];
app.figure.Interruptible    = 'Off';
app.figure.NumberTitle      = 'Off';
app.figure.Resize           = 'Off';
app.figure.CloseRequestFcn  = @cancelFunction;
app.figure.WindowStyle      = 'Modal';
movegui(app.figure,'center');

% Create background axes
app.axes          = axes('Parent',app.figure);
app.axes.Units    = 'Normalized';
app.axes.XLim     = [0,1];
app.axes.YLim     = [0,1];
app.axes.Position = [0,0,1,1];
im = imread(fullfile('@enigmaApp','images','blackBackground.png'));
imagesc(im,'Parent',app.axes);
box(app.axes,'Off');
app.axes.XTick    = [];
app.axes.YTick    = [];
app.axes.Units    = 'Normalized';
app.axes.YDir     = 'Normal';

% Create rotor selection label
app.rotorLabel                     = text(0,0,'Type');
app.rotorLabel.Parent              = app.axes;
app.rotorLabel.Units               = 'Normalized';
app.rotorLabel.Position            = [0.5,labelY];
app.rotorLabel.HorizontalAlignment = 'Center';
app.rotorLabel.VerticalAlignment   = 'Middle';
app.rotorLabel.FontSize            = 12;
app.rotorLabel.FontWeight          = 'Bold';
app.rotorLabel.Color               = [1,1,1];

% Create ring position selection label
app.ringPositionLabel                     = text(0,0,'Ring Offset');
app.ringPositionLabel.Parent              = app.axes;
app.ringPositionLabel.Units               = 'Normalized';
app.ringPositionLabel.Position            = [0.825,labelY];
app.ringPositionLabel.HorizontalAlignment = 'Center';
app.ringPositionLabel.VerticalAlignment   = 'Middle';
app.ringPositionLabel.FontSize            = 12;
app.ringPositionLabel.FontWeight          = 'Bold';
app.ringPositionLabel.Color               = [1,1,1];

% Create left rotor elements
app.leftRotorLabel                     = text(0,0,'Left Rotor:');
app.leftRotorLabel.Parent              = app.axes;
app.leftRotorLabel.Units               = 'Normalized';
app.leftRotorLabel.Position            = [0.05,leftRotorY];
app.leftRotorLabel.HorizontalAlignment = 'Left';
app.leftRotorLabel.VerticalAlignment   = 'Top';
app.leftRotorLabel.FontSize            = 12;
app.leftRotorLabel.FontWeight          = 'Bold';
app.leftRotorLabel.Color               = [1,1,1];

app.leftRotorMenu          = uicontrol('Style','Popupmenu');
app.leftRotorMenu.Parent   = app.figure;
app.leftRotorMenu.String   = availRotorValues;
app.leftRotorMenu.Units    = 'Normalized';
app.leftRotorMenu.Position = [0.35,leftRotorY,0.3,0.0];
app.leftRotorMenu.FontSize = 12;
app.leftRotorMenu.Value    = 3;
app.leftRotorMenu.Callback = @setRotorValueCallback;

app.leftRingMenu          = uicontrol('Style','Popupmenu');
app.leftRingMenu.Parent   = app.figure;
app.leftRingMenu.String   = availRingValues;
app.leftRingMenu.Units    = 'Normalized';
app.leftRingMenu.Position = [0.775,leftRotorY,0.1,0.0];
app.leftRingMenu.HorizontalAlignment = 'Center';
app.leftRingMenu.FontSize = 12;
app.leftRingMenu.Value    = 1;

% Create center rotor elements
app.centerRotorLabel                     = text(0,0,'Center Rotor:');
app.centerRotorLabel.Parent              = app.axes;
app.centerRotorLabel.Units               = 'Normalized';
app.centerRotorLabel.Position            = [0.05,centerRotorY];
app.centerRotorLabel.HorizontalAlignment = 'Left';
app.centerRotorLabel.VerticalAlignment   = 'Top';
app.centerRotorLabel.FontSize            = 12;
app.centerRotorLabel.FontWeight          = 'Bold';
app.centerRotorLabel.Color               = [1,1,1];

app.centerRotorMenu          = uicontrol('Style','Popupmenu');
app.centerRotorMenu.Parent   = app.figure;
app.centerRotorMenu.String   = availRotorValues;
app.centerRotorMenu.Units    = 'Normalized';
app.centerRotorMenu.Position = [0.35,centerRotorY,0.3,0.0];
app.centerRotorMenu.FontSize = 12;
app.centerRotorMenu.Value    = 2;
app.centerRotorMenu.Callback = @setRotorValueCallback;

app.centerRingMenu          = uicontrol('Style','Popupmenu');
app.centerRingMenu.Parent   = app.figure;
app.centerRingMenu.String   = availRingValues;
app.centerRingMenu.Units    = 'Normalized';
app.centerRingMenu.Position = [0.775,centerRotorY,0.1,0.0];
app.centerRingMenu.HorizontalAlignment = 'Center';
app.centerRingMenu.FontSize = 12;
app.centerRingMenu.Value    = 5;

% Create right rotor elements
app.rightRotorLabel                     = text(0,0,'Right Rotor:');
app.rightRotorLabel.Parent              = app.axes;
app.rightRotorLabel.Units               = 'Normalized';
app.rightRotorLabel.Position            = [0.05,rightRotorY];
app.rightRotorLabel.HorizontalAlignment = 'Left';
app.rightRotorLabel.VerticalAlignment   = 'Top';
app.rightRotorLabel.FontSize            = 12;
app.rightRotorLabel.FontWeight          = 'Bold';
app.rightRotorLabel.Color               = [1,1,1];

app.rightRotorMenu          = uicontrol('Style','Popupmenu');
app.rightRotorMenu.Parent   = app.figure;
app.rightRotorMenu.String   = availRotorValues;
app.rightRotorMenu.Units    = 'Normalized';
app.rightRotorMenu.Position = [0.35,rightRotorY,0.3,0.0];
app.rightRotorMenu.FontSize = 12;
app.rightRotorMenu.Value    = 1;
app.rightRotorMenu.Callback = @setRotorValueCallback;

app.rightRingMenu          = uicontrol('Style','Popupmenu');
app.rightRingMenu.Parent   = app.figure;
app.rightRingMenu.String   = availRingValues;
app.rightRingMenu.Units    = 'Normalized';
app.rightRingMenu.Position = [0.775,rightRotorY,0.1,0.0];
app.rightRingMenu.HorizontalAlignment = 'Center';
app.rightRingMenu.FontSize = 12;
app.rightRingMenu.Value    = 11;

% Create reflector elements
app.reflectorLabel                     = text(0,0,'Reflector:');
app.reflectorLabel.Parent              = app.axes;
app.reflectorLabel.Units               = 'Normalized';
app.reflectorLabel.Position            = [0.05,reflectorY];
app.reflectorLabel.HorizontalAlignment = 'Left';
app.reflectorLabel.VerticalAlignment   = 'Top';
app.reflectorLabel.FontSize            = 12;
app.reflectorLabel.FontWeight          = 'Bold';
app.reflectorLabel.Color               = [1,1,1];

app.reflectorMenu          = uicontrol('Style','Popupmenu');
app.reflectorMenu.Parent   = app.figure;
app.reflectorMenu.String   = availReflectorValues;
app.reflectorMenu.Units    = 'Normalized';
app.reflectorMenu.Position = [0.35,reflectorY,0.3,0.0];
app.reflectorMenu.FontSize = 12;
app.reflectorMenu.Value    = 1;

% Create plug board button
app.plugButton          = uicontrol('Style','Pushbutton');
app.plugButton.Parent   = app.figure;
app.plugButton.String   = 'Edit Plugboard Configuration';
app.plugButton.Units    = 'Normalized';
app.plugButton.FontSize = 12;
app.plugButton.Position = [0.10,plugY,0.80,buttonHeight];
app.plugButton.Callback = {@editPlugboardConfiguration,eApp};

% Create Ok button
app.okButton          = uicontrol('Style','Pushbutton');
app.okButton.Parent   = app.figure;
app.okButton.String   = 'Ok';
app.okButton.Units    = 'Normalized';
app.okButton.FontSize = 12;
app.okButton.Position = [0.10,buttonY,0.35,buttonHeight];
app.okButton.Callback = @okFunction;

% Create Cancel button
app.cancelButton          = uicontrol('Style','Pushbutton');
app.cancelButton.Parent   = app.figure;
app.cancelButton.String   = 'Cancel';
app.cancelButton.Units    = 'Normalized';
app.cancelButton.FontSize = 12;
app.cancelButton.Position = [0.55,buttonY,0.35,buttonHeight];
app.cancelButton.Callback = @cancelFunction;


% Read current values and set each menu appropriately
app.leftRotorMenu.Value   = getRotorIndexNum(app.eApp.enigmaObj.Rotors{1});
app.centerRotorMenu.Value = getRotorIndexNum(app.eApp.enigmaObj.Rotors{2});
app.rightRotorMenu.Value  = getRotorIndexNum(app.eApp.enigmaObj.Rotors{3});
app.leftRingMenu.Value    = app.eApp.enigmaObj.RingSettings(1);
app.centerRingMenu.Value  = app.eApp.enigmaObj.RingSettings(2);
app.rightRingMenu.Value   = app.eApp.enigmaObj.RingSettings(3);
app.reflectorMenu.Value   = getLetterNum(app.eApp.enigmaObj.Reflector)-1;

% Save app structure to guidata
guidata(app.figure,app);

% Make UI visible
app.figure.HandleVisibility	= 'Off';
app.figure.Visible = 'On';

end

function cancelFunction(hObject,~)

% Close the figure
figHandle = ancestor(hObject,'Figure');
delete(figHandle)

end

function okFunction(hObject,~)

% Get app structure
app = guidata(hObject);

% Get configuration defaults built into Enigma
rotors     = {enigmaRotors.I
    enigmaRotors.II
    enigmaRotors.III
    enigmaRotors.IV
    enigmaRotors.V
    enigmaRotors.VI
    enigmaRotors.VII
    enigmaRotors.VIII};
reflectors = {enigmaReflectors.B,enigmaReflectors.C};

% Set rotor and reflector types
swapRotor(app.eApp.enigmaObj,'L',rotors{app.leftRotorMenu.Value});
swapRotor(app.eApp.enigmaObj,'C',rotors{app.centerRotorMenu.Value});
swapRotor(app.eApp.enigmaObj,'R',rotors{app.rightRotorMenu.Value});
swapReflector(app.eApp.enigmaObj,reflectors{app.reflectorMenu.Value});

% Set rotor ring offsets
app.eApp.enigmaObj.RingSettings = [app.leftRingMenu.Value,app.centerRingMenu.Value,app.rightRingMenu.Value];

% Close the figure
figHandle = ancestor(hObject,'Figure');
delete(figHandle)

end

function num = getRotorIndexNum(romanNumStr)

num = [];
switch romanNumStr
    case 'I'
        num = 1;
    case 'II'
        num = 2;
    case 'III'
        num = 3;
    case 'IV'
        num = 4;
    case 'V'
        num = 5;
    case 'VI'
        num = 6;
    case 'VII'
        num = 7;
    case 'VIII'
        num = 8;
end

end

function ind = getLetterNum(letter)

ind = double(letter-'A') + 1;

if( ind < 1 || ind > 26 )
    ind = [];
end

end

function setRotorValueCallback(hObject,~)

% Get app structure
app = guidata(hObject);

% Construct list of all rotor menus
rotorMenuList = [app.leftRotorMenu  ;
    app.centerRotorMenu;
    app.rightRotorMenu ];

% Get a list of all other rotors
otherRotors = rotorMenuList(hObject ~= rotorMenuList);
otherRotorValues = [otherRotors(:).Value];

% Check if any other rotors have the same value as the rotor being set
duplicateRotor = otherRotors(otherRotorValues == hObject.Value);

% Swap the duplicate rotor value with this one
if( ~isempty(duplicateRotor) )
    duplicateRotor.Value = availRotorValues(1);
end

end

function editPlugboardConfiguration(~,~,e)

% Open plugboard configuration UI
plugBoardTable(getPlugBoard(e.enigmaObj));

end
