function CleanAudio(audio)
    [s, fs] = audioread(audio);
%%   Основные шаманства  
    [~, numChannels] = size(s);
for i = 1:numChannels
    s(:, i) = Remaking(s(:, i), fs);
    maxPS = max(s( s(:, i)>0, i));
    maxNS = min(s( s(:, i)<0, i));
    m = max(maxPS, abs(maxNS));
	ts(:, i) = s(:, i).*(1/m);
end
%%  Создание аудиозаписи
    [folder, name] = fileparts(audio);
    filename = [folder, '/', name, '_cleaned', '.wav'];
    audiowrite(filename, s, fs)  
end