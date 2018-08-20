function result = BeepFinder(s, fs)
%     fftAbs = abs(fft(audio, fs));
%     fftAbs = fftAbs(1:round(length(fftAbs)/2));
%     fullEnergy = sum(fftAbs);
%     areaEnergy = sum(fftAbs(300:600));
%     
%     result = false;
%     if areaEnergy/fullEnergy*100 > 55
%         result = true;
%     end 
    
    fftAbs = abs(fft(s, fs));
    fftAbs = fftAbs(1:round(length(fftAbs)/2));
    
    [~, i] = max(fftAbs);
    
    fullEnergy = sum(fftAbs);
    areaEnergy = sum(fftAbs(400:500));
    percent = areaEnergy/fullEnergy*100;
    
    result = false;
    if i > 400 && i < 500 && percent > 23
        result = true;
    end 
    
    areaEnergy = sum(fftAbs(700:800));
    percent = areaEnergy/fullEnergy*100;
    
    if i > 700 && i < 800 && percent > 23
        result = true;
    end 
end

