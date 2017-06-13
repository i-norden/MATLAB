function varargout = gui_drift_correction(varargin)
% GUI_DRIFT_CORRECTION M-file for gui_drift_correction.fig
%      GUI_DRIFT_CORRECTION, by itself, creates a new GUI_DRIFT_CORRECTION or raises the existing
%      singleton*.
%
%      H = GUI_DRIFT_CORRECTION returns the handle to a new GUI_DRIFT_CORRECTION or the handle to
%      the existing singleton*.
%
%      GUI_DRIFT_CORRECTION('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in GUI_DRIFT_CORRECTION.M with the given input arguments.
%
%      GUI_DRIFT_CORRECTION('Property','Value',...) creates a new GUI_DRIFT_CORRECTION or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before gui_drift_correction_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to gui_drift_correction_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help gui_drift_correction

% Last Modified by GUIDE v2.5 27-Apr-2010 17:05:31

% Begin initialization code - DO NOT EDIT


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Version 1.0 4/23/10 by Alex O
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Version 1.1 5/1/10 by Alex O




gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @gui_drift_correction_OpeningFcn, ...
                   'gui_OutputFcn',  @gui_drift_correction_OutputFcn, ...
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


% --- Executes just before gui_drift_correction is made visible.
function gui_drift_correction_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to gui_drift_correction (see VARARGIN)

% Choose default command line output for gui_drift_correction
handles.output = hObject;
manual_correction_tab_Callback(hObject, eventdata, handles);
handles.fig=0;
%set handles
handles.trajectory=[];
set(handles.play_movie,'UserData',0);
set(handles.stop,'UserData',0);
handles.cc_drift_correction=[];
handles.drift_correction=[];
handles.cc_drift_correction=[];
handles.cc_fake_track=[];
handles.selected_spots=[];
handles.progress_bar_handle=[];
handles.drift_correction_fit=[];
handles.advanced_frame_selection=[];

%set slider
handles.max_frame=5;
set(handles.frame_slider,'Max',5);
set(handles.frame_slider,'Value',1);
set(handles.frame_slider,'Min',1);
set(handles.frame_slider,'SliderStep',[1/((5-1)) 0.1]);
handles.frame_slider_prev=1;

%set executable function handles for other guis
handles.exe_draw_figure=@draw_figure;
handles.exe_percent_covered=@percent_covered;


%set(handles.figure1,'Position',[30 0 227.8 10.8]);
%main_gui_pos=get(handles.gui_mapping,'Position');
%subgui 1 setup
handles.image1Handle = gui_image_display;
handles.image1Data= guidata(handles.image1Handle);
%set subgui 1 position
set(handles.image1Data.figure1,'Position',[0 17 106 11]);
%get(handles.image1Data.figure1,'Position');
% get figure1 handle
handles.fig1=handles.image1Data.fig;
%get(handles.fig1,'Position')
%set position of figure1
set(handles.fig1,'Position',[10 400 560 420]);
guidata(hObject, handles);
% UIWAIT makes gui_drift_correction wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = gui_drift_correction_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;



function frame_ranges_Callback(hObject, eventdata, handles)
fix_frame_ranges(hObject, eventdata, handles);
percent_covered(hObject, eventdata, handles);
% hObject    handle to frame_ranges (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of frame_ranges as text
%        str2double(get(hObject,'String')) returns contents of frame_ranges as a double




% --- Executes on slider movement.
function frame_slider_Callback(hObject, eventdata, handles)
frame=round(get(handles.frame_slider,'Value'));
set(handles.current_frame,'String',num2str(frame));
%path=get(handles.file_path,'string');
draw_figure(hObject, eventdata, handles);
% hObject    handle to frame_slider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of
%        slider




% --- Executes on button press in add_frame_range.
function add_frame_range_Callback(hObject, eventdata, handles)
values=str2num(get(handles.frame_ranges,'String'));
start=str2num(get(handles.fr_start_frame,'String'));
stop=str2num(get(handles.fr_end_frame,'String'));
if isempty(values)
    values=[start stop];
else
    values=[values;start stop];
end
set(handles.frame_ranges,'String',num2str(values));
fix_frame_ranges(hObject, eventdata, handles);
do_drift_correction(hObject, eventdata, handles);
percent_covered(hObject, eventdata, handles);
% hObject    handle to add_frame_range (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)



function fr_start_frame_Callback(hObject, eventdata, handles)
start_frame=str2num(get(handles.fr_start_frame,'String'));
end_frame=str2num(get(handles.fr_end_frame,'String'));
if start_frame<1
    start_frame=1;
elseif start_frame>=str2num(get(handles.fr_end_frame,'String'))
    start_frame=str2num(get(handles.fr_end_frame,'String'))-1;
end
if get(handles.frame_slider,'Value')<start_frame %fix slider value
    set(handles.frame_slider,'Value',start_frame);
end
set(handles.fr_start_frame,'String',num2str(start_frame));
set(handles.frame_slider,'Min',start_frame);
set(handles.frame_slider,'SliderStep',[1/((end_frame-start_frame)) 0.1]);
% hObject    handle to fr_start_frame (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of fr_start_frame as text
%        str2double(get(hObject,'String')) returns contents of fr_start_frame as a double




function fr_end_frame_Callback(hObject, eventdata, handles)
start_frame=str2num(get(handles.fr_start_frame,'String'));
end_frame=str2num(get(handles.fr_end_frame,'String'));
if end_frame>handles.max_frame
    end_frame=handles.max_frame;
elseif end_frame<=str2num(get(handles.fr_start_frame,'String'))
    end_frame=str2num(get(handles.fr_end_frame,'String'))+1;
end
if get(handles.frame_slider,'Value')>end_frame %fix slider value
    set(handles.frame_slider,'Value',end_frame);
end
set(handles.fr_end_frame,'String',num2str(end_frame));
set(handles.frame_slider,'Max',end_frame);
set(handles.frame_slider,'SliderStep',[1/((end_frame-start_frame)) 0.1]);
% hObject    handle to fr_end_frame (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of fr_end_frame as text
%        str2double(get(hObject,'String')) returns contents of fr_end_frame as a double



% --- Executes on button press in play_movie.
function play_movie_Callback(hObject, eventdata, handles)
figure(handles.fig1);
path=get(handles.file_path,'string');
chd2=get(get(handles.fig1,'children'),'children');
while 1==1
    waitfor(handles.stop,'UserData',0)
    if get(handles.play_movie,'UserData')==1
        set(handles.play_movie,'UserData',0);
        return;
    end
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%STOP CHECK%%%%%%%%%%%%%%%%%%%
    if get(handles.stop,'UserData')==1
        set(handles.stop,'UserData',0);
        return;
    end
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    frame=str2double(get(handles.current_frame,'string'));
    frame=frame+1;
    if frame>str2double(get(handles.fr_end_frame,'string'))
        frame=str2double(get(handles.fr_start_frame,'string'));
    end
    set(handles.current_frame,'String',num2str(frame));
    set(handles.frame_slider,'Value',frame);
    %image=read_image('glimpse',path,frame,' ');
    %set(chd2(end),'CData',image);
    %figure(handles.fig1);
    draw_figure(hObject, eventdata, handles);
    %set(handles.cc_progress,'String',num2str(frame))
end
% hObject    handle to play_movie (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in stop_movie.
function stop_movie_Callback(hObject, eventdata, handles)
set(handles.play_movie,'UserData',1);
%guidata(hObject, handles);
% hObject    handle to stop_movie (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in set_from_current_frame_start.
function set_from_current_frame_start_Callback(hObject, eventdata, handles)
set(handles.fr_start_frame,'String',get(handles.current_frame,'String'));
fr_start_frame_Callback(hObject, eventdata, handles);
% hObject    handle to set_from_current_frame_start (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in set_from_current_frame_end.
function set_from_current_frame_end_Callback(hObject, eventdata, handles)
set(handles.fr_end_frame,'String',get(handles.current_frame,'String'));
fr_end_frame_Callback(hObject, eventdata, handles);
% hObject    handle to set_from_current_frame_end (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


function first_last_toggle_Callback(hObject, eventdata, handles)
current=get(handles.current_frame,'String');
if strcmp(current,get(handles.fr_start_frame,'String'))
    set(handles.current_frame,'String',get(handles.fr_end_frame,'String'));
else
    set(handles.current_frame,'String',get(handles.fr_start_frame,'String'));
end
current_frame_Callback(hObject, eventdata, handles);

function current_frame_Callback(hObject, eventdata, handles)
current=str2num(get(handles.current_frame,'String'));
set(handles.frame_slider,'Value',current);
draw_figure(hObject, eventdata, handles);

% --- Executes on button press in load_file.
function load_file_Callback(hObject, eventdata, handles) %open a file
if isempty(get(handles.file_path,'string'))
    dir_path=uigetdir('D:\matlab\images','pick a glimpse directory');
else
    dir_path=uigetdir(get(handles.file_path,'string'),'pick a glimpse directory');
end

if strcmp('double',class(dir_path)) %cancelled directory selection
    return;
end

set(handles.file_path,'string',dir_path);
%load image into figure1
filename=get(handles.file_path,'String');
im_base=read_image('glimpse',filename,1,' ');
figure(handles.fig1);
legend off;
cla;
imagesc(im_base,str2num(get(handles.image1Data.disp_scale,'String')));
axis image;
colormap(gray);
handles.im_base=im_base;
%now to set gui_image_display's hard coded max to 2^16-1 unless the image is
%8 bit
if ~isa(im_base,'int8') && ~isa(im_base,'uint8')
    handles.image1Data.max_perm=2^16-1;
    guidata(handles.image1Handle, handles.image1Data);
    %reset the sliders
    set(handles.image1Data.black,'Max',2^16-1);
    set(handles.image1Data.white,'Max',2^16-1);
    set(handles.image1Data.black,'Value',1);
    set(handles.image1Data.white,'Value',2^16-1);
    %reset the min, max display
    set(handles.image1Data.min_scale,'string',num2str(0));
    set(handles.image1Data.max_scale,'string',num2str(2^16-1));
    %reset display scale
    set(handles.image1Data.disp_scale,'string',num2str([1 2^16-1]));
    
    %'image is not 8 bit, set as 16 bit!'
else
    %'image is 8 bit!'
end
%update slider
load([dir_path '\header.mat']); 
handles.max_frame=vid.nframes;
set(handles.frame_slider,'Min',1);
set(handles.frame_slider,'Max',handles.max_frame);
set(handles.fr_end_frame,'String',num2str(handles.max_frame));
start_frame=1;
end_frame=handles.max_frame;
set(handles.frame_slider,'SliderStep',[1/((end_frame-start_frame)) 0.1]);

%update selected area
image=read_image('glimpse',dir_path,1,'');
imsize=size(image);
area_selected=['1 ' num2str(imsize(2)) ' 1 ' num2str(imsize(1))];
set(handles.selected_area,'string',area_selected);

%update frame range
values=str2num(get(handles.frame_ranges,'String'));
values=[1 handles.max_frame];
set(handles.frame_ranges,'String',num2str(values));
handles.trajectory=[];

%execute autoscale in gui_image display
guidata(hObject, handles);  %update handles
handles.image1Data.exe_autoscale(handles.image1Handle,[],handles.image1Data);

guidata(hObject, handles);  %update handles
reset_handles(hObject, eventdata, handles);
guidata(hObject, handles);  %update handles
%update percent covered to be 0
percent_covered(hObject, eventdata, handles)
% hObject    handle to load_file (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in start_drift_correction.
function start_drift_correction_Callback(hObject, eventdata, handles)
%universal drift correction stuff here
file_path=[get(handles.file_path,'String') '\'];
selected_area=str2num(get(handles.selected_area,'String'));
%first must fix frame ranges
fix_frame_ranges(hObject, eventdata, handles);

load([file_path 'header.mat']);
%frame ranges to list of frames
frange=get_frame_range(hObject, eventdata, handles);
frange=frange';
if isempty(handles.progress_bar_handle)
    handles.progress_bar_handle=figure;
    guidata(hObject, handles);  %update handles
else
    figure(handles.progress_bar_handle);
end
%select drift correction type
if get(handles.manual_correction,'Value')
    %manual correction inputs here
    
    bpass_1=str2num(get(handles.diameter_of_noise,'String'));
    bpass_2=str2num(get(handles.diameter_of_spots,'String'));
    pkfnd_1=str2num(get(handles.brightness_of_spots,'String'));
    pkfnd_2=bpass_2+1;
    maxdisp_1=str2num(get(handles.max_disp,'String'));
    consec_frames=str2num(get(handles.join_tracks_x_frames_apart,'String'));
    good_tracks=str2num(get(handles.min_frames_in_tracks,'String'));
    pk_master=[];
    for findx=frange'
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %%STOP CHECK%%%%%%%%%%%%%%%%%%%
        if get(handles.stop,'UserData')==1
            set(handles.stop,'UserData',0);
            return;
        end
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        subfunc_progress_bar(handles,findx,1,max(frange),1);
        im=read_image('glimpse',file_path,findx,' ');
        im=im(selected_area(3):selected_area(4),selected_area(1):selected_area(2));
        dat=bpass(im,bpass_1,bpass_2);
        pk=pkfnd(dat,pkfnd_1,pkfnd_2);
        pk=cntrd(dat,pk,pkfnd_2+1); %centroid refinement
        if isempty(pk)
            pk=[0 0 findx];
        else
            pk=pk(:,1:2);
            pk(:,3)=findx;
        end
        pk_master=[pk_master;pk];
    end
    %pk_master
    %tracking--------------------------------------------------------
    param.mem=consec_frames;    %has to be in consecutive frames to be considered in the same trajectory
    param.good=good_tracks;   %min frames to be considered a trajectory
    param.dim=3;    %x y t (3D)
    param.quiet=1;  %no text
    handles.trajectory=track(pk_master,maxdisp_1,param);
    
    if isempty(handles.trajectory)
        'no trajectories found!'
        
    else
        handles.trajectory=sortrows(handles.trajectory,4);
        handles.trajectory(:,5)=0;
        %add to trajectory x and y here to compensate for selected area thing
        handles.trajectory(:,1)=handles.trajectory(:,1)+selected_area(1);
        handles.trajectory(:,2)=handles.trajectory(:,2)+selected_area(3);
        
    end
    %handles.trajectory
    
elseif get(handles.cross_correlation,'Value')
    %Cross Correlation Drift Correction
    %how the variables are used here:
% gfolder == file_path
% frmrange == all of the frame ranges
% frmlim == taken from selected_area
% averange == input from cross correlation tab
% fitwidth == input from cross correlation tab
% filesource == only take glimpse files

    %set progress bar parameters here
    progress_bar_param.handles=handles;
    progress_bar_param.frames_done=0;
    progress_bar_param.tracks_done=1;
    progress_bar_param.frames_total=max(frange);
    progress_bar_param.tracks_total=1;
    

    fitwidth=str2num(get(handles.fitwidth,'String'));
    averange=str2num(get(handles.averange,'String'));

    drift_correction=[];
    %area selected for use y1 y2 x1 x2
    sel_area=[selected_area(3) selected_area(4) selected_area(1) selected_area(2)];
    frame_start=frange(1);
    frame_stop=frange(end);
    [c,d]=size(frange);
    for i=1:c-1
        findi=frange(i);
        findi2=frange(i+1);
        if findi2-findi > 1
            frame_stop=findi;
            ['multi doing ' num2str(frame_start) ' ' num2str(frame_stop)]
            drift_correction=[0 0 0 0 0 0 0 0 0 0 0;drift_correction];
            drift_correction=[drift_correction;drifting_v7(file_path,[frame_start frame_stop],sel_area,averange,fitwidth,1,progress_bar_param)];
            frame_start=frange(i+1);
        else
            frame_stop=findi2;
        end
    end
    if isempty(drift_correction)
        % use default values of frame start-frame stop
        findi=frange(1);
        findi2=frange(end);
        ['single doing ' num2str(findi) ' ' num2str(findi2)]
        drift_correction=[0 0 0 0 0 0 0 0 0 0 0;drift_correction];
        drift_correction=[drift_correction;drifting_v7(file_path,[findi findi2],sel_area,averange,fitwidth,1,progress_bar_param)];
        %progress_bar(hObject, eventdata, handles, max(frange)-findi2,1,max(frange),1);
    else
        ['multi doing last' num2str(frame_start) ' ' num2str(frame_stop)]
        drift_correction=[0 0 0 0 0 0 0 0 0 0 0;drift_correction];
        drift_correction=[drift_correction;drifting_v7(file_path,[frame_start frame_stop],sel_area,averange,fitwidth,1,progress_bar_param)];
        %progress_bar(hObject, eventdata, handles, max(frange)-frame_stop,1,max(frange),1);
    end
    findi=frange(i);
    findi2=frange(i+1);
    [r,c]=size(drift_correction);
    for i=0:r-1
%         if limit==1
%             if drift_correction(r-i,10)>abs(manx)
%                drift_correction(r-i,10)=abs(manx); 
%             elseif drift_correction(r-i,10)<-abs(manx)
%                drift_correction(r-i,10)=-abs(manx); 
%             end
%             if drift_correction(r-i,11)>abs(many)
%                drift_correction(r-i,11)=abs(many); 
%             elseif drift_correction(r-i,11)<-abs(many)
%                drift_correction(r-i,11)=-abs(many); 
%             end
%         end
        drift_correction(r-i,10)=sum(drift_correction(1:r-i,10));
        drift_correction(r-i,11)=sum(drift_correction(1:r-i,11));
    end
    crossx=drift_correction(end,10);
    crossy=drift_correction(end,11);
    %End Cross Correlation Drift Correction
    handles.drift_correction=[drift_correction(:,10) drift_correction(:,11) frange];
    handles.cc_drift_correction=[drift_correction(:,10) drift_correction(:,11) frange];
    fake_x=(selected_area(2)+selected_area(1))/2;
    fake_y=(selected_area(4)+selected_area(3))/2;
    %make fake trajectory
    fake_track=handles.drift_correction;
    %set start to be center of selected area
    fake_track(:,1)=fake_track(:,1)+fake_x;
    fake_track(:,2)=fake_track(:,2)+fake_y;
    fake_track(:,4)=1;
    fake_track(:,5)=1;
    handles.cc_fake_track=fake_track;
    %set(handles.cc_progress,'String','Finished');
elseif get(handles.click_and_track,'Value') %click and track drift correction here
    %set(handles.start_drift_correction,'String','Tracking...');
    %figure(handles.fig1);
    if ~isempty(handles.selected_spots)
        handles.selected_spots
        file_path=get(handles.file_path,'String');
        ranges=str2num(get(handles.frame_ranges,'String'));
        xysize=str2num(get(handles.ct_diam_of_spots,'String'));
        if mod(xysize,2)==0
            xysize=xysize+1; %must be odd number   
        end
        xyjump=str2num(get(handles.ct_max_disp,'String'));
        xy_sigma=str2num(get(handles.xy_sigma,'String'));
        frange=get_frame_range(hObject, eventdata, handles);
        for i=1:size(handles.selected_spots,1) %for each spot selected to be tracked
            new_track_id=1;
            if ~isempty(handles.trajectory) %get the track id this new track will use
                new_track_id=max(handles.trajectory(:,4))+1;
            end
            xin=handles.selected_spots(i,1);
            yin=handles.selected_spots(i,2);
            for j=frange
                %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                %%STOP CHECK%%%%%%%%%%%%%%%%%%%
                if get(handles.stop,'UserData')==1
                    set(handles.stop,'UserData',0);
                    return;
                end
                %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                subfunc_progress_bar(handles, 1,((i-1)*max(frange))+j,max(frange),size(handles.selected_spots,1));
                if j>=handles.selected_spots(i,3) %only use frames on which the spot was selected
                    %set(handles.start_drift_correction,'String',['Refining Frame ' num2str(j)]);
                    %figure(handles.fig1);
                    dum=read_image('glimpse',file_path,j,' ');
                    [xfit yfit amp sigma offset]=spot_2D_gaussian(xin,yin,dum,xysize,xyjump,xy_sigma);
                    xin=xfit;
                    yin=yfit;
                    %add found spot to current track
                    handles.trajectory=[handles.trajectory;xin yin j new_track_id 1];
                end 
            end
        end
    end
    %set(handles.start_drift_correction,'String','Start Drift Correction');
    handles.selected_spots=[];
else
    'not a valid correction choice'
end
%reset image here to make draw_image simpler
frame=round(get(handles.frame_slider,'Value'));
path=get(handles.file_path,'string');
title(['Frame ' num2str(frame)]);
xlabel('X Axis of Image (pixels)');
ylabel('Y Axis of Image (pixels)');
image=read_image('glimpse',path,frame,' ');
disp_scale=str2num(get(handles.image1Data.disp_scale,'String'));
figure(handles.fig1);
cla;
imagesc(image,disp_scale);
colormap(gray);
axis image;
hold on;
%%%%%%%%%%%%%%%%%%%
guidata(hObject, handles);  %update handles
do_drift_correction(hObject, eventdata, handles);
frame_slider_Callback(hObject, eventdata, handles);


function selected_area_Callback(hObject, eventdata, handles)
% hObject    handle to selected_area (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of selected_area as text
%        str2double(get(hObject,'String')) returns contents of selected_area as a double





% --- Executes on button press in select_area_to_analyze.
function select_area_to_analyze_Callback(hObject, eventdata, handles)
path=get(handles.file_path,'string');
set(handles.select_area_to_analyze,'string','Select Area'); 
if ~isempty(path)
    figure(handles.fig1);
    start_frame=str2double(get(handles.fr_start_frame,'string'));
    frame=read_image('glimpse',path,1,'');
    
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
    area_selected=[num2str(floor(area_selected(1))) ' ' num2str(floor(area_selected(2))) ' ' num2str(floor(area_selected(3))) ' ' num2str(floor(area_selected(4)))];
    set(handles.selected_area,'string',area_selected);
    set(handles.select_area_to_analyze,'string','Area Selected');
    set(handles.select_area_to_analyze,'value',1)
else
    set(handles.select_area_to_analyze,'string','Need a path to load sample frame!');
    set(handles.select_area_to_analyze,'value',0);
end
% hObject    handle to select_area_to_analyze (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)



function diameter_of_noise_Callback(hObject, eventdata, handles)
% hObject    handle to diameter_of_noise (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of diameter_of_noise as text
%        str2double(get(hObject,'String')) returns contents of diameter_of_noise as a double




function diameter_of_spots_Callback(hObject, eventdata, handles)
% hObject    handle to diameter_of_spots (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of diameter_of_spots as text
%        str2double(get(hObject,'String')) returns contents of diameter_of_spots as a double





function brightness_of_spots_Callback(hObject, eventdata, handles)
% hObject    handle to brightness_of_spots (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of brightness_of_spots as text
%        str2double(get(hObject,'String')) returns contents of brightness_of_spots as a double





function max_disp_Callback(hObject, eventdata, handles)
% hObject    handle to max_disp (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of max_disp as text
%        str2double(get(hObject,'String')) returns contents of max_disp as a double




function join_tracks_x_frames_apart_Callback(hObject, eventdata, handles)
% hObject    handle to join_tracks_x_frames_apart (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of join_tracks_x_frames_apart as text
%        str2double(get(hObject,'String')) returns contents of join_tracks_x_frames_apart as a double





function min_frames_in_tracks_Callback(hObject, eventdata, handles)
% hObject    handle to min_frames_in_tracks (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of min_frames_in_tracks as text
%        str2double(get(hObject,'String')) returns contents of min_frames_in_tracks as a double





% --- Executes on button press in get_track_information.
function get_track_information_Callback(hObject, eventdata, handles)
if ~isempty(handles.trajectory)
    id=return_nearest_TOI(hObject, eventdata, handles);
    if id==-1 %user aborted selection
        return;
    end
    %open track viewing gui
    handles.track_info_gui = subgui_track_information;
    handles.track_info_gui_data= guidata(handles.track_info_gui);
    %set subgui 1 position
    %set(handles.image1Data.figure1,'Position',[0 17 106 11]);
    
    %get useful info to give to subgui
    track=handles.trajectory(find(handles.trajectory(:,4)==id),:);
    file_path=get(handles.file_path,'string');
    disp_scale=str2num(get(handles.image1Data.disp_scale,'String'));
    track_size=str2num(get(handles.diameter_of_spots,'String'));
    radius=track_size/1.4;
    %set all useful info to subgui handles
    handles.track_info_gui_data.main_gui_handle=hObject;
    handles.track_info_gui_data.track=track;
    handles.track_info_gui_data.file_path=file_path;
    handles.track_info_gui_data.disp_scale=disp_scale;
    handles.track_info_gui_data.track_size=track_size;
    handles.track_info_gui_data.radius=radius;
    
    %set track info in subgui
    handles.track_info_gui_data.exe_set_new_track(handles.track_info_gui, [], handles.track_info_gui_data);
    %set subplot check to on
    handles.track_info_gui_data.subplot_on=1;
    
    %guidata(handles.track_info_gui, handles.track_info_gui_data);
    guidata(hObject, handles);  %update handles
end
% hObject    handle to get_track_information (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in select_tracks_to_use.
function select_tracks_to_use_Callback(hObject, eventdata, handles)
if ~isempty(handles.trajectory) && ~isempty(get(handles.file_path,'String'))
    while true
        id=return_nearest_TOI(hObject, eventdata, handles);
        if isempty(id)
            'no tracks exist in this frame!'
        elseif id==-1 %user wants to stop clicking
            break;
        else
            find_traj=find(handles.trajectory(:,4)==id);
            handles.trajectory(find_traj,5)=1;
            guidata(hObject, handles);  %update handles
        end
        %update percent covered
        percent_covered(hObject, eventdata, handles);
        frame_slider_Callback(hObject, eventdata, handles);
        %do_drift_correction(hObject, eventdata, handles);    
    end
    view_covered_frames_Callback(hObject, eventdata, handles);
end
% hObject    handle to select_tracks_to_use (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in deselect_tracks_to_use.
function deselect_tracks_to_use_Callback(hObject, eventdata, handles)
if ~isempty(handles.trajectory) && ~isempty(get(handles.file_path,'String'))   
    while true
        id=return_nearest_TOI(hObject, eventdata, handles);
        if isempty(id)
            'no tracks exist in this frame!'
        elseif id==-1 %user wants to stop clicking
            break;
        else
            find_traj=find(handles.trajectory(:,4)==id);
            handles.trajectory(find_traj,5)=0;
            guidata(hObject, handles);  %update handles
        end
        %update percent covered
        percent_covered(hObject, eventdata, handles)
        frame_slider_Callback(hObject, eventdata, handles);
        %do_drift_correction(hObject, eventdata, handles);
    end
    view_covered_frames_Callback(hObject, eventdata, handles);
end
% hObject    handle to deselect_tracks_to_use (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in manual_correction_tab.
function manual_correction_tab_Callback(hObject, eventdata, handles)
setVisibility_manual_correction(handles,'on');
setVisibility_cross_correlation(handles,'off');
setVisibility_click_and_track(handles,'off');
set(handles.manual_correction,'value',1);
set(handles.cross_correlation,'value',0);
set(handles.click_and_track,'value',0);
% hObject    handle to manual_correction_tab (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in cross_correlation_tab.
function cross_correlation_tab_Callback(hObject, eventdata, handles)
setVisibility_manual_correction(handles,'off');
setVisibility_cross_correlation(handles,'on');
setVisibility_click_and_track(handles,'off');
set(handles.manual_correction,'value',0);
set(handles.cross_correlation,'value',1);
set(handles.click_and_track,'value',0);
% hObject    handle to cross_correlation_tab (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in click_and_track_tab.
function click_and_track_tab_Callback(hObject, eventdata, handles)
setVisibility_manual_correction(handles,'off');
setVisibility_cross_correlation(handles,'off');
setVisibility_click_and_track(handles,'on');
set(handles.manual_correction,'value',0);
set(handles.cross_correlation,'value',0);
set(handles.click_and_track,'value',1);
% hObject    handle to click_and_track_tab (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


function setVisibility_manual_correction(handles,visible) %sets visibility of everything specific to manual correction
set(handles.manual_correction_panel,'visible',visible);
set(handles.refine_selected_tracks,'visible',visible);
set(handles.refine_selected_tracks_text1,'visible',visible);
set(handles.refine_selected_tracks_text2,'visible',visible);


function setVisibility_cross_correlation(handles,visible) %sets visibility of everything specific to cross_correlation
op_visible='off';
if strcmp(visible,'off')
    op_visible='on';
end
set(handles.cross_correlation_panel,'visible',visible);
set(handles.track_editing_panel,'visible',op_visible);

function setVisibility_click_and_track(handles,visible) %sets visibility of everything specific to click_and_track
set(handles.click_and_track_panel,'visible',visible);


function fix_frame_ranges(hObject, eventdata, handles)
values_string=get(handles.frame_ranges,'String');
%values=str2num(get(handles.frame_ranges,'String'));
new_frame_ranges=[];
if ~isempty(values_string)
    for j=size(values_string,1):-1:1 %declining rows of frame ranges
        cur_string=values_string(j,:);
        cur_values=str2num(cur_string);
        cur_string=strtrim(cur_string); %remove leading and trailing whitespace
        cur_string=regexprep(cur_string,' ',':',1); %replace 1 space with a colon
        cur_string=regexprep(cur_string,' ',''); %removes all spaces
        if isempty(cur_values) %catches all non digit entries
            if size(values_string,1)==1 %this is the only entry
                new_frame_ranges=num2str([1 handles.max_frame]);
                %set(handles.frame_ranges,'String',new_frame_ranges);
            end
        elseif ~isempty(regexp(cur_string, '(\d*+:+\d*+:\d*)', 'once' )) %if in the form x:y:z where they are digits
            parts=regexp(cur_string,':','split');
            parts_num=[str2num(parts{1}) str2num(parts{2}) str2num(parts{3})];
            %size(parts_num)
            if parts_num(1)>=parts_num(3) || parts_num(2)>=parts_num(3) %numbers don;t logically fit
                if size(values_string,1)==1 %this is the only entry
                    new_frame_ranges=num2str([1 handles.max_frame]);
                    %set(handles.frame_ranges,'String',new_frame_ranges);
                end   
            elseif parts_num(1)<1 || parts_num(3)>handles.max_frame %numbers outside bounds
                if size(values_string,1)==1 %this is the only entry
                    new_frame_ranges=num2str([1 handles.max_frame]);
                    %set(handles.frame_ranges,'String',new_frame_ranges);
                end
            else %hopefully a valid selection
                new_frame_ranges=char(cur_string,new_frame_ranges);
            end
            %then do nothing, the user is on their own here
        elseif ~isempty(regexp(cur_string, '(\d*+:+\d*)', 'once' ))==1 || ~isempty(regexp(cur_string, '(\d*+:+\d*)', 'once' ))==1 %if in the form x:y where they are digits
            cur_string=regexprep(cur_string,':',' ');
            cur_values=str2num(cur_string);
            
            if cur_values(1)>=cur_values(2) %improper selection
                if size(values_string,1)==1 %this is the only entry
                    new_frame_ranges=num2str([1 handles.max_frame]);
                    %set(handles.frame_ranges,'String',new_frame_ranges);
                end
            elseif cur_values(1)<1 || cur_values(2)>handles.max_frame %outside of bounds
                if cur_values(1)<1 %start too low
                    cur_values(1)=1;
                else %end too high
                    cur_values(2)=handles.max_frame;
                end
                if size(values_string,1)==1 %this is the only entry
                    new_frame_ranges=num2str([cur_values(1) cur_values(2)]);
                    %set(handles.frame_ranges,'String',new_frame_ranges);
                end
            else %hopefully valid
                new_frame_ranges=char(cur_string,new_frame_ranges);         
            end
          
        else %doesnt match any supported syntax
            if size(values_string,1)==1 %this is the only entry
                new_frame_ranges=num2str([1 handles.max_frame]);
                %set(handles.frame_ranges,'String',new_frame_ranges);
            end
        end
    end
    if size(new_frame_ranges,1)>1
        new_frame_ranges=new_frame_ranges(1:end-1,:);%remove last row (always empty because of char call)
    end
    %now to remove redundant frame ranges
    %'fix redundant'
    newer_frame_ranges=[];
    for i=size(new_frame_ranges,1):-1:1
        cur_string=new_frame_ranges(i,:);
        cur_string=strtrim(cur_string);
        enter_in=1;
        if ~isempty(regexp(cur_string, '(\d*+:+\d*+:\d*)', 'once' )) %if in the form x:y:z where they are digits
            parts=regexp(cur_string,':','split');
            triple=[str2num(parts{1}) str2num(parts{2}) str2num(parts{3})];
            for j=size(new_frame_ranges,1):-1:1 %check each new frame range
                string=new_frame_ranges(j,:);
                string=strtrim(string);
                if ~isempty(regexp(string, '(\d*+:+\d*+:\d*)', 'once' )) %if in the form x:y:z where they are digits
                    parts=regexp(new_frame_ranges(j,:),':','split');
                    parts_num=[str2num(parts{1}) str2num(parts{2}) str2num(parts{3})];
                    %compare [x:y:z] to [x:y:z]
                    if min(parts_num==triple)==1 && j~=i %repeated entry
                        enter_in=0;
                        break;    
                    end
                    %don;t want to do more sophisticated fixing, it's too
                    %complicated and unnecessary

                else %[x y] form
                    values=str2num(new_frame_ranges(j,:));
                    if triple(1)>=values(1) && triple(3)<=values(2) %contained in another range
                        enter_in=0;
                        break;
                    end
                end
            end         
        else %[x y] form
            curr_values=str2num(cur_string);
            for j=size(new_frame_ranges,1):-1:1 %check each new frame range
                string=new_frame_ranges(i,:);
                string=strtrim(string);
                if ~isempty(regexp(string, '(\d*+:+\d*+:\d*)', 'once' )) %if in the form x:y:z where they are digits
                    parts=regexp(new_frame_ranges(j,:),':','split');
                    parts_num=[str2num(parts{1}) str2num(parts{2}) str2num(parts{3})];
                    %compare [x:y:z] to [x:y]
                    if parts_num(2)==1 && parts_num(1)<=curr_values(1) && parts_num(3)>=curr_values(2) %contained in triple
                        enter_in=0;
                        break;    
                    end
                    %don;t want to do more sophisticated fixing, it's too
                    %complicated and unnecessary

                else %[x y] form
                    values=str2num(new_frame_ranges(j,:));
                    if curr_values(1)>=values(1) && curr_values(2)<=values(2) && j~=i %contained in another range and not itself
                        enter_in=0;
                        break;
                    elseif curr_values(1)>=values(1) && curr_values(1)<=values(2) && j~=i %start intersects with another range
                        length=size(new_frame_ranges(j,:),2);
                        replacing=num2str([values(1) curr_values(2)]);
                        %size(replacing,2)
                        if length>=size(replacing,2) %pad replacing with spaces as necessary
                            for k=1:length-size(replacing,2)
                                replacing=[replacing ' '];
                            end   
                        else %pad new_frame_ranges with spaces
                            for k=1:size(replacing,2)-length
                                new_frame_ranges(:,end+1)=' ';
                            end  
                        end
                        %size(replacing,2)
                        new_frame_ranges(j,:)=replacing;
                        enter_in=0;
                        break;
                        
                    elseif curr_values(2)<=values(2) && curr_values(2)>=values(1) && j~=i %end intersects with another range
                        length=size(new_frame_ranges(j,:),2);
                        replacing=num2str([curr_values(1) values(2)]);
                        %size(replacing,2)
                        if length>=size(replacing,2) %pad replacing with spaces as necessary
                            for k=1:length-size(replacing,2)
                                replacing=[replacing ' '];
                            end   
                        else %pad new_frame_ranges with spaces
                            for k=1:size(replacing,2)-length
                                new_frame_ranges(:,end+1)=' ';
                            end  
                        end
                        %size(replacing,2)
                        new_frame_ranges(j,:)=replacing;
                        enter_in=0;
                        break;                   
                    end
                end
            end          
        end
        if enter_in==1
            newer_frame_ranges=char(cur_string,newer_frame_ranges);
        else
            new_frame_ranges(i,:)=[];
        end  
    end
    newer_frame_ranges=newer_frame_ranges(1:end-1,:);%remove last row (always empty because of char call)
    set(handles.frame_ranges,'String',newer_frame_ranges);
end

function range=get_frame_range(hObject, eventdata, handles)
frames=get(handles.frame_ranges,'String');
range=[];
if ~isempty(frames)
    for i=1:size(frames,1)
        cur_string=frames(i,:);
        cur_string=strtrim(cur_string);
        values=str2num(cur_string);
        if ~isempty(regexp(cur_string, '(\d*+:+\d*+:\d*)', 'once' )) %if in the form x:y:z where they are digits
            range=[range values];          
        else %[x y] form
            range=[range values(1):values(2)];
        end
    end
    range=sort(unique(range));
end


function draw_figure(hObject, eventdata, handles)
frame=round(get(handles.frame_slider,'Value'));
path=get(handles.file_path,'string');
if ~isempty(path)
    figure(handles.fig1);
    title(['Frame ' num2str(frame)]);
    xlabel('X Axis of Image (pixels)');
    ylabel('Y Axis of Image (pixels)');
    image=read_image('glimpse',path,frame,' ');
    chd2=get(get(handles.fig1,'children'),'children');
    %drift correction display settings
    spot_size=str2num(get(handles.diameter_of_spots,'String'));
    if ~isempty(handles.trajectory) || ~isempty(handles.selected_spots)
        disp_scale=str2num(get(handles.image1Data.disp_scale,'String'));       
        cla;
        imagesc(image,disp_scale);
        colormap(gray);
        axis image;
        hold on;
        if ~isempty(handles.trajectory)
            tracks_in_frame=handles.trajectory(find(handles.trajectory(:,3)==frame),:);
            unused_parts_of_tracks=tracks_in_frame(find(tracks_in_frame(:,5)==2),:);
            selected_tracks=tracks_in_frame(find(tracks_in_frame(:,5)==1),:);
            unselected_tracks=tracks_in_frame(find(tracks_in_frame(:,5)==0),:);
            plot(unselected_tracks(:,1),unselected_tracks(:,2),'o','MarkerEdgeColor','r','MarkerSize',spot_size)
            plot(unused_parts_of_tracks(:,1),unused_parts_of_tracks(:,2),'o','MarkerEdgeColor','b','MarkerSize',spot_size)
            plot(selected_tracks(:,1),selected_tracks(:,2),'o','MarkerEdgeColor','g','MarkerSize',spot_size)          
            %legend plot check
            if ~isempty(unselected_tracks)
                if ~isempty(unused_parts_of_tracks)
                    if ~isempty(selected_tracks) %all have stuff
                        h = legend('Unselected','Partially Selected','Selected',3);
                    else %no selected tracks in this frame
                        h = legend('Unselected','Partially Selected',3);
                    end              
                else %no partially selected
                    if ~isempty(selected_tracks) %no partially selected
                        h = legend('Unselected','Selected',3);
                    else %no partially selected, no selected
                        h = legend('Unselected',3);
                    end
                end 
            else %no unselected
                if ~isempty(unused_parts_of_tracks)
                    if ~isempty(selected_tracks) %no unselected, all others have stuff
                        h = legend('Partially Selected','Selected',3);
                    else %no unselected, no selected
                        h = legend('Partially Selected',3);
                    end              
                else %no unselected, no partially selected
                    if ~isempty(selected_tracks) %no unselected, no partially selected
                        h = legend('Selected',3);
                    else
                        h = legend('off');
                    end
                    
                end    
            end
            set(h,'Interpreter','none');
        end
        if ~isempty(handles.selected_spots)
            spots_in_frame=handles.selected_spots(find(handles.selected_spots(:,3)==frame),:);
            plot(spots_in_frame(:,1),spots_in_frame(:,2),'rs','MarkerEdgeColor','y','MarkerSize',spot_size)      
        end
    elseif iscell(chd2(end)) %if it became a cell array
        %chd2=get(get(handles.fig1,'children'),'children')
        size(chd2)
        if size(chd2,1)>1
            chd3=chd2{end};
            chd3=chd3(end);
            set(chd3,'CData',image);
        else
            set(chd2{end},'CData',image);
        end
        legend('off');
        
    else %normal case    
        %chd2=get(get(handles.fig1,'children'),'children');
        set(chd2(end),'CData',image);
        legend('off');
    end
    
end

function id=return_nearest_TOI(hObject, eventdata, handles)
frame=str2num(get(handles.current_frame,'String'));
figure(handles.fig1);
[x y button]=ginput(1);
if button==3 || isempty(x) || isempty(y) %user wants to stop clicking
    id=-1;
else
    tracks_in_frame=handles.trajectory(find(handles.trajectory(:,3)==frame),:);
    store=sqrt((tracks_in_frame(:,1)-x).^2 + (tracks_in_frame(:,2)-y).^2);
    id=tracks_in_frame(find(store==min(store)),4);
end
if isempty(id)
    id=-1;
end


% --- Executes on button press in view_covered_frames.
function view_covered_frames_Callback(hObject, eventdata, handles)
%stop_check(hObject, eventdata, handles);
if ~isempty(handles.trajectory)
    %frame ranges to list of frames
    ranges=get(handles.frame_ranges,'String');
    frange=[];
    selected=handles.trajectory(find(handles.trajectory(:,5)==1),:);
    if handles.fig == 0
        handles.fig=figure();
        guidata(hObject, handles);
    else
        figure(handles.fig);
    end
    cla;
    xlabel('Frames');
    ylabel('Track IDs');
    axis ij;
    for i=1:size(ranges,1)
        cur_values=str2num(ranges(i,:));
        frange=[frange cur_values(1):cur_values(end)];
        rectangle('Position',[cur_values(1),-5,cur_values(end)-cur_values(1)+1,5],'EdgeColor','k','FaceColor','k');
    end

    tracks=unique(selected(:,4));
    for i=1:size(tracks,1) %for each track
        length=selected(find(selected(:,4)==tracks(i)),:);
        rectangle('Position',[min(length(:,3)),tracks(i)-.5,size(length,1),1],'EdgeColor','r','FaceColor','r');
    end
    if isempty(tracks)
       tracks=9; 
    end
    axis([min(frange) max(frange) -5 round(max(tracks)+size(tracks,1)+.5)]);
    title('Black= Frame Range, Red= Tracks');    
end



% hObject    handle to view_covered_frames (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

function smaller=return_smaller(num1,num2)
num1=round(num1);
num2=round(num2);
if num1<=num2
    smaller=num1;
else
    smaller=num2;
end

function larger=return_larger(num1,num2)
num1=round(num1);
num2=round(num2);
if num1>=num2
    larger=num1;
else
    larger=num2;
end

function percent_covered(hObject, eventdata, handles)
if ~isempty(handles.trajectory)
    %fix frame ranges
    fix_frame_ranges(hObject, eventdata, handles);

    %frame ranges to list of frames
    frange=get_frame_range(hObject, eventdata, handles);
    frange=frange';
    frange(:,2)=0;
    selected=handles.trajectory(find(handles.trajectory(:,5)==1),[3 5]);
    for i=1:size(frange,1)
        if ~isempty(find(selected(:,1)==frange(i,1), 1))
            frange(i,2)=1;
        end
    end
    covered=round((sum(frange(:,2))/size(frange,1))*100);
    set(handles.percent_covered,'String',[num2str(covered) '% Covered']);
else
    set(handles.percent_covered,'String','0% Covered');
end


% --- Executes on button press in stop.
function stop_Callback(hObject, eventdata, handles)
set(handles.stop,'UserData',1);
% hObject    handle to stop (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)



function averange_Callback(hObject, eventdata, handles)
% hObject    handle to averange (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of averange as text
%        str2double(get(hObject,'String')) returns contents of averange as a double


% --- Executes during object creation, after setting all properties.
function averange_CreateFcn(hObject, eventdata, handles)
% hObject    handle to averange (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function fitwidth_Callback(hObject, eventdata, handles)
% hObject    handle to fitwidth (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of fitwidth as text
%        str2double(get(hObject,'String')) returns contents of fitwidth as a double


% --- Executes during object creation, after setting all properties.
function fitwidth_CreateFcn(hObject, eventdata, handles)
% hObject    handle to fitwidth (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in cc_save_to_file.
function cc_save_to_file_Callback(hObject, eventdata, handles)
cross_correlation_corr=handles.cc_drift_correction;
[filename pathname]=uiputfile(' ','save info as','drift_correction.mat');
save([pathname filename],'cross_correlation_corr');


function [xfit yfit amp sigma offset]=spot_2D_gaussian(xin,yin,dum,xysize,xyjump,xy_sigma)

%xin=guess for x
%yin=guess for y
%dum=image
%xysize=diameter of spot
%xyjump=pixels it can move between frames
%xy_sigma=spread of curve


%find the center x-y position of a spot by fitting it with a 
%symmetric 2D gaussian function.
%dum is the input image

%set AOI and fit parameters
%xy_sigma=2.5;       %set to 2.5 pixels ~ 170 nm in hv scope
%xyjump=5;           %do not track if signal is weak and the fitting
%'jumps' by more than xyjump pixels
%-------------
xyhalf=floor(xysize/2);
xrange=[round(xin)-xyhalf:round(xin)+xyhalf];
yrange=[round(yin)-xyhalf:round(yin)+xyhalf];
%find center x-y position by a symmetric 2D gaussian
dat=dum(yrange,xrange);     %region containing a spot
offset=min(min(dat));
amplitude=max(max(dat))-offset;
fit_arg=[amplitude xysize/2 xysize/2 xy_sigma offset];
xdata(:,:,1)=ones(xysize,xysize)*diag(1:xysize);  % x matrix 
xdata(:,:,2)=diag(1:xysize)*ones(xysize,xysize);  % y matrix	
gaussfun=inline('fit_arg(1)*exp(-0.5*((xdata(:,:,1)-fit_arg(2)).^2+(xdata(:,:,2)-fit_arg(3)).^2)/fit_arg(4)^2)+fit_arg(5)','fit_arg','xdata');
options=optimset('lsqcurvefit');
options=optimset(options,'display','off');
fit_arg=lsqcurvefit(gaussfun,fit_arg,xdata,dat,[10 0 0 0.5 10],[1e5 50 50 25 1e5],options);

%return results:
xfit=fit_arg(2)+xrange(1)-1;
yfit=fit_arg(3)+yrange(1)-1;
%keep the last x and y if the fitted spot moves too much, 
%in this case by more than xyjump pixels.
if abs(xfit-xin>xyjump) || abs(yfit-yin)>xyjump
  xfit=xin;
  yfit=yin;
end 
amp=fit_arg(1);
sigma=fit_arg(4);
offset=fit_arg(5);


% --- Executes on button press in refine_all_tracks.
function refine_all_tracks_Callback(hObject, eventdata, handles)
set(handles.refine_all_tracks,'String','Refining...');
if ~isempty(handles.trajectory)
    handles.trajectory=sortrows(handles.trajectory,3);
    path=get(handles.file_path,'String');
    bpass_2=str2num(get(handles.diameter_of_spots,'String'));
    xy_sigma=str2num(get(handles.xy_sigma,'string'));
    xyjump=1;
    if mod(bpass_2,2)==0
        xysize=bpass_2+5;
    else
        xysize=bpass_2+4;
    end
    %xysize
    frame=handles.trajectory(1,3);
    dum=read_image('glimpse',path,frame,' ');
    for i=1:size(handles.trajectory,1)
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %%STOP CHECK%%%%%%%%%%%%%%%%%%%
        if get(handles.stop,'UserData')==1
            set(handles.stop,'UserData',0);
            return;
        end
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        set(handles.refine_all_tracks,'String',['Refining Frame ' num2str(handles.trajectory(i,3))]);
        figure(handles.fig1);
        xin=handles.trajectory(i,1);
        yin=handles.trajectory(i,2);
        if frame == handles.trajectory(i,3) %if working with same frame
            %do not load image again
        else %new frame
            dum=read_image('glimpse',path,handles.trajectory(i,3),' ');  
            frame=handles.trajectory(i,3);
        end       
        [xfit yfit amp sigma offset]=spot_2D_gaussian(xin,yin,dum,xysize,xyjump,xy_sigma);
        handles.trajectory(i,1:2)=[xfit yfit];
    end
    handles.trajectory=sortrows(handles.trajectory,4);
end
set(handles.refine_all_tracks,'String','Refine All Tracks');
guidata(hObject, handles);
do_drift_correction(hObject, eventdata, handles);
frame_slider_Callback(hObject, eventdata, handles);
% hObject    handle to refine_all_tracks (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in refine_selected_tracks.
function refine_selected_tracks_Callback(hObject, eventdata, handles)
%set(handles.refine_selected_tracks,'String','Refining...');
if ~isempty(handles.trajectory)
    handles.trajectory=sortrows(handles.trajectory,3);
    path=get(handles.file_path,'String');
    bpass_2=str2num(get(handles.diameter_of_spots,'String'));
    xy_sigma=str2num(get(handles.xy_sigma,'string'));
    xyjump=str2num(get(handles.xy_sigma,'string'));
    if mod(bpass_2,2)==0
        xysize=bpass_2+1;
    else
        xysize=bpass_2;
    end
    %xysize
    frame=-1;
    dum=[];
    handles.trajectory=sortrows(handles.trajectory,3);
    for i=1:size(handles.trajectory,1)
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %%STOP CHECK%%%%%%%%%%%%%%%%%%%
        if get(handles.stop,'UserData')==1
            set(handles.stop,'UserData',0);
            return;
        end
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        if handles.trajectory(i,5)==1
            %set(handles.refine_all_tracks,'String',['Refining Frame ' num2str(handles.trajectory(i,3))]);
            %figure(handles.fig1);
            xin=handles.trajectory(i,1);
            yin=handles.trajectory(i,2);
            if frame == handles.trajectory(i,3) %if working with same frame
                %do not load image again
            else %new frame
                dum=read_image('glimpse',path,handles.trajectory(i,3),' ');  
                frame=handles.trajectory(i,3);
            end       
            [xfit yfit amp sigma offset]=spot_2D_gaussian(xin,yin,dum,xysize,xyjump,xy_sigma);
            handles.trajectory(i,1:2)=[xfit yfit];
        end
        subfunc_progress_bar(handles,i,1,size(handles.trajectory,1),1);
    end
    handles.trajectory=sortrows(handles.trajectory,4);
end
%set(handles.refine_all_tracks,'String','Refine All Tracks');
guidata(hObject, handles);
do_drift_correction(hObject, eventdata, handles);
frame_slider_Callback(hObject, eventdata, handles);
% hObject    handle to refine_selected_tracks (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)



function xy_sigma_Callback(hObject, eventdata, handles)
% hObject    handle to xy_sigma (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of xy_sigma as text
%        str2double(get(hObject,'String')) returns contents of xy_sigma as a double


% --- Executes during object creation, after setting all properties.
function xy_sigma_CreateFcn(hObject, eventdata, handles)
% hObject    handle to xy_sigma (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in load_project.
function load_project_Callback(hObject, eventdata, handles)
[dcs_name dcs_path]=uigetfile('D:\matlab\images','pick a map file to load');
if dcs_path==0 %do not proceed if uigetfile is cancelled
    'cancelled loading file!'
    return;
end
reset_handles(hObject, eventdata, handles);
load([dcs_path dcs_name]);

%load saved parameters into handles structure
%tracks
handles.trajectory=drift_correction_save.tracks;
handles.cc_fake_track=drift_correction_save.cc_tracks;
%file path
set(handles.file_path,'String',drift_correction_save.file_path);
%selected area
set(handles.selected_area,'String',drift_correction_save.selected_area);
%frame ranges
set(handles.frame_ranges,'String',drift_correction_save.frame_ranges);
%manual correction parameters
set(handles.diameter_of_noise,'String',drift_correction_save.mc.bpass_1);
set(handles.diameter_of_spots,'String',drift_correction_save.mc.bpass_2);
set(handles.brightness_of_spots,'String',drift_correction_save.mc.pkfnd_1);
set(handles.max_disp,'String',drift_correction_save.mc.maxdisp_1);
set(handles.join_tracks_x_frames_apart,'String',drift_correction_save.mc.consec_frames);
set(handles.min_frames_in_tracks,'String',drift_correction_save.mc.good_tracks);
%click and track parameters
set(handles.xy_sigma,'String',drift_correction_save.ct.xy_sigma);
set(handles.ct_diam_of_spots,'String',drift_correction_save.ct.ct_diam_of_spots);
set(handles.ct_max_disp,'String',drift_correction_save.ct.ct_max_disp);

%cross correlation parameters
set(handles.fitwidth,'String',drift_correction_save.cc.fitwidth);
set(handles.averange,'String',drift_correction_save.cc.averange);

%new loading



%update slider and sub gui

%load image into figure1
filename=get(handles.file_path,'String');
im_base=read_image('glimpse',filename,1,' ');
figure(handles.fig1);
legend off;
cla;
imagesc(im_base,str2num(get(handles.image1Data.disp_scale,'String')));
axis image;
colormap(gray);
handles.im_base=im_base;
%now to set gui_image_display's hard coded max to 2^16-1 unless the image is
%8 bit
%now to set gui_image_display's hard coded max to 2^16-1 unless the image is
%8 bit
if ~isa(im_base,'int8') && ~isa(im_base,'uint8')
    handles.image1Data.max_perm=2^16-1;
    guidata(handles.image1Handle, handles.image1Data);
    %reset the sliders
    set(handles.image1Data.black,'Max',2^16-1);
    set(handles.image1Data.white,'Max',2^16-1);
    set(handles.image1Data.black,'Value',1);
    set(handles.image1Data.white,'Value',2^16-1);
    %reset the min, max display
    set(handles.image1Data.min_scale,'string',num2str(0));
    set(handles.image1Data.max_scale,'string',num2str(2^16-1));
    %reset display scale
    set(handles.image1Data.disp_scale,'string',num2str([1 2^16-1]));
    
    %'image is not 8 bit, set as 16 bit!'
else
    %'image is 8 bit!'
end
%update slider

load([filename '\header.mat']); 
handles.max_frame=vid.nframes;
set(handles.frame_slider,'Max',handles.max_frame);
set(handles.fr_end_frame,'String',num2str(handles.max_frame));

guidata(hObject, handles);
%do_drift_correction(hObject, eventdata, handles);
handles.image1Data.exe_autoscale(handles.image1Handle,[],handles.image1Data);
frame_slider_Callback(hObject, eventdata, handles);
% hObject    handle to load_project (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in select_spots_to_track.
function select_spots_to_track_Callback(hObject, eventdata, handles)
while true % until LMB or enter is pressed
    frame=str2num(get(handles.current_frame,'String'));
    figure(handles.fig1);
    [x y button]=ginput(1);    %first select the point of interest
    if(button==3)
        break;
    end
    if isempty([x y])
        break;
        %end loop 
    end
    handles.selected_spots=[handles.selected_spots;x y frame];
    frame_slider_Callback(hObject, eventdata, handles);
end
%handles.selected_spots
guidata(hObject, handles);
%handles.selected_spots
% hObject    handle to select_spots_to_track (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in save_project.
function save_project_Callback(hObject, eventdata, handles)
%actual drift correction
drift_correction_save.drift_correction=handles.drift_correction;
drift_correction_save.drift_correction_fit=handles.drift_correction_fit;
%tracks
drift_correction_save.tracks=handles.trajectory;
drift_correction_save.cc_tracks=handles.cc_fake_track;
%file path
drift_correction_save.file_path=get(handles.file_path,'String');
%selected area
drift_correction_save.selected_area=get(handles.selected_area,'String');
%frame ranges
drift_correction_save.frame_ranges=get(handles.frame_ranges,'String');
%manual correction parameters
drift_correction_save.mc.bpass_1=get(handles.diameter_of_noise,'String');
drift_correction_save.mc.bpass_2=get(handles.diameter_of_spots,'String');
drift_correction_save.mc.pkfnd_1=get(handles.brightness_of_spots,'String');
drift_correction_save.mc.maxdisp_1=get(handles.max_disp,'String');
drift_correction_save.mc.consec_frames=get(handles.join_tracks_x_frames_apart,'String');
drift_correction_save.mc.good_tracks=get(handles.min_frames_in_tracks,'String');
%click and track parameters
drift_correction_save.ct.xy_sigma=get(handles.xy_sigma,'String');
drift_correction_save.ct.ct_diam_of_spots=get(handles.ct_diam_of_spots,'String');
drift_correction_save.ct.ct_max_disp=get(handles.ct_max_disp,'String');
%cross correlation parameters
drift_correction_save.cc.fitwidth=get(handles.fitwidth,'String');
drift_correction_save.cc.averange=get(handles.averange,'String');
%information about save file
drift_correction_save.info.name='gui_drift_correction';
drift_correction_save.info.date=datestr(now);
drift_correction_save.info.version='1.1';
drift_correction_save.username=getenv('UserName');


[filename pathname]=uiputfile(' ','save info as','drift_correction_save.mat');
save([pathname filename],'drift_correction_save');
% hObject    handle to save_project (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

function reset_handles(hObject, eventdata, handles)
%reset all relevant data, tracks, etc.
handles.trajectory=[];
set(handles.play_movie,'UserData',0);
set(handles.stop,'UserData',0);
handles.drift_correction=[];
handles.drift_correction_fit=[];
handles.selected_spots=[];
handles.drift_correction=[];

guidata(hObject, handles);


% --- Executes on button press in recalculate_drift_corr.
function recalculate_drift_corr_Callback(hObject, eventdata, handles)
do_drift_correction(hObject, eventdata, handles);
% hObject    handle to recalculate_drift_corr (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


function do_drift_correction(hObject, eventdata, handles)
%now uses tracks[] to reference handles.trajectory
if ~isempty(handles.trajectory) || ~isempty(handles.cc_fake_track)
    tracks=handles.trajectory;
    if ~isempty(handles.cc_fake_track)
        tracks=handles.cc_fake_track;
    end
    selected_tracks=tracks(find(tracks(:,5)==1),:);
    if ~isempty(selected_tracks)
        %frame ranges to list of frames
        ranges=str2num(get(handles.frame_ranges,'String'));
        frange=get_frame_range(hObject, eventdata, handles);
        %get time info
        fpath=get(handles.file_path,'string');
        if ~isempty(fpath)
            load([fpath '\header.mat']);
            time=vid.ttb;
            time=time-time(1);
            time=time/1000;
            %set up drift_corr
            drift_corr=frange;
            drift_corr=drift_corr';
            drift_corr(:,2:4)=0;
            drift_corr(1,4)=time(frange(1)); %set first frame used
            counter=2;
            for i=frange(2:end) %all frames except first
                if ~isempty(find(frange(1,:)==i-1, 1)) %continuous with previous frame
                    frame_tracks=selected_tracks(find(selected_tracks(:,3)==i),1:4);
                    prev_frame_tracks=selected_tracks(find(selected_tracks(:,3)==(i-1)),1:4);
                    %make sure tracks exist in both frames
                    if ~isempty(frame_tracks) && ~isempty(prev_frame_tracks)
                        %only get tracks that exist in both frames
                        [ids findex pindex]=intersect(frame_tracks(:,4),prev_frame_tracks(:,4));
                        %update tracks in the two frames
                        frame_tracks=sortrows(frame_tracks(findex,:),4);
                        prev_frame_tracks=sortrows(prev_frame_tracks(pindex,:),4);
                        %make sure there are tracks that exist in the two
                        %frames
                        if ~isempty(frame_tracks) && ~isempty(prev_frame_tracks)
                            frame_tracks=frame_tracks(1:2)-prev_frame_tracks(1:2);
                            drift_corr(counter,2)=mean(mean(frame_tracks(:,1)));
                            drift_corr(counter,3)=mean(mean(frame_tracks(:,2)));
                        end
                    end
                end
                drift_corr(counter,4)=time(i);
                counter=counter+1;
            end
            
            handles.drift_correction=drift_corr;
            %handles.drift_correction
            [r,c]=size(drift_corr);
            for i=0:r-1
                drift_corr(r-i,2)=sum(drift_corr(1:r-i,2));
                drift_corr(r-i,3)=sum(drift_corr(1:r-i,3));
            end
            drift_corr_sum=[drift_corr(:,1) drift_corr(:,2) drift_corr(:,3) drift_corr(:,4)];
            if get(handles.poly_fit,'Value')==1
                degree=str2num(get(handles.poly_fit_degree,'String'));
                fitx=polyfit(drift_corr_sum(:,1),drift_corr_sum(:,2),degree);
                fity=polyfit(drift_corr_sum(:,1),drift_corr_sum(:,3),degree);
                fx = polyval(fitx,drift_corr_sum(:,1));
                %graph fit x vs frames
                figure;
                subplot(1,2,1);
                hold on;
                plot(drift_corr_sum(:,4),drift_corr_sum(:,2),'-ro');
                plot(drift_corr_sum(:,4),fx);
                title('Drift Corr (X axis) vs. Frames');
                h = legend('Drift Correction','Polynomial Smoothing',2);
                set(h,'Interpreter','none');
                xlabel('Time (sec)');
                ylabel('Drift Corr (X axis in pixels)');

                fy = polyval(fity,drift_corr_sum(:,1));
                %graph fit x vs frames
                subplot(1,2,2);
                hold on;
                plot(drift_corr_sum(:,4),drift_corr_sum(:,3),'-ro');
                plot(drift_corr_sum(:,4),fy);
                title('Drift Corr (Y axis) vs. Frames');
                h = legend('Drift Correction','Polynomial Smoothing',2);
                set(h,'Interpreter','none');
                xlabel('Time (sec)');
                ylabel('Drift Corr (Y axis in pixels)');



                drift_correction_fit=[drift_corr_sum(:,1) fx fy drift_corr_sum(:,4)];
                %drift_correction_fit

                [r,c]=size(drift_correction_fit);
                for i=2:r
                    drift_correction_fit(i,2)=drift_correction_fit(i,2)-sum(drift_correction_fit(1:i-1,2));
                    drift_correction_fit(i,3)=drift_correction_fit(i,3)-sum(drift_correction_fit(1:i-1,3));
                end
                handles.drift_correction_fit=drift_correction_fit;
                handles.drift_correction_fit
                temp1=handles.drift_correction_fit(:,1);
                %temp1'

            else
                figure;
                subplot(1,2,1)
                hold on;
                plot(drift_corr_sum(:,4),drift_corr_sum(:,2),'-ro')
                title('Drift Corr (X axis) vs. Frames');
                h = legend('Drift Correction',1);
                set(h,'Interpreter','none');
                xlabel('Time (sec)')
                ylabel('Drift Corr (X axis in pixels)');


                subplot(1,2,2)
                hold on;
                plot(drift_corr_sum(:,4),drift_corr_sum(:,3),'-ro')    
                title('Drift Corr (Y axis) vs. Frames');
                h = legend('Drift Correction',1);
                set(h,'Interpreter','none');
                xlabel('Time (sec)')
                ylabel('Drift Corr (Y axis in pixels)');
                handles.drift_correction
            end
            guidata(hObject, handles);
        end
    
    end
end



function poly_fit_degree_Callback(hObject, eventdata, handles)
% hObject    handle to poly_fit_degree (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of poly_fit_degree as text
%        str2double(get(hObject,'String')) returns contents of poly_fit_degree as a double


% --- Executes during object creation, after setting all properties.
function poly_fit_degree_CreateFcn(hObject, eventdata, handles)
% hObject    handle to poly_fit_degree (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function ct_diam_of_spots_Callback(hObject, eventdata, handles)
% hObject    handle to ct_diam_of_spots (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of ct_diam_of_spots as text
%        str2double(get(hObject,'String')) returns contents of ct_diam_of_spots as a double




function ct_max_disp_Callback(hObject, eventdata, handles)
% hObject    handle to ct_max_disp (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of ct_max_disp as text
%        str2double(get(hObject,'String')) returns contents of ct_max_disp as a double


function check_slider_movement_ButtonMovement(hObject, eventdata, handles)
%values
frame_slider_frame=get(handles.frame_slider,'Value');
%pos = get(handles.frame_slider,'Position')
%R=get(hObject,'currentPoint')
%black slider check
if handles.frame_slider_prev~=frame_slider_frame
    handles.frame_slider_prev=frame_slider_frame;
    guidata(hObject, handles);
    frame_slider_Callback(hObject, eventdata, handles);   
end


% --- Executes on button press in advanced_frame_selection.
function advanced_frame_selection_Callback(hObject, eventdata, handles)

%open frame options gui
advanced_frame_selection = subgui_advanced_frame_selection;
advanced_frame_selection_data= guidata(advanced_frame_selection);
%set subgui 1 position
%set(handles.image1Data.figure1,'Position',[0 17 106 11]);

%get useful info to give to subgui
frame_ranges=get(handles.frame_ranges,'string');

%set all useful info to subgui handles
handles.track_info_gui_data.main_gui_handle=hObject;
advanced_frame_selection_data.frame_ranges=frame_ranges;
%save subgui handles
guidata(advanced_frame_selection, advanced_frame_selection_data);

% hObject    handle to advanced_frame_selection (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of advanced_frame_selection


% --- Executes on button press in clear_tracks.
function clear_tracks_Callback(hObject, eventdata, handles)
handles.trajectory=[];
handles.selected_spots=[];

%frame_slider_Callback(hObject, eventdata, handles);

%update image to clear any drawings on it
frame=round(get(handles.frame_slider,'Value'));
path=get(handles.file_path,'string');
figure(handles.fig1);
cla;
if ~isempty(path) 
    title(['Frame ' num2str(frame)]);
    image=read_image('glimpse',path,frame,' ');
    disp_scale=str2num(get(handles.image1Data.disp_scale,'String'));       
    colormap(gray);
    axis image;
    hold on;
    imagesc(image,disp_scale);
end
guidata(hObject, handles);
% hObject    handle to clear_tracks (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


