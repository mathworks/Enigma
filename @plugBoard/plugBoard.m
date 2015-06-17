classdef plugBoard < handle    
% This class is a plugBoard

% part of the Enigma M3 Emulator
% Copyright 2015, The MathWorks Inc.

    % Properties
    properties (SetAccess= protected)
        Connections = diag(true(1,26)) % Binary connectivity matrix
    end
    
    % Events
    events
        NewConnection % Fired whenever a connection changes 
    end
    
    % Alphabet, used for indexing
    properties (Constant, Hidden, Access = protected)
        Alphabet = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ'.'; % Alphabet
    end
    
    % Main Methods
    methods
        
        % Constructor
        function obj = plugBoard(LetterP,LetterN)
            % Build plugBoard
            % plugBoard() % Empty plugBoard 
            % plugBoard(LetterP,LetterN);
            %
            % LetterP and LetterN can be equally sized char arrays or
            % equally sized cellstrs representing the positive and negative
            % leads of the wires
            
            % Default is empty plug board
            if ~nargin
                return
            elseif nargin == 2
                connect(obj,LetterP,LetterN)
            else
                error('Engima:plugBoard:WrongInputs','Wrong number of inputs, see, help plugBoard');
            end           
            
        end       
        
        % Get connected letter
        function Letter = connectedTo(obj,Letter)
            % Get connected letter
            %
            % connected letter = connectedTo(query letter)
            % 
            % Letter is a char of any size
            % 
            
            % Input handling
            Letter = validateletters(Letter);
      
            % Loop over and identify connected letter for each
            for ii = 1:numel(Letter)
                % Extract letter for each
                Letter(ii) = obj.Alphabet(obj.Connections(ismember(obj.Alphabet,Letter(ii)),:));                 
            end
            
        end
        
        % Get only letters connected to other letters
        function connections = getWiredConnections(obj)
            % GETWIREDCONNECTIONS Returns a length 2xN character array of only the letters that are connected to other
            % letters
            %
            % connections = getWiredConnections(obj)
            % 
            
            % get all letters first
            letters = connectedTo(obj,obj.Alphabet);
      
            % Loop through letters and filter out ones connected to themselves
            connections = '';
            for m = 1:length(letters)
                if ~strcmp(letters(m),obj.Alphabet(m))
                    connections(1,end+1) = obj.Alphabet(m); %#ok<AGROW>
                    connections(2,end) = letters(m);
                end
            end
            
        end
        
        % Connect different letters
        function connect(obj,LetterP, LetterN)
            % Connect different letters
            %
            % LetterP and LetterN must be equally sized char arrays 
            %
            % These if both of the connections are new, they will be
            % appended to any old connections you have.  If either is used,
            % the old connection will be replaced.  If there are multiple
            % uses of the same letter, only the last occurence will be
            % used.
            
            % Validate
            LetterP = validateletters(LetterP);
            LetterN = validateletters(LetterN);
            assert(isequal(size(LetterP),size(LetterN)),'Letter sizes should match');                                
            
            % Loop over and connect each one
            for ii = 1:numel(LetterP)
                connectInMatrix(obj,LetterP(ii),LetterN(ii));
            end

        end     
        
        % Remove connection
        function remove(obj,Letter)
            % Remove Connection
            % Just use connect to disconnect other
            connect(obj,Letter,Letter);
        end
        
        % Show letter connections in an easy to understand way 
        function dispConnections(obj)
            % Show letter connections in an easy to understand way
            % Reflect the connections back on themselves
            az = connectedTo(obj,'A':'Z');
            disp([az; connectedTo(obj,az)]);
        end
        
        
        % Resets the plugBoard, i.e. pull all wires
        function reset(obj)
            % Reset the plugBoard, i.e. pull all wires
            % Reset to diagonal
            obj.Connections = diag(true(1,26));      

            % Let listeners know
            notify(obj,'NewConnection');

        end
        
    end
    
    % Internal methods
    methods (Access = protected, Hidden)        
        
%         % Sets UserInterface property to empty when the figure goes away
%         function resetUserInterface(obj)
%             obj.UserInterface = [];
%         end
        
        % Connect two letters in connections matrix
        function connectInMatrix(obj,first,second)
            % Blank rows and columns of each            
            idx = find(ismember(obj.Alphabet,{first, second}));            
            
            % Blank Old Connections
            obj.Connections(:,idx) = false;
            obj.Connections(idx,:) = false;
            
            % Same Letter
            if numel(idx) == 1
                obj.Connections(idx,idx) = true;
            else
                % Connect the new ones.
                obj.Connections(idx(1),idx(2)) = true;
                obj.Connections(idx(2),idx(1)) = true;
            end           
            
            % Reconnect any that have none (i.e. the plugs on the old
            % connection) to the diagonal
            notconnected = find(~any(obj.Connections));
            idxnotconnected = sub2ind(size(obj.Connections),notconnected,notconnected);
            obj.Connections(idxnotconnected) = true;
            
            % Check
            if ~all(sum(obj.Connections) == 1)
            	warning('Enigma:plugBoard:MulipleConnections','Something went wrong, there are two many connections at one plug');
            end
            
            % Alert listeners
            notify(obj,'NewConnection');
            
        end
                 
    end
    
    % Hidden Handle Methods
    methods (Hidden)
        
        function varargout = vertcat(varargin)
            varargout = vertcat@handle(varargin{:});
        end
        
        function out = addlistener(varargin)
            out = addlistener@handle(varargin{:});
        end
        
        function out = eq(varargin)
            out = eq@handle(varargin{:});
        end
        
        function findobj(varargin)
            findobj@handle(varargin{:});
        end
        
        function out = findprop(varargin)
            out = findprop@handle(varargin{:});
        end
        
        function out = ge(varargin)
            out = ge@handle(varargin{:});
        end
        
        function out = gt(varargin)
            out = gt@handle(varargin{:});
        end
        
        function out = le(varargin)
            out = le@handle(varargin{:});
        end
        
        function out = lt(varargin)
            out = lt@handle(varargin{:});
        end
        
        function out = ne(varargin)
            out = ne@handle(varargin{:});
        end
        
        function notify(varargin)
            notify@handle(varargin{:})
        end
        
    end
        
end

% Validate Letters
function letters = validateletters(letters)
    % Validate type
    validateattributes(letters,{'char'},{})

    % Upper only
    letters = upper(letters);

    % A:Z
    if any(letters < 'A' | letters > 'Z')  % In range
        error('Enigma:plugBoard:InvalidLetter','Invalid Letter, letter should be beween A and Z');
    end

end
