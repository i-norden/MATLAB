function ShowHMM_mod(A,colored)
%shows HMM graphically, emission matrix E can be cell array or matrix  
nStates = size(A,1);

%get state lifetimes
lifetimes = 1./(1 - diag(A));

%set plot parameters  
stateCircR = 0.2;  
stateCircCent = [0.5 ; 0.5];
maxStateBoxEdge = 0.1;
minStateBoxEdge = 0.05;
stateBoxEdgeLengths = (lifetimes).*maxStateBoxEdge./max((lifetimes));
maxArrowWidth = 1;
minArrowWidth = 2;
allDispVector = [0 ; 0];
figureColor = [1 1 1].*0.9;

%get positions of states and arrows on circle
stateBoxPositions = zeros(nStates,2); %x and y positions of state boxes  
arrowStatePositions = zeros(nStates,nStates,4);
stateColors = zeros(nStates,3);
lineWidths = zeros(nStates,nStates);
deltaTheta = 2*pi/nStates;
thetaPhase = pi;
for i = 1:nStates,
    stateBoxPositions(i,1) = stateCircCent(1) + 1.5 * stateCircR*cos((i-1)*deltaTheta+thetaPhase) + allDispVector(1);
    stateBoxPositions(i,2) = stateCircCent(2) + 1.5 * stateCircR*sin((i-1)*deltaTheta+thetaPhase) + allDispVector(2);
end


for i = 1:nStates,
    for j = 1:nStates,
        if i~=j,
            if colored,
                arrowScale = 1.5;
            else            
                arrowScale = 1.2;
            end
            arrowStatePositions(i,j,1) = stateCircCent(1) + arrowScale * stateCircR*cos((i-1)*deltaTheta+thetaPhase) + allDispVector(1);% + 0.1 * stateCircR*
            arrowStatePositions(i,j,2) = stateCircCent(2) + arrowScale * stateCircR*sin((i-1)*deltaTheta+thetaPhase) + allDispVector(2);
      
            if i > j,
                s = -0.1;
            else
                s = 0.1;
            end
            arrowStatePositions(i,j,3) = stateCircCent(1) + arrowScale * stateCircR*cos((j-1)*deltaTheta+thetaPhase) + allDispVector(1);
            arrowStatePositions(i,j,4) = stateCircCent(2) + arrowScale * stateCircR*sin((j-1)*deltaTheta+thetaPhase) + allDispVector(2);
        
            dispVector = s*1*stateCircR.*[cos((j-i)*deltaTheta/2 + (i-1)*deltaTheta+thetaPhase) sin((j-i)*deltaTheta/2 + (i-1)*deltaTheta+thetaPhase)];
            arrowStatePositions(i,j,1) = arrowStatePositions(i,j,1) + dispVector(1) + allDispVector(1);
            arrowStatePositions(i,j,2) = arrowStatePositions(i,j,2) + dispVector(2) + allDispVector(2);
            arrowStatePositions(i,j,3) = arrowStatePositions(i,j,3) + dispVector(1) + allDispVector(1);
            arrowStatePositions(i,j,4) = arrowStatePositions(i,j,4) + dispVector(2) + allDispVector(2);
            
            %shorten arrows by 0.9
            
        end
    end
end
%figure

for i = 1:nStates,
    for j = 1:nStates,
        if i~=j, %do not show transitions back to state  
                
            
           arrow(cax, [arrowStatePositions(i,j,1) arrowStatePositions(i,j,3)],[arrowStatePositions(i,j,2) arrowStatePositions(i,j,4)])
          % annotation('arrow',[arrowStatePositions(i,j,1) arrowStatePositions(i,j,3)],[arrowStatePositions(i,j,2) arrowStatePositions(i,j,4)],...
           %         'HeadStyle','plain','HeadWidth',4,'LineWidth',1);

        end
    end
end
% stateColors
%position states around circle
for i = 1:nStates,  
%     if colored,
%         bColor = stateColors(i,:);
%     else
        bColor = [1 1 1].*0.9;
 %   end
    annotation('textbox',[(stateBoxPositions(i,1)-stateBoxEdgeLengths(i)/2) (stateBoxPositions(i,2)-stateBoxEdgeLengths(i)/2) stateBoxEdgeLengths(i) stateBoxEdgeLengths(i)],...
        'BackgroundColor',bColor.*0.9);
    annotation('textbox',[(stateBoxPositions(i,1)-stateBoxEdgeLengths(i)/2) (stateBoxPositions(i,2)-stateBoxEdgeLengths(i)/2) stateBoxEdgeLengths(i) stateBoxEdgeLengths(i)],...
        'BackgroundColor','none','EdgeColor','none','Color',[0 0 0],'String',num2str(i),...
        'HorizontalAlignment','Center','VerticalAlignment','Middle');
end

%set(gcf,'Color','w');

%set(gcf,'Position',[1261         694         275         211])

