function bestOutputsSoFar = GetClustsRates_v4_(pointsList,cov_matsList,numClusters)
numTraces = length(cov_matsList);
numParams = length(pointsList{1}); %number of entries is number of parameters to cluster
invalidTraces = []; %set of traces not used in clustering because covariance matrix was not calculated

%get coords
coords = zeros(numTraces,numParams);
for i = 1:numTraces,
    for j = 1:numParams,
        coords(i,j) = pointsList{i}(j);
    end
end

% method = 'kmeans'; %'em';
clustPrec = 0.001; %max deviation of cluster center at next iteration
maxIter = 200; %maximum number of iterations

numInitialSamples = 10; %number of times to try reseeding

% w = 1; %weighting power

bestOutputsSoFar = []; %stores output corresponding to initial sample with highest logPx so far

for initialSamples_idx = 1:numInitialSamples,
    %get initial cluster centers
    clustPos = zeros(numClusters,numParams);
    clustFrac = ones(numClusters,1)./numClusters; %expected fraction of traces from each cluster
    %     jList = [1:38 154 40];% [214 42 242];%[159 199 40 200 230];
    
    initialIndices = zeros(1,numClusters);
    for i = 1:numClusters,
        %sample randomly from available traces, choose distinct traces
        
        while initialIndices(i) == 0 || length(unique(initialIndices(1:i))) < min(i,numTraces), 
                            %do not try to get more different starting indices then traces
            initialIndices(i) = ceil(random('unif',0,numTraces));
        end
        
        
        clustPos(i,:) = coords(initialIndices(i),:);
    %         clustPos(i,:) = ratesMat(jList(i),:); 
    end
%     initialIndices
%     clustPos
%     pause
    numIter = 1;
    posprecisionreached = 0; %run until precision in cluster positions reached
    while ~posprecisionreached,
        %evaluate approximate logPx at each trace
        logPxListClust = zeros(numTraces,numClusters);
    %             clustPos
    %     tic
        for j = 1:numTraces,
%             coords_traces_rel_to_clust = clustPos - (ones(numClusters,1)*AToCoords(HMMFitOutputs{j}.A));
            coords_traces_rel_to_clust = clustPos - (ones(numClusters,1)*coords(j,:));
            C = cov_matsList{j};
            if ~isempty(C),
%                 if max(max(chol(C))) >= 1,
%                     L = zeros(size(C));
%                     invalidTraces = [invalidTraces j];
%                 else
                    L = chol(inv(C),'lower');
%                 end
            else
                invalidTraces = [invalidTraces j];
                L = zeros(numParams);
            end
                
            logPxListClust(j,:) = -0.5*sum((L'*coords_traces_rel_to_clust').^2,1);

    %                     logPxListClust2(j,i) = LogPxWith_E_faster_(A,HMMFitOutputs{j}.E,HMMFitOutputs{j}.fitChannelType,traces{j}.data);
    %                     mvnpdf(coords,zeros(1,numParams),C).*(((2*pi)^(numParams/2))*sqrt(det(C)));
        end
        %get probability from each cluster
        clustMembershipP = zeros(numTraces,numClusters);
        for i = 1:numTraces,
    %                 clustMembershipP2(i,:) = PxListClust(i,:).*clustFrac';   
            clustMembershipP(i,:) = exp(logPxListClust(i,:)-max(logPxListClust(i,:))).*clustFrac';
            if sum(clustMembershipP(i,:)) > 0,
                clustMembershipP(i,:) = clustMembershipP(i,:)./sum(clustMembershipP(i,:)); %normalize to sum to 1
            else
                clustMembershipP(i,:) = ones(1,numClusters)./numClusters;
            end
        end
    %             pause
        %update cluster positions, weight by tracelength^w
        clustPos_ = clustPos.*0;
        for i = 1:numClusters,
            for j = 1:numTraces,
                clustPos_(i,:) = clustPos_(i,:) + (coords(j,:)).*clustMembershipP(j,i);%.*(lengths(j)^w);
            end
            clustPos_(i,:) = clustPos_(i,:)./(sum(clustMembershipP(:,i)));%.*lengths.^w));
        end

        %update cluster fraction
        clustFrac_ = mean(clustMembershipP)';
    %             clustFrac = clustFrac + ones(numClusters,1)./(1*numClusters);
    %             clustFrac = clustFrac./sum(clustFrac);

        %check to see if minimum precision reached
        clustPosDev = max(max(abs((clustPos_ - clustPos)./clustPos)));
        clustFracDev = max(abs((clustFrac_ - clustFrac)./clustFrac));

        if max(clustPosDev,clustFracDev) <= clustPrec, %check whether clustFrac changed too
            posprecisionreached = 1;
        end

        clustPos = clustPos_;
        clustFrac = clustFrac_;    

        %check to see if max iteration number reached
        if numIter >= maxIter,
            posprecisionreached = 1;
%             disp(['warning: fit to ' num2str(numClusters) ' did not converge before max iter ' num2str(maxIter)]);
        else
            numIter = numIter + 1;
        end
    end
    
    logPxTracesList = zeros(numTraces,1);
    for i = 1:numTraces,
        maxLogPxOverClusts = max(logPxListClust(i,:)+log(clustMembershipP(i,:)));
        logPxTracesList(i) = log(sum(exp(logPxListClust(i,:)-maxLogPxOverClusts).*clustMembershipP(i,:)))+maxLogPxOverClusts;
    end
    
    %store outputs if best so far
    updateBestSoFar = false;
    if initialSamples_idx == 1,
        updateBestSoFar = true;
    else
        if sum(logPxTracesList) > sum(bestOutputsSoFar.logPxTracesList),
%             disp(initialSamples_idx)
%             'here2'
            updateBestSoFar = true;
        end
    end
%     sum(logPxTracesList)
%     clustPos
%     disp(initialSamples_idx)
%     disp(initialIndices)
%     pause

%     clustPos
%     pause
    if updateBestSoFar,
        bestOutputsSoFar.clustPos = clustPos;
        bestOutputsSoFar.clustFrac = clustFrac;
        bestOutputsSoFar.logPxListClust = logPxListClust;
        bestOutputsSoFar.logPxTracesList = logPxTracesList;
        bestOutputsSoFar.clustMembershipP = clustMembershipP;
        bestOutputsSoFar.numIter = numIter;
        bestOutputsSoFar.initialIndices = initialIndices;
        
        %count number of traces assigned to each cluster
        minTracesInClust = zeros(size(clustFrac));
        for i = 1:numClusters,
            for j =1:numTraces,
                r = find(clustMembershipP(j,:) == max(clustMembershipP(j,:)),1,'first');
                if r == i,
                    minTracesInClust(i) = minTracesInClust(i) + 1;
                end
            end
        end
        bestOutputsSoFar.minTracesInClust = minTracesInClust;
        
        bestOutputsSoFar.logPx = sum(logPxTracesList);
        bestOutputsSoFar.BIC = -2*sum(logPxTracesList) + numClusters*numParams*log(numTraces);
    end
end
% disp(bestOutputsSoFar.numIter)
bestOutputsSoFar.coords = coords;
bestOutputsSoFar.numClusters = numClusters;
bestOutputsSoFar.invalidTraces = unique(invalidTraces);

for i = 1:numTraces,
%         pvalueslist(i) = 1-chi2cdf(-2*log(sum(exp(logPxListClust(i,:)+0*log(clustFrac')))),numRates+0*(numClusters-1));

    pvalueslist(i) = sum((1-chi2cdf(-2*bestOutputsSoFar.logPxListClust(i,:),numParams)).*bestOutputsSoFar.clustMembershipP(i,:));
%         pvalueslist(i) = 1-chi2cdf(sum(-2*(logPxListClust(i,:)+log(clustFrac'))),numRates*numClusters);
end
bestOutputsSoFar.pvalueslist = pvalueslist;



% 
% %return best parameters
% clustPos = bestOutputsSoFar.clustPos;
% clustFrac = bestOutputsSoFar.clustFrac;
% logPxListClust = bestOutputsSoFar.logPxListClust;
% logPxTracesList = bestOutputsSoFar.logPxTracesList;
% clustMembershipP = bestOutputsSoFar.clustMembershipP;
% numIter = bestOutputsSoFar.numIter;
% initialIndices = bestOutputsSoFar.initialIndices;
