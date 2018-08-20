algorithms = {@RecognizeEmotion};
descr = {'Aleksey algorithm'};

for i = 1:length(algorithms)
    fprintf('***************************\n%s\n', descr{i})
    [status] = RecognizeEmotionBatch(algorithms{i});
    if isequal(status, 'incomplete')
        return
    end
end