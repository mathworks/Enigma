function varargout = spinRotor(obj,rotorNum,direction)
% SPINROTOR updates the config based on the spin of the given rotor either up or down one place
% For now, this spins each rotor completely independently, ignoring turnover (i.e. this is for setup only)
% newSetting = SPINROTOR(obj,rotorNum,direction)
%   ROTORNUM    the index of the rotor (L,C,R)
%   DIRECTION   -1 = down, 1 = up
%   Optional Output:
%   NEWSETTING  char that should be showing in window for that rotor after the spin

% part of the Enigma M3 Emulator
% Copyright 2015, The MathWorks Inc.
            
%% validate inputs
p = inputParser;
validRotorNum = {'L','C','R'};
checkRotorNum = @(c) any(validatestring(c,validRotorNum));
checkDirection = @(x) x == -1 || x == 1;
addRequired(p,'rotorNum',checkRotorNum);
addRequired(p,'direction',checkDirection);
parse(p,rotorNum,direction);

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

thisRotor.Index = thisRotor.Index + direction;       % rollover is handled natively by the enumeration
savePosition(thisRotor);

if direction > 0
    rotorNumAndDirection = [rotorNum '+'];
else
    rotorNumAndDirection = [rotorNum '-'];
end
switch rotorNumAndDirection
    case 'R+' 
        notify(obj,'RotorRUp');
    case 'C+'
        notify(obj,'RotorCUp');
    case 'L+'
        notify(obj,'RotorLUp');
    case 'R-' 
        notify(obj,'RotorRDown');
    case 'C-'
        notify(obj,'RotorCDown');
    case 'L-'
        notify(obj,'RotorLDown');       
end

%% Output (optional)
if nargout == 1
    varargout{1} = obj.Alphabet(thisRotor.Index);
end
if nargout > 1
    error('Do not specify more than one optional output (NEWSETTING).');
end
end


