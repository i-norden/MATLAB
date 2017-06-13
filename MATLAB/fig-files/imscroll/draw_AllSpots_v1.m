function pc=draw_AllSpots_v1(AllSpots,frame,driftlist,varargin)
% function draw_AllSpots_v1(AllSpots,frame,driftlist,<UniqueLandingRadius>,<MinimumLandingNumber>,<DrawUniqueBoxes>)
%
% Will draw all the spots detected by the auto spot picker in imscroll and
% stored in the AllSpots structure.  The spots will be drawn at their
% location in the specified 'frame' using the driftlist to compensate for
% drift.  If UniqueLandingRadius is specified the function will output an
% aoiinfo2 structure containing a list of aois located at the landing sites.  
% Those aois (landings) are culled so that no two aois will be closer than
% a distance specified by UniqueLandingRadius (units: pixels)
%
% AllSpots == structure stored by imscroll following auto spot picking of
%            fluorescent spots throughout a specified framed range
% frame == all the detected spots will be drift corrected and plotted at
%         their xy location in this 'frame'.  
% driftlist = [frm#  deltax   deltay  (glimpse time)] driftlist that will
%           be used to correct locations of the detected spots
% UniqueLandingRadius == <optional> the list of output aois in aoiinfo2 will be culled 
%                        so that no two aois will be closer than a distance
%                        specified by UniqueLandingRadius (units: pixels)
% MinimumLandingNumber == <optional> minimum number of landings necessary to be
%                    included in the output list of unique aoi groupings
% DrawUniqueBoxes == <optional> any entry (e.g. = 0,1,'Y',etc)
%                     will mean that the unique boxes (subject to
%                     MinimumLandingNumber) are also to be drawn
%  ********************************
% OUTPUT WILL BE IN THE FORM OF A STRUCTURE WITH MEMBERS DEFINED AS:
% out.xytotal = [x y] list of ALL drift-corrected landing locations
%
% out.UniqueXY = [x  y  (number of landings)] 
%       =[(unique, averaged landing group xy locations)  (number of landings in this grouping)]
%
% out.aoiinfo2 = [(frame#)    ave     x     y     pixnum     aoi#  ]

% v1 Larry F. 4-18-2012 added aoiinfo2 structure as output along with the 
%    specification of unique landings (unique aois), 3 optional arguements
frms=AllSpots.FrameVector;      % List of frames over which we found spots
        
[rose col]=size(frms);
        
 hold on 
 landingcount=0;        % landingcount == total number of landings found for all the frames
for indx=1:max(rose,col)
                        % count the total number of landings
   spotnum=AllSpots.AllSpotsCells{indx,2}; % number of spots found in the current frame     
   landingcount=landingcount+spotnum;
end
xytot=zeros(landingcount,2);        % Reserve space for the list of all landing xy pairs
totindx=1;                          % Running index into the xytot matrix;
for indx=1:max(rose,col)                           % Cycle through frame range
    XYshift=[0 0];                  % initialize aoi shift due to drift
                    
                    
                                    % Fake aoiinfo structure (one entry) specification frame being the indx (i.e. frame for spot detection)  
    aoiinfo=[indx 1 0 0 5 1];
                                    % Get the xy shift that moves each spot detected in frame=indx to the current frame=imval   
    XYshift=ShiftAOI(1,frame,aoiinfo,driftlist);
                 
            
    spotnum=AllSpots.AllSpotsCells{indx,2}; % number of spots found in the current frame
    xy=AllSpots.AllSpotsCells{indx,1}(1:spotnum,:);     % xy pairs of spots in current frame
       
    xy(:,1)=xy(:,1)+XYshift(1);     % Offset all the x coordinates for the detected spots
    xy(:,2)=xy(:,2)+XYshift(2);     % Offset all the y coordinates for the detected spots
    xytot(totindx:totindx+spotnum-1,:)=xy;  % Add the xy list from this frame to the total list
    totindx=totindx+spotnum;        % Increment the index for the xytot array
    %plot(xy(:,1),xy(:,2),'ro','MarkerSize',3.0);                % Plot the spots for current frame
end
plot(xytot(:,1),xytot(:,2),'ro','MarkerSize',3.0); 
hold off
pc.XYtotal=xytot;
pc.XYtotalDescription='[x y] list of all drift-corrected landing locations'; 
inlength=length(varargin);
if inlength>0
                            % Here to make output aoiinfo2 structure for
                            % the landings.  We will remove excess landings
                            % by grouping landings into aois that are a
                            % minimum distance between one another
   
    UniqueLandingRadius=varargin{1}(:); 
    UniqueXY=Find_Unique_xy(xytot,UniqueLandingRadius);
    pc.UniqueXY=UniqueXY.UniqueList;    % List of unique xy locations at the positions of averaged grouped landings 

    pc.UniqueXYDescription='[x  y  (number of landings)] = [(unique, averaged landing group xy locations)  (number of landings in this grouping)]';
    [urose ucol]=size(pc.UniqueXY);           % Get dimensions of unique site list
    aoiinfo2=zeros(urose,6);                    % Allocate space for aoiinfo2 output matrix
        % aoiinfo2 = [(frame#)          ave           x  y     pixnum        aoi#  ] 
    %keyboard
    aoiinfo2=[frame*ones(urose,1) ones(urose,1) pc.UniqueXY(:,1:2) 5*ones(urose,1) [1:urose]'];
    pc.aoiinfo2=aoiinfo2;
    pc.aoiinfo2Description = '[(frame#)    ave     x     y     pixnum     aoi#  ]';
    
                            
end                     % end of if inlength>0
if inlength>1
                % Here to limit the aoiinfo2 list to those xy locations
                % having at least a number of landings equal to 'MinimumLandingNumber'
    MinimumLandingNumber=varargin{2}(:);
    logik=pc.UniqueXY(:,3)>=MinimumLandingNumber;   % number of landings is >= MinimumLandingNumber
    pc.aoiinfo2=pc.aoiinfo2(logik,:);
end
if inlength>2
                % Here to draw the unique aoi boxes
    draw_aois(pc.aoiinfo2,1,5,[1 0 0]);
end    

    