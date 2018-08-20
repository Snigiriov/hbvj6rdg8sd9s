function features = ExtractFeatures(audio, fs)
%%  get audio
    if ischar(audio)
        [s, fs] = audioread(audio);
    else
        s = audio;
    end
%%      preprocessing
%     s = Preprocessing(s, fs);
%%      extracting features
    mfcc = MFCC(s, fs);
    f = Formants(s, fs);
    lp = real(ifft(lpc(s, 1)));
   %%      construct estimated features to one row
    features = [mfcc, min(f), lp];
%%      normalize feature vector
%     m = mean(features);
%     s = std(features);
%     features = (features-m)./s;
end