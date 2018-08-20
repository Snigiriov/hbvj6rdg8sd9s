function ClusterAnalyze
%%      Get features array
ConstructFeatures('mode', 'cluster')
%%      Extract data to workspace
clusterFeatures = load('clusterFeatures.mat');
clusterFeatures = clusterFeatures.featuresTable;
%%      Configuration
config = loadjson('config.json');
classnames = string(config.CLASS_NAMES);
emoCountPredicted = zeros(1,length(classnames));
emoCountOriginal = zeros(1,length(classnames));       
copyTo = 'E:\\cluster\';
maxClust = 4;

%%      Cluster analyze
emoNumberOriginal = table2array(clusterFeatures(:, 2));
emoNumberPredicted = clusterdata(clusterFeatures.features, 'maxclust', maxClust);

for i = 1:length(emoNumberOriginal)
    emoCountOriginal(emoNumberOriginal(i)) = 1 + emoCountOriginal(emoNumberOriginal(i));
    emoCountPredicted(emoNumberPredicted(i)) = 1 + emoCountPredicted(emoNumberPredicted(i));
%     emoCountPredicted(emoNumberOriginal(i)) =...
%     isequal(emoNumberOriginal(i), emoNumberPredicted(i)) + emoNumberPredicted(i);
end
emoCountPredicted
emoCountOriginal
%%      Copy files from source folder to destination folder as clusters
% for i = 1:length(clusterizedArray)
%     folderpath = fullfile(copyTo, num2str(clusterizedArray(i)));
%     
%     if ~exist(folderpath, 'dir')
%         mkdir(folderpath);
%     end
%     
%    copyfile(clusterFeatures.pathTo{i}, folderpath)
% end

end