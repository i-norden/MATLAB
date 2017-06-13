% This script file calculates a FRET values from the data imported with
% loadaoifits.m
% define some output parameters:
% deltaIg(r)=change in green integrated intensity from big to med box
% Bspg(r)=integrated intensity per square pixel of the background
% Ibg(r)=integrated background for a box the size of the smallest box
% IFg(r)=Integrated intensity of the aoi enclosed in the small box less 
% the background

% first input the pixel sizes

smallbox=input('Enter the size of smallest box   ');
middlebox=input('Enter the size of the intermediate box   ');
largebox=input('Enter the size of the largest box   ');
pixel=[smallbox, middlebox, largebox];
clear *box

% calculateoutput variables 

deltaIg=GnAoisBig; deltaIg.data(:,8)=GnAoisBig.data(:,8)-GnAoisMed.data(:,8);
Bspg=deltaIg; Bspg.data(:,8)=deltaIg.data(:,8)/((pixel(3)^2)-(pixel(2)^2));
Ibg=Bspg; Ibg.data(:,8)=Bspg.data(:,8)*(pixel(1)^2);
IFg=GnAoisSmall; IFg.data(:,8)=GnAoisSmall.data(:,8)-Ibg.data(:,8);
deltaIr=RdAoisBig; deltaIr.data(:,8)=RdAoisBig.data(:,8)-RdAoisMed.data(:,8);
Bspr=deltaIr; Bspr.data(:,8)=deltaIr.data(:,8)/((pixel(3)^2)-(pixel(2)^2));
Ibr=Bspr; Ibr.data(:,8)=Bspr.data(:,8)*(pixel(1)^2);
IFr=RdAoisSmall; IFr.data(:,8)=RdAoisSmall.data(:,8)-Ibr.data(:,8);
TotalF=IFr; TotalF.data(:,8)=IFg.data(:,8)+IFr.data(:,8);
FRET=TotalF; FRET.data(:,8)=IFr.data(:,8)./TotalF.data(:,8);

% rename dataDescriptions

Bspg.dataDescription='[aoinumber framenumber amplitude xcenter ycenter sigma offset integrated_bkgdintensity_per_pixel]';
Bspr.dataDescription='[aoinumber framenumber amplitude xcenter ycenter sigma offset integrated_bkgdintensity_per_pixel]';
IFg.dataDescription='[aoinumber framenumber amplitude xcenter ycenter sigma offset bckd_adjstd_integrated_aoi]';
IFr.dataDescription='[aoinumber framenumber amplitude xcenter ycenter sigma offset bckd_adjstd_integrated_aoi]';
TotalF.dataDescription='[aoinumber framenumber amplitude xcenter ycenter sigma offset bckd_adjstd_integrated_aoi]';
FRET.dataDescription='[aoinumber framenumber amplitude xcenter ycenter sigma offset FRET_value]';


% display Fret histogram

figure(5); hist(FRET.data(:,8),30)

% save FRET 

uisave({'deltaIg','Bspg','Ibg','IFg','deltaIr','Bspr','Ibr','IFr','TotalF','FRET'},'fret.dat')
