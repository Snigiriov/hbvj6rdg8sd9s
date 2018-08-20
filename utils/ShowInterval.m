function showInterval(audio, startSec, finishSec)
    audio = 'E:\NeoSound\GSM mp3\EGYS-20180326-150154-000-8-6901000.mp3';
    startSec = 48;
    finishSec = 51;
    
    [s, fs] = audioread(audio);
    s = Preprocessing(s, fs);
    
    int = s(startSec*fs:finishSec*fs);    
    BeepFinder(int, fs);
    
    fftAbs = abs(fft(int, fs));
    fftAbs = fftAbs(1:round(length(fftAbs)/2));
    semilogx(fftAbs)
    
    
end

