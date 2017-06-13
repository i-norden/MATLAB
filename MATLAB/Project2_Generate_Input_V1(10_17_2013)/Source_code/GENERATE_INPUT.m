function varargout = GENERATE_INPUT(varargin)
% GENERATE_INPUT MATLAB code for GENERATE_INPUT.fig
%      GENERATE_INPUT, by itself, creates a new GENERATE_INPUT or raises the existing
%      singleton*.
%
%      H = GENERATE_INPUT returns the handle to a new GENERATE_INPUT or the handle to
%      the existing singleton*.
%
%      GENERATE_INPUT('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in GENERATE_INPUT.M with the given input arguments.
%
%      GENERATE_INPUT('Property','Value',...) creates a new GENERATE_INPUT or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before GENERATE_INPUT_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to GENERATE_INPUT_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help GENERATE_INPUT

% Last Modified by GUIDE v2.5 16-Oct-2013 11:15:28
% $ Author: Fatemeh Jamali $		    $ Version 1$
% Begin initialization code - DO NOT EDIT

gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @GENERATE_INPUT_OpeningFcn, ...
                   'gui_OutputFcn',  @GENERATE_INPUT_OutputFcn, ...
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
global Acceptor Donor folder_name;  

% close Figure 1;
% axis off;
% End initialization code - DO NOT EDIT


% --- Executes just before GENERATE_INPUT is made visible.
function GENERATE_INPUT_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to GENERATE_INPUT (see VARARGIN)
imshow('1.png')
% Choose default command line output for GENERATE_INPUT
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes GENERATE_INPUT wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = GENERATE_INPUT_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in SMART.
function SMART_Callback(hObject, eventdata, handles)
% hObject    handle to SMART (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of SMART
Chk_sel_index = get(handles.SMART, 'Value');
if(Chk_sel_index==1)
    set(hObject,'Value',1);
else
    set(hObject,'Value',0);
end

% --- Executes on button press in VBFRET.
function VBFRET_Callback(hObject, eventdata, handles)
% hObject    handle to VBFRET (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of VBFRET
Chk_sel_index = get(handles.VBFRET, 'Value');
if(Chk_sel_index==1)
    set(hObject,'Value',1);
else
    set(hObject,'Value',0);
end

% --- Executes on button press in BR_ACC.
function BR_ACC_Callback(hObject, eventdata, handles)
% hObject    handle to BR_ACC (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global Acceptor Donor folder_name; 
[filename, pathname] = uigetfile();
load([ pathname filename])
set(handles.edit1,'String',[ pathname filename]);
try
Acceptor=Intervals_FRET;

catch
end
% Donor=Intervals_Cy3;
% eval(['load ' [fp fn] ' -mat']);
% out=[fp fn '_out'];
% kj=0;

% --- Executes on button press in BR_DON.
function BR_DON_Callback(hObject, eventdata, handles)
% hObject    handle to BR_DON (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global Acceptor Donor folder_name; 
[filename, pathname] = uigetfile();
load([ pathname filename])
 set(handles.edit2,'String',[ pathname filename]);
% Acceptor=Intervals_FRET;
try
 Donor=Intervals_Cy3;

catch
end   


function edit1_Callback(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit1 as text
%        str2double(get(hObject,'String')) returns contents of edit1 as a double


% --- Executes during object creation, after setting all properties.
function edit1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit2_Callback(hObject, eventdata, handles)
% hObject    handle to edit2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit2 as text
%        str2double(get(hObject,'String')) returns contents of edit2 as a double


% --- Executes during object creation, after setting all properties.
function edit2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in Done.
function Done_Callback(hObject, eventdata, handles)
% hObject    handle to Done (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global Acceptor Donor folder_name;
Chk_sel_index_VBFRET = get(handles.VBFRET, 'Value');
Chk_sel_index_SMART = get(handles.SMART, 'Value');
if(Chk_sel_index_SMART==1)
    
    
end
if(Chk_sel_index_VBFRET==1)
  frames = size(Acceptor.AllTracesCellArray{1,12}(:,2),1);
 num_acceptors = size(Acceptor.AllTracesCellArray,1);
 num_donors = size(Donor.AllTracesCellArray,1);
 pairs = ones(min(num_acceptors, num_donors),2,frames);

%match donors and acceptors
matches = 0;
for i = 1:1:num_acceptors;
    curr_ID = Acceptor.AllTracesCellArray{i,2};
    for j = 1:1:num_donors;
        if curr_ID == Donor.AllTracesCellArray{j,2};
            matches = matches + 1;
            pairs(matches,1,:) = Acceptor.AllTracesCellArray{i,12}(:,2);
            pairs(matches,2,:) = Donor.AllTracesCellArray{j,12}(:,2);
        end
    end
end
for i=1:size(pairs,1)
    for j=1:size(pairs,3)
data{1,i}(j,1)=pairs(1,1,j);
data{1,i}(j,2)=pairs(1,2,j);
    end
end
OUTPUT_DIR=[folder_name '\VBFRET'];
if ~exist(OUTPUT_DIR,'dir');
    mkdir(OUTPUT_DIR);
end
out=[OUTPUT_DIR '\out.mat'];
save(out,'data');  
    
end


if(Chk_sel_index_SMART==1)
  frames = size(Acceptor.AllTracesCellArray{1,12}(:,2),1);
num_acceptors = size(Acceptor.AllTracesCellArray,2);
num_donors = size(Donor.AllTracesCellArray,2);
pairs = ones(min(num_acceptors, num_donors),2,frames);

%match donors and acceptors
matches = 0;
for i = 1:1:num_acceptors;
    curr_ID = Acceptor.AllTracesCellArray{i,2};
    for j = 1:1:num_donors;
        if curr_ID == Donor.AllTracesCellArray{j,2};
            matches = matches + 1;
            pairs(matches,1,:) = Acceptor.AllTracesCellArray{i,12}(:,2);
            pairs(matches,2,:) = Donor.AllTracesCellArray{j,12}(:,2);
        end
    end
end
pairs = pairs(1:matches,:,:);

%create the .traces data
num_traces = matches;

group_data = cell(num_traces,3);

positions = ones(num_traces,4);
positions(:,2) = 1:1:num_traces;
positions(:,4) = 1:1:num_traces;

for i = 1:1:num_traces;
    %Fill in first cell
    group_data{i,1}.name = '';
    group_data{i,1}.gp_num = NaN;
    group_data{i,1}.movie_num = 1;
    group_data{i,1}.movie_ser = 1;
    group_data{i,1}.trace_num = i;
    group_data{i,1}.spots_in_movie = num_traces;
    group_data{i,1}.position_x = 1;
    group_data{i,1}.position_y = i;
    %group_data{i,1}.positions = [1 1 1 1];
    group_data{i,1}.positions = positions;
    group_data{i,1}.fps = NaN;
    % fill in datta
%     group_data{i,2}(:,1)= pairs(i,1,:);
%      group_data{i,2}(:,2)= pairs(i,2,:);
%      dataout = scaledata(pairs(i,1,:),0,65535);
% a=min(pairs(i,1,:));
% b=min(pairs(i,2,:));
% c=min(a,b);
  dataout = pairs(i,1,:);
    group_data{i,2}(:,1) = int16(dataout);
    
%  dataout = scaledata(pairs(i,2,:),0,65535);
  dataout =pairs(i,2,:);
   group_data{i,2}(:,2) = int16(dataout);
%     group_data{i,2}(:,1) = int16(pairs(i,1,:));
%     group_data{i,2}(:,2) = int16(pairs(i,2,:));
    %group_data{i,2}(:,2) = Acceptor.AllTracesCellArray{i,12}(:,2);
    %group_data{i,3} = true(size(Acceptor,1),1);
    group_data{i,3} = logical(ones(size(pairs(i,1,:),3),1));

    group_data{i,1}.len = size(group_data{i,2},1);
    group_data{i,1}.nchannels = size(group_data{i,2},2);
end
OUTPUT_DIR=[folder_name '\SMART'];
if ~exist(OUTPUT_DIR,'dir');
    mkdir(OUTPUT_DIR);
end
var_name=[OUTPUT_DIR '\out'];
%Use the input arg's name as the filename
% var_name ='out_8';
%tok = strfind(var_name,'.txt');

%save([var_name(1:tok),'traces'], 'group_data')
save([var_name,'.traces'], 'group_data');  
end


function edit4_Callback(hObject, eventdata, handles)
% hObject    handle to edit4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit4 as text
%        str2double(get(hObject,'String')) returns contents of edit4 as a double


% --- Executes during object creation, after setting all properties.
function edit4_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in out_dir.
function out_dir_Callback(hObject, eventdata, handles)
global Acceptor Donor folder_name; 
% hObject    handle to out_dir (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
folder_name = uigetdir;
 set(handles.edit4,'String',[folder_name]);
