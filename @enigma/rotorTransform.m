function rotorTrans = rotorTransform(obj,rotorObj)
% ROTORTRANSFORM determines the transformation matrix of a rotor or
% reflector

% part of the Enigma M3 Emulator
% Copyright 2015, The MathWorks Inc.


% Convert alphabet to numeric
for iA=1:length(rotorObj.Sequence)
    rotorNumSeq(iA) =  find(ismember(obj.Alphabet,rotorObj.Sequence(iA))); %#ok<AGROW>
end

% Create transformation matrix
diagMatrix  = eye(length(rotorNumSeq));            % identity matrix
rotorTrans  = diagMatrix(:,rotorNumSeq);    

% Apply rotor offset
if isa(rotorObj,'enigmaRotors')
    % input object is a rotor
    offset      = rotorObj.Index-rotorObj.RingSetting+1;
    offset      = mod(offset-1,length(obj.Alphabet))+1;    % make sure index is in range (ex. 1-26)
else
    %input object is a reflector
    offset      = 1;
end
rotorTrans  = circshift(rotorTrans,-(offset-1),1);
rotorTrans  = circshift(rotorTrans,-(offset-1),2);

end