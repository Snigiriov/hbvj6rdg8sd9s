%%      Prepare training data from audio signal features
disp('**********TRAIN**********')
[status, trainTime] = ConstructFeatures('mode','train');
if isequal(status, 'incomplete')
    disp('*************************')
    fprintf('Operation failed. Elapsed time: %g seconds\n', trainTime)
    return
end
%%     Train emotion recognition model
[status, classifyTime] = Classify;
if isequal(status, 'incomplete')
    disp('*************************')
    fprintf('Operation failed. Elapsed time: %g seconds\n', classifyTime + trainTime)
    return
end
%%     Display model accuracy and time
overallTrainTime = trainTime + classifyTime;
fprintf('Training is complete. Elapsed time: %g seconds\n',overallTrainTime)
%%     Test training model
disp('**********TEST***********')
[status, testTime] = RecognizeEmotionBatch(@RecognizeEmotion);
if isequal(status, 'incomplete')
    disp('*************************')
    fprintf('Operation failed. Elapsed time: %g seconds\n', overallTrainTime + testTime)
    return
end
%%     Display overall time 
disp('*************************')
fprintf('All operations done. Elapsed time: %g seconds\n',...
    overallTrainTime + testTime)