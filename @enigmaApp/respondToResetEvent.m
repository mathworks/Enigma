function respondToResetEvent(app)
% RESPONDTORESETEVENT - Respond to event that a reset has been triggered

% Notify to get log to display
notify(app.enigmaObj,'LogUpdated');

% Reset wheels
setWheelValueDisplay(app.rotorWheels(1),app);
setWheelValueDisplay(app.rotorWheels(2),app);
setWheelValueDisplay(app.rotorWheels(3),app);
