function pc=gauss2dxyfit_bkgnd_eval(indata,inarg)
%
% function gauss2dfitxy_bkgnd_eval(indata,inputarg)
%
% Used in conjunction with gauss2dfit(), this function will simply
% output the gaussian for comparing with the input data.  The
% purpose is simply to allow the user to visually arrive at a
% set of starting input parameters
%
% indata     == input 2D matrix that will be fit to a gaussian 
%                i.e. the raw data (used for sizing the output array)
% inputarg0  ==  parameters for the fit gaussian
%                 [amp centerx omegax centery omegay offset] 
%
% The form of the exponential will be:
%  amp*exp( -( (x1-centerx).^2/(2*omegax^2)+(y1-centery).^2/(2*omegay^2)  )+offset
%                                +bkgndx*(x1-centerx)+bkgndy*(y1-centery)
%
%                                               

[mrow ncol]=size(indata);                       % Form the xdata input array
xdata=zeros(mrow,ncol,2);
                                                % xdata(:,:,2) will run in
                                                % the Y dimension,
                                                % xdata(:,:,1) in the X
xdata(:,:,2)=diag( [0:mrow-1])*ones(mrow,ncol);
xdata(:,:,1)=ones(mrow,ncol)*diag( [0:ncol-1]);

pc= inarg(1)*exp( -( (xdata(:,:,1)-inarg(2)).^2/(2*inarg(3)^2)+(xdata(:,:,2)-inarg(4)).^2/(2*inarg(5)^2) )  )+inarg(6)...
                                   +inarg(7)*(xdata(:,:,1)-inarg(2))+inarg(8)*(xdata(:,:,2)-inarg(4));

