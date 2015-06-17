function advanceRotor(obj,rotorNum)
% ADVANCEROTOR(obj,rotorNum) updates the config based on the spin of the given rotor, but does not reset rotor's IndexInit
%   ROTORNUM    the index of the rotor (L,C,R)

% part of the Enigma M3 Emulator
% Copyright 2015, The MathWorks Inc.

%% validate inputs
p = inputParser;
validRotorNum = {'L','C','R'};
checkRotorNum = @(c) any(validatestring(c,validRotorNum));
addRequired(p,'rotorNum',checkRotorNum);
parse(p,rotorNum);

%% update config
switch rotorNum
    case 'R'
        thisRotor = obj.rotorR;
    case 'C'
        thisRotor = obj.rotorC;
    case 'L'
        thisRotor = obj.rotorL;
    otherwise
        error('Invalid Rotor specified');   % should not be able to get here
end

thisRotor.Index = thisRotor.Index + 1;       % rollover is handled natively by the enumeration

switch rotorNum
    case 'R' 
        notify(obj,'RotorRUp');
    case 'C'
        notify(obj,'RotorCUp');
    case 'L'
        notify(obj,'RotorLUp');    
end

end

