function varargout = gui_particle_finder(varargin)
% GUI_PARTICLE_FINDER() Lets you dynamically analyze and intercact with
% spots
% This program allows you to analyze a glimpse sequence file and implements
% Grier's spot finding algorithm to automotically locate spots. You can
% edit the spots and analyze tracks (spots over multiple frames).
%
%Alex O, June 16, 2009 Version 1.5
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Alex O, Aug 1, 2009 Version 1.5.1
%   added features to combine, split tracks
%   added features to add, remove aois, tracks
%   added color to panels
%   added disappearing/appearing panels
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Alex O, Aug 3, 2009 Version 1.5.2
%added total tracks and visible tracks found feature
%did various debugging
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Alex O, Aug 14, 2009 Version 1.5.3
%minor debugging, now can use area select and masking in any order and
%without image size change problems
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Alex O, Aug 23, 2009 Version 1.5.4
%major ui overhaul, not much actual code change
%optimized movie_sider_callback
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Alex O, Sept 2, 2009 Version 1.5.5
%fixed loading of different size sequences, masking
%optimized movie_sider_callback
%added rolling and block averaging


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
handles.tracks=[];
handles.aoi_add=[];
handles.aoi_remove=[];
set(handles.cancel_button,'UserData',0);
set(handles.movie_slider,'value',1);
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
fpath=get(handles.file_path,'string');
if ~isempty(fpath)
    load([fpath '\header.mat']);
    max_frame=vid.nframes;
    if str2num(get(handles.start_frame,'string')) > max_frame
        warning(['this file only has ' num2str(max_frame) ' frames!'])
        set(handles.start_frame,'string','1');
        set(handles.end_frame,'string',num2str(max_frame));
    end

    if get(handles.movie_slider,'value') < str2num(get(handles.start_frame,'string'))
        set(handles.movie_slider,'value',str2num(get(handles.start_frame,'string')))
    end
    movie_slider_Callback(hObject, eventdata, handles);
end
set_slider_scale(handles);
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
fpath=get(handles.file_path,'string');
if ~isempty(fpath)
    load([fpath '\header.mat']);
    max_frame=vid.nframes;
    if str2num(get(handles.end_frame,'string')) > max_frame
        warning(['this file only has ' num2str(max_frame) ' frames!'])
        set(handles.end_frame,'string',num2str(max_frame));
    end
    if get(handles.movie_slider,'value') > str2num(get(handles.end_frame,'string'))
        set(handles.movie_slider,'value',str2num(get(handles.end_frame,'string')))
    end
    movie_slider_Callback(hObject, eventdata, handles);
end
set_slider_scale(handles);
% hObject    handle to end_frame (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of end_frame as text
%        str2double(get(hObject,'String')) returns contents of end_frame as a double
function set_slider_scale(handles)
start_frame=str2num(get(handles.start_frame,'string'));
end_frame=str2num(get(handles.end_frame,'string'));
set(handles.movie_slider,'SliderStep',[1/((end_frame-start_frame)) 0.1]);


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
path = uigetdir;
path=[path '\'];
set(handles.file_path,'string',path);
if isempty(path)
   %set(handles.frame_select,'string','Select File Path');
   return;
end
load([path '\header.mat']);
frm_stop=vid.nframes;
set(handles.start_frame,'string',num2str(1));
set(handles.end_frame,'string',num2str(frm_stop));
set(handles.frame_select,'string',num2str(1));
set(handles.movie_slider,'value',1);
image=read_image('glimpse',path,1,'');
imsize=size(image);
area_selected=['1 ' num2str(imsize(2)) ' 1 ' num2str(imsize(1))];
set(handles.area_selected,'string',area_selected);
set(handles.select_area,'value',0);
%select_area_Callback(hObject, eventdata, handles);
set(handles.no_mask,'value',1);
no_mask_Callback(hObject, eventdata, handles);
bw=masking(handles);
handles.bw=bw;
handles.tracks=[];
handles.aoi_add=[];
handles.aoi_remove=[];
guidata(gcbo,handles);
set_slider_scale(handles);
movie_slider_Callback(hObject, eventdata, handles);
% hObject    handle to get_file_path (see GCBO)
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
%        str2double(get(hObject,'String')) returns contents of
%        area_selected as a double
guidata(gcbo,handles);
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
path=get(handles.file_path,'string');
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
    area_selected=[num2str(floor(area_selected(1))) ' ' num2str(floor(area_selected(2))) ' ' num2str(floor(area_selected(3))) ' ' num2str(floor(area_selected(4)))];
    set(handles.area_selected,'string',area_selected);
    set(handles.select_area,'string','Area Selected');
    set(handles.select_area,'value',1)
else
    set(handles.select_area,'string','Need a path to load sample frame!');
    set(handles.select_area,'value',0);
end
handles.tracks=[];
guidata(gcbo,handles);
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
function varargout = movie_slider_Callback(hObject, eventdata, handles)
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
view_aois_tracks=get(handles.view_aois_tracks,'value');
average_type=get(handles.average_menu,'value');
set(handles.movie_slider,'min',frm_start)
set(handles.movie_slider,'max',frm_stop)
slider_frame=floor(get(handles.movie_slider,'value'));
set(handles.frame_select,'string',num2str(slider_frame));

if isempty(fpath)
   %set(handles.frame_select,'string','Select File Path');
   return;
end

if average_type==1
    in=average_image(slider_frame, handles);
else  
    in=block_average_image(slider_frame, handles);
end

frame=in(area_selected(1,3):area_selected(1,4),area_selected(1,1):area_selected(1,2));
frame_bw=handles.bw(area_selected(1,3):area_selected(1,4),area_selected(1,1):area_selected(1,2));
dat=bpass(frame,noise,blob_size);
pk=[];
tracks_info=[];
if view_aois_tracks==1 %view aois, frame by frame options
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
    %remove last two useless rows of pk
    if ~isempty(pk)
        pk=pk(:,1:2);
    end
    %append track info to pk, then make unique
    if ~isempty(handles.tracks)
        toAdd=handles.tracks(find(handles.tracks(:,3)==slider_frame),1:2);
        pk=[pk;toAdd];
        pk=unique(pk,'rows');
    end



    if ~isempty(handles.aoi_remove) %will remove peaks from pk
        removeFrom=[];
        if ~isempty(handles.aoi_add)
            removeFrom=handles.aoi_add(find(handles.aoi_add(:,3)==slider_frame),1:2);
        end
        if ~isempty(pk) && ~isempty(removeFrom) %remove from pk or aoi_add
            toRemove=handles.aoi_remove(find(handles.aoi_remove(:,3)==slider_frame),1:2);
            if ~isempty(toRemove)
                [toRemove_length toRemove_width] = size(toRemove);
                for i=toRemove_length:-1:1
                    store=sqrt((pk(:,1)-toRemove(i,1)).^2 + (pk(:,2)-toRemove(i,2)).^2);
                    store_aoi_add=sqrt((removeFrom(:,1)-toRemove(i,1)).^2 + (removeFrom(:,2)-toRemove(i,2)).^2);
                    if min(store)<min(store_aoi_add) %pk has closer point
                        pk(find(store==min(store)),:)=[];
                    else %if equal or aoi-add has closer point
                        %remove the point from aoi_add so it doesnt appear
                        %again and from aoi_remove so it doeesn;t try to delete
                        %the next closest point
                        [a ind]=ismember(removeFrom(find(store_aoi_add==min(store_aoi_add)),:),handles.aoi_add(:,1:2),'rows');
                        removeFrom(find(store_aoi_add==min(store_aoi_add)),:)=[];
                        handles.aoi_add(ind,:)=[];
                        [a ind]=ismember(toRemove(i,:),handles.aoi_remove(:,1:2),'rows');
                        toRemove(i,:)=[];
                        handles.aoi_remove(ind,:)=[];
                    end
                end
            end


        elseif ~isempty(pk) %aoi_add is empty, will remove peaks from pk only
            toRemove=handles.aoi_remove(find(handles.aoi_remove(:,3)==slider_frame),1:2);
            if ~isempty(toRemove)
                [toRemove_length toRemove_width] = size(toRemove);
                for i=1:toRemove_length
                    store=sqrt((pk(:,1)-toRemove(i,1)).^2 + (pk(:,2)-toRemove(i,2)).^2);
                    pk(find(store==min(store)),:)=[];
                end
            end

        elseif ~isempty(removeFrom) %pk is empty, will remove peaks from aoi_add only
            toRemove=handles.aoi_remove(find(handles.aoi_remove(:,3)==slider_frame),1:2);
            if ~isempty(toRemove) && ~isempty(removeFrom) %both must not be empty, otherwise do nothing
                [toRemove_length toRemove_width] = size(toRemove);
                for i=1:toRemove_length
                    store=sqrt((removeFrom(:,1)-toRemove(i,1)).^2 + (removeFrom(:,2)-toRemove(i,2)).^2);
                    removeFrom(find(store==min(store)),:)=[];
                end
            end

        end
    end

    if ~isempty(handles.aoi_add) && view_aois_tracks==1 %will add peaks to pk
        toAdd=handles.aoi_add(find(handles.aoi_add(:,3)==slider_frame),1:2);
        if ~isempty(toAdd)
            pk=[pk;toAdd];
        end
    end  

else %view_aois_tracks>1 %view tracks, replace pk with track info
    if ~isempty(handles.tracks)
        tracks_info=handles.tracks(find(handles.tracks(:,3)==slider_frame),:);
        pk=tracks_info(:,1:2);
    end
end

handles.peaks=pk;
varargout={pk};
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
set(handles.points_found,'string','0');
if ~isempty(pk)
    %if image is larger than frame_bw (selected area has been changed but
    %mask has not) then set to no mask
    datsize=size(dat);
    bwsize=size(frame_bw);
    if datsize(1)>bwsize(1) || datsize(2)>bwsize(2)
        %set to no mask
        set(handles.no_mask,'value',1);
        no_mask_Callback(hObject, eventdata, handles);
        frame_bw=ones(datsize(1),datsize(2));
    end
    pksize=size(pk);
    %size of rectangles now changes with the size of the second input of noise
    %remove all pk points outside the mask
    for i=pksize(1,1):-1:1
        if frame_bw(floor(pk(i,2)),floor(pk(i,1)))==0 || frame_bw(ceil(pk(i,2)),ceil(pk(i,1)))==0
            pk(i,:)=[];
            if ~isempty(tracks_info)
                tracks_info(i,:)=[];
            end
        end
    end
    if ~isempty(pk)
        pksize=size(pk);
        if view_aois_tracks==1
            %set points found to total size of points inside mask
            set(handles.points_found,'string',num2str(pksize(1,1)));
            set(handles.points_disp,'string','Spots:');
            set(handles.tracks_disp,'string','Tracks:');
        else
            %set points to new display, total tracks. will count all
            %tracks including those that exist but do not appear in this
            %field.
            %tracks will show visible tracks.
            
            set(handles.points_disp,'string','Total Tracks:');
            set(handles.tracks_disp,'string','Visible Tracks:');
            tracks_id_list=unique(handles.tracks(:,4));
            total_tracks_count=0;
            for i=1:length(tracks_id_list) %length of list of track ids
                cur_track=handles.tracks(find(handles.tracks(:,4)==tracks_id_list(i)),:);
                %does track esist at current frame?
                present=find(cur_track(:,3)==slider_frame,1);
                %exists at any frame before current frame?
                past=find(cur_track(:,3)<slider_frame,1);
                %exists at any frame after current frame?
                future=find(cur_track(:,3)>slider_frame,1);
                if ~isempty(present) || (~isempty(past) && ~isempty(future))
                %if track exists in this frame or in any previous and
                %future frame it counts
                    total_tracks_count=total_tracks_count+1;
                end
            end
            set(handles.points_found,'string',num2str(total_tracks_count));
        end
        if view_aois_tracks==3 && ~isempty(handles.tracks)
            %plot each track that exists in current frame in different colors
            hold on;
            track_id_list=unique(tracks_info(:,4));
            track_id_size=size(track_id_list);
            ColorSet=varycolor(track_id_size(1));
            for m=1:track_id_size(1)
                cur_track=handles.tracks(find(handles.tracks(:,4)==track_id_list(m,1)),:);
                %plot(ones(20,1)*m,'Color',ColorSet(m,:));
                plot(cur_track(:,1),cur_track(:,2),'-','LineWidth',2,'Color',ColorSet(m,:));
                cur_point=cur_track(find(cur_track(:,3)==slider_frame),:);
                plot(cur_point(1,1),cur_point(1,2),'.','markersize',blob_size,'Color',ColorSet(m,:));
            end
            
        elseif view_aois_tracks==4 && ~isempty(handles.tracks)
            %plot each track in different colors
            hold on;
            track_id_list=unique(handles.tracks(:,4));
            track_id_size=size(track_id_list);
            ColorSet=varycolor(track_id_size(1));
            for m=1:track_id_size(1)
                cur_track=handles.tracks(find(handles.tracks(:,4)==track_id_list(m,1)),:);
                %plot(ones(20,1)*m,'Color',ColorSet(m,:));
                plot(cur_track(:,1),cur_track(:,2),'-','LineWidth',2,'Color',ColorSet(m,:));
                plot(cur_track(1,1),cur_track(1,2),'.','markersize',blob_size,'Color',ColorSet(m,:));
            end  
        else
            %draw boxes around points in pk
            for i=1:pksize(1,1)
                rect_draw=[pk(i,1)-blob_size/2 pk(i,2)-blob_size/2 blob_size blob_size];
                rectangle('Position', rect_draw, 'LineWidth',1,'EdgeColor','r');
            end
        end
        
        
    end 
end
hold off;
set(handles.tracks_found,'string','0');
if ~isempty(handles.tracks)
    selected_frame=str2num(get(handles.frame_select,'string'));
    [track_count useless]=size(find(handles.tracks(:,3)==selected_frame));
    set(handles.tracks_found,'string',num2str(track_count));
end
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

function varargout = frame_select_Callback(hObject, eventdata, handles)
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
pk=movie_slider_Callback(hObject, eventdata, handles);
varargout={pk};


function frame_select_CreateFcn(hObject, eventdata, handles)
% hObject    handle to frame_select (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

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
selected_area=str2num(get(handles.area_selected,'string'));
noise=str2num(get(handles.noise,'string'));
blob_size=str2num(get(handles.size,'string'));
load([path '\header.mat']);
image=read_image('glimpse',path,1,'');
imsize=size(image);

%set(handles.area_selected,'string',num2str([1 imsize(2) 1 imsize(1)]));

dat=bpass(image,noise,blob_size);
manual_mask=get(handles.manual_mask,'value');
auto_mask=get(handles.auto_mask,'value');
if manual_mask==1 %manual masking
    axes(handles.axes_ave);
    bw=roipolyold();
    bwsize=size(bw);
    %now will add zeros around bw to expand it to the size of the image
    %matrix
    addTop=selected_area(3)-1;
    addBottom=imsize(1)-selected_area(4);
    addLeft=selected_area(1)-1;
    addRight=imsize(2)-selected_area(2);
    if addTop>0 % bw starts lower than pixel 1 vertically
        %add zeros to top of bw until it starts at pixel 1 vertically
        bw=[zeros(addTop,bwsize(2));bw];   
    end
    if addBottom>0 % bw ends higher than lowest pixel of image vertically
        %add zeros to top of bw until it ends at lowest pixel of image vertically
        bw=[bw;zeros(addBottom,bwsize(2))];   
    end
    if addLeft>0 % bw starts to the right of pixel 1 horizontally
        %add zeros to left of bw until it starts at pixel 1 horizontally
        bw=[zeros(imsize(1),addLeft) bw];   
    end
    if addRight>0 % bw ends to the left of rightmost pixel of image horizontally
        %add zeros to right of bw until it ends at rightmost pixel of image horizontally
        bw=[bw zeros(imsize(1),addRight)];   
    end
    size(bw)
    
elseif auto_mask==1 %auto masking
    bw=im2bw(imfilter(dat,ones(25,25)/1100,'symmetric'));
    bw = imfill(bw,'holes');
    bw = bwareaopen(bw,(imsize(1)*imsize(2))/3);
    bw=bwmorph(bw,'shrink',14);
else %no masking
    bw=ones(imsize(1), imsize(2));
end
mask=bw;


% hObject    handle to graph_spots (see GCBO)
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
movie_slider_Callback(hObject, eventdata, handles);
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
movie_slider_Callback(hObject, eventdata, handles);
% hObject    handle to noisy_data (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of noisy_data



function frame_average_Callback(hObject, eventdata, handles)


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
    %cancel button usage, uses unique code for all loops
    if get(handles.cancel_button,'UserData') == 1
        image=read_image('glimpse',fpath,cur_frame,'')*frame_average;
        set(handles.cancel_button,'UserData',0);
        break;
    end
    
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

function out=block_average_image(cur_frame, handles) %block average
fpath=get(handles.file_path,'string');
frame_average=str2num(get(handles.frame_average,'string'));
frm_start=str2double(get(handles.start_frame,'string'));
frm_stop=str2double(get(handles.end_frame,'string'));
out=[];
set(handles.movie_slider,'SliderStep',[1/((frm_stop-frm_start)/frame_average) 0.1]);
if mod(cur_frame,frame_average)==0 %frame to start with
    if cur_frame+frame_average>frm_stop %can't average next x frames
        %average all frames possible until end
        image=read_image('glimpse',fpath,cur_frame,'');
        for i=cur_frame:frm_stop
            image=read_image('glimpse',fpath,i,'')+image;
        end
        out=image/(frm_stop-cur_frame+2);
    else
        image=read_image('glimpse',fpath,cur_frame,'');
        for i=cur_frame+1:cur_frame+frame_average
            image=read_image('glimpse',fpath,i,'')+image;
        end
        out=image/(frame_average+1);
    end
    set(handles.frame_select,'string',num2str(cur_frame));
    set(handles.movie_slider,'value',cur_frame);
else %wrong frame, must go back frame%average frames
    if cur_frame-mod(cur_frame,frame_average)<frm_start %can't go back
        %average start through cur
        image=read_image('glimpse',fpath,cur_frame,'');
        for i=frm_start:cur_frame-1
            image=read_image('glimpse',fpath,i,'')+image;
        end
        out=image/(cur_frame-frm_start+1);
        set(handles.frame_select,'string',num2str(frm_start));
        set(handles.movie_slider,'value',frm_start);
    else %normal case, go back
        cur_frame=cur_frame-mod(cur_frame,frame_average);
        out=block_average_image(cur_frame, handles);
    end
end



function centroid_Callback(hObject, eventdata, handles)
movie_slider_Callback(hObject, eventdata, handles);

function gaussian_Callback(hObject, eventdata, handles)
movie_slider_Callback(hObject, eventdata, handles);


function maxdisp_Callback(hObject, eventdata, handles)
% hObject    handle to maxdisp (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of maxdisp as text
%        str2double(get(hObject,'String')) returns contents of maxdisp as a double


% --- Executes during object creation, after setting all properties.
function maxdisp_CreateFcn(hObject, eventdata, handles)
% hObject    handle to maxdisp (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function track_mem_Callback(hObject, eventdata, handles)
% hObject    handle to track_mem (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of track_mem as text
%        str2double(get(hObject,'String')) returns contents of track_mem as a double


% --- Executes during object creation, after setting all properties.
function track_mem_CreateFcn(hObject, eventdata, handles)
% hObject    handle to track_mem (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function min_track_length_Callback(hObject, eventdata, handles)
% hObject    handle to min_track_length (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of min_track_length as text
%        str2double(get(hObject,'String')) returns contents of min_track_length as a double


% --- Executes during object creation, after setting all properties.
function min_track_length_CreateFcn(hObject, eventdata, handles)
% hObject    handle to min_track_length (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function output_parameters_Callback(hObject, eventdata, handles)

% --- Executes during object creation, after setting all properties.
function output_parameters_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in track_edit_button.
function track_edit_button_Callback(hObject, eventdata, handles)
if get(handles.track_edit_button,'value') == 0 %off (default value), make add/remove aoi panel invisible
    set(handles.edit_tracks_panel,'visible','off');
    set(handles.trajectory_info_panel,'visible','off');
    set(handles.split_menu,'visible','off');
    set(handles.combine_menu,'visible','off');
else %on, make add/remove aoi panel visible
    view_type=get(handles.view_aois_tracks,'value');
    if view_type<2 %if not view tracks or view colored tracks
        set(handles.view_aois_tracks,'value',2); %set to view tracks
        view_aois_tracks_Callback(hObject, eventdata, handles);
    end
    set(handles.edit_tracks_panel,'visible','on');
    set(handles.trajectory_info_panel,'visible','on');
    set(handles.split_menu,'visible','on');
    set(handles.combine_menu,'visible','on');
    if get(handles.spot_edit_button,'value')
        set(handles.spot_edit_button,'value',0)
        spot_edit_button_Callback(hObject, eventdata, handles);
    end
end


function remove_aois_tracks_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in view_aois_tracks.
function view_aois_tracks_Callback(hObject, eventdata, handles)
movie_slider_Callback(hObject, eventdata, handles);
% hObject    handle to view_aois_tracks (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns view_aois_tracks contents as cell array
%        contents{get(hObject,'Value')} returns selected item from view_aois_tracks


% --- Executes during object creation, after setting all properties.
function view_aois_tracks_CreateFcn(hObject, eventdata, handles)
% hObject    handle to view_aois_tracks (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in zoom.
function zoom_Callback(hObject, eventdata, handles)
zoom_val=get(handles.zoom,'value');
if zoom_val==1
    zoom on;
    set(handles.zoom,'string','Zoom On');
else
    zoom out;
    zoom off;
    set(handles.zoom,'string','Zoom');
end
% hObject    handle to zoom (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of zoom


% --- Executes on selection change in popupmenu5.
function popupmenu5_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns popupmenu5 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu5


% --- Executes during object creation, after setting all properties.
function popupmenu5_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in edit_more_toggle.
function edit_more_toggle_Callback(hObject, eventdata, handles)
pressed=get(handles.edit_more_toggle,'value');
if pressed==0
    set(handles.edit_more_toggle,'string','Closed');
    set(handles.trajectory_info_panel,'visible','off');
    set(handles.detection_parameters_panel,'visible','on');
else
    set(handles.edit_more_toggle,'string','Open');
    set(handles.trajectory_info_panel,'visible','on');
    set(handles.detection_parameters_panel,'visible','off');
end



% hObject    handle to edit_more_toggle (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of edit_more_toggle


% --- Executes on selection change in edit_traj_menu.
function edit_traj_menu_Callback(hObject, eventdata, handles)
edit_traj_menu=get(handles.edit_traj_menu,'value');
view_type=get(handles.view_aois_tracks,'value');
if isempty(handles.tracks)
    'need to process tracks!'
else
    if view_type<2 %if not view tracks or view colored tracks
        set(handles.view_aois_tracks,'value',2); %set to view tracks
        view_aois_tracks_Callback(hObject, eventdata, handles);
    end  
    switch edit_traj_menu
        case 1 %get track info
            graph_selected_traj(handles);
        case 2 %combine coexisting tracks
            if isempty(handles.tracks)
                'tracks list is empty!'
            else
                %will store indices of all tracks to be combined
                track_add=[];
                while true % until LMB or enter is pressed
                    %resets the selected traj graph
                    [xin yin button]=ginput(1);    %first select the track of interest
                    if(button==3)
                        break;
                    end
                    selected=[xin yin];
                    if isempty(selected)
                        break;
                        %end loop 
                    end
                    %%%%% graphing
                    store=sqrt((handles.tracks(:,1)-xin).^2 + (handles.tracks(:,2)-yin).^2);
                    track_id=handles.tracks(find(store==min(store)),4);
                    findx=find(handles.tracks(:,4)==track_id);
                    set(handles.disp1,'string',['Track Id: ' num2str(track_id)]);
                    set(handles.disp2,'string',['Exists from ' num2str(min(handles.tracks(findx,3))) ' to ' num2str(max(handles.tracks(findx,3)))]);
                    axis image;
                    axes(handles.axes_traj);
                    hold on;
                    cla;
                    plot(handles.tracks(findx,1),handles.tracks(findx,2),'r-');
                    plot(handles.tracks(findx,1),handles.tracks(findx,2),'k.','markersize',6);
                    axes(handles.axes_ave);
                    %%%%% end graphing       
                    
                    find_track=find(handles.tracks(:,4)==track_id);
                    track_add=[track_add;find_track];
                end
                
                comb_track=handles.tracks(track_add,:);
                time_list=unique(comb_track(:,3));
                rebuild=[0 0 0 0];
                %bias toward first chosen track in selection,
                %redundant coordinates are ignored
                for i=1:length(time_list)
                    rebuild=[rebuild;comb_track(find(comb_track(:,3)==time_list(i,1),1),:)];
                end
                %removes unnecessary first row
                rebuild(1,:)=[];
                %sets the combined track id to be the lowest track id from
                %the remaining selected list
                
                rebuild(:,4)=min(rebuild(:,4));
                %remove all selected tracks and append rebuild to
                %handles.tracks
                handles.tracks(track_add,:)=[];
                handles.tracks=[handles.tracks;rebuild];
            end
            handles.tracks=sortrows(handles.tracks,4);
    end
end
axes(handles.axes_ave);
%handles.tracks
guidata(gcbo,handles);
% hObject    handle to edit_traj_menu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns edit_traj_menu contents as cell array
%        contents{get(hObject,'Value')} returns selected item from edit_traj_menu


% --- Executes during object creation, after setting all properties.
function edit_traj_menu_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_traj_menu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function split_traj_Callback(hObject, eventdata, handles)

% --- Executes during object creation, after setting all properties.
function split_traj_CreateFcn(hObject, eventdata, handles)
% hObject    handle to split_traj (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function track_id=graph_selected_traj(handles)
cur_frame=str2num(get(handles.frame_select,'string'));
[xin yin button]=ginput(1);
tracks_in_frame=handles.tracks(find(handles.tracks(:,3)==cur_frame),:);
if isempty(tracks_in_frame)
    'no tracks in this frame!'
    track_id=0;
else
    store=sqrt((tracks_in_frame(:,1)-xin).^2 + (tracks_in_frame(:,2)-yin).^2);
    track_id=min(tracks_in_frame(find(store==min(store)),4));
    findx=find(handles.tracks(:,4)==track_id);
    set(handles.disp1,'string',['Track Id: ' num2str(track_id)]);
    set(handles.disp2,'string',['Exists from ' num2str(min(handles.tracks(findx,3))) ' to ' num2str(max(handles.tracks(findx,3)))]);
    axes(handles.axes_traj);
    axis ij;
    axis auto;
    cla;
    hold on;
    plot(handles.tracks(findx,1),handles.tracks(findx,2),'r-');
    plot(handles.tracks(findx,1),handles.tracks(findx,2),'k.','markersize',6);
    axes(handles.axes_ave);
end
         
% --- Executes on button press in get_track_1.
function get_track_1_Callback(hObject, eventdata, handles)
% hObject    handle to get_track_1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
track_id=graph_selected_traj(handles);
set(handles.get_track_1,'UserData',track_id);
set(handles.get_track_2,'Visible','on');

% --- Executes on button press in get_track_2.
function get_track_2_Callback(hObject, eventdata, handles)
% hObject    handle to get_track_2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
track_id=graph_selected_traj(handles);
set(handles.get_track_2,'UserData',track_id);
set(handles.comb_traj,'Visible','on');


% --- Executes on button press in comb_traj.
function comb_traj_Callback(hObject, eventdata, handles)
id1=get(handles.get_track_1,'UserData');
id2=get(handles.get_track_2,'UserData');
if id1==0 %traj 1 isnt selected
    'select track 1'  
elseif id2==0
    'select track 2'
else 
    %get tracks of id1 and id2
    comb_track=[handles.tracks(find(handles.tracks(:,4)==id1),:);handles.tracks(find(handles.tracks(:,4)==id2),:)];
    time_list=unique(comb_track(:,3));
    rebuild=[0 0 0 0];
    %bias toward first chosen track in selection,
    %redundant coordinates are ignored
    for i=1:length(time_list)
        rebuild=[rebuild;comb_track(find(comb_track(:,3)==time_list(i,1),1),:)];
    end
    %removes unnecessary first row
    rebuild(1,:)=[];
    %sets the combined track id to be the lowest track id from
    %the remaining selected list

    rebuild(:,4)=min(rebuild(:,4));
    %remove both selected tracks and append rebuild to
    %handles.tracks
    handles.tracks(find(handles.tracks(:,4)==id1),:)=[];
    handles.tracks(find(handles.tracks(:,4)==id2),:)=[];
    handles.tracks=[handles.tracks;rebuild]; 
end
guidata(gcbo,handles);
movie_slider_Callback(hObject, eventdata, handles);
set(handles.comb_traj,'Visible','off');
set(handles.get_track_2,'Visible','off');

% hObject    handle to comb_traj (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in go_button.
function go_button_Callback(hObject, eventdata, handles)
to_output=get(handles.output_parameters,'value');
slider_min=get(handles.movie_slider,'min');
slider_max=get(handles.movie_slider,'max');
switch to_output %case 1 is 'do nothing'
    
    case 2 %find tracks
        handles.tracks=[];
        area_selected=str2num(get(handles.area_selected,'string'));
        view_aois_tracks=get(handles.view_aois_tracks,'value');
        frame_bw=handles.bw(area_selected(1,3):area_selected(1,4),area_selected(1,1):area_selected(1,2));
        %build list of coordinates to track
        peaks=[];
        set(handles.view_aois_tracks,'value',1); 
        for i=slider_min:slider_max
            %cancel button usage, uses unique code for all loops
            if get(handles.cancel_button,'UserData') == 1
                handles.tracks=[];
                set(handles.cancel_button,'UserData',0);
                guidata(gcbo,handles);
                return;
            end
            set(handles.frame_select,'string',num2str(i));
            pk = frame_select_Callback(hObject, eventdata, handles);
            if ~isempty(pk)
                pk=pk(:,1:2);
                [length_pk width_pk] = size(pk);
                for j=length_pk:-1:1
                    if frame_bw(floor(pk(j,2)),floor(pk(j,1)))==0 || frame_bw(ceil(pk(j,2)),ceil(pk(j,1)))==0
                        %apply mask to peaks, if not in mask range then prepare to remove from
                        %peak list
                        pk(j,:)=[];
                    end  
                end 
                pk(:,3)=i;
                peaks=[peaks;pk];
            end  
        end
        maxdisp=str2double(get(handles.maxdisp,'string'));
        track_mem=str2double(get(handles.track_mem,'string'));
        min_track_length=str2double(get(handles.min_track_length,'string'));

        param.mem=track_mem;    %has to be in consecutive frames to be considered in the same track
        param.good=min_track_length;   %min frames to be considered a track
        param.dim=3;    %x y t (3D)
        param.quiet=1;  %no text
        if isempty(peaks)
           'no peaks were found! cant make track list!'
           handles.peaks=[];
           guidata(gcbo,handles);
           return;
        end
        tracks=track(peaks,maxdisp,param);
        if isempty(tracks)
            warning('no tracks to analyze! try again with different parameters!')
        end
        handles.tracks=tracks;
        guidata(gcbo,handles);
        movie_slider_Callback(hObject, eventdata, handles);
         
    case 3 %graph spots vs frames
        spots_per_frame=[];
        for i=slider_min:slider_max
            %cancel button usage, uses unique code for all loops
            if get(handles.cancel_button,'UserData') == 1
                set(handles.cancel_button,'UserData',0);
                return;
            end
            set(handles.frame_select,'string',num2str(i));
            frame_select_Callback(hObject, eventdata, handles);
            point_count=str2num(get(handles.points_found,'string'));
            spots_per_frame=[spots_per_frame;i point_count];
        end
        spots_per_frame
        plot(spots_per_frame(:,1),spots_per_frame(:,2));
        xlabel('Frame');
        ylabel('Spots in Frame');
        
        
        
    case 4 %graph spots vs time
        spots_per_time=[];
        fpath=get(handles.file_path,'string');
        load([fpath '\header.mat']);
        for i=slider_min:slider_max
            %cancel button usage, uses unique code for all loops
            if get(handles.cancel_button,'UserData') == 1
                set(handles.cancel_button,'UserData',0);
                return;
            end
            set(handles.frame_select,'string',num2str(i));
            frame_select_Callback(hObject, eventdata, handles);
            point_count=str2num(get(handles.points_found,'string'));
            spots_per_time=[spots_per_time;(vid.ttb(i)-vid.ttb(1))/1000 point_count];
        end
        spots_per_time
        plot(spots_per_time(:,1),spots_per_time(:,2));
        xlabel('Time (s)');
        ylabel('Spots in Frame');
        
    case 5 %save coordinates in frame
        selected_frame=str2num(get(handles.frame_select,'string'));
        coord=handles.peaks;
        coord=[coord(:,1:2) ones(length(coord),1)*selected_frame]; %#ok<NASGU>
        save_path=[get(handles.file_path,'string') 'frame-' get(handles.frame_select,'string') '-noise-' get(handles.noise,'string') '-size-' get(handles.size,'string') '-bright-' get(handles.pk_find,'string') '.mat'];
        save (save_path,'coord');
        
    case 6 %save coordinates for all frames
        coord_all=[];
        for i=slider_min:slider_max
            %cancel button usage, uses unique code for all loops
            if get(handles.cancel_button,'UserData') == 1
                set(handles.cancel_button,'UserData',0);
                return;
            end
            set(handles.frame_select,'string',num2str(i));
            pk = frame_select_Callback(hObject, eventdata, handles);
            coord=pk;
            if ~isempty(coord)
                %for each frame, append to the matrix coord_all every peak
                %in a frame along with the frame number
                coord_all=[coord_all;[coord(:,1:2) ones(length(coord),1)*i]];
            end
        end
        save_path=[get(handles.file_path,'string') 'frame-' get(handles.frame_select,'string') '-noise-' get(handles.noise,'string') '-size-' get(handles.size,'string') '-bright-' get(handles.pk_find,'string') '-frames-' num2str(slider_min) '-' num2str(slider_max) '.mat'];
        save (save_path,'coord_all');
        
    case 7 %graph tracks vs frames
        if isfield(handles,'tracks')
            if ~isempty(handles.tracks)
                tracks_in_frame=[];
                for i=slider_min:slider_max
                    %cancel button usage, uses unique code for all loops
                    if get(handles.cancel_button,'UserData') == 1
                        set(handles.cancel_button,'UserData',0);
                        return;
                    end
                    tracks_in_frame=[tracks_in_frame;[i length(find(handles.tracks(:,3)==i))]];
                end
                if ~isempty(tracks_in_frame)
                    tracks_in_frame
                    plot(tracks_in_frame(:,1),tracks_in_frame(:,2));
                    xlabel('Frames');
                    ylabel('Tracks in Frame');
                else
                    'no tracks in the current frame range!'               
                end
            else
                'tracks need to be processed and not empty'
            end
        else
            'tracks need to be processed first'
        end
        
    case 8 %cumulative tracks since movie started
        if isfield(handles,'tracks')
            if ~isempty(handles.tracks)
                cumulative_tracks=[];
                track_index=[unique(handles.tracks(:,4)) zeros(length(unique(handles.tracks(:,4))),1)]
                for i=slider_min:slider_max
                    %cancel button usage, uses unique code for all loops
                    if get(handles.cancel_button,'UserData') == 1
                        set(handles.cancel_button,'UserData',0);
                        return;
                    end
                    cur_frame_tracks=handles.tracks(find(handles.tracks(:,3)==i),:);
                    if ~isempty(cur_frame_tracks)
                        %go through each track in a list of tracks in the
                        %current frame
                        [cur_frame_tracks_length cur_frame_tracks_width] = size(cur_frame_tracks);
                        cur_frame_tracks
                        for j=1:cur_frame_tracks_length
                            %if for this track id in the track index the track id hasnt been
                            %used, make it 1
                            if find(track_index(:,1)==cur_frame_tracks(j,4))
                                track_index(find(track_index(:,1)==cur_frame_tracks(j,4)),2)=1;
                            end
                        end
                        %now count up the total tracks used so far in the
                        %track index, this is the number of cumulative
                        %tracks
                        cumulative_tracks=[cumulative_tracks;[i sum(track_index(:,2))]];
                    end
                end
                if ~isempty(cur_frame_tracks)
                    cumulative_tracks               
                    plot(cumulative_tracks(:,1),cumulative_tracks(:,2));
                    xlabel('Frames');
                    ylabel('Cumulative Tracks');
                else
                    'no tracks in the current frame range!'
                end
            else
                'tracks need to be processed and not empty'
            end
        else
            'tracks need to be processed first'
        end
end



% hObject    handle to go_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in spot_edit_button.
function spot_edit_button_Callback(hObject, eventdata, handles)
%on_off=get(handles.spot_edit_button,'value');
if get(handles.spot_edit_button,'value') == 0 %off (default value), make add/remove aoi panel invisible
    set(handles.edit_spots_panel,'visible','off');
else %on, make add/remove aoi panel visible
    view_type=get(handles.view_aois_tracks,'value');
    if view_type>1 %if not view tracks or view colored tracks
        set(handles.view_aois_tracks,'value',1); %set to view tracks
        view_aois_tracks_Callback(hObject, eventdata, handles);
    end
    set(handles.edit_spots_panel,'visible','on');
    if get(handles.track_edit_button,'value')
        set(handles.track_edit_button,'value',0)
        track_edit_button_Callback(hObject, eventdata, handles);
    end
end
% hObject    handle to spot_edit_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of spot_edit_button


% --- Executes on button press in add_spot_button.
function add_spot_button_Callback(hObject, eventdata, handles)
selected_frame=str2num(get(handles.frame_select,'string'));
[xin yin button]=ginput(1);
handles.aoi_add=[handles.aoi_add;[xin yin selected_frame]];
guidata(gcbo,handles);
movie_slider_Callback(hObject, eventdata, handles);
% hObject    handle to add_spot_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in add_mult_spots_button.
function add_mult_spots_button_Callback(hObject, eventdata, handles)
selected_frame=str2num(get(handles.frame_select,'string'));
while true % until LMB or enter is pressed
    %resets the selected traj graph
    [xin yin button]=ginput(1);    %first select the track of interest
    if(button==3)
        break;
    end
    if isempty([xin yin])
        break;
        %end loop 
    end
    handles.aoi_add=[handles.aoi_add;[xin yin selected_frame]];
    guidata(gcbo,handles);
    movie_slider_Callback(hObject, eventdata, handles);
end

% hObject    handle to add_mult_spots_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in remove_spot_button.
function remove_spot_button_Callback(hObject, eventdata, handles)
selected_frame=str2num(get(handles.frame_select,'string'));
[xin yin button]=ginput(1);
handles.aoi_remove=[handles.aoi_remove;[xin yin selected_frame]];
guidata(gcbo,handles);
movie_slider_Callback(hObject, eventdata, handles);
% hObject    handle to remove_spot_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in remove_mult_spots_button.
function remove_mult_spots_button_Callback(hObject, eventdata, handles)
selected_frame=str2num(get(handles.frame_select,'string'));
while true % until LMB or enter is pressed
    %resets the selected traj graph
    [xin yin button]=ginput(1);    %first select the track of interest
    if(button==3)
        break;
    end
    if isempty([xin yin])
        break;
        %end loop 
    end
    handles.aoi_remove=[handles.aoi_remove;[xin yin selected_frame]];
    guidata(gcbo,handles);
    movie_slider_Callback(hObject, eventdata, handles);
end
% hObject    handle to remove_mult_spots_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in add_track_button.
function add_track_button_Callback(hObject, eventdata, handles)
slider_min=get(handles.movie_slider,'min');
slider_max=get(handles.movie_slider,'max');
[xin yin button]=ginput(1);
if isempty(handles.tracks) %tracks is empty, highest track id will be 1
    track_id=1;
else
    track_id=max(handles.tracks(:,4))+1;
end
for i=slider_min:slider_max
    handles.tracks=[handles.tracks;[xin yin i track_id]];
end
guidata(gcbo,handles);
movie_slider_Callback(hObject, eventdata, handles);
% hObject    handle to add_track_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in add_mult_tracks_button.
function add_mult_tracks_button_Callback(hObject, eventdata, handles)
slider_min=get(handles.movie_slider,'min');
slider_max=get(handles.movie_slider,'max');
while true % until LMB or enter is pressed
    [xin yin button]=ginput(1);    %first select the track of interest
    if(button==3)
        break;
    end
    selected=[xin yin];
    if isempty(selected)
        break;
        %end loop 
    end

    if isempty(handles.tracks) %tracks is empty, highest track id will be 1
        track_id=1;
    else
        track_id=max(handles.tracks(:,4))+1;
    end
    for i=slider_min:slider_max
        handles.tracks=[handles.tracks;[xin yin i track_id]];
    end
    guidata(gcbo,handles);
    movie_slider_Callback(hObject, eventdata, handles);
end

% hObject    handle to add_mult_tracks_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in remove_track_button.
function remove_track_button_Callback(hObject, eventdata, handles)
if isempty(handles.tracks)
    'tracks list is empty!'
else
    [xin yin button]=ginput(1);
    store=sqrt((handles.tracks(:,1)-xin).^2 + (handles.tracks(:,2)-yin).^2);
    track_id=min(handles.tracks(find(store==min(store)),4));
    handles.tracks(find(handles.tracks(:,4)==track_id),:)=[];
end
guidata(gcbo,handles);
movie_slider_Callback(hObject, eventdata, handles);
% hObject    handle to remove_track_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in remove_mult_tracks_button.
function remove_mult_tracks_button_Callback(hObject, eventdata, handles)
while true % until LMB or enter is pressed
    [xin yin button]=ginput(1);    %first select the track of interest
    if(button==3)
        break;
    end
    selected=[xin yin];
    if isempty(selected)
        break;
        %end loop 
    end
    if isempty(handles.tracks)
        'tracks list is empty!'
        break;
    else
        store=sqrt((handles.tracks(:,1)-xin).^2 + (handles.tracks(:,2)-yin).^2);
        track_id=min(handles.tracks(find(store==min(store)),4));
        handles.tracks(find(handles.tracks(:,4)==track_id),:)=[];
    end
    guidata(gcbo,handles);
    movie_slider_Callback(hObject, eventdata, handles);
end
% hObject    handle to remove_mult_tracks_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in cancel_button.
function cancel_button_Callback(hObject, eventdata, handles)
set(handles.cancel_button,'UserData',1);
% hObject    handle to cancel_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in split_track_button.
function split_track_button_Callback(hObject, eventdata, handles)
track_id=graph_selected_traj(handles);
tosplit=str2num(get(handles.split_traj,'string'));
if isempty(tosplit)
   'Split in frames parameter is empty!'
else
    for i=length(tosplit):-1:1
       find_track=find(handles.tracks(:,4)==track_id); 
       split_frame=tosplit(i);
       %get all tracks greater than the frame to split at
       r=find(handles.tracks(find_track,3)>split_frame);
       if ~isempty(r)
           %give the second half of the list a new traj id
           handles.tracks(find_track(r,:),4)=max(handles.tracks(:,4))+1;
       end
    end 
end
guidata(gcbo,handles);
movie_slider_Callback(hObject, eventdata, handles);
% hObject    handle to split_track_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% --- Executes on button press in average_button.
function average_button_Callback(hObject, eventdata, handles)
movie_slider_Callback(hObject, eventdata, handles);
% hObject    handle to average_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


