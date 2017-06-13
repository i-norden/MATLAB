% take a structure called aoidata containing the 6 default.dat format 
% files for FRETanalysis and rename into structures with distinct names.
% 
% aoidata format:
% aoidata.rsmallbox='path'
% aoidata.rmedbox='path'
% aoidata.rbigbox='path'
% aoidata.gsmallbox='path'
% aoidata.gmedbox='path'
% aoidata.gbigbox='path'

clear RdAoisSmall
clear RdAoisMed
clear RdAoisBig
clear GnAoisSmall
clear GnAoisMed
clear GnAoisB


Fret{1}=aoidata.rsmallbox;
Fret{2}=aoidata.rmedbox;
Fret{3}=aoidata.rbigbox;
Fret{4}=aoidata.gsmallbox;
Fret{5}=aoidata.gmedbox;
Fret{6}=aoidata.gbigbox;

%make a cell with the appropriate names

NAME{1}='RdAoisSmall';
NAME{2}='RdAoisMed';
NAME{3}='RdAoisBig';
NAME{4}='GnAoisSmall';
NAME{5}='GnAoisMed';
NAME{6}='GnAoisBig';

%load in the dat files

for indx=1:6;
eval(['load ' Fret{indx} ' -mat']);
eval([NAME{indx} '=aoifits']);
end;

clear Fret
clear NAME
clear indx
clear aoifits

