function catchMouseClickOnKeys(app,src)
% CATCHMOUSECLICKONKEYS - catch callback fired when user clicks on keys

% part of the Enigma M3 Emulator
% Copyright 2015, The MathWorks Inc.

% Evaluate character
charVal = getappdata(src,'char');
evaluateEnteredChar(app,charVal)

end

