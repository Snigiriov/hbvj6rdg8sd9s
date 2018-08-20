%%      Configuration
    Path
    config = loadjson('config.json');
    classNames = string(config.CLASS_NAMES);

    files = dir(fullfile(config.TEST_DIR));
    files(1:2) = [];
        
    emoCount = zeros(1,length(classNames));
    waitWindow = waitbar(0, 'Predicting folder, please wait...');
%%      Main routine
tic
    for i = 1:length(files)
        filename = fullfile(files(i).folder, files(i).name);
            
        emoClassPredicted = RecognizeEmotion(filename);
        emoCount = contains(classNames, emoClassPredicted) + emoCount;
        
        waitbar(i/length(files))        
    end
toc
close(waitWindow)
%%      Display result of prediction  
    for i = 1:length(classNames)         
       fprintf('%s: %i from %i\n',...
       classNames(i), emoCount(i), length(files))
    end