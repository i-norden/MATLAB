clear all;
close all;
%% Lets user select appropriate files for Resolution Filter %%
fprintf(1,'Please select all your path files \n')
[MFileName, MPathName] = uigetfile('*.dat','Please select all your Parsed files','Multiselect','on');
% This is just in case the user selects only one file (converts array ->
% cell array), because the rest of the code expects a cell array.
if ~iscell(MFileName)
    G = cell(1);
    G{1} = MFileName;
    MFileName = G;
end
nfiles = length(MFileName);
nfiles = nfiles(1,1);
TestFileName = MFileName;
TestPathName = MPathName;


%% Checks the FRET states found
x=0:0.05:1;
for n=1:nfiles
    raw=[];
    y=[];
    bin=[];
    FileName = strcat(TestPathName,TestFileName{n});
    fid = fopen(FileName,'rt');
    raw = fscanf(fid,'  %e %e %e %e %e', [5 inf]);   
    raw=raw';
    rawstore{n,1}=raw;      
    fclose(fid);
    [y,bin]=histc(raw(:,5),x);
    if ~isempty(bin(bin==0))
        fprintf('Molecule has regions out of bounds\n'); 
        fprintf([TestFileName{1,n} '\n'])
        newrawstore{n,1}=0; 
    else        
    newPath=x(bin)+0.05;
    raw(:,5)=newPath;  
    newrawstore{n,1}=raw; 
    dlmwrite(strcat(TestPathName,strtok(TestFileName{1,n},'.'),'Binned.dat'),raw,'delimiter', '\t'); 
    end         
end

