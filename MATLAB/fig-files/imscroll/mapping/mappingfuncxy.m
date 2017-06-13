function pc=mappingfuncxy(inarg,xydata)
%
% function mappingfuncxy(inarg,xydata)
%
% This function will be called from mappingfit() while using the
% lscurvefit() function to map the x1y1 image1 point pairs onto x2 or y2
% points.  
% The form of the mapping is
% x2 = mxx21 * x1 + mxy21* y1 + bx
% and
% y2 = myx21 * x1 + myy21 * y1 + by
%
% where the input arguements are given in inarg according to
% inarg  == [ mxx21 mxy21 bx;  myx21 myy21 by]
%           'inarg MAY contain 4 rows rather than 2 rows.  In that case the
%           function will map each point twice:  the first map will be
%           performed using the first two rows and the second mapping will
%           be performed using the parameters from rows 3 and 4
%                                                    
% xdata == n x 2 list of [x1(:) y1(:)] points that will be mapped onto
%          either an x2(:) or y2(:) list of output points

xyshift1= [ (inarg(1,1)*xydata(:,1) + inarg(1,2)*xydata(:,2) + inarg(1,3) ) ...
                       (inarg(2,1)*xydata(:,1) + inarg(2,2)*xydata(:,2) + inarg(2,3) )];
[rose col]=size(inarg);
if rose==4
                % Here in order to perform two successive mappings
                % (the inarg has four rows, i.e. two sets of
                % fitparamvectors
                % e.g. field 1 -> field 2 followed by a slight shift from
                % drifting
    xyshift2= [ (inarg(3,1)*xyshift1(:,1) + inarg(3,2)*xyshift1(:,2) + inarg(3,3) ) ...
                       (inarg(4,1)*xyshift1(:,1) + inarg(4,2)*xyshift1(:,2) + inarg(4,3) )];
else
    xyshift2=xyshift1;
end
pc=xyshift2;