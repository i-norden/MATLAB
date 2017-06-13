function varargout = subgui_track_information(varargin)
% SUBGUI_TRACK_INFORMATION M-file for subgui_track_information.fig
%      SUBGUI_TRACK_INFORMATION, by itself, creates a new SUBGUI_TRACK_INFORMATION or raises the existing
%      singleton*.
%
%      H = SUBGUI_TRACK_INFORMATION returns the handle to a new SUBGUI_TRACK_INFORMATION or the handle to
%      the existing singleton*.
%
%      SUBGUI_TRACK_INFORMATION('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in SUBGUI_TRACK_INFORMATION.M with the given input arguments.
%
%      SUBGUI_TRACK_INFORMATION('Property','Value',...) creates a new SUBGUI_TRACK_INFORMATION or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before subgui_track_information_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to subgui_track_information_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help subgui_track_information

% Last Modified by GUIDE v2.5 27-Apr-2010 17:08:33

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @subgui_track_information_OpeningFcn, ...
                   'gui_OutputFcn',  @subgui_track_information_OutputFcn, ...
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


% --- Executes just before subgui_track_information is made visible.
function subgui_track_information_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to subgui_track_information (see VARARGIN)

% Choose default command line output for subgui_track_information
handles.output = hObject;
handles.track=[];
handles.file_path=[];
handles.disp_scale=[];
handles.track_size=[];
handles.main_gui_handle=[];
handles.opened_once=[];
handles.sub_axes=[];
handles.subplot_on=0;


%set executable handles to functions here
handles.exe_set_new_track=@set_new_track;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes subgui_track_information wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = subgui_track_information_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in previous.
function previous_Callback(hObject, eventdata, handles)
track_info=str2num(get(handles.frames_displayed,'String'));
min_disp=track_info(1);
max_disp=track_info(2);
max_frame=max(handles.track(:,3));
min_frame=min(handles.track(:,3));


if min_disp-25>=min_frame %go back full 25 frames
    set(handles.frames_displayed,'String',[num2str(min_disp-25) ' ' num2str(min_disp-1)]);
    counter=1;
    for i=min_disp-25:min_disp-1
        im=read_image('glimpse',handles.file_path,i,' ');
        frame_index=find(handles.track(:,3)==i,1);
        subplot(5,5,counter);
        if ~isempty(frame_index)
            x1=return_larger(handles.track(frame_index,1)-handles.radius,1);
            x2=return_smaller(handles.track(frame_index,1)+handles.radius,size(im,2));
            y1=return_larger(handles.track(frame_index,2)-handles.radius,1);
            y2=return_smaller(handles.track(frame_index,2)+handles.radius,size(im,1));      
            im=im(y1:y2,x1:x2);
            imagesc(im,handles.disp_scale);
            axis off;
            title(['Frame ' num2str(i)]); 
        else
            cla;
            title('');
            axis off;
        end
        
        
        counter=counter+1;
    end    
elseif min_frame ~= min_disp && min_disp-25<min_frame %go back as many frames as possible (less than 25)    
    set(handles.frames_displayed,'String',[num2str(min_frame) ' ' num2str(min_disp-1)]);
    counter=1;
    for i=min_frame:min_disp-1
        im=read_image('glimpse',handles.file_path,i,' ');
        frame_index=find(handles.track(:,3)==i,1);
        subplot(5,5,counter);
        if ~isempty(frame_index)
            x1=return_larger(handles.track(frame_index,1)-handles.radius,1);
            x2=return_smaller(handles.track(frame_index,1)+handles.radius,size(im,2));
            y1=return_larger(handles.track(frame_index,2)-handles.radius,1);
            y2=return_smaller(handles.track(frame_index,2)+handles.radius,size(im,1));      
            im=im(y1:y2,x1:x2);      
            imagesc(im,handles.disp_scale);
            axis off;
            title(['Frame ' num2str(i)]);
        else
            cla;
            title('');
            axis off;
        end
        
        counter=counter+1;
    end
    %now reset all unused graphs
    for i=counter:25
        subplot(5,5,i);
        cla;
        axis off;
        title('');
    end
    
end %if not then do nothing at all
% hObject    handle to previous (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in next.
function next_Callback(hObject, eventdata, handles)
track_info=str2num(get(handles.frames_displayed,'String'));
min_disp=track_info(1);
max_disp=track_info(2);
max_frame=max(handles.track(:,3));
min_frame=min(handles.track(:,3));



if max_disp+25<=max_frame %go forward full 25 frames
    set(handles.frames_displayed,'String',[num2str(max_disp+1) ' ' num2str(max_disp+25)]);
    counter=1;
    for i=max_disp+1:max_disp+25
        im=read_image('glimpse',handles.file_path,i,' ');
        frame_index=find(handles.track(:,3)==i,1);
        subplot(5,5,counter);
        if ~isempty(frame_index)
            x1=return_larger(handles.track(frame_index,1)-handles.radius,1);
            x2=return_smaller(handles.track(frame_index,1)+handles.radius,size(im,2));
            y1=return_larger(handles.track(frame_index,2)-handles.radius,1);
            y2=return_smaller(handles.track(frame_index,2)+handles.radius,size(im,1));      
            im=im(y1:y2,x1:x2);     
            imagesc(im,handles.disp_scale);
            axis off;
            title(['Frame ' num2str(i)]);
        else
            cla;
            title('');
            axis off;
        end
        
        counter=counter+1;
    end    
elseif max_frame ~= max_disp && max_disp+25>max_frame %go forward as many frames as possible (less than 25)
    
    set(handles.frames_displayed,'String',[num2str(max_disp+1) ' ' num2str(max_frame)]);
    counter=1;
    for i=max_disp+1:max_frame
        im=read_image('glimpse',handles.file_path,i,' ');
        frame_index=find(handles.track(:,3)==i,1);
        x1=return_larger(handles.track(frame_index,1)-handles.radius,1);
        x2=return_smaller(handles.track(frame_index,1)+handles.radius,size(im,2));
        y1=return_larger(handles.track(frame_index,2)-handles.radius,1);
        y2=return_smaller(handles.track(frame_index,2)+handles.radius,size(im,1));      
        im=im(y1:y2,x1:x2);
        subplot(5,5,counter);       
        imagesc(im,handles.disp_scale);
        axis off;
        title(['Frame ' num2str(i)]);
        counter=counter+1;
    end
    %now reset all unused graphs
    for i=counter:25
        subplot(5,5,i);
        cla;
        axis off;
        title('');
    end
    
end %if not then do nothing at all
% hObject    handle to next (see GCBO)
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


% --- Executes on button press in previous_track.
function previous_track_Callback(hObject, eventdata, handles)
track_id=str2num(get(handles.track_id,'String'));
main_gui_data= guidata(handles.main_gui_handle);
%main_gui_data.trajectory
track_ids=sort(unique(main_gui_data.trajectory(:,4)));
if size(track_ids,1)>1 %if current track is not the only track
    index=find(track_ids(:,1)==track_id);
    if index>1
        track_id_new=track_ids(index-1,1);
    else
        track_id_new=track_ids(end,1);
    end
    set(handles.track_id,'String',num2str(track_id_new))
    track=main_gui_data.trajectory(find(main_gui_data.trajectory(:,4)==track_id_new),:);
    handles.track=track;
    guidata(hObject, handles);  %update handles
    set_new_track(hObject, eventdata, handles);
end



% hObject    handle to previous_track (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in next_track.
function next_track_Callback(hObject, eventdata, handles)
track_id=str2num(get(handles.track_id,'String'));
main_gui_data= guidata(handles.main_gui_handle);
%main_gui_data.trajectory
track_ids=sort(unique(main_gui_data.trajectory(:,4)));
if size(track_ids,1)>1 %if current track is not the only track
    index=find(track_ids(:,1)==track_id);
    if index<size(track_ids,1)
        track_id_new=track_ids(index+1,1);
    else
        track_id_new=track_ids(1,1);
    end
    set(handles.track_id,'String',num2str(track_id_new))
    track=main_gui_data.trajectory(find(main_gui_data.trajectory(:,4)==track_id_new),:);
    handles.track=track;
    guidata(hObject, handles);  %update handles
    set_new_track(hObject, eventdata, handles);
end
% hObject    handle to next_track (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


function set_new_track(hObject, eventdata, handles)
if handles.subplot_on~=1%if graph hasnt been made into subplot yet
    sub_axes=handles.axes1;
    %'not yet set as subplot'
    %sub_axes
else
    %sub_axes=gca;
    %handles.sub_axes
    sub_axes=handles.sub_axes;
    %'set as subplot'
    %sub_axes 
end
%isfield(handles,'subplot_on')
handles.subplot_on=1;
%isfield(handles,'subplot_on')
%handles.subplot_on
%set range
track=handles.track;
set(handles.frame_range_of_track,'String',[num2str(min(track(:,3))) ' to ' num2str(max(track(:,3)))]);
used_frames=track(find(track(:,5)==1),3);

%set track id
set(handles.track_id,'String',num2str(track(1,4)));

%graph mini overlay display
axes(handles.axes2);
%cla;
%hold on;
colormap(gray);
image=read_image('glimpse',handles.file_path,min(min(track(:,3))),' ');
%plot(track(:,1),track(:,2),'o','MarkerEdgeColor','r','MarkerSize',track_size);
axis ij;
axis auto;
cla;
hold on;

imagesc(image,handles.disp_scale);
plot(track(:,1),track(:,2),'o','MarkerEdgeColor','r','MarkerSize',handles.track_size);
axis image;

%graph actual track
axes(handles.axes3);
axis ij;
axis auto;
cla;
hold on;
plot(track(:,1),track(:,2),'r-');
plot(track(:,1),track(:,2),'k.','markersize',6);

%set axes to subplot graph
%sub_axes

axes(sub_axes);
%now to graph first 25 frames of the track
if size(track,1)>=25
    set(handles.frames_displayed,'String',[num2str(min(track(:,3))) ' ' num2str(min(track(:,3))+24)]);
    counter=1;
    for i=min(track(:,3)):min(track(:,3))+24
        im=read_image('glimpse',handles.file_path,i,' ');
        frame_index=find(handles.track(:,3)==i,1);
        x1=return_larger(handles.track(frame_index,1)-handles.radius,1);
        x2=return_smaller(handles.track(frame_index,1)+handles.radius,size(im,2));
        y1=return_larger(handles.track(frame_index,2)-handles.radius,1);
        y2=return_smaller(handles.track(frame_index,2)+handles.radius,size(im,1));      
        im=im(y1:y2,x1:x2);
        subplot(5,5,counter);       
        imagesc(im,handles.disp_scale);
        axis off;
        title(['Frame ' num2str(i)]);
        counter=counter+1;
    end
else %less than 25 frames in track
    set(handles.frames_displayed,'String',[num2str(min(track(:,3))) ' ' num2str(max(track(:,3)))]);
    counter=1;
    for i=1:size(track,1)
        im=read_image('glimpse',handles.file_path,i+min(track(:,3)-1),' ');
        x1=return_larger(track(i,1)-handles.radius,1);
        x2=return_smaller(track(i,1)+handles.radius,size(image,2));
        y1=return_larger(track(i,2)-handles.radius,1);
        y2=return_smaller(track(i,2)+handles.radius,size(image,1));
        im=im(y1:y2,x1:x2);
        subplot(5,5,i);

        imagesc(im,handles.disp_scale);
        axis off;
        title(['Frame ' num2str(i+min(track(:,3)-1))]);
        counter=counter+1;
    end
    %now reset all unused graphs
    for i=counter:25
        subplot(5,5,i);
        cla;
        title('');
    end    
end
guidata(hObject, handles);
handles.sub_axes=gca;
%gca
%update frames

if isempty(used_frames)
    set(handles.frame_range_of_track_used,'String','N/A');   
else
    set(handles.frame_range_of_track_used,'String',[num2str(min(used_frames)) ' to ' num2str(max(used_frames))]);
end
%update handles
guidata(hObject, handles);

% --- Executes on button press in select_this_track.
function select_this_track_Callback(hObject, eventdata, handles)
track_id=str2num(get(handles.track_id,'String'));
main_gui_data= guidata(handles.main_gui_handle);
id_indexes=find(main_gui_data.trajectory(:,4)==track_id);
main_gui_data.trajectory(id_indexes,5)=1;

%update main gui handles
guidata(handles.main_gui_handle,main_gui_data);

%update current track
handles.track=main_gui_data.trajectory(find(main_gui_data.trajectory(:,4)==track_id),:);
guidata(hObject, handles);

%update local track
set_new_track(hObject, eventdata, handles);

%refresh image in main gui 
main_gui_data= guidata(handles.main_gui_handle);
main_gui_data.exe_draw_figure(handles.main_gui_handle, [], main_gui_data);
%update percent covered
main_gui_data.exe_percent_covered(handles.main_gui_handle, [], main_gui_data);
% hObject    handle to select_this_track (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in select_start_of_track.
function select_start_of_track_Callback(hObject, eventdata, handles)
%select_this_track_Callback(hObject, eventdata, handles);
main_gui_data= guidata(handles.main_gui_handle);
%main_gui_data.trajectory
track_id=str2num(get(handles.track_id,'String'));
%sub_axes=gca;
sub_axes=handles.sub_axes;
axes(sub_axes);
[x y button]=ginput(1);
if button==3 || isempty(x) || isempty(y)
    return; %user wanted to cancel
else
    get_title=get(get(gca,'Title'),'String');
    if ~isempty(get_title)
        get_frame=regexp(get_title,' ','split');
        if size(get_frame,2)>1 && ~isempty(get_frame{2})
            cur_frame=str2num(get_frame{2});
            track_indexes=find(main_gui_data.trajectory(:,4)==track_id);
            track_low_frames=find(main_gui_data.trajectory(:,3)<cur_frame);
            [ids findex pindex]=intersect(track_indexes,track_low_frames);
            track_indexes_unused=track_indexes(findex,1);
            %size(track_indexes_unused)
            if ~isempty(track_indexes_unused)
                %update used frame range
                used_fr=get(handles.frame_range_of_track_used,'String');
                get_frames=regexp(used_fr,' to ','split');
                if strcmp(get_frames{1},'N/A')
                    select_this_track_Callback(hObject, eventdata, handles);
                    %reset frames
                    used_fr=get(handles.frame_range_of_track_used,'String');
                    get_frames=regexp(used_fr,' to ','split');
                    main_gui_data= guidata(handles.main_gui_handle);
                    track_indexes=find(main_gui_data.trajectory(:,4)==track_id);
                end    
                
                
                %undo the last start of track selection
           
                %str2num(get_frames{1})
                %main_gui_data.trajectory(:,3)
                prev_unselected_indexes=find(main_gui_data.trajectory(:,3)<str2num(get_frames{1}));                 
                %main_gui_data.trajectory(prev_unselected_indexes,:)                  
                [ids findex pindex]=intersect(track_indexes,prev_unselected_indexes);           
                %lowest col 5 = selection type
                selection_type=min(main_gui_data.trajectory(track_indexes,5));
                %main_gui_data.trajectory(track_indexes,:)
                main_gui_data.trajectory(ids,5)=selection_type;
                %main_gui_data.trajectory(track_indexes,:)


                %do the current set of start of track selection                    
                main_gui_data.trajectory(track_indexes_unused,5)=2;

                track_indexes=find(main_gui_data.trajectory(:,4)==track_id);
                %main_gui_data.trajectory(track_indexes,5)

                if find(main_gui_data.trajectory(track_indexes,5)==1,1) %at least one actually selected spot in track
                    set(handles.frame_range_of_track_used,'String',[num2str(cur_frame) ' to ' get_frames{2}]);                       
                else %no selected spots in track
                    set(handles.frame_range_of_track_used,'String','N/A');  
                    main_gui_data.trajectory(track_indexes,5)=0;
                end 
                guidata(handles.main_gui_handle,main_gui_data);
                
            end
        end   
    end   
end
%refresh image in main gui 
main_gui_data= guidata(handles.main_gui_handle);
main_gui_data.exe_draw_figure(handles.main_gui_handle, [], main_gui_data);
%update percent covered
main_gui_data.exe_percent_covered(handles.main_gui_handle, [], main_gui_data);


% hObject    handle to select_start_of_track (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in select_end_of_track.
function select_end_of_track_Callback(hObject, eventdata, handles)
main_gui_data= guidata(handles.main_gui_handle);
%main_gui_data.trajectory
track_id=str2num(get(handles.track_id,'String'));
%sub_axes=gca;
sub_axes=handles.sub_axes;
axes(sub_axes);
[x y button]=ginput(1);
if button==3 || isempty(x) || isempty(y)
    return; %user wanted to cancel
else
    get_title=get(get(gca,'Title'),'String');
    if ~isempty(get_title)
        get_frame=regexp(get_title,' ','split');
        if size(get_frame,2)>1 && ~isempty(get_frame{2})
            cur_frame=str2num(get_frame{2});
            track_indexes=find(main_gui_data.trajectory(:,4)==track_id);
            track_high_frames=find(main_gui_data.trajectory(:,3)>cur_frame);
            [ids findex pindex]=intersect(track_indexes,track_high_frames);
            track_indexes_unused=track_indexes(findex,1);
            %size(track_indexes_unused)
            if ~isempty(track_indexes_unused)
                %update used frame range
                used_fr=get(handles.frame_range_of_track_used,'String');
                get_frames=regexp(used_fr,' to ','split');
                if strcmp(get_frames{1},'N/A')
                    select_this_track_Callback(hObject, eventdata, handles);
                    %reset frames
                    used_fr=get(handles.frame_range_of_track_used,'String');
                    get_frames=regexp(used_fr,' to ','split');
                    main_gui_data= guidata(handles.main_gui_handle);
                    track_indexes=find(main_gui_data.trajectory(:,4)==track_id);
                end  
                     
                %undo the last start of track selection
                %main_gui_data.trajectory(track_indexes,:)
                %str2num(get_frames{2})
                prev_unselected_indexes=find(main_gui_data.trajectory(:,3)>str2num(get_frames{2}));                 
                %main_gui_data.trajectory(prev_unselected_indexes,:)                  
                [ids findex pindex]=intersect(track_indexes,prev_unselected_indexes);           
                %lowest col 5 = selection type
                selection_type=min(main_gui_data.trajectory(track_indexes,5));
                %main_gui_data.trajectory(track_indexes,:)
                main_gui_data.trajectory(ids,5)=selection_type;
                %main_gui_data.trajectory(track_indexes,:)


                %do the current set of start of track selection
                main_gui_data.trajectory(track_indexes_unused,5)=2;


                track_indexes=find(main_gui_data.trajectory(:,4)==track_id);
                if find(main_gui_data.trajectory(track_indexes,5)==1,1) %at least one actually selected spot in track
                    set(handles.frame_range_of_track_used,'String',[get_frames{1} ' to ' num2str(cur_frame)]);                       
                else %no selected spots in track
                    set(handles.frame_range_of_track_used,'String','N/A');  
                    main_gui_data.trajectory(track_indexes,5)=0;
                end                   
                guidata(handles.main_gui_handle,main_gui_data);
            end
        end   
    end   
end
%refresh image in main gui 
main_gui_data= guidata(handles.main_gui_handle);
main_gui_data.exe_draw_figure(handles.main_gui_handle, [], main_gui_data);
%update percent covered
main_gui_data.exe_percent_covered(handles.main_gui_handle, [], main_gui_data);
% hObject    handle to select_end_of_track (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in deselect_this_track.
function deselect_this_track_Callback(hObject, eventdata, handles)
track_id=str2num(get(handles.track_id,'String'));
main_gui_data= guidata(handles.main_gui_handle);
id_indexes=find(main_gui_data.trajectory(:,4)==track_id);
main_gui_data.trajectory(id_indexes,5)=0;

%update main gui handles
guidata(handles.main_gui_handle,main_gui_data);

%update current track
handles.track=main_gui_data.trajectory(find(main_gui_data.trajectory(:,4)==track_id),:);
guidata(hObject, handles);

%refresh image in main gui 
main_gui_data= guidata(handles.main_gui_handle);
main_gui_data.exe_draw_figure(handles.main_gui_handle, [], main_gui_data);
%update local track
set_new_track(hObject, eventdata, handles);
%update percent covered
main_gui_data.exe_percent_covered(handles.main_gui_handle, [], main_gui_data);
% hObject    handle to deselect_this_track (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


function check_mouseover_MousePress(hObject, eventdata, handles)
%graph_pos = get(handles.axes3,'Position')
mouse_pos=get(handles.axes3,'currentpoint');
x_limit=get(handles.axes3,'XLim');
y_limit=get(handles.axes3,'YLim');
x=mouse_pos(1,1);
y=mouse_pos(1,2);
if x>x_limit(1) && x<=x_limit(2) %check x
    if y>y_limit(1) && y<=y_limit(2) %check y
        store=sqrt((handles.track(:,1)-x).^2 + (handles.track(:,2)-y).^2);
        frame=handles.track(find(store==min(store)),3);
        set(handles.graph_frame,'String',num2str(frame));
    end
end






