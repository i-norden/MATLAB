function pc=update_MappingPoints_aoinum(MappingPoints)
%
% function update_MappingPoints_aoinum(MappingPoints)
%
% After altering the aoi list, you need to reorder the aoinumbers so that
% no values are skipped.  Otherwise other programs get confused due to
% having aoi numbers that are greater than the total number of aois.  This
% function takes care of that task.
% MappingPoints=[Field1point Field2point]
%   [frame#  ave  x   y  pixnum  aoinum frame#  ave  x   y pixnum  aoinum]
[aoinum b]=size(MappingPoints);                % a = number of aois in the list

                                    % Number the aois without skipping any
                                    % values
pc=MappingPoints;
for indx=1:aoinum
    pc(indx,6)=indx;
    pc(indx,12)=indx;
end
