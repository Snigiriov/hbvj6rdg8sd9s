function response = AudiofileEmoAnalyse(audio, varargin)
%% help
% 'mode', 'viaRMS'
% 'mode', 'viaTime'
%%  
Path
tic
global getParam
try
%%  init input parser
parser = inputParser;
parser.addParameter('mode', 'viaRMS', @ischar)
parser.addParameter('time', 0.5, @isnumeric)
parser.addParameter('timeThreshold', 0.5, @isnumeric)
parser.addParameter('debugMode', 0, @isnumeric)
parser.addParameter('saveImage', 0, @isnumeric)
parser.parse(varargin{:})
%%  get discrete values of audio
[s, fs] = audioread(audio);
[~, name] = fileparts(audio);
%%  init objects
getParam = initGetParam(parser, name);
%%
res.statusCode = 200;
res.status = 'OK';
res.fileName = name;

if size(s, 2) == 2   
    if isequal(parser.Results.mode, 'viaTime')
        res.leftChannel = viaTime(s(:, 1), fs);
        res.rightChannel = viaTime(s(:, 2), fs);
    elseif isequal(parser.Results.mode, 'viaRMS')
       res.leftChannel = viaRMS(s(:, 1),  fs);
       res.rightChannel = viaRMS(s(:, 2), fs);
    end
    
    res.metricDataLeft = Metric(res.leftChannel, length(s)/fs);
    res.metricdataRight = Metric(res.rightChannel, length(s)/fs);
else
    if isequal(parser.Results.mode, 'viaTime')
        res.monoChannel = viaTime(s, fs);
    elseif isequal(parser.Results.mode, 'viaRMS')
        res.monoChannel = viaRMS(s,  fs);
    end
    
    res.metricDataMono = Metric(res.monoChannel, length(s)/fs);
end

res.responceTime = round(toc,2);
response = savejson('', res);

catch exception
	response = savejson('', struct('statusCode', 500,...
                  'status', 'Internal Server Error',...
                  'errorMessage', exception.message,...
                  'responceTime', round(toc,2)...
                  ));
end

end
%%  
function [rmsArray, thresholdRMS] = getRMSarray(timeInSamples, s) 
    rmsArray = zeros(1, fix(length(s)/timeInSamples));
    x = 1;
        for i = 0:timeInSamples:length(s)-timeInSamples
            rmsArray(x) = EstimateRMS(s(i+1:i+timeInSamples));
            x = x + 1;
        end
    rmsArrayTemp = EstimateRMS(s(end-timeInSamples:end));
    rmsArray = [rmsArray, rmsArrayTemp];
    rmsArray(rmsArray<0) = 0;
    thresholdRMS = median(rmsArray);
end
%%
function data = viaTime(s, fs)
global getParam
outputData = getParam();
emoObj = outputData.emoObj;
debugMode = outputData.debugMode;
time = outputData.time;
saveImage = outputData.saveImage;
    [rmsArray, thresholdRMS] = getRMSarray(time*fs, s);
    if debugMode
        f = figure('Name', 'Emotion Map');
		hAxes = axes('Parent', f);
    end
    for i = 1:length(rmsArray)
        if i*time < length(s)/fs
            timeEnd = i*time;
        else
            timeEnd = length(s)/fs;
        end
            timeStart = (i-1)*time;
        if rmsArray(i) >= thresholdRMS
            emotion = RecognizeEmotion(s(timeStart*fs+1:timeEnd*fs), fs);            
        else
            emotion = 'Trash';
        end
            [rms1, rms2] = getRMSvalues(s, timeStart*fs, timeEnd*fs);
            numEmotion = emoObj.getNumber(emotion);
            data(i) = struct('emotion', numEmotion,...
                             'startTime', timeStart,...
                             'endTime', timeEnd,...
                             'rms1', rms1,...
                             'rms2', rms2);
        if debugMode
            CreateColoredRectangleOnAxes(s(round(timeStart*fs): round(timeEnd*fs)),...
            hAxes, timeStart, timeEnd, emoObj.getColor(emotion));
        end
    end
    
    if saveImage && debugMode
        saveFigure(f, name)
    end
end
%%
function data = viaRMS(s, fs)
global getParam
outputData = getParam();
emoObj = outputData.emoObj;
debugMode = outputData.debugMode;
timeThreshold = outputData.timeThreshold;
name = outputData.name;
saveImage = outputData.saveImage;
[~, ~, ~, booleanArray] = activlev(s, fs);
    audiodata_temp = 0;
    x = 1;
    if debugMode
        f = figure('Name', 'Emotion Map');
        hAxes = axes('Parent', f);
    end
    for i = 1:length(booleanArray)
        if booleanArray(i) == 1
            audiodata_temp = audiodata_temp + 1;
            if i == length(booleanArray)
                break
            else
                continue
            end
        end
%  trying predict emotion from gathering data if length more than needed
        if audiodata_temp/fs >= timeThreshold
        	sampleEnd = i;
            sampleStart = sampleEnd - audiodata_temp;
            if BeepFinder(s(sampleStart:sampleEnd), fs)
                emotion = 'Beep';
            else
            	emotion = RecognizeEmotion(s(sampleStart:sampleEnd), fs);
            end           
                [rms1, rms2] = getRMSvalues(s, sampleStart, sampleEnd);
                numEmotion = emoObj.getNumber(emotion);
                data(x) = struct('emotion', numEmotion,...
                                 'startTime', sampleStart,...
                                 'endTime', sampleEnd,...
                                 'rms1', rms1,...
                                 'rms2', rms2);
        	 x = x + 1;
            
            if debugMode
                CreateColoredRectangleOnAxes(s(sampleStart: sampleEnd),...
                 hAxes, sampleStart, sampleEnd, emoObj.getColor(emotion));
            end
        end
        audiodata_temp = 0;
    end
    if saveImage && debugMode
        saveFigure(f, name)
    end
end

function [rms1, rms2] = getRMSvalues(s, startSample, endSample)
    audiodata = s(startSample:endSample);
    rms1 = EstimateRMS(audiodata(1:round(end/2)));
    rms2 = EstimateRMS(audiodata(round(end/2):end));
end

function getparam = initGetParam(parser, name)
    emoObj = EmotionObject;
    debugMode = parser.Results.debugMode;
    timeThreshold = parser.Results.timeThreshold;
    time = parser.Results.time;
    saveImage = parser.Results.saveImage;
    getparam = @() getParam();
    
    function outputData = getParam()
        outputData = struct('emoObj', emoObj,...
                            'debugMode', debugMode,...
                            'timeThreshold', timeThreshold,...
                            'time', time,...
                            'name', name,...
                            'saveImage', saveImage);
    end
end

function saveFigure(f, name)
folderName = 'savedFig';
    if ~exist(folderName, 'dir')
        mkdir(folderName)
    end
    f.Position = [0 0 1366 768];
    f.Visible = 'off';
    saveas(f, [folderName, '\', name, '.png'])
end