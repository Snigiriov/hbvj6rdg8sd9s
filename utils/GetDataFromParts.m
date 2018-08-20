function data = GetDataFromParts(audio, varargin)
%%  ввод данных (возможен множественный, через пробел или запятую)
%     1 - plotENERGY
%     2 - plotMaxFQ
%     3 - plotMaxEnergy
%% инициализация
Path
parser = inputParser;
parser.addParameter('showGraphics', 'off', @(x)contains(x, {'on'; 'off'}))
parser.addParameter('choose', 1:3)
parser.addParameter('partLength', 0.02)
parser.parse(varargin{:});
showGraphics = parser.Results.showGraphics;
choose = parser.Results.choose;
%%  выбор аудиофайла
[samples, fs] = audioread(audio);
[~,name] = fileparts(audio);
%% анализ аудиофайла
partLength = parser.Results.partLength;               % длина кусочка в секундах
numSamplesFromPart = fs*partLength;                   % количество сэмплов в кусочке
numParts = length(samples)/numSamplesFromPart;        % количество кусочков в аудиофайле
%% проверка, делится ли аудиофайл на кусочки нацело
if fix(numParts) - numParts == 0
    limit = numParts;
else
    limit = numParts-1;
end
%% цикл извлечение данных из каждого кусочка
for k = 1:length(choose)            % обработка множественного выбора
    for i = 1:limit 
    samplesArray = samples((i)*numSamplesFromPart:(i+1)*numSamplesFromPart);
        switch choose(k)
            case 1
                data.energy(i) = ENERGY(samplesArray);
            case 2
                data.fq(i) = maxFQ(samplesArray, fs);
            case 3
                [~, ~, data.maxEnergy(i)] = ENERGY(samplesArray);
        end
    end
end
% построение графиков на основании извлеченных данных
if isequal(showGraphics, 'on')
type = @(x) figure('Name', ['Type: ', x, ', Filename: ', name], 'NumberTitle','off');
    timeArray = (1:limit)*0.02;
    for k = 1:length(choose)    % обработка множественного выбора
        switch choose(k)
            case 1
                axesENERGY = type('Energy');
                plot(axes('parent', axesENERGY), timeArray, data.energy)
            case 2
                axesFQ = type('maxFQ');
                plot(axes('parent', axesFQ), timeArray, data.fq)
            case 3
                axesMaxENERGY = type('MaxEnergy');
                plot(axes('parent', axesMaxENERGY), timeArray, data.maxEnergy)
        end
    end
end
end
%% функция нахождения максимальной частоты
function I = maxFQ(s, fs)
    fftABS = abs(fft(s, fs));
    fftABSnorm = fftABS(1:end/2);
    [~, I] = max(fftABSnorm);
end