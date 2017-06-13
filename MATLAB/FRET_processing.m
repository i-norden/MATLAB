function varargout = FRET_processing(varargin)
% FRET_PROCESSING MATLAB code for FRET_processing.fig
%      FRET_PROCESSING, by itself, creates a new FRET_PROCESSING or raises the existing
%      singleton*.
%
%      H = FRET_PROCESSING returns the handle to a new FRET_PROCESSING or the handle to
%      the existing singleton*.
%
%      FRET_PROCESSING('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in FRET_PROCESSING.M with the given input arguments.
%
%      FRET_PROCESSING('Property','Value',...) creates a new FRET_PROCESSING or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before FRET_processing_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to FRET_processing_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help FRET_processing

% Last Modified by GUIDE v2.5 30-Aug-2013 10:13:53

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @FRET_processing_OpeningFcn, ...
                   'gui_OutputFcn',  @FRET_processing_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT


% --- Executes just before FRET_processing is made visible.
function FRET_processing_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to FRET_processing (see VARARGIN)

% Choose default command line output for FRET_processing
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);
set(handles.raw_files,'string',{'raw files'});
set(handles.HMM_files,'string',{'HMM files'});

%needs a check for vbFRET!
if length(strfind(path,'vbFRET'))<1
folder_path=uigetdir('Select vbFRET path');
p=genpath(folder_path);
addpath(p);
end
FRETvalues=num2str([
0.001763
0.035835
 0.12981
 0.25597
 0.45998
 0.66666
 0.83654]);
set(handles.FRET_values,'string',FRETvalues)

% UIWAIT makes FRET_processing wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = FRET_processing_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on selection change in listbox1.
function listbox1_Callback(hObject, eventdata, handles)
% hObject    handle to listbox1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns listbox1 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from listbox1


% --- Executes during object creation, after setting all properties.
function listbox1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to listbox1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in Load_HMM_direcotry.
function Load_HMM_direcotry_Callback(hObject, eventdata, handles)
% hObject    handle to Load_HMM_direcotry (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

[files,path]=uigetfile({'*.txt;*.dat;*.data;*.datH'},'Select file or direcotry to load','Multiselect','on');
list_files=get(handles.HMM_files,'string');
list_files=fill_in_list(list_files,path,files,'HMM files');
set(handles.HMM_files,'string',list_files);


% --- Executes on selection change in HMM_files.
function HMM_files_Callback(hObject, eventdata, handles)
% hObject    handle to HMM_files (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns HMM_files contents as cell array
%        contents{get(hObject,'Value')} returns selected item from HMM_files
  files=cellstr(get(hObject,'String'));
 file=files{get(hObject,'Value')};
 
[path,name,ext]=fileparts(file);

        ans=questdlg(['Remove ',name,ext,'?'],'Confirm Deleate','Yes','Cancel','Yes');
        if ~strcmp('Yes',ans)
            return;
        end
        files=files((get(hObject,'Value')~=[1:length(files)]));

        if length(files)==1
            files{1}='HMM files';
        end
            set(handles.HMM_files,'String',files)

% --- Executes during object creation, after setting all properties.
function HMM_files_CreateFcn(hObject, eventdata, handles)
% hObject    handle to HMM_files (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in Reassign_fret.
function Reassign_fret_Callback(hObject, eventdata, handles)
% hObject    handle to Reassign_fret (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

HMM_files=get(handles.HMM_files,'string');

string_values=get(handles.FRET_values,'string');
try
FRET_VALUES=str2num(string_values);
catch
    FRET_VALUES=[1:length(string_values)];
    for i=1:length(string_values)
        FRET_VALUES(i)=str2num(string_values{i});
    end
end

h=waitbar(0,'reassigning');
for i=1:length(HMM_files)
   
old_data=load(HMM_files{i});
new_data=FRET_reassignment(old_data,FRET_VALUES);
[path,name,ext]=fileparts(HMM_files{i});
save(fullfile(path,[name,ext,'R']),'new_data','-ascii');
waitbar(i/length(HMM_files),h,'reassigning');
end
close(h);


% --- Executes on selection change in raw_files.
function raw_files_Callback(hObject, eventdata, handles)
% hObject    handle to raw_files (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns raw_files contents as cell array
%        contents{get(hObject,'Value')} returns selected item from raw_files

  files=cellstr(get(hObject,'String'));
 file=files{get(hObject,'Value')};
 
[path,name,ext]=fileparts(file);

        ans=questdlg(['Remove ',name,ext,'?'],'Confirm Deleate','Yes','Cancel','Yes');
        if ~strcmp('Yes',ans)
            return;
        end
        files=files((get(hObject,'Value')~=[1:length(files)]));

        if get(hObject,'Value')>length(files)
    set(hObject,'Value',1);
end
        
        if length(files)==0
            files{1}='raw files';
        end
            set(handles.raw_files,'String',files)


% --- Executes during object creation, after setting all properties.
function raw_files_CreateFcn(hObject, eventdata, handles)
% hObject    handle to raw_files (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in Load_data_Directory.
function Load_data_Directory_Callback(hObject, eventdata, handles)
% hObject    handle to Load_data_Directory (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

[files,path]=uigetfile({'*.txt;*.dat;*.data'},'Select file or direcotry to load','Multiselect','on');
list_files=get(handles.raw_files,'string');
list_files=fill_in_list(list_files,path,files,'raw files');
set(handles.raw_files,'string',list_files);

%-----fill in list
function list_files=fill_in_list(list_files,path,files,defualt_str)

if length(list_files)==1 && strcmp(list_files{1},defualt_str)
    list_files={};
end

if ~iscell(list_files)
    list_files={list_files};
end

if ~iscell(files)==1 
    list_files={list_files{:},fullfile(path,files)};
    
else
    for i=1:length(files)

list_files={list_files{:},fullfile(path,files{i})};

    end
end

% --- Executes on button press in Run_vbFRET.
function Run_vbFRET_Callback(hObject, eventdata, handles)
% hObject    handle to Run_vbFRET (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

list_files=get(handles.raw_files,'string');
if length(list_files)==1 && strcmp(list_files{1},'HMM files')
    warndlg('No files selected')
else
    h=waitbar(0,'running vbFRET - this may take sometime');
    for i=1:length(list_files)
          [path,f_name,ext]=fileparts(list_files{i});
    [out_data,save_name]=vbFRET_nogui(list_files{i},fullfile(path,f_name));%save_name doesn't have an extension
    
    save(save_name,'out_data','-ascii')
    [path,f_name,ext]=fileparts(save_name);
    
    HMM_files=get(handles.HMM_files,'string');
    HMM_files=fill_in_list(HMM_files,path,[f_name,ext],'HMM files');
    set(handles.HMM_files,'string',HMM_files);
    
        waitbar(i/length(list_files),h,'running vbFRET - this may take sometime')
        
    end
   close(h)
end

% --- running vbFRET to get the hmm data
function [out_data,save_name]=vbFRET_nogui(datafile,outfile)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% This is a command line version of vbFRET
% the data must be FRET transformed already and stored in a cell array
% called 'FRET'
%
% Posterior parameters are stored in an NxK array called 'bestOut'
%
% Idealized trajectories are stored in an NxK array called 'x_hat'
%
% Idealized hidden state trajectories are stored in an NxK array called 
% 'z_hat' 
%
% Please direct any questions to Jonathan Bronson (jeb2126@columbia.edu)
%
% March 2010
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% load data 
data=load(datafile);

if size(data,2)>=4
FRET{1}=data(:,4);
elseif size(data,2)==3
     FRET{1}=data(:,3)./(data(:,2)+data(:,3));
elseif size(data,2)==2
         FRET{1}=data(:,2)./(data(:,1)+data(:,2));
else
    FRET{1}=data(:,1);
end
% make file name to save data to
[path,fil_name,ext] = fileparts(outfile); % name of output file (must be string)
d_t = clock;
save_name=sprintf('%s_HMMs.datH',fullfile(path,fil_name));

%%%%%%%%%%%%%%%%%%%%%
% parameter settings
%%%%%%%%%%%%%%%%%%%%%

% analyze data in 1D
D = 1;
% set minimum number of states to try fitting
kmin = 1;
% set maximum number of states to try fitting
K = 10;
% set maximum number of restarts 
I = 10;

N = length(FRET);

% analyzeFRET program settings
PriorPar.upi = 1;
PriorPar.mu = .5*ones(D,1);
PriorPar.beta = 0.25;
PriorPar.W = 50*eye(D);
PriorPar.v = 5.0;
PriorPar.ua = 1.0;
PriorPar.uad = 0;
%PriorPar.Wa_init = true;


% set the vb_opts for VBEM
% stop after vb_opts iterations if program has not yet converged
vb_opts.maxIter = 100;
% question: should this be a function of the size of the data set??
vb_opts.threshold = 1e-5;
% display graphical analysis
vb_opts.displayFig = 0;
% display nrg after each iteration of forward-back
vb_opts.displayNrg = 0;
% display iteration number after each round of forward-back
vb_opts.displayIter = 0;
% display number of steped needed for convergance
vb_opts.DisplayItersToConverge = 0;


% bestMix = cell(N,K);
bestOut=cell(N,K);
outF=-inf*ones(N,K);
best_idx=zeros(N,K);

%%%%%%%%%%%%%%%%%%%%%%%%
%run the VBEM algorithm
%%%%%%%%%%%%%%%%%%%%%%%%

for n=1:N
    fret = FRET{n}(:)'; %make sure the data is a row vector
    for k=kmin:K
        ncentres = k;
        init_mu = (1:ncentres)'/(ncentres+1);
        i=1;
        maxLP = -Inf;
        while i<I+1
            if k==1 && i > 3
                break
            end
            if i > 1
                init_mu = rand(ncentres,1);
            end
            clear mix out;
%            disp(sprintf('Working on inference for restart %d, k%d of trace %d...',i,k,n))
            % Initialize gaussians
            % Note: x and mix can be saved at this point andused for future
            % experiments or for troubleshooting. try-catch needed because
            % sometimes the K-means algorithm doesn't initialze and the program
            % crashes otherwise when this happens.
           try
                [mix] = get_mix(fret',init_mu);
                [out] = vbFRET_VBEM(fret, mix, PriorPar, vb_opts);
            catch
%                disp('There was an error, repeating restart.');
                runError=lasterror;
                disp(runError.message)
                continue
           end
            
            % Only save the iterations with the best out.F
            if out.F(end) > maxLP
                maxLP = out.F(end);
%                 bestMix{n,k} = mix;
                bestOut{n,k} = out;
                outF(n,k)=out.F(end);
                best_idx(n,k) = i;
            end
            i=i+1;
        end
    end
   % save results


end

%%%%%%%%%%%%%%%%%%%%%%%% VBHMM postprocessing %%%%%%%%%%%%%%%%%%%%%%%%%%%

% analyze accuracy and save analysis
disp('Analyzing results...')


%%%%%%%%%%%%%%%%%%%%%%%%%%
% Get idealized data fits
%%%%%%%%%%%%%%%%%%%%%%%%%%
z_hat=cell(N,K);
x_hat=cell(N,K);
for n=1:N
    for k=kmin:K
        [z_hat{n,k} x_hat{n,k}] = chmmViterbi(bestOut{n,k},FRET{n}(:)');
    end
end

%disp('...done w/ analysis') 

best_fit=find(outF==max(outF));
best_trace=x_hat{best_fit};
%save(save_name);           
out_data=data;
out_data(:,5)=best_trace;


% --- Executes on button press in load_FRET_values.
function load_FRET_values_Callback(hObject, eventdata, handles)
% hObject    handle to load_FRET_values (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

[files,path]=uigetfile({'*.txt;*.dat;*.data'},'Select file with desired FRET values','Multiselect','on');

FRET=load(fullfile(path,files));
if size(FRET,2)==5
    values=unique(FRET(:,5));
else
    values=unique(FRET(:,1));
end

set(handles.FRET_values,'string',num2str(values));


% --- Executes on selection change in FRET_values.
function FRET_values_Callback(hObject, eventdata, handles)
% hObject    handle to FRET_values (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns FRET_values contents as cell array
%        contents{get(hObject,'Value')} returns selected item from FRET_values

  files=cellstr(get(hObject,'String'));
 file=files{get(hObject,'Value')};
 
[path,name,ext]=fileparts(file);

  files=cellstr(get(hObject,'String'));
 file=files{get(hObject,'Value')};
 
[path,name,ext]=fileparts(file);

ans=questdlg(['Remove ',name,ext,'?'],'Choise Action','Change Value','Delete','Cancel','Cancel');
if strcmp('Delete',ans)
    
        files=files((get(hObject,'Value')~=[1:length(files)]));

            set(handles.FRET_values,'String',files)

elseif strcmp('Change Value',ans)
    value=inputdlg('New Fret Value');
            files(get(hObject,'Value'))=value;
                        set(handles.FRET_values,'String',files)
else
return
end

% --- Executes during object creation, after setting all properties.
function FRET_values_CreateFcn(hObject, eventdata, handles)
% hObject    handle to FRET_values (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in Run_single_file.
function Run_single_file_Callback(hObject, eventdata, handles)
% hObject    handle to Run_single_file (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

[file,path]=uigetfile({'*.txt;*.dat;*.data;*.datH'},'Pick file to analyze');
answer=questdlg('Run vbfret on file?');
if strcmpi(answer,'cancel')
    return
elseif strcmpi(answer,'yes')
     [out_data,save_name]=vbFRET_nogui(fullfile(path,file),fullfile(path,file));
else
    out_data=load(fullfile(path,file));
end
    
string_values=get(handles.FRET_values,'string');
try
FRET_VALUES=str2num(string_values);
catch
    FRET_VALUES=[1:length(string_values)];
    for i=1:length(string_values)
        FRET_VALUES(i)=str2num(string_values{i});
    end
end

new_data=FRET_reassignment(out_data,FRET_VALUES);
save(fullfile(path,file),'new_data','-ascii');

%---- reassignment of FRET values based upon a list
function new_data=FRET_reassignment(data,FRET_VALUES)

FRET_VALUES=unique(FRET_VALUES);%makes sure the fret values are unique

if size(FRET_VALUES,2)>size(FRET_VALUES,1)%rotates the fret vector if horizontal instead of vertical
   FRET_VALUES=FRET_VALUES'; 
end

new_data=data;%copies into new vector

for i=1:size(data,1)%steps through data
FRET_point=data(i,5);
    difference=abs(meshgrid(FRET_point,FRET_VALUES)-FRET_VALUES);%gets the differences to find the closest value
    pos=find(difference==min(difference));%finds the lowest values - the closest fret value
    new_data(i,5)=FRET_VALUES(pos);%writes to the new vector
end


% --- If Enable == 'on', executes on mouse press in 5 pixel border.
% --- Otherwise, executes on mouse press in 5 pixel border or over Load_data_Directory.
function Load_data_Directory_ButtonDownFcn(hObject, eventdata, handles)
% hObject    handle to Load_data_Directory (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
