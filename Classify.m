function [status, elapsedTime] = Classify
tic
try
% Extract predictors and response
Path
config = loadjson('config.json');
classifier = config.CLASSIFIER;
classNames = string(config.CLASS_NAMES);
numEmotions = num2str(length(classNames));

trainingData = load(['featuresTable_',numEmotions,'.mat']);
trainingData = trainingData.featuresTable;
predictors = trainingData.features;
response = trainingData.emotion;

% Train a classifier
switch classifier
    case 'LINEAR_DISCRIMINANT'
        classification = fitcdiscr(...
            predictors, ...
            response, ...
            'DiscrimType', 'linear', ...
            'Gamma', 0, ...
            'FillCoeffs', 'off', ...
            'ClassNames', classNames);
    case 'KNN'
        classification = fitcknn(...
            predictors, ...
            response, ...    
            'Distance', 'Euclidean', ...
            'Exponent', [], ...
            'NumNeighbors', 1, ...
            'DistanceWeight', 'Equal', ...
            'Standardize', true, ...
            'ClassNames', classNames);
    case 'SVM'
        template = templateSVM(...
            'KernelFunction', 'polynomial', ...
            'PolynomialOrder', 2, ...
            'KernelScale', 'auto', ...
            'BoxConstraint', 1, ...
            'Standardize', true);
        classification = fitcecoc(...
            predictors, ...
            response, ...
            'Learners', template, ...
            'Coding', 'onevsone', ...
            'ClassNames', classNames);
    case 'DECISION_TREE'
        classification = fitctree(...
            predictors, ...
            response, ...    
            'SplitCriterion', 'gdi', ...
            'MaxNumSplits', 4, ...                                                
            'Surrogate', 'off', ...
            'ClassNames', classNames);
end

% Create the result struct with predict function
trainedClassifier.predictFcn = @(x) predict(classification, x);

% Perform cross-validation
partitionedModel = crossval(classification, 'KFold', config.KFOLD);

% Compute validation accuracy
validationAccuracy = 1 - kfoldLoss(partitionedModel, 'LossFun', 'ClassifError');

save(['ClassificationModel_', numEmotions, '.mat'], 'trainedClassifier')

status = 'complete';
elapsedTime = toc;
fprintf('Creating classifying model is %s. ' ,status)
fprintf('Validation accuracy is %g%%. Elapsed time: %g seconds\n', ...
        validationAccuracy*100, elapsedTime)
catch exception
    status = 'incomplete';
    message = exception.message;
    fprintf('Creating classifying model is %s, cause: %s \n', status, message)
    elapsedTime = toc;
end

end