function [status, elapsedTime, message] = ConstructFeatures(varargin)
%%      Configuration
tic
try
Path
emoObj = EmotionObject;
config = loadjson('config.json');
parser = inputParser;
parser.addParameter('mode','train');
parser.parse(varargin{:})

switch parser.Results.mode
    case 'cluster'
        sourceDir = config.CLUSTER_DIR;
    case 'train'
        sourceDir = config.TRAIN_DIR;  
end

files = dir(sourceDir);
files(1:2) = [];

waitWindow = waitbar(0, 'Extracting features, please wait...');
%%      Main routine
x = 1;
for i = 1:length(files)
    featuresArray = ExtractFeatures(fullfile(sourceDir,files(i).name));
    emotion = emoObj.getEmotionName(files(i).name);
    emotionNumber = emoObj.getNumber(emotion);
    if any(contains(string(config.CLASS_NAMES), emotion))
        featuresTable(x, :) = cell2table({featuresArray, emotionNumber, emotion, files(i).name},...
        'VariableNames', {'features', 'emotionNumber', 'emotion', 'name'});
        x = x + 1;
    end
    waitbar(i/length(files))
end
close(waitWindow)
%%      Save data
switch parser.Results.mode
    case 'cluster'
        save('clusterFeatures.mat','featuresTable');
    case 'train'
        save(['featuresTable_',num2str(length(config.CLASS_NAMES)),'.mat'],...
              'featuresTable');
end
status = 'complete';
elapsedTime = toc;
fprintf('Extracting features is %s. Elapsed time: %g seconds\n', status, elapsedTime)
catch exception
    status = 'incomplete';
    message = exception.message;
    fprintf('Extracting features is %s, cause: %s \n', status, message)
    elapsedTime = toc;
end