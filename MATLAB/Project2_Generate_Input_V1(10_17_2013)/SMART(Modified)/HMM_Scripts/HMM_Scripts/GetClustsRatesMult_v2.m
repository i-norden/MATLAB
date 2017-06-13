function clustFitOutputs = GetClustsRatesMult_v2(HMMFitOutputs,cov_mats_string,numClustersList)
%check that all outputs have covariance matrices of type cov_mats_string
cov_matsList = cell([length(HMMFitOutputs) 1]);
pointsList = cell([length(HMMFitOutputs) 1]); %list of coordinates to cluster



cov_mats_string = AddParensForRegExp(cov_mats_string);
paramsToTry = regexp(cov_mats_string,'(?<={)[^{}]*(?=})','match');
varsstr = regexp(paramsToTry{1},'[ae]\(\d*(,\d*)*\)','match');

for i = 1:length(HMMFitOutputs),
    match = false;
    for j = 1:length(HMMFitOutputs{i}.covmats),
        namesMatch = [];
        if length(HMMFitOutputs{i}.covmats{j}.varnames) == length(varsstr),
            namesMatch = true;
            for k = 1:length(varsstr),
                namesMatch = namesMatch & strcmp(HMMFitOutputs{i}.covmats{j}.varnames{k},varsstr{k});
            end
        else
            namesMatch = false;
        end
        if namesMatch,
            ixCovMat = j;
        end
        match = match | namesMatch;
    end
    if ~match,
        disp(['warning: did not find covariance matrix for ' paramsToTry{1} ' in output ' num2str(i)])
        disp('this HMM fit output will be omitted in clustering');
        cov_matsList{i} = [];
    else
        cov_matsList{i} = HMMFitOutputs{i}.covmats{ixCovMat}.C;
    end
    pointsList{i} = [];
    for j = 1:length(varsstr),
        if strcmp(varsstr{j}(1),'a'),
            [r,c] = GetNumsFromString_(varsstr{j});
            pointsList{i} = [pointsList{i} HMMFitOutputs{i}.A(r,c)];
        elseif strcmp(varsstr{j}(1),'e'),
            [n,c,p] = GetNumsFromString_(varsstr{j});
            pointsList{i} = [pointsList{i} HMMFitOutputs{i}.E{n,c}(p)];
        end
    end
end
% keyboard
%fit multiple clusters, cluster number list in numClustersList, to data
clustFitOutputs = cell([length(numClustersList) 1]);
for i = 1:length(numClustersList),
    tic
    clustFitOutputs{i} = GetClustsRates_v4_(pointsList,cov_matsList,numClustersList(i));
    disp(['Cluster ' num2str(i) ' of ' num2str(length(numClustersList))  ' took'])
    toc
end
% 
% %show summary of output
% numClustsToShow = 2; %how many clusters fit to show
% showTraceLabels = false;
% LogLogScale = true;
% SolidColor = true;
% 
% alpha = 0.05; %confidence level
% ShowClustFitOutputs(clustFitOutputs,2,HMMFitOutputs,traces,alpha,showTraceLabels,LogLogScale,SolidColor);
% ShowClustFitOutputs(clustFitOutputs,3,HMMFitOutputs,traces,alpha,showTraceLabels,LogLogScale,SolidColor);