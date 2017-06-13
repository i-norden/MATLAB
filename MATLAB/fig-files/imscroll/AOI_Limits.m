function [xlow xhi ylow yhi]=AOI_Limits(AOICenterxy,AOIhalfwidth)
%
%function [xlow xhi ylow yhi]=AOI_Limits(AOICenterxy,AOIhalfwidth)
%
% This function will define the x and y limits to our AOI so that we have a
% consistent definition throughout the program.
%
% AOICenterxy== [x y] coordinates of the AOI as returned by the ginput()
%             function
% xlow xhi == the low x pixel number and hi x pixel number defining the 
%          limits of our AOI 
% ylow yhi == the low y pixel number and hi y pixel number defining the 
%          limits of our AOI
% AOIhalfwidth == 1/2 the edge length (in pixels) of our AOI.  e.g. a 
%                3x3 AOI will have a AOIhalfwidth=1.5, or =2 for a 4x4 AOI
xlow=round(AOICenterxy(1)-AOIhalfwidth+0.5);
xhi=round(xlow+2*AOIhalfwidth-1);
ylow=round(AOICenterxy(2)-AOIhalfwidth+0.5);
yhi=round(ylow+2*AOIhalfwidth-1);
