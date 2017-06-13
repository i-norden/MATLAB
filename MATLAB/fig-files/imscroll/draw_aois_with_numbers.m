function pc=draw_aois_with_numbers(aoiinfo2,frame,aoisize,driftlist)
%
% function pc=draw_aois_with_numbers(aoiinfo2,frame,aoisize,driftlist)
%
% This function will use the list of aois in aoiinfo2, reposition all aois
% at their location for frame 'frame' (using data in driftlist)and draw at
% those locations with the box side specified in 'aoisize'
%
% aoiinfo2 == array that is saved from imscroll.  The aoiinfo2 matrix is of
%          the form:
%   [ (frame #)  (frame average) (x coordinate=column) (ycoordinate=row)...
%                            (aoi side dimension in pixels)  (aoi number) ]
% frame == common frame number to be used in positioning all the aois
% aoisize==  side (in pixels) dimension of the aoi box to be drawn
% driftlist ==[(frame #) (x shift from last frame) (y shift from last frm)]
%
[rose col]=size(aoiinfo2);
for indx=1:rose
                        % Cycle through for each aoi
                        % Get the shift in aoi center due to drift
   XYshift=ShiftAOI(indx,frame,aoiinfo2,driftlist);
                        % Draw the box for the shifted aoi location
   draw_box_v1(aoiinfo2(indx,3:4)+XYshift,(aoisize)/2,...
                              (aoisize)/2,'y');
   text(aoiinfo2(indx,3)+aoisize+XYshift(1),aoiinfo2(indx,4)-aoisize+XYshift(2),num2str(indx),'Color','y')
end
