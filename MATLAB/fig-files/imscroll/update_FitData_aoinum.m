function pc=update_FitData_aoinum(FitData)
%
% function update_FitData_aoinum(FitData)
%
% After altering the aoi list, you need to reorder the aoinumbers so that
% no values are skipped.  Otherwise other programs get confused due to
% having aoi numbers that are greater than the total number of aois.  This
% function takes care of that task.
[aoinum b]=size(FitData);                % a = number of aois in the list

                                    % Number the aois without skipping any
                                    % values
                                    % column 6 contains the unique aoi number
pc=FitData;
for indx=1:aoinum
    pc(indx,6)=indx;
end
