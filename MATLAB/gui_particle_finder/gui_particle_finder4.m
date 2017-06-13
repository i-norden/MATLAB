function varargout = gui_particle_finder(varargin)
% GUI_PARTICLE_FINDER M-file for gui_particle_finder.fig
%      GUI_PARTICLE_FINDER, by itself, creates a new GUI_PARTICLE_FINDER or raises the existing
%      singleton*.
%
%      H = GUI_PARTICLE_FINDER returns the handle to a new GUI_PARTICLE_FINDER or the handle to
%      the existing singleton*.
%
%      GUI_PARTICLE_FINDER('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in GUI_PARTICLE_FINDER.M with the given input arguments.
%
%      GUI_PARTICLE_FINDER('Property','Value',...) creates a new GUI_PARTICLE_FINDER or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before gui_particle_finder_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to gui_particle_finder_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help gui_particle_finder

% Last Modified by GUIDE v2.5 18-Jun-2009 14:13:48

% Begin initialization code - DO NOT EDIT


%Alex O, June 16, 2009 Version 1.5
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @gui_particle_finder_OpeningFcn, ...
                   'gui_OutputFcn',  @gui_particle_finder_OutputFcn, ...
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


% --- Executes just before gui_particle_finder is made visible.
function gui_particle_finder_OpeningFcn(hObject, eventdata, handles, varargin)
set(handles.area_selected,'string','1 512 1 300');
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to gui_particle_finder (see VARARGIN)

% Choose default command line output for gui_particle_finder
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes gui_particle_finder wait for user response (see UIRESUME)
% uiwait(handles.gui_particle_finder);



% --- Outputs from this function are returned to the command line.
function varargout = gui_particle_finder_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;

% hObject    handle to process (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)




function start_frame_Callback(hObject, eventdata, handles)
% hObject    handle to start_frame (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of start_frame as text
%        str2double(get(hObject,'String')) returns contents of start_frame as a double



% --- Executes during object creation, after setting all properties.
function start_frame_CreateFcn(hObject, eventdata, handles)
% hObject    handle to start_frame (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function end_frame_Callback(hObject, eventdata, handles)
% hObject    handle to end_frame (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of end_frame as text
%        str2double(get(hObject,'String')) returns contents of end_frame as a double



% --- Executes during object creation, after setting all properties.
function end_frame_CreateFcn(hObject, eventdata, handles)
% hObject    handle to end_frame (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes during object creation, after setting all properties.
function out_path_CreateFcn(hObject, eventdata, handles)
% hObject    handle to out_path (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end




function file_path_Callback(hObject, eventdata, handles)
% hObject    handle to file_path (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of file_path as text
%        str2double(get(hObject,'String')) returns contents of file_path as a double



% --- Executes during object creation, after setting all properties.
function file_path_CreateFcn(hObject, eventdata, handles)
% hObject    handle to file_path (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



% --- Executes on button press in get_file_path.
function get_file_path_Callback(hObject, eventdata, handles)
axes(handles.axes_ave);
noise=str2num(get(handles.noise,'string'));
blob_size=str2num(get(handles.size,'string'));
frm_start=str2double(get(handles.start_frame,'string'));
frm_stop=str2double(get(handles.end_frame,'string'));
path = uigetdir;
path=[path '\'];
set(handles.file_path,'string',path);

if isempty(path)
   set(handles.frame_select,'string','Select File Path');
   return;
end
load([path '\header.mat']);
max_frame=vid.nframes;
if frm_stop > max_frame
    warning(['this file only has ' num2str(max_frame) ' frames!'])
    frm_stop=max_frame;
    set(handles.end_frame,'string',num2str(max_frame));
end
if frm_start > max_frame
    warning(['this file only has ' num2str(max_frame) ' frames!'])
    frm_start=1;
    frm_stop=max_frame;
    set(handles.start_frame,'string','1');
    set(handles.end_frame,'string',num2str(max_frame));
end
out=average_image(1, handles);
imagesc(out)

bw=masking(handles);
handles.bw=bw;
guidata(gcbo,handles);
movie_slider_Callback(hObject, eventdata, handles);
% hObject    handle to get_file_path (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in get_out_path.
function get_out_path_Callback(hObject, eventdata, handles)
path = uigetdir;
path=[path '\'];
set(handles.out_path,'string',path);
% hObject    handle to get_out_path (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)




function disp_scale_Callback(hObject, eventdata, handles)
movie_slider_Callback(hObject, eventdata, handles);
% hObject    handle to disp_scale (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of disp_scale as text
%        str2double(get(hObject,'String')) returns contents of disp_scale as a double



% --- Executes during object creation, after setting all properties.
function disp_scale_CreateFcn(hObject, eventdata, handles)
% hObject    handle to disp_scale (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in area_select.
function area_select_Callback(hObject, eventdata, handles)
%if a path is set, load the first frame and select area. Otherwise, say
%'need path to load'
path=get(handles.file_path,'string');
pressed=get(handles.area_select,'value');
set(handles.area_select,'string','Select Area to Analyze'); 
if ~isempty(path)
    axes(handles.axes_ave);
    start_frame=str2double(get(handles.start_frame,'string'));
    frame=read_image('glimpse',path,start_frame,'');
    disp_scale=str2num(get(handles.disp_scale,'string'));
    cla;
    hold off;
    
    colormap(gray);
    imagesc(frame,disp_scale);
    selected=func_gbox;
    selected=[num2str(floor(selected(1))) ' ' num2str(floor(selected(2))) ' ' num2str(floor(selected(3))) ' ' num2str(floor(selected(4)))];
    set(handles.area_selected,'string',selected);
    set(handles.area_select,'string','Area Selected');
    set(handles.area_select,'value',1)
else
    set(handles.area_select,'string','Need a path to load sample frame!');
    set(handles.area_select,'value',0);
end

% hObject    handle to area_select (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of area_select



function noise_Callback(hObject, eventdata, handles)
movie_slider_Callback(hObject, eventdata, handles);
% hObject    handle to noise (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of noise as text
%        str2double(get(hObject,'String')) returns contents of noise as a
%        double


% --- Executes during object creation, after setting all properties.
function noise_CreateFcn(hObject, eventdata, handles)
% hObject    handle to noise (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function pk_find_Callback(hObject, eventdata, handles)
movie_slider_Callback(hObject, eventdata, handles);
% hObject    handle to pk_find (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of pk_find as text
%        str2double(get(hObject,'String')) returns contents of pk_find as a
%        double


% --- Executes during object creation, after setting all properties.
function pk_find_CreateFcn(hObject, eventdata, handles)
% hObject    handle to pk_find (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function max_disp_Callback(hObject, eventdata, handles)
% hObject    handle to max_disp (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of max_disp as text
%        str2double(get(hObject,'String')) returns contents of max_disp as
%        a double


% --- Executes during object creation, after setting all properties.
function max_disp_CreateFcn(hObject, eventdata, handles)
% hObject    handle to max_disp (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function area_selected_Callback(hObject, eventdata, handles)
% hObject    handle to area_selected (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of area_selected as text
%        str2double(get(hObject,'String')) returns contents of area_selected as a double
movie_slider_Callback(hObject, eventdata, handles);


% --- Executes during object creation, after setting all properties.
function area_selected_CreateFcn(hObject, eventdata, handles)
% hObject    handle to area_selected (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in select_area.
function select_area_Callback(hObject, eventdata, handles)
global selected_area
path=get(handles.file_path,'string');
pressed=get(handles.select_area,'value');
set(handles.select_area,'string','Select Area'); 
if ~isempty(path)
    axes(handles.axes_ave);
    start_frame=str2double(get(handles.start_frame,'string'));
    frame=read_image('glimpse',path,start_frame,'');
    disp_scale=str2num(get(handles.disp_scale,'string'));
    hold off;
    axis auto;
    cla;
    colormap(gray);
    imagesc(frame,disp_scale);
    axis image;
    area_selected=func_gbox;
    frame_size=size(frame);
    if area_selected(1,3)>= area_selected(1,4) || area_selected(1,3)<1
        area_selected(1,3)=1;
    end
    if area_selected(1,4)<= area_selected(1,3) || area_selected(1,4)>frame_size(1)
        area_selected(1,4)=frame_size(1);
    end
    if area_selected(1,1)>= area_selected(1,2) || area_selected(1,1)<1
        area_selected(1,1)=1;
    end
    if area_selected(1,2)<= area_selected(1,1) || area_selected(1,2)>frame_size(2)
        area_selected(1,2)=frame_size(2);
    end
    selected_area=floor(area_selected);
    area_selected=[num2str(floor(area_selected(1))) ' ' num2str(floor(area_selected(2))) ' ' num2str(floor(area_selected(3))) ' ' num2str(floor(area_selected(4)))];
    set(handles.area_selected,'string',area_selected);
    set(handles.select_area,'string','Area Selected');
    set(handles.select_area,'value',1)
else
    set(handles.select_area,'string','Need a path to load sample frame!');
    set(handles.select_area,'value',0);
end
movie_slider_Callback(hObject, eventdata, handles);
% hObject    handle to select_area (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)



function frames_per_second_Callback(hObject, eventdata, handles)
% hObject    handle to frames_per_second (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of frames_per_second as text
%        str2double(get(hObject,'String')) returns contents of
%        frames_per_second as a double


% --- Executes during object creation, after setting all properties.
function frames_per_second_CreateFcn(hObject, eventdata, handles)
% hObject    handle to frames_per_second (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on slider movement.
function movie_slider_Callback(hObject, eventdata, handles)
axes(handles.axes_ave);
frm_start=str2double(get(handles.start_frame,'string'));
frm_stop=str2double(get(handles.end_frame,'string'));
fpath=get(handles.file_path,'string');
disp_scale=str2num(get(handles.disp_scale,'string'));
noise=str2num(get(handles.noise,'string'));
blob_size=str2num(get(handles.size,'string'));
pkfnd_input=str2num(get(handles.pk_find,'string'));
area_selected=str2num(get(handles.area_selected,'string'));
bpass_disp=get(handles.bpass_disp,'value');
noisy_data=get(handles.noisy_data,'value');
centroid=get(handles.centroid,'value');
selected_frame=get(handles.movie_slider,'value');
frame_average=str2num(get(handles.frame_average,'string'));

set(handles.movie_slider,'min',frm_start);
set(handles.movie_slider,'max',frm_stop);

%sets slider min max and values in different orders, must keep value
%between min and max at all times-
if selected_frame > frm_stop
    set(handles.movie_slider,'min',frm_start);
    set(handles.movie_slider,'value',frm_start);
    set(handles.movie_slider,'max',frm_stop);
elseif selected_frame < frm_start
    set(handles.movie_slider,'max',frm_stop);
    set(handles.movie_slider,'value',frm_start);
    set(handles.movie_slider,'min',frm_start);
end
set(handles.movie_slider,'min',frm_start);
set(handles.movie_slider,'max',frm_stop);

stored_frame=get(handles.frame_selected_temp,'value');
if stored_frame > 0
    slider_frame=floor(stored_frame);
    set(handles.frame_selected_temp,'value',0);
else
    slider_frame=floor(get(handles.movie_slider,'value'));
end

set(handles.frame_select,'string',num2str(slider_frame));

if isempty(fpath)
   set(handles.frame_select,'string','Select File Path');
   return;
end
load([fpath '\header.mat']);
max_frame=vid.nframes;
if frm_stop > max_frame
    warning(['this file only has ' num2str(max_frame) ' frames!'])
    frm_stop=max_frame;
    set(handles.end_frame,'string',num2str(max_frame));
end
if frm_start > max_frame
    warning(['this file only has ' num2str(max_frame) ' frames!'])
    frm_start=1;
    frm_end=max_frame;
    set(handles.start_frame,'string','1');
    set(handles.end_frame,'string',num2str(max_frame));
end

in=read_image('glimpse',fpath,slider_frame,'');

in=average_image(slider_frame, handles);

frame=in(area_selected(1,3):area_selected(1,4),area_selected(1,1):area_selected(1,2));
frame_bw=handles.bw(area_selected(1,3):area_selected(1,4),area_selected(1,1):area_selected(1,2));
dat=bpass(frame,noise,blob_size);
pk=[];
if noisy_data==1 %if optional third input of pkfind is to be used
    pk=pkfnd(dat,pkfnd_input(1),blob_size);
else
    pk=pkfnd(dat,pkfnd_input(1),0);
end

if centroid==1 %centroid refinement
    pk=cntrd(dat,pk,blob_size+2); 
else %gaussian refinement
    pk=gauss(dat,pk,blob_size+2); %centroid refinement
end

handles.peaks=pk;
axes(handles.axes_ave);
cla;
hold off;
colormap(gray);
if bpass_disp==1
    cla;
    imagesc(dat);
else
    imagesc(frame,disp_scale);
end
axis image;
%now need to draw boxes over the selected points and return number of
%points
point_count=0;
if ~isempty(pk)
    pksize=size(pk);
    %size of rectangles now changes with the size of the second input of noise
    for i=1:pksize(1,1)
        if frame_bw(floor(pk(i,2)),floor(pk(i,1)))==1 || frame_bw(ceil(pk(i,2)),ceil(pk(i,1)))==1
            rect_draw=[pk(i,1)-blob_size/2 pk(i,2)-blob_size/2 blob_size blob_size];
            rectangle('Position', rect_draw, 'LineWidth',1,'EdgeColor','r');
            point_count=point_count+1;
        end
    end 
end
set(handles.points_found,'string',num2str(point_count));
guidata(gcbo,handles);


% hObject    handle to movie_slider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of
%        slider


% --- Executes during object creation, after setting all properties.
function movie_slider_CreateFcn(hObject, eventdata, handles)
% hObject    handle to movie_slider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end

function frame_select_Callback(hObject, eventdata, handles)
selected_frame=str2num(get(handles.frame_select,'string'));
slider_min=get(handles.movie_slider,'min');
slider_max=get(handles.movie_slider,'max');
if selected_frame > slider_max
    selected_frame=slider_max;
end
if selected_frame < slider_min
    selected_frame=slider_min;
end
set(handles.movie_slider,'value',selected_frame);
set(handles.frame_selected_temp,'value',selected_frame);
movie_slider_Callback(hObject, eventdata, handles)


function frame_select_CreateFcn(hObject, eventdata, handles)
% hObject    handle to frame_select (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in frame_next.
function frame_next_Callback(hObject, eventdata, handles)
selected_frame=str2num(get(handles.frame_select,'string'));
set(handles.frame_select,'string',num2str(selected_frame+1));
frame_select_Callback(hObject, eventdata, handles);
% hObject    handle to frame_next (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in frame_prev.
function frame_prev_Callback(hObject, eventdata, handles)
selected_frame=str2num(get(handles.frame_select,'string'));
set(handles.frame_select,'string',num2str(selected_frame-1));
frame_select_Callback(hObject, eventdata, handles);
% hObject    handle to frame_prev (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% --- Executes on button press in bpass_disp.
function bpass_disp_Callback(hObject, eventdata, handles)
movie_slider_Callback(hObject, eventdata, handles);
% hObject    handle to bpass_disp (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of bpass_disp

% --- Executes on button press in manual_mask.
function manual_mask_Callback(hObject, eventdata, handles)
bw=masking(handles);
handles.bw=bw;
guidata(gcbo,handles);
movie_slider_Callback(hObject, eventdata, handles);


% hObject    handle to manual_mask (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of manual_mask


function manual_mask_CreateFcn(hObject, eventdata, handles)
% hObject    handle to frame_average (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function auto_mask_Callback(hObject, eventdata, handles)
bw=masking(handles);
handles.bw=bw;
guidata(gcbo,handles);
movie_slider_Callback(hObject, eventdata, handles);

function auto_mask_CreateFcn(hObject, eventdata, handles)
% hObject    handle to frame_average (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function no_mask_Callback(hObject, eventdata, handles)
bw=masking(handles);
handles.bw=bw;
guidata(gcbo,handles);
movie_slider_Callback(hObject, eventdata, handles);

function no_mask_CreateFcn(hObject, eventdata, handles)
% hObject    handle to frame_average (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function mask=masking(handles)
path=get(handles.file_path,'string');
noise=str2num(get(handles.noise,'string'));
blob_size=str2num(get(handles.size,'string'));
load([path '\header.mat']);
map_ave=read_image('glimpse',path,1,'');
for i=2:5
    map_ave=map_ave+read_image('glimpse',path,i,'');
end
map_ave=map_ave/5;
imsize=size(map_ave);
set(handles.area_selected,'string',num2str([1 imsize(2) 1 imsize(1)]));
dat=bpass(map_ave,noise,blob_size);
manual_mask=get(handles.manual_mask,'value');
auto_mask=get(handles.auto_mask,'value');
bw=[];
if manual_mask==1 %manual masking
    bw=roipolyold(dat);
elseif auto_mask==1 %auto masking
    bw=im2bw(imfilter(dat,ones(25,25)/1100,'symmetric'));
    bw = imfill(bw,'holes');
    bw = bwareaopen(bw,(imsize(1)*imsize(2))/3);
    bw=bwmorph(bw,'shrink',14);
else %no masking
    bw=ones(imsize(1), imsize(2));
end
mask=bw;

% --- Executes on button press in graph_spots.
function graph_spots_Callback(hObject, eventdata, handles)
slider_min=get(handles.movie_slider,'min');
slider_max=get(handles.movie_slider,'max');
spots_per_frame=[0 0];
for i=slider_min:slider_max
    set(handles.frame_select,'string',num2str(i));
    frame_select_Callback(hObject, eventdata, handles)
    point_count=str2num(get(handles.points_found,'string'));
    spots_per_frame=[spots_per_frame;i point_count];
end
spots_per_frame
plot(spots_per_frame(:,1),spots_per_frame(:,2));


% hObject    handle to graph_spots (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in save_coordinates.
function save_coordinates_Callback(hObject, eventdata, handles)
coord=handles.peaks;
coord=coord(:,1:2);
save_path=[get(handles.file_path,'string') 'frame-' get(handles.frame_select,'string') '-noise-' get(handles.noise,'string') '-size-' get(handles.size,'string') '-bright-' get(handles.pk_find,'string') '.mat'];
save (save_path,'coord');
% hObject    handle to save_coordinates (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)



function size_Callback(hObject, eventdata, handles)
blob_size=str2num(get(handles.size,'string'));
if blob_size/2 == floor(blob_size/2) || (blob_size+1)/2 ~= floor((blob_size+1)/2)
   'diameter of spots must be an odd integer!'
   blob_size=floor(blob_size);
   if blob_size/2 == floor(blob_size/2)
       blob_size=blob_size+1;
   end
   set(handles.size,'string',num2str(blob_size));
end
movie_slider_Callback(hObject, eventdata, handles)
% hObject    handle to size (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of size as text
%        str2double(get(hObject,'String')) returns contents of size as a
%        double


% --- Executes during object creation, after setting all properties.
function size_CreateFcn(hObject, eventdata, handles)
% hObject    handle to size (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in noisy_data.
function noisy_data_Callback(hObject, eventdata, handles)
movie_slider_Callback(hObject, eventdata, handles)
% hObject    handle to noisy_data (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of noisy_data



function frame_average_Callback(hObject, eventdata, handles)
movie_slider_Callback(hObject, eventdata, handles)
% hObject    handle to frame_average (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of frame_average as text
%        str2double(get(hObject,'String')) returns contents of
%        frame_average as a double


% --- Executes during object creation, after setting all properties.
function frame_average_CreateFcn(hObject, eventdata, handles)
% hObject    handle to frame_average (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end




function out=average_image(cur_frame, handles) %returns image averaged over %average% frames
frm_start=str2double(get(handles.start_frame,'string'));
frm_stop=str2double(get(handles.end_frame,'string'));
fpath=get(handles.file_path,'string');
frame_average=str2num(get(handles.frame_average,'string'));
frames_to_go=frame_average-1;
image=read_image('glimpse',fpath,cur_frame,'');
for i=1:frame_average-1 %loop and add a frame (next then prev) until the counter runs out
    if frames_to_go>0
        if cur_frame+i>frm_stop && cur_frame-i<frm_start %f can't add from next or prev, do nothing
           'frame average was set too large!'
           frames_to_go=0;
           set(handles.frame_average,'string',num2str(1));
           image=read_image('glimpse',fpath,cur_frame,'');
           image=image*frame_average;
        else
            if frames_to_go>=2 %add from next and prev if possible
                if cur_frame+i>frm_stop %can't add from next, add from prev once instead
                    %[num2str(cur_frame) ' frame + ' num2str(cur_frame-i) '   1']
                    image=image+read_image('glimpse',fpath,cur_frame-i,'');
                elseif cur_frame-i<frm_start% can't add from prev, add from next once instead
                    %[num2str(cur_frame) ' frame + ' num2str(cur_frame+i) '   2']
                    image=image+read_image('glimpse',fpath,cur_frame+i,'');
                else %can add from next and prev, will do so in that order
                    %[num2str(cur_frame) ' frame + ' num2str(cur_frame+i)  ' and ' num2str(cur_frame-i) '   3']
                    image=image+read_image('glimpse',fpath,cur_frame+i,'');
                    image=image+read_image('glimpse',fpath,cur_frame-i,'');
                    frames_to_go=frames_to_go-1;
                end
            elseif frames_to_go==1 %add to front if possible, if not then add to back
                if cur_frame+i>frm_stop %can't add from next, add from prev once instead
                    %[num2str(cur_frame) ' frame + ' num2str(cur_frame-i) '   4']
                    image=image+read_image('glimpse',fpath,cur_frame-i,'');
                elseif cur_frame-i<frm_start% can't add from prev, add from next once instead
                    %[num2str(cur_frame) ' frame + ' num2str(cur_frame+i) '   5']
                    image=image+read_image('glimpse',fpath,cur_frame+i,'');
                else %can add from next or prev, will add from next
                    %[num2str(cur_frame) ' frame + ' num2str(cur_frame+i) '   6']
                    image=image+read_image('glimpse',fpath,cur_frame+i,'');
                end
            end
            frames_to_go=frames_to_go-1;
        end
    end
end
out=image/frame_average;

function centroid_Callback(hObject, eventdata, handles)
movie_slider_Callback(hObject, eventdata, handles)

function gaussian_Callback(hObject, eventdata, handles)
movie_slider_Callback(hObject, eventdata, handles)




