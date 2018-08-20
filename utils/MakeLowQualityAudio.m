function MakeLowQualityAudio(audio)
[s, fs] = audioread(audio);

s = diff(s);

s(2:2:end) = s(2:2:end) + 0.1;
s(1:3:end) = s(1:3:end) - 0.1;

    [folder, name] = fileparts(audio);
    filename = [folder, '/', name, '_low_level', '.wav'];
    audiowrite(filename, s, fs)  
