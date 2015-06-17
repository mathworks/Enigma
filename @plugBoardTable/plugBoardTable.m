classdef plugBoardTable < handle
% Table tool for modifying plugboard configuration.   
%
% pbtable = plugBoardTable(board)
% pbtable = plugBoardTable()
%
% This function builds a table for interactively modifying a
% plugboard.

% This is being used in the interim until the modifiable plugboard is
% complete.

% part of the Enigma M3 Emulator
% Copyright 2015, The MathWorks Inc.


    % Handles
    properties (Hidden, Transient, Access = protected)
        Figure             % Figure Handle          
        Table              % Handle to uitable
        ThisPlugBoard      % Handle to the PlugBoard        
        ConnectionListener % Listener for new connections
    end
    
    % A2Z
    properties (Hidden, Constant)
        cellA2Z = cellstr(('A':'Z').').';
        charA2Z = 'A':'Z';
    end

    % Constructor, Destructor
    methods
        
        % Constructor
        function obj = plugBoardTable(board)
        % pbtable = plugBoardTable(board)
        % pbtable = plugBoardTable()
        %
        % This function builds a table for interactively modifying a
        % plugboard.                                       
            
            % Input check
            if ~nargin
                % Build Default plugBoard
                obj.ThisPlugBoard = plugBoard();                
            else
                % Make sure it's a plug board
                assert(isa(board,'plugBoard'),'Input 1 should be a plugBoard object')
                obj.ThisPlugBoard = board; 
            end
            
            % Build User Interface
            buildUI(obj)        
        
            % Listeners:
            % New Connections, if plugboard or figure goes away
            addlistener(obj.ThisPlugBoard,'NewConnection',@(~,~)populateTable(obj));
            addlistener(obj.ThisPlugBoard,'ObjectBeingDestroyed',@(~,~)delete(obj));            
            addlistener(obj.Figure,'ObjectBeingDestroyed',@(~,~)delete(obj));
            
        end
        
        % Destructor
        function delete(obj)
            % Delete figure and listener
            if isvalid(obj.Figure)
                delete(obj.Figure);
            end
            delete(obj.ConnectionListener);
        end
    
    end
    
    % Internal methods
    methods (Hidden, Access = protected)
    
        % Build user interface
        function buildUI(obj)            
            % Create figure
            obj.Figure = figure('Visible','Off');
            obj.Figure.Name = 'Plug Board Configuration';
            obj.Figure.ToolBar = 'None';
            obj.Figure.MenuBar = 'None';
            obj.Figure.Color = [1,1,1];
            obj.Figure.Units = 'Pixels';
            obj.Figure.Position(3:4) = [400 700];
            obj.Figure.Interruptible = 'Off';
            obj.Figure.NumberTitle = 'Off';
            obj.Figure.Resize = 'Off';
            obj.Figure.HandleVisibility = 'Off';
            movegui(obj.Figure,'center');
            
            % Create background axes
            bg = axes('Parent',obj.Figure);
            bg.Units = 'Normalized';
            bg.XLim = [0,1];
            bg.YLim = [0,1];
            bg.Position = [0,0,1,1];
            try
                % Read the background image.  
                % FIXME, this path should be full
                im = imread('@enigmaApp\images\blackBackground.png');
            catch
                % Can't find it, default to black
                im = zeros(256,256,3,'uint8');
            end
            imagesc(im,'Parent',bg)
            box(bg,'Off');
            bg.XTick = [];
            bg.YTick = [];
            bg.Units = 'Normalized';
            bg.YDir   = 'Normal';
                                    
            % Table
            obj.Table = uitable('Parent',obj.Figure);
            obj.Table.Units = 'Pixels';
            obj.Table.Position = [50 100 300 575];
            obj.Table.CellEditCallback = @(src,evt)updateFromTable(obj,src,evt);
            obj.Table.RearrangeableColumns = 'Off';
            obj.Table.ColumnName = {'Positive','Negative'};
            obj.Table.ColumnFormat = {obj.cellA2Z,obj.cellA2Z};
            obj.Table.ColumnEditable = [true true];
            obj.Table.FontUnits = 'pixels';
            obj.Table.FontSize = 24;
            obj.Table.ColumnWidth = {130 130};
            obj.Table.RowName = [];
            populateTable(obj);            
            
            % Done button
            done = uicontrol('Style','pushbutton','Parent',obj.Figure);
            done.Units = 'normalized';
            done.Position = [0.2 0.025 0.6 0.075];
            done.String ='Done';
            done.FontUnits = 'normalized';
            done.FontSize = 0.45;
            done.Callback = @(~,~)delete(obj);
            
            % Make it visible
            obj.Figure.Visible = 'on';
            drawnow update
            
        end
        
        % Initial population
        function populateTable(obj)             
            % Connections
            conn = connectedTo(obj.ThisPlugBoard,obj.charA2Z);
            data = [obj.cellA2Z.',cellstr(conn.')];
                    
            % Update table
            obj.Table.Data = data;
            drawnow update
        end
        
        % Updates from user
        function updateFromTable(obj,src,evt)            
            % Connect the two new values
            connect(obj.ThisPlugBoard,src.Data{evt.Indices(1),1},src.Data{evt.Indices(1),2});

        end
        
    end
    
end
