function catchMouseScroll(app,src,evt)
% CATCHMOUSESCROLL - Catch mouse scroll over rotors

% part of the Enigma M3 Emulator
% Copyright 2015, The MathWorks Inc.

src.Units = 'Normalized';
curPoint = src.CurrentPoint;
if evt.VerticalScrollCount > 0
    scrollDir = 1;
else
    scrollDir = -1;
end
src.Units = 'Pixels';

for iWheel = app.rotorWheels
    posWheel1 = iWheel.Position;

    insideX = curPoint(1) >= posWheel1(1) && curPoint(1) <= posWheel1(1)+posWheel1(3);
    insideY = curPoint(2) >= posWheel1(2) && curPoint(2) <= posWheel1(2)+posWheel1(4);
    insideBoth = insideX && insideY;

    if (insideBoth)
        updateWheel(app,iWheel,scrollDir);
        break;
    end
end

function updateWheel(app,iWheel,scrollDir)

% Spin rotor code
spinRotor(app.enigmaObj,iWheel.tag,scrollDir);
