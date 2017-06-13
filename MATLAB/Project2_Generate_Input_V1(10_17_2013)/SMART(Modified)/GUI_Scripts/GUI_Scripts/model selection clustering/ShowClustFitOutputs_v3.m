function ShowClustFitOutputs_v3(clustFitOutputs,traces,numClustersList,alpha,showTraceLabels,LogLogScale,SolidColor)
%plot results

coords = clustFitOutputs{1}.coords;

numParams = size(coords,2); %number of parameters clustered
numTraces = size(coords,1);

lengths = zeros(numTraces,1);
for i = 1:numTraces,
    lengths(i) = length(traces{i});
end

minL = min(lengths);
maxL = max(lengths);
minMarkerSize = 2;
maxMarkerSize = 10;

[lengthsSorted,sortedix] = sort(lengths,'descend'); %plot points in order of decreasing trace lengths to avoid markers overlapping

MarkerColors = [1 0 0 ; 0 1 0 ; 0 0 1 ; 1 0 1 ; 0 1 1 ; 1 1 0 ; 0.5 1 0 ; 1 0.5 0 ; 0 1 0.5 ; 0 0.5 1 ; 1 0 0.5 ; 0.5 0 1];

figure

for numClusters_index = 1:length(numClustersList),
    subplot(1,length(numClustersList)+2,numClusters_index); hold on
    
    clustMembershipP = clustFitOutputs{numClusters_index}.clustMembershipP;
    clustPos = clustFitOutputs{numClusters_index}.clustPos;
    invalidTraces = clustFitOutputs{numClusters_index}.invalidTraces;
    numClusters = numClustersList(numClusters_index);
    for i = 1:numTraces,
        j = sortedix(i);
        if maxL ~= minL,
            markerSize = ((lengths(j) - minL)*maxMarkerSize + (maxL -lengths(j))*minMarkerSize)/(maxL-minL);
        else
            markerSize = 5;
        end
    %     markerSize = ((1/lengths(j) - 1/minL)*maxMarkerSize + (1/maxL - 1/lengths(j))*minMarkerSize)/(1/maxL-1/minL);
        if SolidColor, %assign each trace to cluster
            markerColor = MarkerColors(find(clustMembershipP(j,:) == max(clustMembershipP(j,:)),1,'last'),:);
        else %shade color to represent probability for each cluster
            try
            markerColor = sum(MarkerColors(1:numClusters,:).*(clustMembershipP(j,:)'*ones(1,3)),1);
            catch
                keyboard
            end
        end
%         keyboard
        if ~ismember(j,invalidTraces),
            PlotDim(coords(j,:),markerColor.*0.9999,[1 1 1].*0.2,markerSize,'o');
        else
            PlotDim(coords(j,:),markerColor.*0.9999,[1 1 1].*0.2,markerSize,'x');
        end
        if showTraceLabels,
            ShowTextDim(coords(j,:),num2str(j));
        end
    end
    for i = 1:numClusters,
        
        PlotDim(clustPos(i,:),'none',MarkerColors(i,:)./1.2,20,'o');
        PlotDim(clustPos(i,:),'none',MarkerColors(i,:)./1.2,20,'x');
        PlotDim(clustPos(i,:),'none',MarkerColors(i,:)./1.2,20,'s');
    end
    if LogLogScale,
        set(gca,'xscale','log');
        set(gca,'yscale','log');
    end
    if numParams == 3,
        axis vis3d
    end
    title([num2str(numClusters) ' clusters fit']);
end


% % figure
% subplot(2,1,1)
subplot(1,length(numClustersList)+2,length(numClustersList)+1)
logPxList = zeros(length(numClustersList),1);
BICList = zeros(length(numClustersList),1);
for numClusters_index = 1:length(numClustersList),
    logPxList(numClusters_index) = clustFitOutputs{numClusters_index}.logPx;
    BICList(numClusters_index) = clustFitOutputs{numClusters_index}.BIC;
end
plot(numClustersList,logPxList,'b.-'); hold on
plot(numClustersList,BICList,'r.-'); hold on
legend('logPx','BIC');

% subplot(2,1,2)
subplot(1,length(numClustersList)+2,length(numClustersList)+2)
%get bar plots for cluster occupation fractions
y = zeros(length(numClustersList),max(numClustersList));
for numClusters_index = 1:length(numClustersList),
    minTracesInClust = clustFitOutputs{numClusters_index}.minTracesInClust;
    y(numClusters_index,1:length(minTracesInClust)) = sort(minTracesInClust,'descend');
end
bar(numClustersList,y,'stack');

ylabel('traces in each cluster');
xlabel('number of clusters');

function PlotDim(point,markerFaceColor,markerEdgeColor,markerSize,markerObj) %plots point in dimension dim
dim = size(point,2); %dimension is number of columns
if dim == 1,
    plot(point(1),1,['k' markerObj],'MarkerFaceColor',markerFaceColor,'MarkerEdgeColor',markerEdgeColor,'MarkerSize',markerSize); hold on
elseif dim == 2,
    plot(point(1),point(2),['k' markerObj],'MarkerFaceColor',markerFaceColor,'MarkerEdgeColor',markerEdgeColor,'MarkerSize',markerSize); hold on
elseif dim == 3,
    plot3(point(1),point(2),point(3),['k' markerObj],'MarkerFaceColor',markerFaceColor,'MarkerEdgeColor',markerEdgeColor,'MarkerSize',markerSize); hold on
end

function ShowTextDim(point,string) %shows text in dimension dim
dim = size(point,2); %dimension is number of columns
if dim == 1,
    text(point(1),1,string,'HorizontalAlignment','left','VerticalAlignment','top');
elseif dim == 2,
    text(point(1),point(2),string,'HorizontalAlignment','left','VerticalAlignment','top');
elseif dim == 2,
    text(point(1),point(2),point(3),string,'HorizontalAlignment','left','VerticalAlignment','top');
end