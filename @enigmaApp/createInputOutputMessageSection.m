function createInputOutputMessageSection(app)
% CREATEINPUTOUTPUTMESSAGESECTION - Create input and output message display 
% sections within the notepad section

% part of the Enigma M3 Emulator
% Copyright 2015, The MathWorks Inc.

fontSizeText  = 22.5;
fontSizeLabel = 28;
fontName      = 'Bradley Hand ITC';
% Blackadder ITC
% Bradley Hand ITC
% Brush Script MT
% Buxton Sketch
shadedColor = 0.40*[1 1 1];

% Position offsets
paddingLR        = 0.06;
yStartProcessed  = 0.50;
yHeightProcessed = 0.475;
yStartOriginal   = 0.052;
yHeightOriginal  = 0.4350;
yLine            = 0.506;
paddingDividerL  = 0.02;
paddingDividerR  = 0.06;

% Add edit box for output message
app.outputText = annotation(app.figure,'textbox',...
    [app.notepadImageStruct.XStart+paddingLR, yStartProcessed, 1-paddingLR, yHeightProcessed]);
app.outputText.String     = '';
app.outputText.EdgeColor  = 'none';
app.outputText.FontName   = fontName;
app.outputText.FontSize   = fontSizeText;
app.outputText.FontWeight = 'bold';

% Add edit box for original message
app.inputText = annotation(app.figure,'textbox',...
    [app.notepadImageStruct.XStart+paddingLR, yStartOriginal, 1-paddingLR, yHeightOriginal]);
app.inputText.String     = '';    
app.inputText.EdgeColor  = 'none';
app.inputText.FontName   = fontName;
app.inputText.FontSize   = fontSizeText;
app.inputText.FontWeight = 'bold';

% Add subdivision
app.divider = annotation(app.figure,'Line',...
    [app.notepadImageStruct.XStart+paddingDividerL 1-paddingDividerR],[1 1]*yLine);
app.divider.LineWidth = 2;
app.divider.Color     = shadedColor;

% Add "Output" label to notepad
app.outputLabel            = text('Parent',app.notepadAxes);
app.outputLabel.String     = 'Output';
app.outputLabel.Units      = 'Normalized';
app.outputLabel.Position   = [0.07 0.59 0];
app.outputLabel.Rotation   = 90;
app.outputLabel.FontSize   = fontSizeLabel;
app.outputLabel.FontName   = fontName;
app.outputLabel.FontWeight = 'bold';
app.outputLabel.Color      = [0 0 0];

% Add "Input" label to notepad
app.inputLabel            = text('Parent',app.notepadAxes);
app.inputLabel.String     = 'Input';
app.inputLabel.Units      = 'Normalized';
app.inputLabel.Position   = [0.07 0.15 0];
app.inputLabel.Rotation   = 90;
app.inputLabel.FontSize   = fontSizeLabel;
app.inputLabel.FontName   = fontName;
app.inputLabel.FontWeight = 'bold';
app.inputLabel.Color      = [0 0 0];