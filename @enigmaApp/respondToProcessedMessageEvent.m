function respondToProcessedMessageEvent(app)
% RESPONDTOPROCESSEDMESSAGEEVENT - ProcessedMessage event triggers this 
% function to update diary window with input and processed messages

% part of the Enigma M3 Emulator
% Copyright 2015, The MathWorks Inc

% Get machine logs
inputStr    = app.enigmaObj.InputLog;
outputStr   = app.enigmaObj.OutputLog;

% Add spaces accordingly
inputStrWithSpaces  = addSpaces(app,inputStr);
outputStrWithSpaces = addSpaces(app,outputStr);

% Convert to multi line strings
inputMultiStr   = convertToMultiLineString(app,inputStrWithSpaces);
outputMultiStr  = convertToMultiLineString(app,outputStrWithSpaces);

% Set to diary sections
app.inputText.String     = inputMultiStr;
app.outputText.String    = outputMultiStr;

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

function cStr = convertToMultiLineString(app,str)

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

if size(cStr,1) >= app.numLinesLim
    cStr(app.numLinesLim:end) = [];
end

end