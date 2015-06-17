classdef enigma < handle & matlab.mixin.CustomDisplay
    % Main handle class for the Enigma Machine
    
    % part of the Enigma M3 Emulator
    % Copyright 2015, The MathWorks Inc.

    %%
 
    properties (Dependent = true)
        % Configuration state of the Enigma Machine

        % Rotor Identifiers: three-element cell array with identifier of each rotor
        % values = {Label for Left Rotor, Center Rotor, Right Rotor}, must get/set all three together
        Rotors

        % Rotor ring settings: 1x3 vector with the ring setting of each rotor
        % values = [Setting for Left Rotor, Center Rotor, Right Rotor], must get/set all three together
        RingSettings

        % Rotor index: 1x3 vector of the index (visible letter) of each rotor
        % values = [Letter for Left Rotor, Center Rotor, Right Rotor], must get/set all three together
        RotorSettings   
                
        % Reflector Identifier (i.e. enumeration of the reflector)
        Reflector
        
        % Plugboard connections - 2xN char array, each column representing a connection
        WiredConnections
        
    end
    
    properties
        OutputLog = '';    % running log of characters to be output from run method
        InputLog = '';     % running log of characters input to run method
    end
    
    properties (Hidden = true, Access = private)
        % rotors
        rotorR
        rotorC
        rotorL
        % reflector
        reflector
        % plugs
        plugs
    end

    properties (Constant = true, Hidden = true)
        Alphabet = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ';
    end
    
    %%
    events (Hidden = true)
        % Used by enigmaApp to monitor what is happening to the object
        RotorRUp                % index of rotor R has incremented +1
        RotorRDown              % index of rotor R has incremented -1
        RotorCUp                % index of rotor C has incremented +1
        RotorCDown              % index of rotor C has incremented -1
        RotorLUp                % index of rotor L has incremented +1
        RotorLDown              % index of rotor L has incremented -1
        RotorPositionUpdated    % multiple rotor indicies have been changed at the same time
        LogUpdated              % the input and output logs have been updated
        LampLighted             % an output lamp on the machine should be lit
    end
    
    %%
    methods
        %% 
        function msgOut = run(obj,msgIn)
            % msgOut = RUN(msgIn) Main interface to the Enigma Machine.
            %   MSGIN       input string
            %   MSGOUT      output string 
            
            p = inputParser;
            addRequired(p,'msgIn',@(c) ischar(c));
            parse(p,msgIn);
            
            obj.InputLog = [obj.InputLog msgIn];
            
            for k = 1:length(msgIn)
                % Check for turnover events. This code checks the rotors in the mechanically reverse order,  
                % but evaluates logically to the correct behavior:
                %       Step    L   C   R
                %         1     A   D   Q 
                %         2     A   E   R   <--- R notch at Q
                %         3     B   F   R   <--- C notch at E. The D>E>F behavior is "double-stepping"
                
                if ~isempty(strfind(obj.rotorC.Notches, obj.getRotorLetter('C')))
                    % turnover C
                    advanceRotor(obj,'C');   % double-stepping behavior
                    advanceRotor(obj,'L');
                end
                if ~isempty(strfind(obj.rotorR.Notches, obj.getRotorLetter('R')))
                    % turnover R
                    advanceRotor(obj,'C');
                end 
                advanceRotor(obj,'R');   % R spins every keypress
                             
                % Create transformation matrices
                pb      = double(obj.plugs.Connections);
                rR      = rotorTransform(obj,obj.rotorR);
                rC      = rotorTransform(obj,obj.rotorC);
                rL      = rotorTransform(obj,obj.rotorL);
                rRef    = rotorTransform(obj,obj.reflector);

                % Perform encryption/decription
                charArrayIn     = ismember(obj.Alphabet,upper(msgIn(k)))';
                pBAndRotors     = rL*rC*rR*pb;
                charArrayOut    = pBAndRotors\rRef*pBAndRotors*charArrayIn;

                % Get output character from array
                msgOut(k)    = obj.Alphabet(logical(charArrayOut)); %#ok<AGROW>
                
                % Update output log and trigger App updates
                obj.OutputLog = [obj.OutputLog msgOut(k)];
                notify(obj,'LogUpdated');
                notify(obj,'LampLighted');
            end   
        end

        function reset(obj)
            % RESET clears the charLog, and spins the CURRENT rotors to their saved positions
            
            obj.rotorR.Index = loadPosition(obj.rotorR); 
            obj.rotorC.Index = loadPosition(obj.rotorC);
            obj.rotorL.Index = loadPosition(obj.rotorL);
            notify(obj,'RotorPositionUpdated');
            clearLog(obj);
        end
        
        function restart(obj)
            % RESTART returns all properties to their default values (I,II,III @ A,A,A; no plugs, empty log)
            
            swapRotor(obj,'R',enigmaRotors.III);
            swapRotor(obj,'C',enigmaRotors.II);
            swapRotor(obj,'L',enigmaRotors.I);
            swapReflector(obj,enigmaReflectors.B);
            obj.rotorR.Index = 1; 
            obj.rotorC.Index = 1;
            obj.rotorL.Index = 1;
            savePosition(obj.rotorR);
            savePosition(obj.rotorC);
            savePosition(obj.rotorL);
            reset(obj.plugs);
            notify(obj,'RotorPositionUpdated');
            clearLog(obj);
        end
        
        function clearLog(obj)
            % CLEARLOG empties the two logs, but leaves all other properties alone
            
            obj.InputLog = '';        
            obj.OutputLog = '';
            notify(obj,'LogUpdated');
        end

        %% constructor
        function obj = enigma()
            % ENIGMA constructor
            
            % rotors
            obj.rotorR = enigmaRotors.III;
            obj.rotorC = enigmaRotors.II;
            obj.rotorL = enigmaRotors.I;
            % reflector
            obj.reflector = enigmaReflectors.B;
            % plugs
            obj.plugs = plugBoard;  % default is empty plugboard 
        end
        
        %% set and get for Rotors (dependent property)
        function values = get.Rotors(obj)
            % VALUES is a three-element cell array of strings, the labels for the current rotors
            % {Label for Left Rotor, Center Rotor, Right Rotor}
            
            values = {char(obj.rotorL) char(obj.rotorC) char(obj.rotorR)};
        end
        
        function set.Rotors(obj,values)
            % VALUES must be a three-element cell array of strings, the labels of the desired rotors
            % {Label for Left Rotor, Center Rotor, Right Rotor}
            
            p = inputParser;
            addRequired(p,'values',@(v) iscellstr(v) && length(v) == 3);
            parse(p,values);
            
            swapRotor(obj,'L',enigmaRotors.(values{1}));
            swapRotor(obj,'C',enigmaRotors.(values{2}));
            swapRotor(obj,'R',enigmaRotors.(values{3}));
        end
        
        
        %% set and get for RingSettings (dependent property) 
        function values = get.RingSettings(obj)
            %   VALUES is a length 3 vector, [Settting for Left Rotor, Center Rotor, Right Rotor]
            
            values = [obj.rotorL.RingSetting obj.rotorC.RingSetting obj.rotorR.RingSetting];
        end
        
        function set.RingSettings(obj,values)
            %   VALUES must be a length 3 vector, [Settting for Left Rotor, Center Rotor, Right Rotor]
            %       elements of VALUES must be >= 1 and <= 26
            
            p = inputParser;
            addRequired(p,'values',@(v) isnumeric(v) && length(v) == 3 && max(v)<=26 && min(v)>=1);
            parse(p,values);
            
            obj.rotorL.RingSetting = values(1);
            obj.rotorC.RingSetting = values(2);
            obj.rotorR.RingSetting = values(3);
        end
        
        %% set and get for RotorSettings (dependent property) 
        function values = get.RotorSettings(obj)
            %   VALUES is a length 3 vector, [Letter for Left Rotor, Center Rotor, Right Rotor] 
            
            values = [getRotorLetter(obj,'L') getRotorLetter(obj,'C') getRotorLetter(obj,'R')];
        end
        
        function set.RotorSettings(obj,values)
            %   VALUES must be a length 3 vector, [Settting for Left Rotor, Center Rotor, Right Rotor]
            %       elements of VALUES must A-Z
            
            p = inputParser;
            addRequired(p,'values',@(v) ischar(v) && length(v) == 3);
            parse(p,values);
            
            setRotorLetter(obj,'L',values(1));
            setRotorLetter(obj,'C',values(2));
            setRotorLetter(obj,'R',values(3));
        end
        
        %% set and get for Reflector (dependent property)
        function value = get.Reflector(obj)
            % VALUE is a char, the label for the current reflector
            
            value = char(obj.reflector);
        end
        
        function set.Reflector(obj,value)
            % VALUE is a char, the label for the new reflector
            
            [~,s] = enumeration('enigmaReflectors');
            p = inputParser;
            addRequired(p,'value',@(c) ischar(c) && any(~cellfun(@isempty,regexp(s,value))));
            parse(p,value);
            
            swapReflector(obj,enigmaReflectors.(value));  
        end
        
        %% set and get for WiredConnections (dependent property)
        function values = get.WiredConnections(obj)
            % VALUES is a 2xN array of chars, each column represents one plug connection
            
%             values = [obj.Alphabet ;...
%                       obj.plugs.connectedTo(obj.Alphabet)];
            values = getWiredConnections(obj.plugs);
        end
        
        function set.WiredConnections(obj,values)
            % VALUES is a 2xN array of chars, each column represents one plug connection
            % if one of the letters specified in VALUES was already involved in another connection, that connection will
            % be disconnected
            
            p = inputParser;
            addRequired(p,'values',@(c) ischar(c) && size(c,1) == 2) 
            parse(p,values);
            
            connectPlug(obj,values(1,:),values(2,:));
        end
        %%
        
        varargout = spinRotor(obj,rotorNum,direction)
            % SPINROTOR updates the config based on the spin of the given rotor either up or down one place, and resets
            % the rotor's IndexInitial
            % This spins each rotor completely independently, ignoring turnover (i.e. this is for setup only)
            % newSetting = SPINROTOR(obj,rotorNum,direction)
            %   ROTORNUM    the index of the rotor (L,C,R)
            %   DIRECTION   -1 = down, 1 = up
            %   Optional Output:
            %   NEWSETTING  char that should be showing in window for that rotor after the spin
            
        varargout = swapRotor(obj,rotorNum,rotorSel)
            % SWAPROTOR changes out one of the rotors for another
            % currSetting = SWAPROTOR(obj,rotorNum,rotorSel)
            %   ROTORNUM    the index of the rotor (L,C,R)
            %   ROTORSEL    enum <enigmaRotors>
            %   Optional Output:
            %   CURRSETTING char that should be showing in window for that rotor
        
        function swapReflector(obj,reflectSel)
            % SWAPREFLECTOR changes out one of the reflectors for another
            %   REFLECTSEL    enum <enigmaReflectors>
            
            p = inputParser;
            addRequired(p,'reflectSel',@(e) isa(e,'enigmaReflectors'));
            parse(p,reflectSel);
            
            obj.reflector = reflectSel;
        end 
        
        function connectPlug(obj,LetterP,LetterN)
            % CONNECTPLUG(obj,LetterP,LetterN) passthrough interface to plugBoard method
            %   LETTERP     char array of one end of plug connection(s)
            %   LETTERN     char array of other end of plug connection(s), must be same length as LETTERP
            %               creates plug connection between LETTERP(k)and LETTERN(k)
            %               If either LETTERP(k) or LETTERN(k) were previously used, this also
            %               replaces that connection
            
            connect(obj.plugs,LetterP,LetterN);      
        end
        
        function removePlug(obj,Letter)
            % REMOVEPLUG(obj,Letter) passthrough interface to plugBoard method
            %   LETTER      char array of letters to be disconnected
            %               This also removes the plug from the other end (e.g. if A-D was a connection,
            %               obj.removePlug('A') also disconnects 'D'
            
            remove(obj.plugs,Letter);      
        end
        
        function currSetting = getRotorLetter(obj,rotorNum)
            % GETROTORLETTER(obj,rotorNum) returns the current (displayed) character for the given rotor
            %   ROTORNUM    the index of the rotor (L,C,R)
            %   CURRSETTING char that should be showing in window for that rotor
            
            p = inputParser;
            validRotorNum = {'L','C','R'};
            checkRotorNum = @(c) any(validatestring(c,validRotorNum));
            addRequired(p,'rotorNum',checkRotorNum);
            parse(p,rotorNum);
            thisRotor = getRotor(obj,rotorNum);
            currSetting = obj.Alphabet(thisRotor.Index);
        end
        
        function varargout = setRotorLetter(obj,rotorNum,letter)
            % SETROTORLETTER lets you specify a new setting for the given rotor as the letter, rather than the index
            %                   Note: this function spins the rotor independently and does not turnover the other rotors
            % currSetting = SETROTORLETTER(obj,rotorNum,letter)
            %   ROTORNUM    the index of the rotor (L,C,R)
            %   LETTER      the desired setting
            %   Optional Output:
            %   CURRSETTING char that should be showing in window for that rotor
            
            p = inputParser;
            validRotorNum = {'L','C','R'};
            checkRotorNum = @(c) any(validatestring(c,validRotorNum));
            addRequired(p,'rotorNum',checkRotorNum);
            addRequired(p,'letter',@(c) ischar(c) && length(c) == 1);
            parse(p,rotorNum,letter);
            thisRotor = getRotor(obj,rotorNum);
            thisRotor.Index = strfind(obj.Alphabet,letter);
            savePosition(thisRotor);              % set initial condition for easy reset
            if nargout == 1
                varargout{1} = thisRotor.Index;
            end
            if nargout > 1
                error('Do not specify more than one optional output (CURRSETTING).');
            end
            
            notify(obj,'RotorPositionUpdated');
        end
     
    end
    
    %% Methods supplied only to the App
    methods (Hidden = true, Access = {?enigmaApp})
        
        function pb = getPlugBoard(obj)
            % GETPLUGBOARD returns a handle to the private plugBoard object
            
            pb = obj.plugs;
        end
        
    end
    
    %% Customize Object Display methods
    methods (Access = protected)
        function displayScalarObject(obj)
         % Implement the custom display for scalar obj
         className = matlab.mixin.CustomDisplay.getClassNameForHeader(obj);
         scalarHeader = [className, ' M3 Emulator'];
         header = sprintf(' %s\n',scalarHeader);
         disp(header)
         disp(sprintf('   %-16s %3s  %3s  %3s',' ','L','C','R'))
         disp(' ')
         disp(sprintf('   %-16s %3s  %3s  %3s','Rotors:',obj.Rotors{1},obj.Rotors{2},obj.Rotors{3}))
         disp(sprintf('   %-16s %3u  %3u  %3u','Ring Offsets:',obj.RingSettings(1),obj.RingSettings(2),obj.RingSettings(3)))
         disp(sprintf('   %-16s %3s  %3s  %3s','Rotor Settings:',obj.RotorSettings(1),obj.RotorSettings(2),obj.RotorSettings(3)))
         disp(' ')
         disp(sprintf('   %-14s %1s','Reflector:',obj.Reflector))
         disp(' ')
         
         disp('   Wired Plug Connections:')
         p1str = '     ';
         p2str = '     ';
         plstr = '     ';
         for k = 1:size(obj.WiredConnections,2)
             p1str = [p1str obj.WiredConnections(1,k) ' '];
             p2str = [p2str obj.WiredConnections(2,k) ' '];
             plstr = [plstr '| '];
         end
         disp(p1str)
         disp(plstr)
         disp(p2str)
         disp(' ')
         
         disp('   Input Log:')
         disp(['     ' obj.InputLog])
         disp(' ')
         disp('   Output Log:')
         disp(['     ' obj.OutputLog])
         
         disp('Show all <a href="matlab:properties(''enigma'')">Properties</a>, <a href="matlab:methods(''enigma'')">Methods</a>');
      end
    end
        

    %% Private Methods
    methods (Access = private)

        advanceRotor(obj,rotorNum)
            % ADVANCEROTOR updates the config based on the spin of the given rotor, but does not reset the rotor's IndexInit
            %   ROTORNUM    the index of the rotor (L,C,R)
            
        rotorTrans = rotorTransform(rotorObj,alphabet)
            % ROTORTRANSFORM returns the transformation matrix of a rotor
            %   ROTORSTRING     wiring table of the rotor as string of 26 chars
            %   IDX             rotor index setting
            %   RINGSETTING     rotor ring setting
            %   ALPHABET        alphabet for the machine          
            
        function thisRotor = getRotor(obj,rotorNum)
            p = inputParser;
            validRotorNum = {'L','C','R'};
            checkRotorNum = @(c) any(validatestring(c,validRotorNum));
            addRequired(p,'rotorNum',checkRotorNum);
            parse(p,rotorNum);
            switch rotorNum
                case 'R'
                    thisRotor = obj.rotorR;
                case 'C'
                    thisRotor = obj.rotorC;
                case 'L'
                    thisRotor = obj.rotorL;
                otherwise
                    error('Invalid Rotor specified');   % should not be able to get here
            end
        end
              
    end
end