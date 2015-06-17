function turnAllLightsKeysOff(app)
% TURNALLLIGHTSKEYSOFF - Set all lights and key edges off

% part of the Enigma M3 Emulator
% Copyright 2015, The MathWorks Inc

set(app.lightKeys,'Visible','Off');
set(app.pushKeys,'LineWidth',1);
set(app.pushKeys,'MarkerEdgeColor','k');
