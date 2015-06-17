classdef enigmaRotors < handle
    % Enumerated handle class for Rotors
    
    % part of the Enigma M3 Emulator
    % Copyright 2015, The MathWorks Inc.
    
    properties (SetObservable = true, Access = {?enigma,?enigmaApp});
        Sequence    % character sequence of the rotor. Squence(Index) is the expected output when electrical input is A.
        Notches     % location of the notch or notches in the rotor, a rotation through which causes the next rotor to spin
        Index       % "current" position of the rotor. Index+1 is the electrical input for B, Index+2 for C, etc.
        RingSetting % ring offset of the rotor. 
    end
    
    properties (Access = private)
        IndexInitial
    end
    
    methods (Access = {?enigma,?enigmaApp})
        function c = enigmaRotors(charSeq,turnoverNotch)
            c.Sequence = charSeq;
            c.Notches = turnoverNotch;  
            c.Index = 1;
            c.IndexInitial = 1;
            c.RingSetting = 1;
        end
        
        function savePosition(obj)
            % set method for IndexInitial
            obj.IndexInitial = obj.Index;
        end
        
        function value = loadPosition(obj)
            % get method for IndexInitial
            value = obj.IndexInitial;
        end
        
        function reset(obj)
            obj.IndexInitial = 1;
            obj.Index = 1;
            obj.RingSetting = 1;
        end
        
    end
    
    methods 
        function set.Index(obj,value)
            % handles rollover of the sequence
            if (value == 0 || value == 26)
                obj.Index = 26;
            else
                obj.Index = mod(value,26);
            end       
        end
    end
    
    enumeration
        I       ('EKMFLGDQVZNTOWYHXUSPAIBRCJ','Q')
        II      ('AJDKSIRUXBLHWTMCQGZNPYFVOE','E')
        III     ('BDFHJLCPRTXVZNYEIWGAKMUSQO','V')
        %I       ('JGDQOXUSCAMIFRVTPNEWKBLZYH','Q',  1) %German Railway model
        %II      ('NTZPSFBOKMWRCJDIVLAEYUXHGQ','E',  1) %German Railway model
        %III     ('JVIUBHTCDYAKEQZPOSGXNRMWFL','V',  1) %German Railway model
        IV      ('ESOVPZJAYQUIRHXLNFTGKDCMWB','J')
        V       ('VZBRGITYUPSDNHLXAWMJQOFECK','Z')
        VI      ('JPGVOUMFYQBENHZRDKASXLICTW','ZM')
        VII     ('NZJHGRCXMYSWBOUFAIVLPEKQDT','ZM')
        VIII    ('FKQHTLXOCBJSPDZRAMEWNIUYGV','ZM')
    end

end