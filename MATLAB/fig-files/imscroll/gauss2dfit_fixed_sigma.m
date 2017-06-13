function pc=gauss2dfit_fixed_sigma(indata,varargin)
%
% function gauss2dfit_fixed_sigma(indata,<inputarg0>)
%
% Will fit the 'indata' (2D matrix) to a gaussian function.
%
% indata     == input 2D matrix (e.g. image intensity) that will be fit to a gaussian 
% inputarg0  == optional starting parameters for the fit
%                 [amp centerx centery omega offset] 
%
% The form of the exponential will be:
%  amp*exp( -( (x1-centerx).^2/(2*omega^2)+(y1-centery).^2/(2*omega^2)  )+offset
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
                                                %centery=varargin{1}(3);
                                                %omega=varargin{1}(4);
                                                %offset=varargin{1}(5);
end
[mrow ncol]=size(indata);                       % Form the xdata input array
xdata=zeros(mrow,ncol,2);
                                                % xdata(:,:,2) will run in
                                                % the Y dimension,
                                                % xdata(:,:,1) in the X
xdata(:,:,2)=diag( [0:mrow-1])*ones(mrow,ncol);
xdata(:,:,1)=ones(mrow,ncol)*diag( [0:ncol-1]);
options=optimset('Display','off');              % suppress the screen printing 
                                                %during the lsqcurvefit()
                                                %call
 sigma=inputarg0(4);                    % Pick off fixed value of sigma
 inputarg0=inputarg0';
                       % fit parameters = [ amp   x    y    offset]                                                         fixed sigma 
 
%pc =lsqcurvefit('gauss2dfunc_fixed_sigma',[inputarg0(1:3) inputarg0(5)],xdata,indata,-10000*ones(1,5),100000*ones(1,5),options,sigma);
%pc =lsqcurvefit('gauss2dfunc_fixed_sigma',[inputarg0(1:3) inputarg0(5)],xdata,indata,-10000*ones(1,4),100000*ones(1,4),options,sigma);
                % Limit range of parameters:  amp:    -0 to 100000  
                %                             xzero:  0 to  pixnum  (note: inputarg0(2:3) are pixnum/2  
                %                             yzero:  0 to  pixnum
                %                             offset:  0 to  100000
                
pc =lsqcurvefit('gauss2dfunc_fixed_sigma',[inputarg0(1:3) inputarg0(5)],xdata,indata,[0 0 0 0],[100000 inputarg0(2)*2 inputarg0(3)*2 100000],options,sigma);
