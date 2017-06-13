% This is a script to provide a user interface to load a glimpse file in a 
% folder containing a file named header.mat and glimpse data.  It will load 
% the glimpse video file and open imscroll.m.

[fn fp]=uigetfile
folder=[fp fn];
eval(['load ' [fp fn] ' -mat']);
images=glimpse_image(fp,vid,1);
images2=images;
folder2=folder;
dum=images(:,:,1);
dum=dum-dum;
foldstruc.gfolder=fp;
foldstruc.gfolder2=fp;
imscroll(foldstruc)