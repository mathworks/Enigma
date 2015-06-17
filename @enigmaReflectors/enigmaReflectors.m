classdef enigmaReflectors < handle
    % Enumerated handle class for Reflector drum
    
    % part of the Enigma M3 Emulator
    % Copyright 2015, The MathWorks Inc.
    
    properties (Access = {?enigma,?enigmaApp})
        Sequence     % character sequence of reflector. Index 1 is output returned when input is A, idx2 when input is B, etc
    end
    methods (Access = {?enigma,?enigmaApp})
        function c = enigmaReflectors(charSeq)
            c.Sequence = charSeq;
        end
    end
    enumeration
        A     ('EJMZALYXVBWFCRQUONTSPIKHGD')
        B     ('YRUHQSLDPXNGOKMIEBFZCWVJAT')
        C     ('FVPJIAOYEDRZXWGCTKUQSBNMHL')
    end

end