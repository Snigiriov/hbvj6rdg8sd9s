function maxFQ = getMaxFQ(s, fs)

if nargin == 0
    [audioFile, path] = uigetfile({'*.wav';'*.mp3';'*.*'}, 'Select audiofile');
    [s, fs] = audioread(fullfile(path, audioFile));
    
    h = db(abs(fft(s)));
    h = h(1:fix(length(h)/2));

    f = 0:fs/(length(s)):fs-fs/(length(s));
    f = f(1:length(f)/2);
    
    I1 = FQ2Index(0, fs, length(s));
    I2 = FQ2Index(66, fs, length(s));
%     I3 = FQ2Index(7900, f);
%     I4 = FQ2Index(8000, f);
    h(I1:I2) = 0;
%     h(I3:I4) = 0;
    
    semilogx(f, h) 
else
%     [s, fs] = audioread(audiofile);
    h = db(abs((fft(s))));
    h = h(1:fix(length(h)/2));
    
    I1 = FQ2Index(0, fs, length(s));
    I2 = FQ2Index(66, fs, length(s));
    h(I1:I2) = 0;

end

[~, I] = max(h);
maxFQ = round(I*fs/(length(s)));
end

function I = FQ2Index(fcut, fs, lengthS)

    f = 0:fs/lengthS:fs-fs/lengthS;
    f = f(1:fix(length(f)/2));
    f = fix(f);
    
    I = find(f == fcut, 1);

end