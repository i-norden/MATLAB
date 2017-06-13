function pc = maxfind(inputmat)
%
% function maxfind(inputmat)
%
% Used to find the indices of the maximum element in the two dimensional
% input matrix 'inputmat'
% Output will be the said indices [row col maxin] where inputmat(row,col) will
% contain the maximum entry 'maxin'
[mcol irow]=max(inputmat);
[maxin icol]=max(mcol);
pc=[irow(icol) icol  maxin];
