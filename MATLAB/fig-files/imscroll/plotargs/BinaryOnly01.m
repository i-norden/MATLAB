function pc=BinaryOnly01(Bin2013)
%
% function BinaryOnly01(Bin2013)
%
% Will be used as part of the editing process in plotargout gui.  The
% Bin2013 (N x 2) array will have low=-2,0,2 and high=-3,1,3.  This
% function will merely create a true binary trace that defines low=0 and
% high = 1 alwarys.  The output true binary trace will be the same size as
% the input.
%Bin2013 = [N x 2] matrix with low defined alternately as -2,0 or 2 and high
%         defined as alternately -3,1 or 3
[rosebin colbin]=size(Bin2013);
for indx=1:rosebin
    if any(Bin2013(indx,2)==[-3 1 3])
        Bin2013(indx,2)=1;
    elseif any(Bin2013(indx,2)==[-2 0 2])
        Bin2013(indx,2)=0;
    end
end
pc=Bin2013;
