% STARTHERE - Script to describe how users can interface with the Enigma
% App via the user interface or command line.

% part of the Enigma M3 Emulator
% Copyright 2015, The MathWorks Inc.

%% To perform Enigma encryption, either:
%% (1) Launch the app directly
% by calling launchEngima to get the default machine configuration
% >> launchEnigma
% Once the app is called, the machine configuration can be modified through
% the graphical user interface 

%% (2) Use the command line interface as follows
% Create an Enigma object with default settings
e = enigma;

% Select the rotors. For example, to place the rotors from left to right as
% rotors I, II and III, respectively:
e.Rotors = {'I' 'II' 'III'};

% Offset the rotor rings. For example, to set the left rotor to 1, the 
% center rotor to 11 and the right rotor to 5:
e.RingSettings = [1 11 5];

% Rotate the rotors to the desired position: For example, to have them
% display A, A, A:
e.RotorSettings = 'AAA';

% Select the reflector, for example:
e.Reflector = 'B';

% Connect the plugboard as desired, for example:
connectPlug(e,'QWERASDFPYC','ZUIOGJKLVHM');

% Perform encryption
run(e,'HELLOMATLAB')

% The enigma object will maintain its state as you continue to perform
% encryption