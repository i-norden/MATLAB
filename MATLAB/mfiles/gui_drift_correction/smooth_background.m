function pc=smooth_background(inframe)
%
% This function will provide a smoothed baseline to an image frame to allow
% a cross or autocorrelation.  It will remove the dye spot peaks with an
% outlier test based on a standard deviation threshold, then smooth the
% remaining image using a savitzky-golay filter.  The output can then be
% subtacted off the original frame so that only the frame difference will
% contain only the spot peaks.  This will then be used for cross
% correlations that can compensate for drifts in drifting_v2.m
% see b19p57a_prepare_for_correlation.doc
%
% inframe == an M x N image frame containing single molecule fluorescence
%        spots
%
% Output will be an M x N image frame that has the spot peaks removed and
% the remaining image smoothed so as to provide a baseline for subracting
% off the original image.
%
dinframe=double(inframe);   % A number of the operations require doubles
[rose col]=size(dinframe);
dinframe_std=dinframe;  % Will be the frame with the peaks removed via a 
                        % standard deviation outlier test
                        % Apply outlier test for spots multiple times:
mean_num=2;         % Defines number of cycles through the mean/std outlier test
for indx=1:mean_num
    mn=mean(mean(dinframe_std)); 			            % mean of region
    st=std(reshape(double(dinframe_std),1,rose*col));	% standard deviation of the image
    logic=dinframe_std>(mn+st*3) | dinframe_std<(mn-st*3);	% two D logical matrix to catch spots (outliers)
    dinframe_std(logic)=mn;                     % Replace spots with frame mean
end
          % Next, smooth out the remaining image (that now lacks spots)
          % Smooth over length approx 1/3 image size, (must be odd) 

svrose=round(rose/3);
if svrose/2 ==round(svrose/2), svrose=svrose+1;end
svcol=round(col/3);
if svcol/2 == round(svcol/2), svcol=svcol+1;end
            
dinframe_std_smc=sgolayfilt(dinframe_std,2,svrose);  % Apply quadratic S-G filter to columns
                            % Then apply the S-G filter across the rows
dinframe_std_smcr=sgolayfilt(dinframe_std_smc',2,svcol);
dinframe_std_smcr=dinframe_std_smcr';   % Transpose to put image into original configuration
pc=(dinframe_std_smcr);
%pc=(dinframe_std);

