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
       sec = 1;                            % ������������ ������ ������� 
    end

    [data, fs] = audioread(singleAudioFile);        % ���������� ���� ���������� ���������� ��� ���������� ���������� ������ ��������
    fullLength = length(data);
    num_full_frames = fix(length(data)/(fs*sec));   % ���������� ���������� ������ ��������
    startSamples = 1;                          % ��� ����� ���� - ��������� �������� ��������� samples 
    finishSamples = fs*sec;                        % ��� ����� ���� - �������� �������� ��������� samples
    
if num_full_frames == 0
        [~, filename, ext] = fileparts(singleAudioFile);
        name = getName(dirPathTO, filename, ext, 0);
        audiowrite(name, data, fs) 
else   
    for i = 1:num_full_frames                               % ��������� �� num_full_frames ��������
        samples = [startSamples,finishSamples];             % �������� samples ��� ������� audioread
        data = audioread(singleAudioFile, samples);    % ���������� ������� ������ ����������, ������� ������� � samples
        
        [~, filename, ext] = fileparts(singleAudioFile);
        name = getName(dirPathTO, filename, '.wav', i);      % �������� ����� ������� ����������
        audiowrite(name, data, fs)                                       % �������� ������� ����������
                
        startSamples = startSamples + fs*sec;               % �������� ���������� �������� ��������� samples
        finishSamples = finishSamples + fs*sec;             % �������� ��������� �������� ��������� samples
        
        if finishSamples>fullLength
            samples = [finishSamples-fs*sec,fullLength];             % �������� samples ��� ������� audioread
            data = audioread(singleAudioFile, samples);    % ���������� ������� ������ ����������, ������� ������� � samples
        
            [~, filename, ext] = fileparts(singleAudioFile);
            name = getName(dirPathTO, filename, ext, i+1);
            audiowrite(name, data, fs)                                       % �������� ������� ����������
        end        
    end    
end

end

function name = getName(dirPathTO, filename, ext, i)
        name = strcat(dirPathTO, '\', filename, '_', num2str(i), ext);
end