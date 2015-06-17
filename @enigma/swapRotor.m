function varargout = swapRotor(obj,rotorNum,rotorSel)
% SWAPROTOR changes out one of the rotors for another
% currSetting = SWAPROTOR(obj,rotorNum,rotorSel)
%   ROTORNUM    the index of the rotor (L,C,R)
%   ROTORSEL    enum <enigmaRotors>
%   Optional Output:
%   CURRSETTING char that should be showing in window for that rotor

% part of the Enigma M3 Emulator
% Copyright 2015, The MathWorks Inc.

p = inputParser;
validRotorNum = {'L','C','R'};
checkRotorNum = @(c) any(validatestring(c,validRotorNum));
addRequired(p,'rotorNum',checkRotorNum);
addRequired(p,'rotorSel',@(e) isa(e,'enigmaRotors'));
parse(p,rotorNum,rotorSel);

if nargout > 1
    error('Do not specify more than one optional output (NEWSETTING).');
end

% check that rotorSel is not being used in another rotor slot
currRotor = ~cellfun(@isempty,regexp(obj.Rotors,['^' rotorSel.char '$']));
slotOptions = {'L','C','R'};
% rotorOptions = {'I','II','III','IV','V','VI'};
if (sum(currRotor) == 1) && ~strcmp(slotOptions(currRotor),rotorNum)
    % set flag to swap the existing rotor with this one later
    flag = 1;
else
    flag = 0;
end

switch rotorNum     % cannot use getRotor method because we are trying to replace the object the handle itself refers to
    case 'R'
        old = obj.rotorR;
        obj.rotorR = rotorSel;
        reset(obj.rotorR); 
        if nargout == 1
            varargout{1} = obj.rotorR.Index;
        end
    case 'C'
        old = obj.rotorC;
        obj.rotorC = rotorSel;
        reset(obj.rotorC);
        if nargout == 1
            varargout{1} = obj.rotorC.Index;
        end    
    case 'L'
        old = obj.rotorL;
        obj.rotorL = rotorSel;
        reset(obj.rotorL);
        if nargout == 1
            varargout{1} = obj.rotorL.Index;
        end
    otherwise
        error('Invalid Rotor specified');   % should not be able to get here
end

if flag
    swapRotor(obj,slotOptions{currRotor},old);
end


end

