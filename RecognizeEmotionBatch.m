function [status, elapsedTime] = RecognizeEmotionBatch(varargin)
tic
try
parser = inputParser;
parser.addRequired('algorithm')
parser.parse(varargin{:})
algorithm = @(audiofile) parser.Results.algorithm(audiofile);
%%      Configuration
Path
config = loadjson('config.json');
emoObj = EmotionObject;
testdir = config.TEST_DIR;
classnames = string(config.CLASS_NAMES);

files = dir(testdir);
files(1:2) = [];

emoCountPredicted = zeros(1,length(classnames));
emoCount = zeros(1,length(classnames));       
correct = 0;
    
waitWindow = waitbar(0, 'Testing, please wait...');
%%      Main routine           
tic
for i = 1:length(files)
    audiofile = fullfile(testdir, files(i).name);
%   original emotion
    emoClassOriginal = emoObj.getEmotionName(files(i).name);
%   predicted emotion
    emoClassPredicted = algorithm(audiofile);
%   count overall emotions
    emoCount = contains(classnames, emoClassOriginal) + emoCount;
%   count predicted emotions
    if isequal(emoClassOriginal, emoClassPredicted)
        correct = correct+1;
        emoCountPredicted = emoCountPredicted...
        + contains(classnames, emoClassOriginal);
    end

    waitbar(i/length(files))
end
close(waitWindow)
%%      Display result of test
%   overall stat
    p = round(correct/sum(emoCount)*100);
    fprintf('Accuracy: %g%%, correct %i from %i, where:\n', p, correct, sum(emoCount))
%   stat for every emo class    
    for i = 1:length(classnames)      
       percent_predicted = emoCountPredicted(i)/emoCount(i)*100;
       
       fprintf('   %s... accuracy: %g%%, correct %i from %i\n',...
       classnames{i}, percent_predicted, emoCountPredicted(i), emoCount(i))
    end
status = 'complete';
elapsedTime = toc;
fprintf('Testing is %s. Elapsed time: %g seconds\n', status, elapsedTime)
catch exception
    status = 'incomplete';
    message = exception.message;
    fprintf('Testing is %s, cause: %s \n', status, message)
    elapsedTime = toc;
end
end