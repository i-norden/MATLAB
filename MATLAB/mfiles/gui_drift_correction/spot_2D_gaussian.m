function [xfit yfit amp sigma offset]=spot_2D_gaussian(xin,yin,dum,xysize,xyjump,xy_sigma)

%xin=guess for x
%yin=guess for y
%dum=image
%xysize=diameter of spot
%xyjump=pixels it can move between frames
%xy_sigma=spread of curve



%find the center x-y position of a spot by fitting it with a 
%symmetric 2D gaussian function.
%dum is the input image

%set AOI and fit parameters
%xy_sigma=2.5;       %set to 2.5 pixels ~ 170 nm in hv scope
%xyjump=5;           %do not track if signal is weak and the fitting 'jumps' by more than xyjump pixels
%-------------
xyhalf=floor(xysize/2);
xrange=[round(xin)-xyhalf:round(xin)+xyhalf];
yrange=[round(yin)-xyhalf:round(yin)+xyhalf];
%find center x-y position by a symmetric 2D gaussian
dat=dum(yrange,xrange);     %region containing a spot
offset=min(min(dat));
amplitude=max(max(dat))-offset;
fit_arg=[amplitude xysize/2 xysize/2 xy_sigma offset];
xdata(:,:,1)=ones(xysize,xysize)*diag(1:xysize);  % x matrix 
xdata(:,:,2)=diag(1:xysize)*ones(xysize,xysize);  % y matrix	
gaussfun=inline('fit_arg(1)*exp(-0.5*((xdata(:,:,1)-fit_arg(2)).^2+(xdata(:,:,2)-fit_arg(3)).^2)/fit_arg(4)^2)+fit_arg(5)','fit_arg','xdata');
options=optimset('lsqcurvefit');
options=optimset(options,'display','off');
fit_arg=lsqcurvefit(gaussfun,fit_arg,xdata,dat,[10 0 0 0.5 10],[1e5 50 50 25 1e5],options);

%return results:
xfit=fit_arg(2)+xrange(1)-1;
yfit=fit_arg(3)+yrange(1)-1;
%keep the last x and y if the fitted spot moves too much, 
%in this case by more than xyjump pixels.
if abs(xfit-xin>xyjump) || abs(yfit-yin)>xyjump
  xfit=xin;
  yfit=yin;
end 
amp=fit_arg(1);
sigma=fit_arg(4);
offset=fit_arg(5);