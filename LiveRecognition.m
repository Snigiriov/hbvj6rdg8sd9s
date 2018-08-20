function LiveRecognition(varargin)
%% name/value parameters
% name: 'startPeriod'; 
%   value: must be more than 0 and less than finish period;
%   type: 'numeric';
%   default: 0;
% name: 'tickCount';
%   value: must be more than 0;
%   type: 'numeric';
%   default: 4;
% name: 'finishPeriod';
%   value: must be more than 0 and more than start period;
%   type: 'numeric';
%   default: 60;
%%
Path
config = loadjson('config.json');
emoObj = EmotionObject;
if length(string(config.CLASS_NAMES)) ~= 4
    error('set 4 emotions in config file ');
end
%%      init input parser and configure parameters/values pairs
parser = inputParser;
parser.addParameter('xAxisStart',0, @isnumeric);
parser.addParameter('xAxisTickCount',4, @isnumeric);
parser.addParameter('xAxisFinish',60, @isnumeric);
parser.addParameter('yAxisStart',0, @isnumeric);
parser.addParameter('yAxisTickCount',4, @isnumeric);
parser.addParameter('yAxisFinish',50, @isnumeric);
parser.addParameter('thresholdRMS',45, @isnumeric);
parser.addParameter('thresholdSec',0.25, @isnumeric);
parser.addParameter('sampleRate',16000, @isnumeric);
parser.addParameter('recordBlockLen',0.025, @isnumeric);
parser.addParameter('audioDeviceID',-1, @isnumeric);
parser.parse(varargin{:})
%%      init variables
global xAxisStart xAxisFinish audiodata_temp
xAxisStart       =   parser.Results.xAxisStart;
xAxisTickCount   =   parser.Results.xAxisTickCount;
xAxisFinish      =   parser.Results.xAxisFinish;
yAxisStart       =   parser.Results.yAxisStart;
yAxisTickCount   =   parser.Results.yAxisTickCount;
yAxisFinish      =   parser.Results.yAxisFinish;
thresholdRMS     =   parser.Results.thresholdRMS;
thresholdSec     =   parser.Results.thresholdSec;
sampleRate       =   parser.Results.sampleRate;
recordBlockLen   =   parser.Results.recordBlockLen;
audioDeviceID    =   parser.Results.audioDeviceID;
xTick = (xAxisFinish - xAxisStart)/(xAxisTickCount + 1);
yTick = (yAxisFinish - yAxisStart)/(yAxisTickCount + 1);
%%      init UI
mainFigure      =   LiveRecognition_GUI();
textRMS         =   findobj(mainFigure, 'Tag', 'TextRMS');
text_Joy        =   findobj(mainFigure, 'Tag', 'Text_Joy');
text_Negative   =   findobj(mainFigure, 'Tag', 'Text_Negative');
text_Neutral    =   findobj(mainFigure, 'Tag', 'Text_Neutral');
text_Sadness    =   findobj(mainFigure, 'Tag', 'Text_Sadness');
axes            =   findobj(mainFigure, 'Tag', 'Axes');
textLastEmotion =   findobj(mainFigure, 'Tag', 'TextLastEmotion');
textTime        =   findobj(mainFigure, 'Tag', 'TextTime');
button          =   findobj(mainFigure, 'Tag', 'Button');
%%      configure x and y axis
set(axes, 'XLim',  [xAxisStart,xAxisFinish])
set(axes, 'XTick', xAxisStart:xTick:xAxisFinish)
set(axes, 'YLim',  [yAxisStart,yAxisFinish])
set(axes, 'YTick', yAxisStart:yTick:yAxisFinish)
%%       init functions
audiodataRMS = init_audiodataRMS(textRMS, sampleRate);
recordData = @()getRecordData(audiorecorder(sampleRate, 16, 1, audioDeviceID), recordBlockLen);
timerStopFcn = init_timerStopFcn(xAxisStart, xAxisFinish, xTick);
%%      init timer
mainTimer = timer('StartDelay', xAxisFinish,...
             'StartFcn', @(~,~) tic,...
             'TimerFcn', @(~,~) toc,...
             'StopFcn', @(timerObj,~) timerStopFcn(timerObj, axes)...
             );
start(mainTimer)
%%      main loop
while isequal(get(button, 'Enable'), 'on')
    if audiodataRMS(recordData())>=thresholdRMS 
        continue
    end
%  trying predict emotion from gathering data if length more than needed
    if length(audiodata_temp)/sampleRate >= thresholdSec
%  if graphic has cleared set start time to 0
        timeEnd  = toc;
        timeStart = timeEnd - length(audiodata_temp)/sampleRate;
        if timeStart>toc
            timeStart = 0;
        end
%  get emotion and emotions percent
        [emo, percent] = RecognizeEmotion(audiodata_temp, sampleRate);
%  create colored rectangles
        color = emoObj.getColor(emo);
        CreateColoredRectangleOnAxes(audiodata_temp, axes, timeStart, timeEnd, color);
%  set text on GUI 
        set(textTime, 'String', round(length(audiodata_temp)/sampleRate, 2))
        set(textLastEmotion, 'BackgroundColor', color)  	
        set(textLastEmotion, 'String', emo)
        set(text_Joy,'string',sprintf('Joy: %g%%',percent(1)))
        set(text_Negative,'string',sprintf('Negative: %g%%', percent(2)))
        set(text_Neutral,'string',sprintf('Neutral: %g%%', percent(3)))
        set(text_Sadness,'string',sprintf('Sadness: %g%%', percent(4)))
    end
	audiodata_temp = [];
end

clean = onCleanup(@() cleanFcn(mainFigure));
end
%%	function to estimate and update rms value on GUI
function audiodataRMS = init_audiodataRMS(obj, sampleRate)
    global audiodata_temp
    specObj = fdesign.audioweighting('WT,Class', 'A', 1, sampleRate);
    filt = design(specObj,'Systemobject',true);
    audiodata_temp = [];
    
    audiodataRMS = @(audiodata) nf_audiodataRMS(audiodata);   
%   nested function
    function rms = nf_audiodataRMS(audiodata)  
        audiodata = filt(audiodata);
        rms = EstimateRMS(audiodata);
        audiodata_temp = cat(1, audiodata, audiodata_temp);
        set(obj, 'String', rms)
    end
end
%%  timer stop function
function timerStopFcn = init_timerStopFcn(initStartPeriod, initFinishPeriod, xTick)
    global xAxisStart xAxisFinish
    deltaPeriod = initFinishPeriod - initStartPeriod;
    
    timerStopFcn = @(timerObj, axes) nf_timerStopFcn(timerObj, axes);
    function nf_timerStopFcn(timerObj, axes)
        if ishandle(axes)
            start(timerObj) 
            xAxisStart = xAxisStart + deltaPeriod;
            xAxisFinish = xAxisFinish + deltaPeriod;
            set(axes, 'XTickLabel', {xAxisStart:xTick:xAxisFinish})
            cla(axes) 
        end  
    end
end
%%
function audiodata = getRecordData(recorder, recordBlockLength)
    recordblocking(recorder, recordBlockLength);
    audiodata = getaudiodata(recorder);
end
%%
function cleanFcn(mainFigure)
    delete(timerfindall)
    close(mainFigure)
end