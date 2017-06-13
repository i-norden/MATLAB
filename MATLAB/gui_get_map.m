function varargout = gui_get_map(varargin)
% GUI_GET_MAP M-file for gui_get_map.fig
%      GUI_GET_MAP, by itself, creates a new GUI_GET_MAP or raises the existing
%      singleton*.
%
%      H = GUI_GET_MAP returns the handle to a new GUI_GET_MAP or the handle to
%      the existing singleton*.
%
%      GUI_GET_MAP('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in GUI_GET_MAP.M with the given input arguments.
%
%      GUI_GET_MAP('Property','Value',...) creates a new GUI_GET_MAP or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before gui_get_map_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to gui_get_map_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help gui_get_map

% Last Modified by GUIDE v2.5 28-Jul-2009 03:22:48

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @gui_get_map_OpeningFcn, ...
                   'gui_OutputFcn',  @gui_get_map_OutputFcn, ...
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


% --- Executes just before gui_get_map is made visible.
function gui_get_map_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to gui_get_map (see VARARGIN)

% Choose default command line output for gui_get_map
handles.output = hObject;
%------------------------
handles.im_info=[];
handles.im_base=[];
handles.im_input=[];
handles.base_points=[];
handles.input_points=[];
handles.currnet=0;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes gui_get_map wait for user response (see UIRESUME)
% uiwait(handles.gui_get_map);


% --- Outputs from this function are returned to the command line.
function varargout = gui_get_map_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;
%=======================================================================




%=======================================================================
function set_pairs_Callback(hObject, eventdata, handles)
aoi_hw=str2num(get(handles.aoi_half_width,'string'));
% select mapping pairs
% select base points first and set the number of pairs
[m n]=size(handles.base_points);
axes(handles.axes_short);
title('base points (right click to end)','color',[1 0.5 0]);
[xin yin button]=ginput(1);
npoints=m;
while button==1
    handles.base_points=[handles.base_points;xin yin];
    xmin=round(xin)-aoi_hw;
    xmax=round(xin)+aoi_hw;
    ymin=round(yin)-aoi_hw;
    ymax=round(yin)+aoi_hw;
    line([xmin xmax xmax xmin xmin],[ymin ymin ymax ymax ymin],'Color',[1 0.5 0]);
    npoints=npoints+1;
    text(xmax+5,ymax+5,num2str(npoints),'color',[1 0.5 0]);
    [xin yin button]=ginput(1);
end

handles.current=npoints-m;  %current number of pairs

% input points
axes(handles.axes_long);
title('matching input points','color','r');
pause(0.1);
for indx=m+1:length(handles.base_points(:,1))
    handles.input_points=[handles.input_points;ginput(1)];
    xmin=round(handles.input_points(indx,1))-aoi_hw;
    xmax=round(handles.input_points(indx,1))+aoi_hw;
    ymin=round(handles.input_points(indx,2))-aoi_hw;
    ymax=round(handles.input_points(indx,2))+aoi_hw;
    line([xmin xmax xmax xmin xmin],[ymin ymin ymax ymax ymin],'Color','r');
    text(xmax+5,ymax+5,num2str(indx),'color','r');
end
pause(0.1);

% fine-tune control popints by Gaussian fitting to intensity
% [amplitude x_center y_center xy_sigma amp_offset]
for indx=m+1:length(handles.base_points(:,1))
    % base_points
    xmin=round(handles.base_points(indx,1))-aoi_hw;
    xmax=round(handles.base_points(indx,1))+aoi_hw;
    ymin=round(handles.base_points(indx,2))-aoi_hw;
    ymax=round(handles.base_points(indx,2))+aoi_hw;
    fit_arg=func_display_2dgaussian_fit(handles.im_base(ymin:ymax,xmin:xmax),10);
    text(xmax-xmin-6,ymax-ymin+3,[num2str(indx) ': base']);
    handles.base_points(indx,:)=[fit_arg(1,2)-1+xmin fit_arg(1,3)-1+ymin];
    pause(0.1);
    % input_points
    xmin=round(handles.input_points(indx,1))-aoi_hw;
    xmax=round(handles.input_points(indx,1))+aoi_hw;
    ymin=round(handles.input_points(indx,2))-aoi_hw;
    ymax=round(handles.input_points(indx,2))+aoi_hw;
    fit_arg=func_display_2dgaussian_fit(handles.im_input(ymin:ymax,xmin:xmax),10);
    text(xmax-xmin-6,ymax-ymin+3,[num2str(indx) ': input']);
    handles.input_points(indx,:)=[fit_arg(1,2)-1+xmin fit_arg(1,3)-1+ymin];
    pause(0.1);
end

guidata(hObject, handles);  %update handles structure




%=======================================================================
function map_field_Callback(hObject, eventdata, handles)
% calculate shift, magnification, and rotation by fitting 
% x2=fit_arg(1)*x1+fit_arg(2)*y1+fit_arg(3) and
% y2=fit_arg(1)*x1+fit_arg(2)*y1+fit_arg(3) separately
% PERFORM the fitting in 2 steps
% (1) do a linear fit of x2=fit_arg_x(1)*x1+fit_arg_x(2) and
%     y2=fit_arg_y(1)*y1+fit_arg_y(2) to get the initial guesses for step (2)
% (2) set the initial value of fig_arg(2)=0, fit_arg(1)=fit_arg_x(1), & fit_arg(3)=
%     fit_arg_x(2) for x2=fit_arg_x(1)*x1+fit_arg_x(2)*y1+fit_arg_x(3) AND
%     fit_arg(1)=0, fit_arg(2)=fit_arg_y(1), & fit_arg(3)=fit_arg_y(2) for 
%     y2=fit_arg(1)*x1+fit_arg(2)*y1+fit_arg(3) and perform the final fitting

base_points=handles.base_points;
input_points=handles.input_points;
map_func=inline('fit_arg(1)*xdata(:,1)+fit_arg(2)*xdata(:,2)+fit_arg(3)','fit_arg','xdata');
% find initial gueses for step 2
fit_arg_x=polyfit(base_points(:,1),input_points(:,1),1);
fit_arg_y=polyfit(base_points(:,2),input_points(:,2),1);
xdata=base_points;

fit_arg=[fit_arg_x(1) 0 fit_arg_x(2)];
options=optimset('lsqcurvefit');
options=optimset(options,'display','off');
px=lsqcurvefit(map_func,fit_arg,xdata,input_points(:,1),[],[],options);

fit_arg=[0 fit_arg_y(1) fit_arg_y(2)];
options=optimset('lsqcurvefit');
options=optimset(options,'display','off');
py=lsqcurvefit(map_func,fit_arg,xdata,input_points(:,2),[],[],options);

% display fit (dx vs x, dy vs y, linear fits, and the 2 variable linear fits)
% all the fitted points are rounded as in actual experiment (AOI's are defined
% by integer coordinates.
figure(22);set(22,'position',[10 250 600 325]);
subplot(1,2,1);plot(base_points(:,1),round(input_points(:,1)),'bo');
hold on;plot(sort(base_points(:,1)),round(polyval(fit_arg_x,sort(base_points(:,1)))),'b');
hold off;title(['[' num2str(px) ']']);ylabel('x2');xlabel('x1');
subplot(1,2,2);plot(base_points(:,2),round(input_points(:,2)),'ro');
hold on;plot(sort(base_points(:,2)),round(polyval(fit_arg_y,sort(base_points(:,2)))),'r');
hold off;
title(['[' num2str(py) ']']);ylabel('y2');xlabel('y1');
subplot(1,2,1);hold on;
plot(base_points(:,1),round(base_points(:,1)*px(1)+base_points(:,2)*px(2)+px(3)),'kx');
hold off;
subplot(1,2,2);hold on;
plot(base_points(:,2),round(base_points(:,1)*py(1)+base_points(:,2)*py(2)+py(3)),'kx');
hold off;

%---------------------------------------------
map.xs2l=px;
map.ys2l=py;
map.xl2s=[py(2) -px(2) -(px(3)*py(2)-px(2)*py(3))]/(px(1)*py(2)-px(2)*py(1));
map.yl2s=[py(1) -px(1) -(px(3)*py(1)-px(1)*py(3))]/(py(1)*px(2)-px(1)*py(2));
disp(get(handles.name_short,'string'));
disp(map);
pause(0.1);

[%--- save map ------------------------------
filename pathname]=uiputfile(' ','save mp as','D:\matlab\vista\maps');
if filename==0
    disp('mapped but not saved!');
else
    if sum(filename=='.')==1
      filename=filename(1:find(filename=='.')-1);
    end
    disp([pathname filename]);
    save([pathname filename],'map');
    saveas(22,[pathname filename], 'fig');
    disp('mapped & saved!');
end





%=======================================================================
function frame_plus_Callback(hObject, eventdata, handles)
frame=str2num(get(handles.frame_number,'string'));
if isempty(frame)
    frame=0;
end
frame=frame+1;
if frame>handles.im_info.nframes
    frame=1;
end
set(handles.frame_number,'string',num2str(frame));
%--- determine display mode -------------------
half_view=get(handles.half_view,'value');
im_axis532=[1 handles.im_info.width 1 handles.im_info.height];
im_axis633=[1 handles.im_info.width 1 handles.im_info.height];
if half_view==1 %split horizontally
  im_axis532=[round(handles.im_info.width/2)+1 handles.im_info.width 1 handles.im_info.height];
  im_axis633=[1 round(handles.im_info.width/2) 1 handles.im_info.height];
end
%----------------------------------------------
if get(handles.image_type,'value')==2       %TIFF
  filename=get(handles.name_short,'string');
  im_base=read_image('tiff',filename,frame,'stacked');
  filename=get(handles.name_long,'string');
  im_input=read_image('tiff',filename,frame,'stacked');
elseif get(handles.image_type,'value')==1   %glimpse
  filename=get(handles.name_short,'string');
  im_base=read_image('glimpse',filename,frame,' ');
  filename=get(handles.name_long,'string');
  im_input=read_image('glimpse',filename,frame,' ');
end
%----------------------------------------------
axes(handles.axes_short);
imagesc(im_base,str2num(get(handles.scale_short,'string')));
colormap(gray);axis off image;
axis(im_axis532);

axes(handles.axes_long);
imagesc(im_input,str2num(get(handles.scale_long,'string')));
colormap(gray);axis off image;
axis(im_axis633);

handles.im_base=im_base;
handles.im_input=im_input;
guidata(hObject, handles);  %update handles structure



%=======================================================================
function frame_minus_Callback(hObject, eventdata, handles)
frame=str2num(get(handles.frame_number,'string'));
if isempty(frame)
    frame=1;
end
frame=frame-1;
if frame<1
    frame=handles.im_info.nframes;
end
set(handles.frame_number,'string',num2str(frame));
%--- determine display mode -------------------
half_view=get(handles.half_view,'value');
im_axis532=[1 handles.im_info.width 1 handles.im_info.height];
im_axis633=[1 handles.im_info.width 1 handles.im_info.height];
if half_view==1 %split horizontally
  im_axis532=[round(handles.im_info.width/2)+1 handles.im_info.width 1 handles.im_info.height];
  im_axis633=[1 round(handles.im_info.width/2) 1 handles.im_info.height];
end
%----------------------------------------------
if get(handles.image_type,'value')==2       %TIFF
  filename=get(handles.name_short,'string');
  im_base=read_image('tiff',filename,frame,'stacked');
  filename=get(handles.name_long,'string');
  im_input=read_image('tiff',filename,frame,'stacked');
elseif get(handles.image_type,'value')==1   %glimpse
  filename=get(handles.name_short,'string');
  im_base=read_image('glimpse',filename,frame,' ');
  filename=get(handles.name_long,'string');
  im_input=read_image('glimpse',filename,frame,' ');
end
%----------------------------------------------
axes(handles.axes_short);
imagesc(im_base,str2num(get(handles.scale_short,'string')));
colormap(gray);axis off image;
axis(im_axis532);

axes(handles.axes_long);
imagesc(im_input,str2num(get(handles.scale_long,'string')));
colormap(gray);axis off image;
axis(im_axis633);

handles.im_base=im_base;
handles.im_input=im_input;
guidata(hObject, handles);  %update handles structure


%=======================================================================
function zoom_button_Callback(hObject, eventdata, handles)
[xin yin button]=ginput(1);
if button==3
  axis off image;
else
  while button==1
    point1 = get(gca,'CurrentPoint');    % button down detected
    finalRect = rbbox;                   % return figure units
    point2 = get(gca,'CurrentPoint');    % button up detected
    point1 = point1(1,1:2);              % extract x and y
    point2 = point2(1,1:2);
    p1 = min(point1,point2);             % calculate locations
    offset = abs(point1-point2);         % and dimensions
    x = [p1(1) p1(1)+offset(1) p1(1)+offset(1) p1(1) p1(1)];
    y = [p1(2) p1(2) p1(2)+offset(2) p1(2)+offset(2) p1(2)];
    image_region=round([min(x) max(x) min(y) max(y)]);
    axis(image_region);
    [xin yin button]=ginput(1);
  end
end



function delete_current_set_Callback(hObject, eventdata, handles)
%delete the most current set of mapping pairs if maistakes were made
handles.base_points=handles.base_points(end-handles.current+1,:);
handles.input_points=handles.input_points(end-handles.current+1,:);
handles.current=0;
guidata(hObject, handles);  %update handles



%=======================================================================
function reset_button_Callback(hObject, eventdata, handles)
handles.base_points=[];
handles.input_points=[];
handles.current=0;
guidata(hObject, handles);  %update handles




%=======================================================================
%=======================================================================
function name_short_Callback(hObject, eventdata, handles)
image_type=get(handles.image_type,'value');
switch image_type
  case 1      %glimpse
    if isempty(get(handles.name_short,'string'))
      dir_path=uigetdir('D:\matlab\images','pick a glimpse directory');
    else
      dir_path=uigetdir(get(handles.name_short,'string'),'pick a glimpse directory');
    end
    set(handles.name_short,'string',dir_path);
    if isempty(get(handles.name_long,'string'))
      set(handles.name_long,'string',dir_path);
    end
    load([dir_path '\header.mat']); 
    dum.nframes=vid.nframes;
    dum.width=vid.height;
    dum.height=vid.width;
    dum.time=vid.ttb-vid.ttb(1);
  case 2      %stacked TIFF
    if isempty(get(handles.name_short,'string'))
      [filename, pathname] = uigetfile('*.tif', 'pick a TIFF file','D:\matlab\images');
    else
      [filename, pathname] = uigetfile('*.tif', 'pick a TIFF file',get(handles.name_short,'string'));
    end
    set(handles.name_short,'string',[pathname filename]);
    if isempty(get(handles.name_long,'string'))
        set(handles.name_long,'string',[pathname filename]);
    end
    iminfo=imfinfo([pathname filename],'tif');
    dum.nframes=length(iminfo);
    dum.width=iminfo(1).Width;
    dum.height=iminfo(1).Height;
end
handles.im_info=dum;
handles.base_points=[];
handles.input_points=[];
guidata(hObject, handles);  %update handles

function name_short_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function name_long_Callback(hObject, eventdata, handles)
image_type=get(handles.image_type,'value');
switch image_type
  case 1      %glimpse
    if isempty(get(handles.name_long,'string'))
      dir_path=uigetdir('D:\matlab\images','pick a glimpse directory');
    else
      dir_path=uigetdir(get(handles.name_long,'string'),'pick a glimpse directory');
    end
    set(handles.name_long,'string',dir_path);
    if isempty(get(handles.name_short,'string'))
      set(handles.name_short,'string',dir_path);
    end
    load([dir_path '\header.mat']); 
    dum.nframes=vid.nframes;
    dum.width=vid.height;   %flip to get horizontal view
    dum.height=vid.width;   
    dum.time=vid.ttb-vid.ttb(1);
  case 2      %stacked TIFF
    if isempty(get(handles.name_long,'string'))
      [filename, pathname] = uigetfile('*.tif', 'pick a TIFF file','D:\matlab\images');
    else
      [filename, pathname] = uigetfile('*.tif', 'pick a TIFF file',get(handles.name_long,'string'));
    end
    set(handles.name_long,'string',[pathname filename]);
    if isempty(get(handles.name_short,'string'))
        set(handles.name_short,'string',[pathname filename]);
    end
    iminfo=imfinfo([pathname filename],'tif');
    dum.nframes=length(iminfo);
    dum.width=iminfo(1).Width;
    dum.height=iminfo(1).Height;
end
handles.im_info=dum;
handles.base_points=[];
handles.input_points=[];
guidata(hObject, handles);  %update handles

function name_long_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function scale_long_Callback(hObject, eventdata, handles)
frame=str2num(get(handles.frame_number,'string'));
%--- determine display mode -------------------
half_view=get(handles.half_view,'value');
im_axis532=[1 handles.im_info.width 1 handles.im_info.height];
im_axis633=[1 handles.im_info.width 1 handles.im_info.height];
if half_view==1 %split horizontally
  im_axis532=[round(handles.im_info.width/2)+1 handles.im_info.width 1 handles.im_info.height];
  im_axis633=[1 round(handles.im_info.width/2) 1 handles.im_info.height];
end
%----------------------------------------------
if get(handles.image_type,'value')==2       %TIFF
  filename=get(handles.name_short,'string');
  im_base=read_image('tiff',filename,frame,'stacked');
  filename=get(handles.name_long,'string');
  im_input=read_image('tiff',filename,frame,'stacked');
elseif get(handles.image_type,'value')==1   %glimpse
  filename=get(handles.name_short,'string');
  im_base=read_image('glimpse',filename,frame,' ');
  filename=get(handles.name_long,'string');
  im_input=read_image('glimpse',filename,frame,' ');
end
%----------------------------------------------
axes(handles.axes_long);
imagesc(im_input,str2num(get(handles.scale_long,'string')));
colormap(gray);axis off image;
axis(im_axis633);

handles.im_base=im_base;
handles.im_input=im_input;
guidata(hObject, handles);  %update handles structure

function scale_long_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function scale_short_Callback(hObject, eventdata, handles)
frame=str2num(get(handles.frame_number,'string'));
%--- determine display mode -------------------
half_view=get(handles.half_view,'value');
im_axis532=[1 handles.im_info.width 1 handles.im_info.height];
im_axis633=[1 handles.im_info.width 1 handles.im_info.height];
if half_view==1 %split horizontally
  im_axis532=[round(handles.im_info.width/2)+1 handles.im_info.width 1 handles.im_info.height];
  im_axis633=[1 round(handles.im_info.width/2) 1 handles.im_info.height];
end
%----------------------------------------------
if get(handles.image_type,'value')==2       %TIFF
  filename=get(handles.name_short,'string');
  im_base=read_image('tiff',filename,frame,'stacked');
  filename=get(handles.name_long,'string');
  im_input=read_image('tiff',filename,frame,'stacked');
elseif get(handles.image_type,'value')==1   %glimpse
  filename=get(handles.name_short,'string');
  im_base=read_image('glimpse',filename,frame,' ');
  filename=get(handles.name_long,'string');
  im_input=read_image('glimpse',filename,frame,' ');
end
%----------------------------------------------
axes(handles.axes_short);
imagesc(im_base,str2num(get(handles.scale_short,'string')));
colormap(gray);axis off image;
axis(im_axis532);

handles.im_base=im_base;
handles.im_input=im_input;
guidata(hObject, handles);  %update handles structure

function scale_short_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
function frame_number_Callback(hObject, eventdata, handles)
function frame_number_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
function half_view_Callback(hObject, eventdata, handles)
function aoi_half_width_Callback(hObject, eventdata, handles)
function aoi_half_width_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
function image_type_Callback(hObject, eventdata, handles)
function image_type_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
%=======================================================================
%=======================================================================



%{
%=======================================================================
function get_short_Callback(hObject, eventdata, handles)
image_type=get(handles.image_type,'value');
switch image_type
  case 1      %glimpse
    if isempty(get(handles.name_short,'string'))
      dir_path=uigetdir('D:\matlab\images','pick a glimpse directory');
    else
      dir_path=uigetdir(get(handles.name_short,'string'),'pick a glimpse directory');
    end
    set(handles.name_short,'string',dir_path);
    if isempty(get(handles.name_long,'string'))
      set(handles.name_long,'string',dir_path);
    end
    load([dir_path '\header.mat']); 
    dum.nframes=vid.nframes;
    dum.width=vid.height;
    dum.height=vid.width;
    dum.time=vid.ttb-vid.ttb(1);
  case 2      %stacked TIFF
    if isempty(get(handles.name_short,'string'))
      [filename, pathname] = uigetfile('*.tif', 'pick a TIFF file','D:\matlab\images');
    else
      [filename, pathname] = uigetfile('*.tif', 'pick a TIFF file',get(handles.name_short,'string'));
    end
    set(handles.name_short,'string',[pathname filename]);
    if isempty(get(handles.name_long,'string'))
        set(handles.name_long,'string',[pathname filename]);
    end
    iminfo=imfinfo([pathname filename],'tif');
    dum.nframes=length(iminfo);
    dum.width=iminfo(1).Width;
    dum.height=iminfo(1).Height;
end
handles.im_info=dum;
handles.base_points=[];
handles.input_points=[];
guidata(hObject, handles);  %update handles



%=======================================================================
function get_long_Callback(hObject, eventdata, handles)
image_type=get(handles.image_type,'value');
switch image_type
  case 1      %glimpse
    if isempty(get(handles.name_long,'string'))
      dir_path=uigetdir('D:\matlab\images','pick a glimpse directory');
    else
      dir_path=uigetdir(get(handles.name_long,'string'),'pick a glimpse directory');
    end
    set(handles.name_long,'string',dir_path);
    if isempty(get(handles.name_short,'string'))
      set(handles.name_short,'string',dir_path);
    end
    load([dir_path '\header.mat']); 
    dum.nframes=vid.nframes;
    dum.width=vid.height;   %flip to get horizontal view
    dum.height=vid.width;   
    dum.time=vid.ttb-vid.ttb(1);
  case 2      %stacked TIFF
    if isempty(get(handles.name_long,'string'))
      [filename, pathname] = uigetfile('*.tif', 'pick a TIFF file','D:\matlab\images');
    else
      [filename, pathname] = uigetfile('*.tif', 'pick a TIFF file',get(handles.name_long,'string'));
    end
    set(handles.name_long,'string',[pathname filename]);
    if isempty(get(handles.name_short,'string'))
        set(handles.name_short,'string',[pathname filename]);
    end
    iminfo=imfinfo([pathname filename],'tif');
    dum.nframes=length(iminfo);
    dum.width=iminfo(1).Width;
    dum.height=iminfo(1).Height;
end
handles.im_info=dum;
handles.base_points=[];
handles.input_points=[];
guidata(hObject, handles);  %update handles
%}