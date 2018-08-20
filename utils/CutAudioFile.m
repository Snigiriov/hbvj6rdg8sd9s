function cutAudioFile(singleAudioFile, dirPathTO, sec)

    file = dir(singleAudioFile);
    if exist(dirPathTO, 'dir') == 0
            mkdir(dirPathTO)
    end
    
    if nargin < 2
        if exist(fullfile(file.folder, '\cuttedAudio\'), 'dir') == 0
                mkdir(fullfile(file.folder, '\cuttedAudio\'))
        end
        dirPathTO = fullfile(file.folder, '\cuttedAudio\');
    end
    
    if nargin < 3
       sec = 1;                            % Длительность одного кусочка 
    end

    [data, fs] = audioread(singleAudioFile);        % Извлечение двух параметров аудиофайла для вычисления количества полных кусочков
    fullLength = length(data);
    num_full_frames = fix(length(data)/(fs*sec));   % Вычисление количества полных кусочков
    startSamples = 1;                          % Для цикла ниже - начальное значение аргумента samples 
    finishSamples = fs*sec;                        % Для цикла ниже - конечное значение аргумента samples
    
if num_full_frames == 0
        [~, filename, ext] = fileparts(singleAudioFile);
        name = getName(dirPathTO, filename, ext, 0);
        audiowrite(name, data, fs) 
else   
    for i = 1:num_full_frames                               % Разбиение на num_full_frames кусочков
        samples = [startSamples,finishSamples];             % Аргумент samples для функции audioread
        data = audioread(singleAudioFile, samples);    % Извлечение кусочка данных аудиофайла, границы указаны в samples
        
        [~, filename, ext] = fileparts(singleAudioFile);
        name = getName(dirPathTO, filename, '.wav', i);      % Создание имени кусочка аудиофайла
        audiowrite(name, data, fs)                                       % Создание кусочка аудиофайла
                
        startSamples = startSamples + fs*sec;               % Смещение начального значения аргумента samples
        finishSamples = finishSamples + fs*sec;             % Смещение конечного значения аргумента samples
        
        if finishSamples>fullLength
            samples = [finishSamples-fs*sec,fullLength];             % Аргумент samples для функции audioread
            data = audioread(singleAudioFile, samples);    % Извлечение кусочка данных аудиофайла, границы указаны в samples
        
            [~, filename, ext] = fileparts(singleAudioFile);
            name = getName(dirPathTO, filename, ext, i+1);
            audiowrite(name, data, fs)                                       % Создание кусочка аудиофайла
        end        
    end    
end

end

function name = getName(dirPathTO, filename, ext, i)
        name = strcat(dirPathTO, '\', filename, '_', num2str(i), ext);
end