function catchDrag(app,origPos,src)
% CATCHDRAG - catch mouse drag

% part of the Enigma M3 Emulator
% Copyright 2015, The MathWorks Inc.

% Get current position
newPos = src.CurrentPoint;

% Determine vertical motion
verMotion = newPos(2) - origPos(2);

if abs(verMotion) > 10
    
    % Update callback with new original position
    app.figure.WindowButtonMotionFcn = @(s,e)catchDrag(app,newPos,s);
    
    % Create fake event
    fakeEvt = struct;
    fakeEvt.VerticalScrollCount = sign(verMotion);

    % Trigger fake scroll callback
    catchMouseScroll(app,app.figure,fakeEvt);

end

