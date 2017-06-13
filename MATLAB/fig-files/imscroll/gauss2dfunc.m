function pc=gauss2dfunc(inarg,xdata)
%
% function gauss2dfunc(inarg,xdata)
%
% This function will be called from gaus2dfit() while using the
% lscurvefit() function to fit a two dimensional gaussian.  The form of the
% function is:
% amp*exp( -( (x1-centerx).^2/(2*omega^2)+(y1-centery).^2/(2*omega^2)  )+offset
%
% where the input arguements are given in inarg according to
% inarg  == [ amp centerx centery omega offset]
% xdata(:,:,1) == x matrix defining the x range of data
% xdata(:,:,2) == y matrix defining the y range of data
%                  e.g.  11 x 10 matrices running 0 to 1 in each dimension
%                    will be given by:
%                   xdata(:,:,1)=ones(11,10)*diag( [0:9])
%                   xdata(:,:,2)=diag([0:10])*ones(11,10)

pc= inarg(1)*exp( -( (xdata(:,:,1)-inarg(2)).^2/(2*inarg(4)^2)+(xdata(:,:,2)-inarg(3)).^2/(2*inarg(4)^2) )  )+inarg(5);