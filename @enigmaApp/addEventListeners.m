function addEventListeners(app)
% ADDEVENTLISTER - Add listeners for app to integrate with enigma object

% part of the Enigma M3 Emulator
% Copyright 2015, The MathWorks Inc.

% Listen for when input string is finished processing
addlistener(app.enigmaObj,'LogUpdated',     @(~,~)respondToProcessedMessageEvent(app));
addlistener(app.enigmaObj,'LampLighted',    @(~,~)respondToLightOnEvent(app));
% Listen for a reset event
addlistener(app.enigmaObj,'RotorPositionUpdated',@(~,~)respondToResetEvent(app));

% Listen for changes to the rotors
addlistener(app.enigmaObj,'RotorRUp',@(~,~)spinWheel(app.rotorWheels(1),app,1));
addlistener(app.enigmaObj,'RotorRDown',@(~,~)spinWheel(app.rotorWheels(1),app,-1));
addlistener(app.enigmaObj,'RotorCUp',@(~,~)spinWheel(app.rotorWheels(2),app,1));
addlistener(app.enigmaObj,'RotorCDown',@(~,~)spinWheel(app.rotorWheels(2),app,-1));
addlistener(app.enigmaObj,'RotorLUp',@(~,~)spinWheel(app.rotorWheels(3),app,1));
addlistener(app.enigmaObj,'RotorLDown',@(~,~)spinWheel(app.rotorWheels(3),app,-1));

notify(app.enigmaObj,'RotorPositionUpdated');