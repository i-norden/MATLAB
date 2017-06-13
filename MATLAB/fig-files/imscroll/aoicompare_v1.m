function pc=aoicompare_v1(inputxy,ghandles,varargin)
%
% function aoicompare_v1(inputxy,ghandles,<pixnumSize>)
%
% This function is intended to help located corresponding aois
% in the Cy3 and and alexa488 aoi lists during the tricolor oligo
% experiment.  We will input the x and y coordinates of one aoi from
% e.g. the Cy3 list, and look for the corresponding aoi in the 
% alexa488 list (aoiinfo2).  The program will find the closest aoi
% in the aoiinfo2 list, and it is up to the user to make the decision
% as to whether those two aois are actually coincident.
%
% inputxy == [x y] the x and y coordinates of our input aoi.  We are
%               trying to find which aoi in the aoiinfo2 list is actually
%               closest spatially to this input aoi
% ghandles == the handles structure from the calling gui.  e.g.
%           handles.FitData = aoiinfo2 (see below)
% aoiinfo2 = list of aois output by imscroll when the user is tracking a
%              time course for the appearence of dye spots
%              [frame#  ave  x   y  pixnum  aoinum (danny's original aoi#)]
% <pixnumSize> == optional input that specifies the size of the aoi that is an 
%            acceptable choice as our output
%
% The function will return the aoinum from the aoiinfo2 list that
% identifies the aoi minimizing:
%   (inputxy(1) - x)^2  + (inputxy(2) - y)^2 )
if nargin==3
            % User input an acceptable aoi size for output choice
    pixnumSize=varargin{1};
end
aoiinfo2=ghandles.FitData;           % Current list of fixed aois (see above)
                                    %
                                    % If we are in a 'moving aois' mode, we
                                    % need to shift the xy coordinates of
                                    % the aois in our list to reflect the
                                    % present frame
[maoi naoi]=size(aoiinfo2);
                                    % maoi = number of aois in our list
OptionalXYshift=zeros(maoi,2);      % Initialize list of xy coordinate shifts

if any(get(ghandles.StartParameters,'Value')==[2 3 4])
                                    % Here if we are in a 'moving aoi mode'
    imagenum=get(ghandles.ImageNumber,'value');        % Retrieve the value of the slider
    imagenum= round(imagenum);

    for indx=1:maoi
                                    % Go through all aois and compute the
                                    % relevant xy shift of the aoicenter
     
        OptionalXYshift(indx,:)=ShiftAOI(indx,imagenum,aoiinfo2,ghandles.DriftList);
     
    end
else
end

                                    % Correct the xy centers of the aois
                                    % using the above computed
                                    % OptionalXYshift (will be zero
                                    % correction if we are not in 'moving
                                    % aoi' mode

aoiinfo2(:,3:4)=aoiinfo2(:,3:4)+OptionalXYshift; 
                                    
distancelist=[(aoiinfo2(:,3)-inputxy(1)).^2+(aoiinfo2(:,4)-inputxy(2)).^2 aoiinfo2(:,5:6)];
                                     % [distance pixnum aoinumber]
                                     % The above computes the distances
                                     % between the input aoi and all the
                                     % aois in the aoiinfo2 list
if nargin==3    
                    % Pick out only those aois of the correct size
    logik=distancelist(:,2)==pixnumSize;
    distancelist=distancelist(logik,:);
end
[sortdistance I]=sort(distancelist(:,1));   % Now sort list (ascending)
pc=distancelist(I(1),3);                    % Get the aoi number of the aoi in aoiinfo2
                                            % that is closest to the input
                                            % aoi
                                        
                                           
