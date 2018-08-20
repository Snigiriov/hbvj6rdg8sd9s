function MatchAudioSample(inputAudio, thresholdRMS, timeThreshold)
[audioData, fs] = audioread(inputAudio);
    loaded = load('audio_temp.mat');
    audiodataLoaded = loaded.audiodataLoaded;

    if EstimateRMS(audioData)>=thresholdRMS 
        audiodataLoaded = cat(1, audiodataLoaded, audioData);
    else        
        if length(audiodataLoaded)/fs >= timeThreshold    
            audiowrite('audio.wav', audiodataLoaded, fs);
        end
        audiodataLoaded = [];
    end
    
    save('audio_temp.mat', 'audiodataLoaded')
end

function sendJSON
    URL = 'https://speech.googleapis.com/v1/speech:recognize';
    data.audio = struct('content', 'audio.wav');
    data.config = struct('enableAutomaticPunctuation','false',...
                         'encoding', 'LINEAR16',...
                         'languageCode', 'es-CL', ...
                         'model', 'default');
%     resp = savejson('', data);
    options = weboptions('MediaType','application/json');
    response = webwrite(URL,data,options);
end