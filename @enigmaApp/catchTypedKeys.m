function catchTypedKeys(app,evt)
% CATCHTYPEDKEYS - Catch keys typed on machine

% part of the Enigma M3 Emulator
% Copyright 2015, The MathWorks Inc.

% Capture important keypress information
keyPressed   = upper(evt.Key     );
keyModifier  = upper(evt.Modifier);
allowedStr   = [num2cell('A':'Z'),{'SPACE','BACKSPACE','ESCAPE','RETURN'}];
isAllowedKey = any(strcmp(keyPressed,allowedStr));

% Check for copy or paste (CTRL+C or CTRL+V) and ignore cases in which only
% the CONTROL key was pressed
if( ~isempty(keyModifier) && ~strcmp(keyPressed,'CONTROL') )
    
    % Check that only control was pressed
    if( numel(keyModifier) == 1          && ...
        strcmp(keyModifier{1},'CONTROL')       )
        
        switch keyPressed
            
            case 'C'
                % Grab the processed string
                processedStr = app.processedText.String;
                if( iscell(processedStr) )
                    processedStr = [processedStr{:}];
                end
                
                % Copy it to the clipboard
                % Note: This method is necessary for copying empty strings
                cbObj = com.mathworks.page.utils.ClipboardHandler;
                cbObj.copy(processedStr);
                
            case 'V'
                % Grab clipboard and sanitize the input
                pasteStr = upper(clipboard('paste'));
                cleanStr = regexprep(pasteStr,'[^A-Z\s]','');
                
                % Decode each character and shift rotors when necessary
                for i = 1:numel(cleanStr)
                    evaluateEnteredChar(app,cleanStr(i),false);
                end
                
        end
        
    end

elseif( isAllowedKey ) 
    % Append to original current string
    evaluateEnteredChar(app,keyPressed);
    
end

end

