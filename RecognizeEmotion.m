function [emotion, percent] = RecognizeEmotion(audio, fs)
%%     configure
Path
    config = loadjson('config.json');
    ClassificationModelName = ['ClassificationModel_',...
                        num2str(length(config.CLASS_NAMES))];
    trainedClass = load(ClassificationModelName);
    trainedClassifier = trainedClass.trainedClassifier;
%%      features array
if ischar(audio)
	featuresArray = ExtractFeatures(audio);
else
    featuresArray = ExtractFeatures(audio, fs);
end
%%      predict emotion by features array  
    [emotion, extEmotion] = trainedClassifier.predictFcn(featuresArray);
    emotion = emotion{1};
%%      get emotion prediction stat in percent 
	toPercent = abs(sum(extEmotion)-extEmotion);
	percent = (toPercent/sum(toPercent))*100;
    percent = round(percent, 2);
end