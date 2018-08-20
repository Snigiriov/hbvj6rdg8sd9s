function metricData = Metric(inputData, audiolength)
emotion = [inputData.emotion];
startTime = [inputData.startTime];
endTime = [inputData.endTime];
rms1 = [inputData.rms1];
rms2 = [inputData.rms2];

    function score = SatisfactionScore
        emoObj = EmotionObject;
        score = 0;
        for i = 1:length(emotion)
            if endTime(i) >= audiolength / 4
                score = 2*emoObj.getScore(emotion(i)) + score;
            elseif endTime(i) >= audiolength / 2
                score = emoObj.getScore(emotion(i)) + score;
            end
        end
        score = round(score, 1);
    end

    function aggressionLevel = AggressionLevel
        deltaTime = endTime - startTime;
        aggressionLevel = round(sum(deltaTime(emotion == 2))/audiolength*100, 1);
    end

    function aggressionDynamic = AggressionDynamic
        aggression = find(emotion == 2);

        rms = mean([rms1, rms2], 2);
        [~, i] = max(rms);

        if length(aggression) > 1 && i ~=1
           aggressionDynamic1 = abs(rms(aggression(end)) - rms(aggression(1)))...
               / (startTime(aggression(end)) - endTime(aggression(1)));

           aggressionDynamic2 = abs(rms(aggression(i)) - rms(aggression(1)))...
               / (startTime(aggression(i)) - endTime(aggression(1)));
           aggressionDynamic = max(aggressionDynamic1, aggressionDynamic2);
        else
            aggressionDynamic = 0;
        end

    end

    function nps = NPSprognosis(aggressionLevel)  

    intervals = [{-Inf;30}, {30;40}, {40;50}, {50;60}, {60; 70}, {70; 90}, {90; Inf}];
    answers = [7, 6, 5, 4, 3, 2, 1, 0];
        for i = 1:length(intervals)
            if intervals{1, i} <= aggressionLevel <= intervals{2, i}
                nps = answers(i);
                break
            end
        end 
    end

    function beepsOnly = CheckBeeps
        beepsOnly = false;
        if length(emotion(emotion == 9))/length(emotion)*100 > 80
            beepsOnly = true;
        end
    end

    aggressionLevel = AggressionLevel;
    aggressionDynamic = AggressionDynamic;
    metricData = struct('score', SatisfactionScore,...
           'aggressionLevel', aggressionLevel,...
           'aggressionDynamic', aggressionDynamic,... 
           'nps', NPSprognosis(aggressionLevel),...
           'beepsOnly', CheckBeeps);
end

