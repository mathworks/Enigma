function createRotorSection(app)
% CREATEROTORSECTION - Create rotor section on application

% part of the Enigma M3 Emulator
% Copyright 2015, The MathWorks Inc

nRotors = 3;

for i = 1:nRotors
    % Create display patch with white background
    haxDispPatch = axes('units','normalized',...
                        'Position',app.rotorDispPatchLoc(i,:),...
                        'Parent',app.figure);
    img = imread('@enigmaRotorUI\images\blankGauge.png');
    image(img,'Parent',haxDispPatch);  
    haxDispPatch.Visible = 'off';


    % Create display patch with text in window
    haxDispWindow = axes('Units','Normalized',...
               'Position',app.rotorDispTextLoc(i,:),...
               'Parent',app.figure);
    haxDispWindow.XTick = [];
    haxDispWindow.YTick = [];
    haxDispWindow.Color = 'None';
    rotorText_i = text(0.5,0.5,'A','Parent',haxDispWindow);
    rotorText_i.FontSize               = 22;
    rotorText_i.FontWeight             = 'bold';
    rotorText_i.HorizontalAlignment    = 'Center';
    rotorText_i.UserData               = 65:90;
    
    % Create scroll wheel
    haxWheel = axes('Parent',app.figure);
    haxWheel.Units = 'normalized';
    haxWheel.Position = app.rotorWheelLoc(i,:);
    haxWheel.Parent = app.figure;
    rotorWheels(i) = enigmaRotorUI(haxWheel,rotorText_i); %#ok<*AGROW>
    haxWheel.Visible = 'off';
    
    % Assign tag
    switch i
        case 1
            rotorWheels(i).tag = 'R';
        case 2
            rotorWheels(i).tag = 'C';
        case 3
            rotorWheels(i).tag = 'L';
    end
end

app.rotorWheels = rotorWheels;


