%function p = larrypath
%PATHDEF Search path defaults.
%   PATHDEF returns a string that can be used as input to MATLABPATH
%   in order to set the path.

  
%   Copyright 1984-2000 The MathWorks, Inc.
%   $Revision: 1.4 $ $Date: 2000/06/01 16:19:21 $

% PATH DEFINED HERE -- Don't change this line.

path([...
        'c:\MatLab\mfiles;',...
matlabroot,'\toolbox\matlab\general;',...
matlabroot,'\toolbox\matlab\ops;',...
matlabroot,'\toolbox\matlab\lang;',...
matlabroot,'\toolbox\matlab\elmat;',...
matlabroot,'\toolbox\matlab\elfun;',...
matlabroot,'\toolbox\matlab\specfun;',...
matlabroot,'\toolbox\matlab\matfun;',...
matlabroot,'\toolbox\matlab\datafun;',...
matlabroot,'\toolbox\matlab\polyfun;',...
matlabroot,'\toolbox\matlab\funfun;',...
matlabroot,'\toolbox\matlab\sparfun;',...
matlabroot,'\toolbox\matlab\scribe;',...
matlabroot,'\toolbox\matlab\graph2d;',...
matlabroot,'\toolbox\matlab\graph3d;',...
matlabroot,'\toolbox\matlab\specgraph;',...
matlabroot,'\toolbox\matlab\graphics;',...
matlabroot,'\toolbox\matlab\uitools;',...
matlabroot,'\toolbox\matlab\strfun;',...
matlabroot,'\toolbox\matlab\imagesci;',...
matlabroot,'\toolbox\matlab\iofun;',...
matlabroot,'\toolbox\matlab\audiovideo;',...
matlabroot,'\toolbox\matlab\timefun;',...
matlabroot,'\toolbox\matlab\datatypes;',...
matlabroot,'\toolbox\matlab\verctrl;',...
matlabroot,'\toolbox\matlab\codetools;',...
matlabroot,'\toolbox\matlab\helptools;',...
matlabroot,'\toolbox\matlab\winfun;',...
matlabroot,'\toolbox\matlab\demos;',...
matlabroot,'\toolbox\local;',...
matlabroot,'\toolbox\bioinfo\bioinfo;',...
matlabroot,'\toolbox\bioinfo\microarray;',...
matlabroot,'\toolbox\bioinfo\proteins;',...
matlabroot,'\toolbox\bioinfo\biomatrices;',...
matlabroot,'\toolbox\bioinfo\biodemos;',...
matlabroot,'\toolbox\compiler;',...
matlabroot,'\toolbox\symbolic\extended;',...
matlabroot,'\toolbox\images\images;',...
matlabroot,'\toolbox\images\imdemos;',...
matlabroot,'\toolbox\optim;',...
matlabroot,'\toolbox\shared\optimlib;',...
matlabroot,'\toolbox\pde;',...
matlabroot,'\toolbox\signal\signal;',...
matlabroot,'\toolbox\signal\sigtools;',...
matlabroot,'\toolbox\signal\sptoolgui;',...
matlabroot,'\toolbox\signal\sigdemos;',...
matlabroot,'\toolbox\splines;',...
matlabroot,'\toolbox\stats;',...
matlabroot,'\toolbox\symbolic;',...
matlabroot,'\toolbox\wavelet\wavelet;',...
matlabroot,'\toolbox\wavelet\wavedemo;',...
matlabroot,'\work;',...
     ...
]);
path(path,genpath('c:\MatLab\'));
cd 'c:\MatLab'

%p = [userpath,p];                      % userpath not defined on PCs
