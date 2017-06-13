function pc=proximity_mapping(mappingpoints,xyin,numpoints,fitparmvector0,outfield)
%
% function proximity_mapping(mappingpoints,xyin,numpoints,fitparmvector0,outfield)
%
% This function will map between fields using a restricted set from the
% list in mappingpoints to determine a set of mapping fit parameters (fitparmvector)
% Specifically, we will use a number of the mappingpoints 'numpoints' 
% that lie closest to the input point xyin=[xin yin] to determine the mapping
% fit parameters fitparmvector.
%
% mappingpoints == the Nx12 set of points from the mapping gui used for mapping
%              between the fields.  The form is
% [frm#1   ave1  x1  y1  pixnum1  aoinum1   frm#2  ave2 x2 y2 pixnum2 aoinum2] 
%
% xyin == [xin yin] xy pair of input points that will be mapped to the other field
% numpoints== the number of closest xy pairs to use from the mappingpoints
%         list.  For example, with numpoints=15 we use the 15 points in the
%         mappingpoints list that lie closest to the [xin yin] input pair
% fitparmvector0== the fitparmvector likely stored already from the mapping
%         gui.  This will be used as a starting parameter for the fits
%         performed in this routine
% outfield == 1 if we are mapping from field 2 to field 1 (xyin is from field2)  
%             2 if we are mapping from field 1 to field 2 (xyin is from field 1)  
%          
% The output will be a single xy pair [xout yout]
[rose col]=size(mappingpoints);
if rose<numpoints
                % If the number of points in mappingpoints is smaller than numpoints, 
                % we use the entire mappingpoints array
    numpoints=rose;
end
if outfield==1
                    % Here if our output field is field 1 (xyin is from field2)
                    % Calculate distances from field2 points:
    distance=( mappingpoints(:,9)-xyin(1) ).^2 + (mappingpoints(:,10)-xyin(2) ).^2;
    [sortdistance I]=sort(distance(:,1));
                    % Just keep a number 'numpoints' of points closest to xyin  
    mappingpoints_subset=mappingpoints(I(1:numpoints),:);
elseif outfield==2
                        % Here if our output field is field 2 (xyin is from field1)
                    % Calculate distances from field1 points:
    distance=( mappingpoints(:,3)-xyin(1) ).^2 + (mappingpoints(:,4)-xyin(2) ).^2;
    [sortdistance I]=sort(distance(:,1));
                    % Just keep a number 'numpoints' of points closest to xyin  
    mappingpoints_subset=mappingpoints(I(1:numpoints),:);
    
end
    % At this point the mappingpoints_subset list contains those points we
    % will use for mapping xyin to the output field.  Regarless of the
    % value of outfield we form the fitparmvector with the standard
    % definitions of fields 1 and 2 so that fitparmvector=[fitparmx21';fitparmy21'] with 
    %  x2 = fitparmx21(1)*x1 + fitparmx21(2)*y1 + fitparmx21(3) 
    %  y2 = fitparmy21(1)*x1 + fitparmy21(2)*y1 + fitparmy21(3)
            % Follow the mapping.m gui callback:
% Form a cell array, first member is a matrix of the
                                % x1y1 pairs    
inarray{1}=[ mappingpoints_subset(:,3) mappingpoints_subset(:,4)];
                                % second member is a vector of the output
                                % x2 points
inarray{2} = mappingpoints_subset(:,9);
                                % Input guess is [mxx21 mxy21 bx] 
                                % from input fitparmvector0(1,:)
fitparmx21=mappingfit(inarray,fitparmvector0(1,:));
            % Next, obtain the fitting for the y coordinate
             % Form a cell array, first member is a
                                % matrix of the x1y1 pairs
inarray{1}=[ mappingpoints_subset(:,3) mappingpoints_subset(:,4)];
                                % second member is a vector of the output
                                % y2 points
inarray{2} = mappingpoints_subset(:,10);
                                % Input guess is [myx21 myy21 bx] with
                                % myx21 = 0 at first
 fitparmy21=mappingfit(inarray,fitparmvector0(2,:));
                % We now have our fitting parameters:
fitparmvector=[fitparmx21';fitparmy21']; 

        % Now we must map xyin to the appropriate output field (following imscroll gobutton callback)  
if outfield ==1
            % Here if we map to field1 (xyin is from field2_)
            % We must Invert the map: go from e.g. x2 -> x1
            % output is x1y1 coordinates
            % B9p148
     % Fetch the mapping parameters
     % Stored as [mxx21 mxy21 bx; 
     %            myx21 myy21 by]
     za=fitparmvector(1,1);zb=fitparmvector(1,2);zc=fitparmvector(1,3);
     zd=fitparmvector(2,1);ze=fitparmvector(2,2);zf=fitparmvector(2,3);
     denom=1/(za*ze-zb*zd);
     invmapmat=denom*[ze -zb (zb*zf-zc*ze) ; -zd za (zd*zc-zf*za)]; % b9p148 inverse matrix


                % Now map to the x1
     pc(1)=mappingfunc(invmapmat(1,:),xyin);
                % Now map to the y1
     pc(2)=mappingfunc(invmapmat(2,:),xyin);
elseif outfield ==2
            % Here if we map to field2 (xyin is from field1)
              % map the present AOI set to 
              % field #2 e.g. x1 -> x2
               % (output is x2y2  coordinates)
               % Now map to the x2 
       
     pc(1)=mappingfunc(fitparmvector(1,:),xyin);
              % Now map to the y2 
     pc(2)=mappingfunc(fitparmvector(2,:),xyin);
end
    % only keep points with pixel indices >=1 and <=512
      %log=(handles.FitData(:,3)>=1 ) & pc( >=1);
      %handles.FitData=handles.FitData(log,:);
      %handles.FitData=update_FitData_aoinum(handles.FitData);



