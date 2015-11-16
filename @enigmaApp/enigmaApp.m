classdef enigmaApp < handle
    % Main handle class for the Enigma user interface
    
    % part of the Enigma M3 Emulator
    % Copyright 2015, The MathWorks Inc.

    
    properties (Access = private, Constant = true)
        
        % Keyboard markers
        keyMarkerSize   = 26
        % Notepad section properties
        lineLim         = 13; 
        numLinesLim     = 12;
        
        % Image files
        machineImageFile = fullfile('@enigmaApp','images','enigma_Fixed_Perspective_Removed_Rotors_Shrunk.png');
        notepadImageFile = fullfile('@enigmaApp','images','diaryBackgroundCreated2.png');
        
        % Location of keyboard keys
        pushKeyLoc = {'A',0.169,0.218;
                      'B',0.582,0.149;
                      'C',0.394,0.148;
                      'D',0.359,0.215;
                      'E',0.325,0.286;
                      'F',0.457,0.215;
                      'G',0.555,0.217;
                      'H',0.650,0.216;
                      'I',0.815,0.288;
                      'J',0.744,0.218;
                      'K',0.839,0.219;
                      'L',0.862,0.153;
                      'M',0.770,0.152;
                      'N',0.677,0.149;
                      'O',0.909,0.290;
                      'P',0.113,0.151;
                      'Q',0.130,0.288;
                      'R',0.422,0.286;
                      'S',0.265,0.216;
                      'T',0.520,0.287;
                      'U',0.720,0.286;
                      'V',0.488,0.148;
                      'W',0.227,0.287;
                      'X',0.298,0.150;
                      'Y',0.205,0.150;
                      'Z',0.621,0.286};
        % Location of lights
        lightKeyLoc = {'A',0.165,0.4675;
                       'B',0.583,0.3890;
                       'C',0.388,0.3910;
                       'D',0.355,0.4655;
                       'E',0.323,0.5400;
                       'F',0.453,0.4650;
                       'G',0.551,0.4645;
                       'H',0.647,0.4645;
                       'I',0.808,0.5390;
                       'J',0.744,0.4645;
                       'K',0.839,0.4645;
                       'L',0.870,0.3910;
                       'M',0.775,0.3905;
                       'N',0.679,0.3900;
                       'O',0.902,0.5390;
                       'P',0.100,0.3920;
                       'Q',0.133,0.5400;
                       'R',0.420,0.5395;
                       'S',0.259,0.4660;
                       'T',0.517,0.5395;
                       'U',0.712,0.5400;
                       'V',0.485,0.3900;
                       'W',0.228,0.5400;
                       'X',0.292,0.3910;
                       'Y',0.196,0.3910;
                       'Z',0.615,0.5400};
        % Icon for scrolling
        scrollIconData = [NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN;
                          NaN   NaN   NaN   NaN   NaN     1     1     1     1     1     1   NaN   NaN   NaN   NaN   NaN;
                          NaN   NaN   NaN   NaN     1     1     2     2     1     2     2     1   NaN   NaN   NaN   NaN;
                          NaN   NaN   NaN     1     2     2     2     1     1     1     2     2     1   NaN   NaN   NaN;
                          NaN   NaN     1     1     2     2     1     1     1     1     1     2     2     1   NaN   NaN;
                          NaN   NaN     1     2     2     2     2     2     2     2     2     2     2     1     1   NaN;
                          NaN   NaN     1     2     2     2     2     2     2     2     2     2     2     2     1   NaN;
                          NaN   NaN     1     2     2     2     2     1     1     1     2     2     2     2     1   NaN;
                          NaN   NaN     1     2     2     2     2     1     1     1     2     2     2     2     1   NaN;
                          NaN   NaN     1     2     2     2     2     1     1     1     2     2     2     2     1   NaN;
                          NaN   NaN     1     2     2     2     2     2     2     2     2     2     2     2     1   NaN;
                          NaN   NaN     1     2     2     2     2     2     2     2     1     2     2     1   NaN   NaN;
                          NaN   NaN   NaN     1     2     2     1     1     1     1     1     2     1     1   NaN   NaN;
                          NaN   NaN   NaN   NaN     1     2     2     1     1     2     2     2     1   NaN   NaN   NaN;
                          NaN   NaN   NaN   NaN     1     1     1     1     1     1     1     1   NaN   NaN   NaN   NaN;
                          NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN];
        % Location of rotor backgrounds
        rotorDispPatchLoc = [0.445 0.7 0.08 0.08;
                             0.270 0.7 0.08 0.08;
                             0.095 0.7 0.08 0.08;
                             0.000 0.7 0.08 0.08];
        % Location of rotor window displays
        rotorDispTextLoc = [0.450 0.71 0.07 0.07;
                            0.275 0.71 0.07 0.07;
                            0.100 0.71 0.07 0.07;
                            0.000 0.71 0.07 0.07];
        % Location of rotor weheels
        rotorWheelLoc = [0.530 0.6 0.05 0.3;
                         0.355 0.6 0.05 0.3;
                         0.180 0.6 0.05 0.3;
                         0.000 0.6 0.05 0.3];

    end
    
    properties (SetAccess = private)
        % Enigma object
        enigmaObj
    end
    
    properties (Access = private)
        
        % Enigma image structure
        enigmaImageStruct
        notepadImageStruct
        
        % Message display properties
        lineBreakLoc = 0;
        lineSpaceLoc = 0;
        
    end
    
    properties (Access = private)
        
        % Graphic handles
        figure
        machineAxes
        notepadAxes
        keyboardAxes
        settingsAxes
        inputText
        inputLabel
        outputText
        outputLabel
        divider
        pushKeys = gobjects(1,26);
        lightKeys = gobjects(1,26);
        
        % Rotors
        rotorWheels
        
    end
    
    methods
        
        function app = enigmaApp(enigmaCmd)
            % Creates an enigma UI app with a given enigma object
            
            % 14b check
            assert(~verLessThan('matlab','8.4'),'R2014b or newer is required for this app')  
            
            if nargin <= 0
                app.enigmaObj = enigma();
                restart(app.enigmaObj);
            else
                app.enigmaObj = enigmaCmd;
            end
            
            createMachineSection(app);
            
            createNotepadSection(app);
            
            resizeFigureToFitScreen(app)
            
            addEventListeners(app);
            
            app.figure.Visible = 'On';
            
        end
            
    end
    
    methods (Access = private)
        
        % Adds event listeners to figure app
        addEventListener(app)
        
        % Catch dragging callback when dragging rotor wheel
        catchDrag(app,origPos,src)
        
        % Catch click callback when clicking on keys of app
        catchMouseClickOnKeys(app,src)
        
        % Catch mouse motion callback when hovering over app
        catchMouseMotion(app,src)
        
        % Catch mouse scroll callback when scrolling rotors
        catchMouseScroll(app,src,evt)
        
        % Catch typed key callback
        catchTypedKeys(app,evt)
        
        % Create app figure
        createFigure(app)
       
        % Create input/output display sections in notepad
        createInputOutputMessageSection(app)
        
        % Create keyboard and lights section
        createKeyboardLightSection(app)
        
        % Create machine background 
        createMachineBackground(app)
        
        % Create machine section
        createMachineSection(app)
        
        % Create notepad background
        createNotepadBackground(app)
        
        % Create notepad section
        createNotepadSection(app)
        
        % Create rotor section
        createRotorSection(app)
        
        % Create settings icon
        createSettingsIcon(app)
        
        % Evaluate actions based on entered characters
        evaluateEnteredChar(app,str)
        
        % Resize figure to fit screen height
        resizeFigureToFitScreen(app)
        
        % Respond to events to turn lights on
        respondToLightOnEvent(app)
        
        % Respond to event to display processed message
        respondToProcessedMessageEvent(app)
        
        % Respond to event to reset application
        respondToResetEvent(app)
        
        % Set all lights and key edges off
        turnAllLightsKeysOff(app)

        % Turn on single key
        turnSingleKeyOn(app,str)
        
        % Turn on single light
        turnSingleLightOn(app,str)

    end
    
end

