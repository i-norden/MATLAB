function aoifits=bkgdAdj(aoifits,foldstruc)

%bkgdAdj(aoifits,foldstruc) yields aoifits with background adjusted element
%
%bkgdAdj takes an aoifits structure from a integrated .dat file that has 3
%different sized aoi's for each spot.  This only works on a .dat file
%obtained by integrating the output of a "Create Background AOIs" action.
%There also must be a Pixnums vector in "foldstruc.Pixnums".


aoifits.bkgdAdjDescription='[aoinumber framenumber background_corrected_int]';
% Describe output matrix 'bkgdAdj'

logsmall=aoifits.data(:,9)==foldstruc.Pixnums(1,1);
logmed=aoifits.data(:,9)==foldstruc.Pixnums(1,2);
loglarge=aoifits.data(:,9)==foldstruc.Pixnums(1,3);
%create logicals to get segregate individual box sized aois

small=aoifits.data(logsmall,8);
med=aoifits.data(logmed,8);
large=aoifits.data(loglarge,8);
%create small, med, and large vectors

background=large-med;
%create a vector that subtracts int aois of med from large boxes

backgroundPixel=foldstruc.Pixnums(1,3)^2-foldstruc.Pixnums(1,2)^2;
%calculate number of pixels in 'background'

bkgdPerPixel=background/backgroundPixel;
%calculate background integrated intensity per pixel

backgroundSmall=bkgdPerPixel*(foldstruc.Pixnums(1,1))^2;
%calculate background adjusted to the same pixel size as the small aoi

bkgdAdj=small-backgroundSmall;
%calculate background adjusted integrated intensity

[aoirows aoicol]=size(bkgdAdj(:,1));
aoinumber=ones(aoirows,1);
aoinumber(:,1)=aoifits.data(1:aoirows,1);
%generate aoinumbers for bkgdAdj;

framenumber=aoifits.data(logsmall,2);
%generate framenumber for bkgdAdj;

aoifits.bkgdAdj=[aoinumber framenumber bkgdAdj];
aoifits=aoifits;

