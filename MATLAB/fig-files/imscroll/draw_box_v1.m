function pc=draw_box_v1(center_xy,x_radius,y_radius,linecolor)
%
% function draw_box_v1(center_xy,x_radius,y_radius,linecolor)
%
% This function will draw a box centered at ( center_xy(1),center_xy(2) ) of the current
% figure.  The box will enclose an area of (2*x_radius+1)*(2*y_radius+1) pixels.
%
% center_xy == gives the coordinates of the box center as the (x,y) coordinate
%                of the current figure
% x_radius  == gives the distance (in pixels) from the box center to y edge of the box
% y_radius == gives the distance (in pixels) from the box center the x edge of the box
% linecolor  == ascii character giving the color of the line that will be
%                 drawn  e.g. ='[0 0 1]' for blue
%
% The box will be drawn with the corners given by the xy coordinates:
%   [x] = [center_xy(1)-x_radius  center_xy(1)+x_radius  center_xy(1)+x_radius  center_xy(1)-x_radius]
%   [y]   [center_xy(2)-y_radius  center_xy(2)-y_radius  center_xy(2)+y_radius  center_xy(2)+y_radius] 
%
% v1:  This routine will draw the box only at pixel edges in a manner that
%      the box will outline the pixels actually integrated by the imscroll
%      routine (see gauss2d_mapstruc() for integration protocol.

%xvec = [center_xy(1)-x_radius  center_xy(1)+x_radius  center_xy(1)+x_radius  center_xy(1)-x_radius center_xy(1)-x_radius];
%yvec =[center_xy(2)-y_radius  center_xy(2)-y_radius  center_xy(2)+y_radius  center_xy(2)+y_radius center_xy(2)-y_radius] ;
xlow=round(center_xy(1)-x_radius+.5)-.5; 
xhi=round(xlow+2*x_radius)-.5;
ylow=round(center_xy(2)-y_radius+.5)-.5;
yhi=round(ylow+2*y_radius)-.5;
xvec=[xlow xhi xhi xlow xlow];
yvec=[ylow ylow yhi yhi ylow];


%center_xy(2)+y_radius center_xy(2)-y_radius] ;
line(xvec,yvec,'color',linecolor,'LineWidth',.5)
pc=1;
