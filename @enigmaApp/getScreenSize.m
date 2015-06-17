function [ screenSize ] = getScreenSize(app)
% GETSCREENSIZE - Get monitor positions

% part of the Enigma M3 Emulator
% Copyright 2015, The MathWorks Inc

screenSize = get(groot,'MonitorPositions');

nMonitors = size(screenSize,1);
if( nMonitors > 1 )
    
    % Calculate pixel location of app center
    origUnits        = app.figure.Units;
    app.figure.Units = 'Pixels';
    figOuterPos      = app.figure.OuterPosition;
    figPos           = app.figure.Position;
    xCenter          = figOuterPos(1)+(0.5*figOuterPos(3));
    yCenter          = figOuterPos(2)+(0.5*figOuterPos(4));
    app.figure.Units = origUnits;
    
    % Move UI to center of screen to ensure that we find a screen
    movegui(app.figure,'center');
    
    % Find which screen the UI is on
    for i = 1:nMonitors
        xStart = screenSize(i,1);
        xEnd   = screenSize(i,3) + xStart;
        yStart = screenSize(i,2);
        yEnd   = screenSize(i,4) + yStart;
        
        if( xCenter > xStart && xCenter < xEnd && ...
            yCenter > yStart && yCenter < yEnd       )
            screenSize = screenSize(i,:);
            break;
        end
        
    end
    
    % Move UI back to original position
    app.figure.Position = figPos;
    
end

end