function pc=gauss2dxyfit(indata,varargin)
%
% function gauss2dxyfit(indata,<inputarg0>)
%
% Will fit the 'indata' (2D matrix) to a gaussian function.
%
% indata     == input 2D matrix that will be fit to a gaussian 
% inputarg0  == optional starting parameters for the fit
%                 [amp centerx omegax centery omegay offset] 
%
% The form of the exponential will be:
%  amp*exp( -( (x1-centerx).^2/(2*omegax^2)+(y1-centery).^2/(2*omegay^2)  )+offset
%
% I time a 10 x 10 aoi fit to be around 0.1 sec
%                                               
inlength=length(varargin);
                                                % Grab the starting
                                                % parameters if they are
                                                % present
if inlength>0
    inputarg0=varargin{1}(:);                   %amp=varargin{1}(1);
                                                %centerx=varargin{1}(2);
                                                %omegax=varargin{1}(3);
                                                %centery=varargin{1}(4);
                                                %omegay=varargin{1}(5);
                                                %offset=varargin{1}(6);
end
[mrow ncol]=size(indata);                       % Form the xdata input array
xdata=zeros(mrow,ncol,2);
                                                % xdata(:,:,2) will run in
                                                % the Y dimension,
                                                % xdata(:,:,1) in the X
xdata(:,:,2)=diag( [0:mrow-1])*ones(mrow,ncol);
xdata(:,:,1)=ones(mrow,ncol)*diag( [0:ncol-1]);
options=optimset('Display','off');              % suppress the screen printing 
                                                %during the lsqcurvefit() call


pc =lsqcurvefit('gauss2dxyfunc',inputarg0,xdata,indata,-10000*ones(1,6),10000*ones(1,6),options);
