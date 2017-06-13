function [aoifits] = Gen_aoifits_FRET(aoifits)
% This function Gen_aoifits_FRET(aoifits) uses a loaded aoifits structure
% that has been prepared with 2 background boxes has been integrated, and
% averages the background over the frames it is analyzed over and
% calculates an uncorrected FRET Efficiency cell, as well as
% manipulating the cells that describe the centers so that they only
% describe the centers for the corrected AOI numbers.

%   This function Gen_aoifits_FRET(aoifits) uses a loaded aoifits

%derive foldstruc.Pixnums

foldstruc.Pixnums=sort(unique(aoifits.data(:,9)));

%Describe analysis and make a blank analysis vector
aoifits.analysisDescription='[aoinumber framenumber xcenter ycenter Adj_I_Acceptor Adj_I_Donor Total_I FRET]';
aoifits.analysis=[];

%Start loop, from 1 to half max of AOI numbers
for aoinum=1:(max(aoifits.data(:,10))/2);
analysis=[];
analysis_short=[];

%Generate logicals
logik_long_small=(aoifits.data(:,10)==aoinum) & (aoifits.data(:,9)==foldstruc.Pixnums(1));
logik_long_med=(aoifits.data(:,10)==aoinum) & (aoifits.data(:,9)==foldstruc.Pixnums(2));
logik_long_big=(aoifits.data(:,10)==aoinum) & (aoifits.data(:,9)==foldstruc.Pixnums(3));
logik_short_small=(aoifits.data(:,10)==((max(aoifits.data(:,10)))/2+aoinum)) & (aoifits.data(:,9)==foldstruc.Pixnums(1));
logik_short_med=(aoifits.data(:,10)==((max(aoifits.data(:,10)))/2+aoinum)) & (aoifits.data(:,9)==foldstruc.Pixnums(2));
logik_short_big=(aoifits.data(:,10)==((max(aoifits.data(:,10)))/2+aoinum)) & (aoifits.data(:,9)==foldstruc.Pixnums(3));

% generate row by row of analysis
analysis=[aoifits.data(logik_long_small,10) aoifits.data(logik_long_small,2)...
aoifits.data(logik_long_small,4) aoifits.data(logik_long_small,5)...
 (aoifits.data(logik_long_small,8)-(mean(aoifits.data(logik_long_big,8))-mean(aoifits.data(logik_long_med,8)))*foldstruc.Pixnums(1)^2/(foldstruc.Pixnums(3)^2-foldstruc.Pixnums(2)^2))...
 (aoifits.data(logik_short_small,8)-(mean(aoifits.data(logik_short_big,8))-mean(aoifits.data(logik_short_med,8)))*foldstruc.Pixnums(1)^2/(foldstruc.Pixnums(3)^2-foldstruc.Pixnums(2)^2))];
analysis=[analysis (analysis(:,5)+analysis(:,6))];
analysis=[analysis (analysis(:,5)./analysis(:,7))];

analysis_short=[aoifits.data(logik_short_small,10) aoifits.data(logik_short_small,2)...
 aoifits.data(logik_short_small,4) aoifits.data(logik_short_small,5)...
 analysis(:,5:8)];

aoifits.analysis=[aoifits.analysis;analysis;analysis_short];

end

logik_centers=aoifits.analysis(:,2)==min(aoifits.analysis(:,2));
aoifits.centers=aoifits.analysis(logik_centers,3:4);
Y=aoifits.aoiinfo2(1,1);
aoifits.aoiinfo2=[aoifits.analysis(logik_centers,2) aoifits.analysis(logik_centers,2) aoifits.analysis(logik_centers,3:4) aoifits.analysis(logik_centers,2) aoifits.analysis(logik_centers,1)];
aoifits.aoiinfo2(:,2)=Y;
aoifits.aoiinfo2(:,5)=foldstruc.Pixnums(1);

end

