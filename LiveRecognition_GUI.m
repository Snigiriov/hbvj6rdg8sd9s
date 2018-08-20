function mainFigure = LiveRecognition_GUI()
mainFigure = figure('Position', [450 200 500 450],...
                    'Name', 'Live recognition');

hAxes           = axes(...
                    'Parent', mainFigure,...
                    'Units', 'pixels',...
                    'Position', [42 295 450 150],...
                    'Tag', 'Axes');
xlabel(hAxes,'t, sec')
ylabel(hAxes,'RMS, db')

hButton         =   uicontrol(...
                    'Parent', mainFigure,...
                    'Style', 'pushbutton',...
                    'String', '���������� ������',...
                    'Position', [150 0 150 50],...
                    'Callback', @hButton_Callback1,...
                    'Tag', 'Button');

hJoy       =   uicontrol(...
                     'Parent', mainFigure,...
                     'Style','text', ...
                     'FontSize', 18,...
                     'String','',...
                     'Position',[0 150 250 50],...
                     'BackgroundColor', [1, 1, 0],...
                     'Tag', 'Text_Joy');
                 
hNegative       =   uicontrol(...
                     'Parent', mainFigure,...
                     'Style','text', ...
                     'FontSize', 18,...
                     'String','',...
                     'Position',[0 100 250 50],...
                     'BackgroundColor', [1, 0, 0],...
                     'Tag', 'Text_Negative');
                 
hNeutral      =   uicontrol(...
                     'Parent', mainFigure,...
                     'Style','text', ...
                     'FontSize', 18,...
                     'String','',...
                     'Position',[250 150 250 50],...
                     'BackgroundColor', [0, 1, 0],...
                     'Tag', 'Text_Neutral');
                 
hSadness      =   uicontrol(...
                     'Parent', mainFigure,...
                     'Style','text', ...
                     'FontSize', 18,...
                     'String','',...
                     'Position',[250 100 250 50],...
                     'BackgroundColor', [0, 0, 1],...
                     'Tag', 'Text_Sadness');

hhTextEmotion_description = uicontrol(...
                     'Parent', mainFigure,...
                     'Style','text', ...
                     'Position', [0 200 500 50], ...
                     'String','Last emotion on percent:',...
                     'FontSize', 24,...
                     'BackgroundColor', [0.15, 0.15, 0.15],...
                     'ForegroundColor',	[0, 1, 0]);
                 
hTextLastEmotion       =   uicontrol(...
                     'Parent', mainFigure,...
                     'Style','text', ...
                     'Position', [250 50 250 50], ...
                     'String','Unvoiced',...
                     'FontSize', 28,...
                     'BackgroundColor', [0.8, 0.8, 0.8],...
                     'Tag', 'TextLastEmotion');
                 
hTextLastEmotion_description = uicontrol(...
                     'Parent', mainFigure,...
                     'Style','text', ...
                     'Position', [0 50 250 50], ...
                     'String','Last emotion:',...
                     'FontSize', 24,...
                     'BackgroundColor', [0.15, 0.15, 0.15],...
                     'ForegroundColor',	[0, 1, 0]);
                 
hTextTime       =   uicontrol(...
                     'Parent', mainFigure,...
                     'Style','text', ...
                     'Position', [450 0 50 50], ...
                     'String',0,...
                     'FontSize', 18,...
                     'BackgroundColor', [0.94, 0.94, 0.94],...
                     'Tag', 'TextTime');
                 
hTextTime_description = uicontrol(...
                     'Parent', mainFigure,...
                     'Style','text', ...
                     'Position', [300 0 150 50], ...
                     'String','Last time:',...
                     'FontSize', 24,...
                     'BackgroundColor', [0.15, 0.15, 0.15],...
                     'ForegroundColor',	[0, 1, 0]);
                 
hTextRMS        =   uicontrol(...
                     'Parent', mainFigure,...
                     'Style','text', ...
                     'Position', [100 0 50 50], ...
                     'String','0',...
                     'FontSize', 24,...
                     'BackgroundColor', [0, 1, 1],...
                     'Tag', 'TextRMS');
                 
hTextRMS_description = uicontrol(...
                     'Parent', mainFigure,...
                     'Style','text', ...
                     'Position', [0 0 100 50], ...
                     'String','RMS:',...
                     'FontSize', 24,...
                     'BackgroundColor', [0.15, 0.15, 0.15],...
                     'ForegroundColor',	[0, 1, 0]);
end
    
%%      callback functions
function hButton_Callback1(hObject, ~, ~)
    set(hObject, 'Enable', 'off')
    set(hObject, 'String', '����� ������')
end 