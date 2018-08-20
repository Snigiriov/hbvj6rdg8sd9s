classdef EmotionObject

    properties (Constant, Access = private)
        classNames = {'Joy', 'Negative', 'Neutral', 'Sadness', 'Trash', 'Beep'}
        colors = {'y', 'r', 'g', 'b', 'w', 'k'}
        scores = [75, 10, 50, 25, 0, 0]
        mapObjNumbers = containers.Map(EmotionObject.classNames,1:length(EmotionObject.classNames));
        mapObjColors = containers.Map(EmotionObject.classNames,EmotionObject.colors);
        mapObjScores = containers.Map(1:length(EmotionObject.classNames), EmotionObject.scores)
    end
    
    methods
    	function number = getNumber(obj, emo)
            number = obj.mapObjNumbers(emo);
        end
        
        function color = getColor(obj, emo)
            color = obj.mapObjColors(emo);
        end
        
        function emotion = getEmotionName(obj, filename)
            emotion = 'Unknown'; 
            for i = 1:length(obj.classNames)
                if contains(filename, obj.classNames{i})
                    emotion = obj.classNames{i};
                    break
                end
            end
        end
        
        function score = getScore(obj, emo)
        	score = obj.mapObjScores(emo);
        end
    end
end

