function evaluateEnteredChar(app,str)
% EVALUATEENTEREDCHAR - Evaluate actions based on entered characters

% part of the Enigma M3 Emulator
% Copyright 2015, The MathWorks Inc

switch str
    
    case num2cell('A':'Z')
        
        % Check if there is enough space in notepad
        % before running new character
        enoughSpace = evaluateSpace(app);
        if (enoughSpace)
            % Encode
            run(app.enigmaObj,str);
        end
        
    case 'ESCAPE'
        
        % Reset list of spaces and break points
        app.lineBreakLoc = 0;
        app.lineSpaceLoc = 0;
        
        % Reset enigma code
        reset(app.enigmaObj);
        
    case 'SPACE'
        
        % Convert string to single line
        strSingle = [app.inputText.String{:}];
        % Remove spaces
        strSingle = strrep(strSingle,' ','');
        
        % Determine current number of characters
        nChar = numel(strSingle);
        
        app.lineSpaceLoc = [app.lineSpaceLoc nChar];
        
    case 'RETURN'
        
        % Determine current number of characters
        nChar = numel([app.inputText.String{:}]);
        
        % Add that to list of break points
        app.lineBreakLoc = [app.lineBreakLoc nChar-1];
        
end


end

function enoughSpace = evaluateSpace(app)

enoughSpace = true;
% Get current string, remove spaces and newline characters
curStr = app.inputText.String;
if isempty(curStr)
    return;
end
curStr = [curStr{:}];
curStr = strrep(curStr,' ','');

% Add a new dummy character
newStr = [curStr 'A'];

tooMany = evaluateNewStrFit(app,newStr);

enoughSpace = ~tooMany;

end

function tooMany = evaluateNewStrFit(app,newStr)
% Determine if new string would fit in the notepad

% Add spaces accordingly
newStrWithSpaces  = addSpaces(app,newStr);

% Convert to multi line strings
tooMany  = convertToMultiLineString(app,newStrWithSpaces);


end

function cStr = addSpaces(app,str)

cStr = [];

% Add end of character to line break
nChar = numel(str);
lineSpaceLoc = [app.lineSpaceLoc nChar];

% For every space location
for i = 2:numel(lineSpaceLoc)
    
    % Extract string section
    secLim = lineSpaceLoc(i-1)+1:lineSpaceLoc(i);
    sectionStr = str(secLim);
    
    % Add to new string with space after
    cStr = [cStr sectionStr ' ']; %#ok<AGROW>
    
end

end

function tooMany = convertToMultiLineString(app,str)

cStr = '';
if( isempty(str) )
    return;
end


nChar = numel(str);

cStr = cell(0);

% Add end of character to line break
lineBreakLoc = [app.lineBreakLoc nChar];

j = 2;
while j <= numel(lineBreakLoc)    
    secLim = lineBreakLoc(j-1)+1:lineBreakLoc(j);
    sectionStr = str(secLim);
    
    % Check section is not too long
    if (numel(sectionStr) > app.lineLim) 
        
        % Append a new section
        lineBreakLoc = [lineBreakLoc(1:j-1) lineBreakLoc(j-1)+app.lineLim lineBreakLoc(j)];
        
        % Extract section
        secLim = lineBreakLoc(j-1)+1:lineBreakLoc(j);
        sectionStr = str(secLim);
    end
    
    % Add section
    cStr{j-1,1} = sectionStr;
    j = j + 1;
end

% Check if it is too much!
if size(cStr,1) >= app.numLinesLim
    tooMany = true;
else
    tooMany = false;
end

end