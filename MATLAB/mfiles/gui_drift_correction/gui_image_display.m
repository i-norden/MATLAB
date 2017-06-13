function varargout = gui_image_display(varargin)
% GUI_IMAGE_DISPLAY() Allows you to interact with an image that is opened
% in a new figure. It does not edit the figure in any way, it just zooms
% and sets a drawing scale.
%This program can be opened multiple times in multiple copies to
%simultaneously interact with multiple images in multiple figures.
%gui_image_display relies on the program that calls it to get information from handles in
%order to edit the figure gui_image_display opens directly.
%
%Alex O, November 11, 2009 Version 1.0
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Alex O, December 11, 2009 Version 1.1
%Added a hard coded min max range that can be set by the parent gui.
%The range varies for image scaling on different images (8 bit vs 16 bit)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%fixed the scaling to be like glimpse, fixed the hard coded min max ranges
%and made it easier for parent guis to change the ranges.
%Alex O, Jan 12, 2010 Version 1.2
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
gui_Singleton = 0;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @gui_image_display_OpeningFcn, ...
                   'gui_OutputFcn',  @gui_image_display_OutputFcn, ...
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


% --- Executes just before gui_image_display is made visible.
function gui_image_display_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to gui_image_display (see VARARGIN)

% Choose default command line output for gui_image_display

handles.output = hObject;


%executable function for other guis to call
handles.exe_autoscale=@autoscale_Callback;


handles.fig=figure;
handles.image=ones(20,30);
handles.min_perm=1;
handles.max_perm=255;
set(handles.black,'Max',255);
set(handles.white,'Max',255);
handles.black_prev=1;
handles.white_prev=255;


set(handles.black,'value',1);
set(handles.white,'value',255);
% Update handles structure
guidata(hObject, handles);

% UIWAIT makes gui_image_display wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = gui_image_display_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in zoom.
function zoom_Callback(hObject, eventdata, handles)
draw_image(handles);
zoom_val=get(handles.zoom,'value');
if zoom_val==1
    zoom on;
    set(handles.zoom,'string','zoom on');
else
    zoom out;
    zoom off;
    set(handles.zoom,'string','zoom off');
end
% hObject    handle to zoom (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of zoom

function disp_scale_Callback(hObject, eventdata, handles)
disp_scale=str2num(get(handles.disp_scale,'string'));
set(handles.black,'value',disp_scale(1));
set(handles.white,'value',disp_scale(2));
%disp_scale=str2num(get(handles.disp_scale,'string'));
min_scale_Callback(hObject, eventdata, handles);
max_scale_Callback(hObject, eventdata, handles);
% hObject    handle to disp_scale (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of disp_scale as text
%        str2double(get(hObject,'String')) returns contents of disp_scale
%        as a double


% --- Executes on slider movement.
function black_Callback(hObject, eventdata, handles)
disp_scale=str2num(get(handles.disp_scale,'string'));
black_value=floor(get(handles.black,'value'));
set(handles.disp_scale,'string',[num2str(black_value) ' ' num2str(disp_scale(2))]);
draw_image(handles);
% hObject    handle to black (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of
%        slider

% --- Executes on slider movement.
function white_Callback(hObject, eventdata, handles)
disp_scale=str2num(get(handles.disp_scale,'string'));
white_value=ceil(get(handles.white,'value'));
set(handles.disp_scale,'string',[num2str(disp_scale(1)) ' ' num2str(white_value)]);
draw_image(handles);
% hObject    handle to white (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of
%        slider


% --- Executes on button press in incScale.
function incScale_Callback(hObject, eventdata, handles) %divide differences between min,max and actual values by 4
min=str2num(get(handles.min_scale,'string'));
max=str2num(get(handles.max_scale,'string'));
disp_scale=str2num(get(handles.disp_scale,'string'));
new_min=floor(disp_scale(1)-((disp_scale(1)-min)/4));
new_max=floor(disp_scale(2)+(max-disp_scale(2))/4);
if new_min<handles.min_perm
    set(handles.min_scale,'string',num2str(handles.min_perm));
else
    set(handles.min_scale,'string',num2str(new_min));
end
if new_max>handles.max_perm
    set(handles.max_scale,'string',num2str(handles.max_perm));
else
    set(handles.max_scale,'string',num2str(new_max));
end
min_scale_Callback(hObject, eventdata, handles);
max_scale_Callback(hObject, eventdata, handles);
% hObject    handle to incScale (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in decScale.
function decScale_Callback(hObject, eventdata, handles) %multiply differences between min,max and actual values by 4
min=str2num(get(handles.min_scale,'string'));
max=str2num(get(handles.max_scale,'string'));
disp_scale=str2num(get(handles.disp_scale,'string'));
new_min=floor(disp_scale(1)-((disp_scale(1)-min)*4))+1;
new_max=floor(disp_scale(2)+(max-disp_scale(2))*4)+1;
if new_min<handles.min_perm
    set(handles.min_scale,'string',num2str(handles.min_perm));
else
    set(handles.min_scale,'string',num2str(new_min));
end
if new_max>handles.max_perm
    set(handles.max_scale,'string',num2str(handles.max_perm));
else
    set(handles.max_scale,'string',num2str(new_max));
end
min_scale_Callback(hObject, eventdata, handles);
max_scale_Callback(hObject, eventdata, handles);
% hObject    handle to decScale (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)



function min_scale_Callback(hObject, eventdata, handles) %set min scales on sliders manually
min=str2num(get(handles.min_scale,'string'));
disp_scale=str2num(get(handles.disp_scale,'string'));
if min<handles.min_perm
    min=handles.min_perm;
    set(handles.min_scale,'string',num2str(min));
elseif min>disp_scale(2)
    min=disp_scale(2);
    set(handles.min_scale,'string',num2str(min));
end
if get(handles.black,'Value')<min
    set(handles.black,'Value',min);
end
if get(handles.white,'Value')<min
    set(handles.white,'Value',min);
end
set(handles.black,'Min',min);
set(handles.white,'Min',min);
black_Callback(hObject, eventdata, handles);
white_Callback(hObject, eventdata, handles);
% hObject    handle to min_scale (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of min_scale as text
%        str2double(get(hObject,'String')) returns contents of min_scale as a double




function max_scale_Callback(hObject, eventdata, handles) %set max scales on sliders manually
max=str2num(get(handles.max_scale,'string'));
disp_scale=str2num(get(handles.disp_scale,'string'));
if max>handles.max_perm
    max=handles.max_perm;
    set(handles.max_scale,'string',num2str(max));
elseif max<disp_scale(1)
    max=disp_scale(1);
    set(handles.max_scale,'string',num2str(max));
end

if get(handles.black,'Value')>max
    set(handles.black,'Value',max);
end
if get(handles.white,'Value')>max
    set(handles.white,'Value',max);
end
set(handles.black,'Max',max);
set(handles.white,'Max',max);
black_Callback(hObject, eventdata, handles);
white_Callback(hObject, eventdata, handles);
% hObject    handle to max_scale (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of max_scale as text
%        str2double(get(hObject,'String')) returns contents of max_scale as a double

function draw_image(handles)
disp_scale=str2num(get(handles.disp_scale,'string'));
figure(handles.fig);
colormap(gray);
%fix display scale
if disp_scale(1)>=disp_scale(2)
    white=round(get(handles.white,'Value'));
    black=round(get(handles.black,'Value'));
    if white<handles.white_prev %white slider moved incorrectly
        disp_scale(2)=black+1;       
    elseif white>handles.min_perm %black slider moved incorrectly, white>min
        disp_scale(1)=white-1;
    else
        disp_scale(1)=1;
        disp_scale(2)=2;
    end
    %update disp_scale
    set(handles.disp_scale,'string',[num2str(disp_scale(1)) ' ' num2str(disp_scale(2))]);
    %update slider values
    set(handles.white,'Value',disp_scale(2));
    set(handles.black,'Value',disp_scale(1));
end
set(gca, 'CLim', disp_scale);


% --- Executes on button press in store_data.
function store_data_Callback(hObject, eventdata, handles)


% --- Executes on button press in autoscale.
function autoscale_Callback(hObject, eventdata, handles)
chd_graph=get(get(handles.fig,'Children'),'Children');
if isempty(chd_graph)
   'need to load image first!'
   return;
end

image=[];
if iscell(chd_graph(end)) %if it became a cell array
    %chd2=get(get(handles.fig1,'children'),'children')
    %size(chd_graph)
    if size(chd_graph,1)>1
        chd3=chd_graph{end};
        %chd3
        chd3=chd3(end);
        %get(chd3)
        chd3=chd3(end);
        image=get(chd3,'CData');
    else
        %get(chd_graph{end})
        image=get(chd_graph{end},'CData');
        
    end
else %normal case
    %get(chd_graph(end))
    image=get(chd_graph(end),'CData');
end

%image=get(chd_graph(end),'CData');
%image=get(get(gca, 'Children'))
%image=get(get(get(handles.fig,'Children'),'Children'),'CData');
if ~isempty(image) %not empty
    %make new figure, plot scaled image
    temp_fig=figure('visible','off');
    imagesc(image);
    %get scale used
    auto_scale=get(get(temp_fig,'Children'),'CLim');
    
    %set the gui values to accomodate the autoscale
    handles.max_perm=2^16-1;
    %reset the sliders
    set(handles.black,'Max',2^16-1);
    set(handles.white,'Max',2^16-1);
    set(handles.black,'Value',auto_scale(1));
    set(handles.white,'Value',auto_scale(2));
    %reset the min, max display
    set(handles.min_scale,'string',num2str(0));
    set(handles.max_scale,'string',num2str(2^16-1));
    %reset display scale
    set(handles.disp_scale,'string',num2str(auto_scale));
    close(temp_fig);
else
    'you need to load an image before autoscaling!'
end
guidata(hObject, handles);
disp_scale_Callback(hObject, eventdata, handles)

% hObject    handle to autoscale (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

function check_slider_movement_ButtonMovement(hObject, eventdata, handles)
%callback for slider in guide=
%gui_image_display('black_Callback',gcbo,[],guidata(gcbo))

%values
black=get(handles.black,'Value');
white=get(handles.white,'Value');
%black slider check
if handles.black_prev~=black
    handles.black_prev=black;
    guidata(hObject, handles);
    black_Callback(hObject, eventdata, handles);   
end
%white slider check
if handles.white_prev~=white
    handles.white_prev=white;
    guidata(hObject, handles);
    white_Callback(hObject, eventdata, handles);
end










