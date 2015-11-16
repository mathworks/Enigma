classdef enigmaRotorUI < handle
% Handle class for the spinning of Enigma Machine rotors

% part of the Enigma M3 Emulator
% Copyright 2015, The MathWorks Inc.
    
    properties
       
        tag
        
    end
    
    properties (Access = private )
        
        % Graphic handles
        rotorAxes
        rotorImage
        rotorDisplayText
        
        % Other
        curState = 0;
        
    end
    
    methods
        
        function obj = enigmaRotorUI(hAxes,rotorDisplayText)
            % Create enigma rotor wheel
            
            % Extract information
            obj.rotorAxes           = hAxes;
            obj.rotorDisplayText    = rotorDisplayText;
            
            % Read image and update
            img = readNextImageFile(obj);
            obj.rotorImage = image(img,'Parent',obj.rotorAxes);
            
        end
        
        function spinWheel(obj,app,dir)
            % Spin rotor wheel
            
            if dir > 0
                obj.rotorImage.CData = readPreviousImageFile(obj);
            else
                obj.rotorImage.CData = readNextImageFile(obj);
            end
            
            setWheelValueDisplay(obj, app);
        
        end
        
        function setWheelValueDisplay(obj,app)
            % Set rotor value to display
            
            % Extract new wheel character from wheel object
            newValue = getRotorLetter(app.enigmaObj,obj.tag);
            
            obj.rotorDisplayText.String = newValue;
            
        end
        
        function pos = Position (obj)       
            % Get rotor object position
            
            pos = obj.rotorAxes.Position;
        end
    end
    
    methods (Access = private)
        
        function img = readPreviousImageFile(obj)
            % Read previous rotor image file
            
            % Move to next image file
            prev = obj.curState - 1;
            obj.curState = prev;
            % If did full cycle, restart
            prev = mod(prev,5);
            if (prev == 0)
                prev = 5;
            end
            newImageFile = fullfile('@enigmaRotorUI','images',['wheel' num2str(prev) '.png']);

            img = imread(newImageFile);

        end
        
        function img = readNextImageFile(obj)
            % Read next rotor image file
            
            % Move to next image file
            next = obj.curState + 1;
            obj.curState = next;
            % If did full cycle, restart
            next = mod(next,5);
            if (next == 0)
                next = 5;
            end
            newImageFile = fullfile('@enigmaRotorUI','images',['wheel' num2str(next) '.png']);

            img = imread(newImageFile);

        end
        
    end
    
end
