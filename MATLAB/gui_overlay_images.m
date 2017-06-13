function varargout = gui_overlay_images(varargin)
% GUI_OVERLAY_IMAGES M-file for gui_overlay_images.fig
%      GUI_OVERLAY_IMAGES, by itself, creates a new GUI_OVERLAY_IMAGES or raises the existing
%      singleton*.
%
%      H = GUI_OVERLAY_IMAGES returns the handle to a new GUI_OVERLAY_IMAGES or the handle to
%      the existing singleton*.
%
%      GUI_OVERLAY_IMAGES('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in GUI_OVERLAY_IMAGES.M with the given input arguments.
%
%      GUI_OVERLAY_IMAGES('Property','Value',...) creates a new GUI_OVERLAY_IMAGES or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before gui_overlay_images_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to gui_overlay_images_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help gui_overlay_images

% Last Modified by GUIDE v2.5 20-Aug-2009 10:40:40

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @gui_overlay_images_OpeningFcn, ...
                   'gui_OutputFcn',  @gui_overlay_images_OutputFcn, ...
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


% --- Executes just before gui_overlay_images is made visible.
function gui_overlay_images_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to gui_overlay_images (see VARARGIN)

% Choose default command line output for gui_overlay_images
handles.output = hObject;

%------------------------------
%define global variables
handles.scalered=[];
handles.scalegreen=[];
handles.imgreen=[];
handles.imred=[];
handles.map=[];
handles.im_info=[];
handles.image_region=[];
handles.AOI_red=[];
handles.AOI_green=[];
handles.red_shift=[0 0];
%------------------------------

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes gui_overlay_images wait for user response (see UIRESUME)
% uiwait(handles.gui_overlay_images);


% --- Outputs from this function are returned to the command line.
function varargout = gui_overlay_images_OutputFcn(hObject, eventdata, handles) 
varargout{1} = handles.output;







%==========================================================================
%==========================================================================
function select_AOI_Callback(hObject, eventdata, handles)
%load mapping file if not loaded already
if isempty(get(handles.fpath_map,'string')) 
  [filename, pathname] = uigetfile('*.mat', 'load map path','D:\matlab\vista\maps\');
  if pathname==0    %direct overlay if no mapping function is selected
    handles.map.xs2l=[1 0 0];
    handles.map.ys2l=[0 1 0];
    handles.map.xl2s=[1 0 0];
    handles.map.yl2s=[0 1 0];
  else
    set(handles.fpath_map,'string',[pathname filename]);
    wawa=load(get(handles.fpath_map,'string'));
    handles.map=wawa.map;
  end
  guidata(hObject, handles);
end

axes(handles.axes_overlay);
[xin yin button]=ginput(1); 
axis_name=get(get(gca,'title'),'string');


if button==3    %set both channels to its original image size
    
  axis([1 handles.im_info.width 1 handles.im_info.height]);
  handles.image_region=[1 handles.im_info.width 1 handles.im_info.height];
  handles.AOI_red   = [1 handles.im_info.width 1 handles.im_info.height];
  handles.AOI_green = handles.AOI_red;
  guidata(hObject, handles);
  overlay_images(handles,get(handles.fig,'value'));

else            %define an AOI
  
  midline=handles.im_info.width/2;
  while button==1
    point1 = get(gca,'CurrentPoint');   % button down detected
    rbbox;                              % return figure units
    point2 = get(gca,'CurrentPoint');   % button up detected
    point1 = point1(1,1:2);             % extract x and y
    point2 = point2(1,1:2);
    
	% skip if mouse isn't dragged or if the box crosses mid-line
    if (point1~=point2) & ( (point1(1)<midline & point2(1)<midline) |...
                            (point1(1)>midline & point2(1)>midline) )
                        
      p1 = min(point1,point2);          % get locations and dimensions
      offset = abs(point1-point2);      
      x = [p1(1) p1(1)+offset(1) p1(1)+offset(1) p1(1) p1(1)];
      y = [p1(2) p1(2) p1(2)+offset(2) p1(2)+offset(2) p1(2)];
      image_region=round([min(x) max(x) min(y) max(y)]);
      handles.image_region=image_region;
      %-------------------------------
      if strcmp(axis_name,'red channel') || strcmp(axis_name,'overlay')
        image_region(1:2)=image_region(1:2)+handles.AOI_red(1)-1;
        image_region(3:4)=image_region(3:4)+handles.AOI_red(3)-1;
        xmid=sum(image_region(1:2))/2;
        %ymin=image_region(3);
        if xmid<midline
          map.x=handles.map.xl2s;
          map.y=handles.map.yl2s;
          AOI_both=AOI_overlay(map,image_region);
        elseif xmid>midline
          map.x=handles.map.xs2l;
          map.y=handles.map.ys2l;
          AOI_both=AOI_overlay(map,image_region);
        end
        handles.AOI_red = AOI_both(1,:);
        handles.AOI_green = AOI_both(2,:);
      elseif strcmp(axis_name,'green channel')
        image_region(1:2)=image_region(1:2)+handles.AOI_green(1)-1;
        image_region(3:4)=image_region(3:4)+handles.AOI_green(3)-1;
        xmid=sum(image_region(1:2))/2;
        %ymin=image_region(3);
        if xmid<midline
          map.x=handles.map.xl2s;
          map.y=handles.map.yl2s;
          AOI_both=AOI_overlay(map,image_region);
        elseif xmid>midline
          map.x=handles.map.xs2l;
          map.y=handles.map.ys2l;
          AOI_both=AOI_overlay(map,image_region);
        end
        handles.AOI_green = AOI_both(1,:);
        handles.AOI_red = AOI_both(2,:);
      end
      guidata(hObject, handles);
      overlay_images(handles,get(handles.fig,'value'));
      %-------------------------------
      
    end
    axes(handles.axes_overlay);
    [xin yin button]=ginput(1);
  end

end








function make_avi_Callback(hObject, eventdata, handles)
fnum_red=str2num(get(handles.fnum_red,'string'));
fnum_green=str2num(get(handles.fnum_green,'string'));
red_FOV=str2num(get(handles.red_FOV,'string'));
green_FOV=str2num(get(handles.green_FOV,'string'));
%----------------------------------------
fpath_red=get(handles.fpath_red,'string');
fpath_green=get(handles.fpath_green,'string');
%match the two sequences 
fsequence_red=generate_FOV_info(red_FOV(1),red_FOV(2),handles.im_info.nframes_red,fnum_red);
fsequence_green=generate_FOV_info(green_FOV(1),green_FOV(2),handles.im_info.nframes_green,fnum_green);
if red_FOV(2)>green_FOV(2)      
  dum=[];
  for indx=1:length(fsequence_green)
    dum=[dum fsequence_green(indx)*ones(1,red_FOV(2))]; 
  end
  fsequence_green=dum;
elseif green_FOV(2)>red_FOV(2)
  dum=[];
  for indx=1:length(fsequence_red)
    dum=[dum fsequence_red(indx)*ones(1,green_FOV(2))]; 
  end
  fsequence_red=dum;
end
%make the 2 final sequences equal in length
seq_length=min(length(fsequence_red),length(fsequence_green));
fsequence_red=fsequence_red(1:seq_length);
fsequence_green=fsequence_green(1:seq_length);

%make AVI movie
[filename, pathname] = uiputfile('*.avi','save as AVI movie', 'D:\matlab\images\avi\');
fpath_avi=[pathname filename];
%-------------------------------------------------
fps=str2num(get(handles.frames_per_second,'string'));
frange=str2num(get(handles.frame_range,'string'));
if isempty(frange) 
  %make an avi movie of all images
  frange=[1:seq_length];
end
aviobj = avifile(fpath_avi,'Compression','none');
aviobj.fps=fps;
for findx=frange
  dum=read_image('glimpse',fpath_red,fsequence_red(findx),' ');
  handles.imred=dum;
  dum=read_image('glimpse',fpath_green,fsequence_green(findx),' ');
  handles.imgreen=dum;
  guidata(hObject, handles); 
  %-----------------------------
  overlay_images(handles,10);
  set(10,'color',[0 0 0]);            %set figure background to black to 
  aviobj=addframe(aviobj,getframe);   %get rid of the white edges problem
end
aviobj=close(aviobj);
delete(10);






function play_sequence_Callback(hObject, eventdata, handles)
%play sequence if the button is toggled on
if get(handles.play_sequence,'value')==1     
    
  fnum_red=str2num(get(handles.fnum_red,'string'));
  fnum_green=str2num(get(handles.fnum_green,'string'));
  red_FOV=str2num(get(handles.red_FOV,'string'));
  green_FOV=str2num(get(handles.green_FOV,'string'));
  %----------------------------------------
  fpath_red=get(handles.fpath_red,'string');
  fpath_green=get(handles.fpath_green,'string');
  %match the two sequences 
  fsequence_red=generate_FOV_info(red_FOV(1),red_FOV(2),handles.im_info.nframes_red,fnum_red);
  fsequence_green=generate_FOV_info(green_FOV(1),green_FOV(2),handles.im_info.nframes_green,fnum_green);
  if red_FOV(2)>green_FOV(2)      
    dum=[];
    for indx=1:length(fsequence_green)
      dum=[dum fsequence_green(indx)*ones(1,red_FOV(2))]; 
    end
    fsequence_green=dum;
  elseif green_FOV(2)>red_FOV(2)
    dum=[];
    for indx=1:length(fsequence_red)
      dum=[dum fsequence_red(indx)*ones(1,green_FOV(2))]; 
    end
    fsequence_red=dum;
  end
  %make the 2 final sequences equal in length
  seq_length=min(length(fsequence_red),length(fsequence_green));
  fsequence_red=fsequence_red(1:seq_length);
  fsequence_green=fsequence_green(1:seq_length);

  %make movie
  %-------------------------------------------------
  fps=str2num(get(handles.frames_per_second,'string'));
  frange=str2num(get(handles.frame_range,'string'));
  if isempty(frange) 
    %make an avi movie of all images
    frange=[1:seq_length];
  end

  while get(handles.play_sequence,'value')==1
    fcnt=0;
    for findx=frange
      fcnt=fcnt+1;
      dum=read_image('glimpse',fpath_red,fsequence_red(findx),' ');
      handles.imred=dum;
      dum=read_image('glimpse',fpath_green,fsequence_green(findx),' ');
      handles.imgreen=dum;
      guidata(hObject, handles); 
      %-----------------------------
      overlay_images(handles,0);
      pause(1/fps/3);
    end
  end

  %return display to the first frame of the sequence
  dum=read_image('glimpse',fpath_red,fsequence_red(frange(1)),' ');
  handles.imred=dum;
  dum=read_image('glimpse',fpath_green,fsequence_green(frange(1)),' ');
  handles.imgreen=dum;
  guidata(hObject, handles); 
  %-----------------------------
  overlay_images(handles,0);

end


  
  
  
function rv=generate_FOV_info(nFOV,fFOV,nframes,fnum)
%generate frame sequence for each channel by assigning
%each frame with the correct FOV number.  Return the
%correct frame sequence that includes the current displayed
%frame
dum=zeros(nFOV,ceil(nframes/nFOV));
bnum=nFOV*fFOV;
for findx=1:nframes
  bcnt=ceil(findx/bnum)-1;
  rindx=ceil((findx-bcnt*bnum)/fFOV);
  cindx=(findx-bcnt*bnum)-(rindx-1)*fFOV+bcnt*fFOV;
  dum(rindx,cindx)=findx;
end
%output frame sequence
for indx=1:nFOV
  FOV_frames=dum(indx,:);
  if sum(FOV_frames==fnum)==1
    rv=FOV_frames(FOV_frames>0);
  end
end


  
  
  
  
  
  
  


function fpath_red_Callback(hObject, eventdata, handles)
if isempty(get(handles.fpath_red,'string'))     %there is no existing file path
  if isempty(get(handles.fpath_green,'string')) 
    fpath_red = uigetdir('D:\matlab\images\','select a glimpse folder');
  else                                          %use green path directory
    fpath_red = uigetdir(get(handles.fpath_green,'string'),'select a glimpse folder');
  end
else        %there is an existing file path
  fpath_red = uigetdir(get(handles.fpath_red,'string'),'select a glimpse folder'); 
end
set(handles.fpath_red,'string',fpath_red);
fnum_red=str2num(get(handles.fnum_red,'string'));
load([fpath_red '\header.mat']);
handles.im_info.nframes_red=vid.nframes;
if fnum_red>vid.nframes
  fnum_red=1;
  set(handles.fnum_red,'string','1');
end
dum=read_image('glimpse',fpath_red,fnum_red,' ');
dum_size=size(dum);
handles.im_info.width=dum_size(2);
handles.im_info.height=dum_size(1);
if isempty(handles.AOI_red)
  handles.AOI_red=[1 dum_size(2) 1 dum_size(1)];
end
handles.imred=dum;
handles.scalered=str2num(get(handles.scale_red,'string'));
guidata(hObject, handles);
overlay_images(handles,get(handles.fig,'value'));


function fpath_green_Callback(hObject, eventdata, handles)
if isempty(get(handles.fpath_green,'string'))    %there is no existing file path
  if isempty(get(handles.fpath_red,'string'))
    fpath_green = uigetdir('D:\matlab\images\','select a glimpse folder');
  else                                          %use red path directory
    fpath_green = uigetdir(get(handles.fpath_red,'string'),'select a glimpse folder');
  end
else        %there is an existing file path
  fpath_green = uigetdir(get(handles.fpath_green,'string'),'select a glimpse folder'); 
end
set(handles.fpath_green,'string',fpath_green);
fnum_green=str2num(get(handles.fnum_green,'string'));
load([fpath_green '\header.mat']);
handles.im_info.nframes_green=vid.nframes;
if fnum_green>vid.nframes
  fnum_green=1;
  set(handles.fnum_green,'string','1');
end
dum=read_image('glimpse',fpath_green,fnum_green,' ');
dum_size=size(dum);
handles.im_info.width=dum_size(2);
handles.im_info.height=dum_size(1);
if isempty(handles.AOI_green)
  handles.AOI_green=[1 dum_size(2) 1 dum_size(1)];
end
handles.imgreen=dum;
handles.scalegreen=str2num(get(handles.scale_green,'string'));
guidata(hObject, handles);
overlay_images(handles,get(handles.fig,'value'));


function scale_green_Callback(hObject, eventdata, handles)
handles.scalegreen=str2num(get(handles.scale_green,'string'));
guidata(hObject, handles);
overlay_images(handles,get(handles.fig,'value'));


function scale_red_Callback(hObject, eventdata, handles)
handles.scalered=str2num(get(handles.scale_red,'string'));
guidata(hObject, handles);
overlay_images(handles,get(handles.fig,'value'));


function fnum_red_Callback(hObject, eventdata, handles)
fnum_red=str2num(get(handles.fnum_red,'string'));
fnum_green=str2num(get(handles.fnum_green,'string'));
fpath_red=get(handles.fpath_red,'string');
dum=read_image('glimpse',fpath_red,fnum_red,' ');
handles.imred=dum;
%change green channel frame number if necessary
red_FOV=str2num(get(handles.red_FOV,'string'));
nFOV=red_FOV(1);
fFOV=red_FOV(2);
bnum_red=nFOV*fFOV;
bcnt_red=ceil(fnum_red/bnum_red)-1;
rindx_red=ceil((fnum_red-bcnt_red*bnum_red)/fFOV);
%----------------------------------------
green_FOV=str2num(get(handles.green_FOV,'string'));
nFOV=green_FOV(1);
fFOV=green_FOV(2);
bnum_green=nFOV*fFOV;
bcnt_green=ceil(fnum_green/bnum_green)-1;
rindx_green=ceil((fnum_green-bcnt_green*bnum_green)/fFOV);
if isempty(fnum_green) || bcnt_green~=bcnt_red || rindx_green~=rindx_red
  fnum_green=bcnt_red*bnum_green+(rindx_red-1)*green_FOV(2)+1;
  set(handles.fnum_green,'string',num2str(fnum_green));
  fpath_green=get(handles.fpath_green,'string');
  dum=read_image('glimpse',fpath_green,fnum_green,' ');
  handles.imgreen=dum;
end
%----------------------------------------
guidata(hObject, handles);
overlay_images(handles,get(handles.fig,'value')); 



function fnum_green_Callback(hObject, eventdata, handles)
fnum_red=str2num(get(handles.fnum_red,'string'));
fnum_green=str2num(get(handles.fnum_green,'string'));
fpath_green=get(handles.fpath_green,'string');
dum=read_image('glimpse',fpath_green,fnum_green,' ');
handles.imgreen=dum;
%change red channel frame number if necessary
red_FOV=str2num(get(handles.red_FOV,'string'));
nFOV=red_FOV(1);
fFOV=red_FOV(2);
bnum_red=nFOV*fFOV;
bcnt_red=ceil(fnum_red/bnum_red)-1;
rindx_red=ceil((fnum_red-bcnt_red*bnum_red)/fFOV);
%----------------------------------------
green_FOV=str2num(get(handles.green_FOV,'string'));
nFOV=green_FOV(1);
fFOV=green_FOV(2);
bnum_green=nFOV*fFOV;
bcnt_green=ceil(fnum_green/bnum_green)-1;
rindx_green=ceil((fnum_green-bcnt_green*bnum_green)/fFOV);
if isempty(fnum_green) || bcnt_green~=bcnt_red || rindx_green~=rindx_red
  fnum_red=bcnt_green*bnum_red+(rindx_green-1)*red_FOV(2)+1;
  set(handles.fnum_red,'string',num2str(fnum_red));
  fpath_red=get(handles.fpath_red,'string');
  dum=read_image('glimpse',fpath_red,fnum_red,' ');
  handles.imred=dum;
end
%----------------------------------------
guidata(hObject, handles);
overlay_images(handles,get(handles.fig,'value')); 





function shift_red_channel_Callback(hObject, eventdata, handles)
red_shift_option=get(handles.red_shift_option,'value');
switch red_shift_option
  case 1    %define a function for this GUI's KeyPressFcn 
    set( handles.shift_red_channel ,'KeyPressFcn',@key_detection );
  case 2    %reset shift to zero
    handles.red_shift=[0 0];
    overlay_images(handles,get(handles.fig,'value'));
end
guidata(hObject, handles);

%=======================================
function key_detection(hObject,evnt,eventdata,handles)
handles=guidata(hObject);
dx=0; dy=0;
switch evnt.Key
  case 'uparrow'
    dy=1;
  case 'downarrow'
    dy=-1;
  case 'leftarrow'
    dx=1;
  case 'rightarrow'
    dx=-1;
  case 'return'
     set( handles.shift_red_channel ,'KeyPressFcn','' );
     overlay_images(handles,get(handles.fig,'value'));
end

if ~strcmp(evnt.Key,'return')
  handles.red_shift=handles.red_shift+[dx dy];
  guidata(hObject,handles);

  image_region=handles.image_region;
  dum=zeros(image_region(4)-image_region(3),image_region(2)-image_region(1));
  overlay_images(handles,0);
end





function red_FOV_Callback(hObject, eventdata, handles)
red_FOV=str2num(get(handles.red_FOV,'string'));
green_FOV=str2num(get(handles.green_FOV,'string'));
if red_FOV(1)~=green_FOV(1)
  green_FOV(1)=red_FOV(1);
  set(handles.green_FOV,'string',num2str(green_FOV));
end
green_FOV=str2num(get(handles.green_FOV,'string'));
%generate FOV frames
nFOV=red_FOV(1);
fFOV=red_FOV(2);
nframes=handles.im_info.nframes_red;
nFOV=green_FOV(1);
fFOV=green_FOV(2);
nframes=handles.im_info.nframes_green;

%red channel fnum number
fnum_red=str2num(get(handles.fnum_red,'string'));
fnum_green=str2num(get(handles.fnum_green,'string'));

%change green channel frame number if necessary
nFOV=red_FOV(1);
fFOV=red_FOV(2);
bnum_red=nFOV*fFOV;
bcnt_red=ceil(fnum_red/bnum_red)-1;
rindx_red=ceil((fnum_red-bcnt_red*bnum_red)/fFOV);
%---------------------------
nFOV=green_FOV(1);
fFOV=green_FOV(2);
bnum_green=nFOV*fFOV;
bcnt_green=ceil(fnum_green/bnum_green)-1;
rindx_green=ceil((fnum_green-bcnt_green*bnum_green)/fFOV);
if bcnt_green~=bcnt_red || rindx_green~=rindx_red
  fnum_green=bcnt_red*bnum_green+(rindx_red-1)*green_FOV(2)+1;
  set(handles.fnum_green,'string',num2str(fnum_green));
end

%update handles
guidata(hObject, handles);


function green_FOV_Callback(hObject, eventdata, handles)
%[nFOV   frames/field]
red_FOV=str2num(get(handles.red_FOV,'string'));
green_FOV=str2num(get(handles.green_FOV,'string'));
%the number of fields should be the same
if red_FOV(1)~=green_FOV(1)
  red_FOV(1)=green_FOV(1);
  set(handles.red_FOV,'string',num2str(red_FOV));
end
red_FOV=str2num(get(handles.red_FOV,'string'));
%generate FOV frames
nFOV=red_FOV(1);
fFOV=red_FOV(2);
nframes=handles.im_info.nframes_red;
nFOV=green_FOV(1);
fFOV=green_FOV(2);
nframes=handles.im_info.nframes_green;

%get channel frame number
fnum_green=str2num(get(handles.fnum_green,'string'));
fnum_red=str2num(get(handles.fnum_red,'string'));

%change red channel frame number if necessary
nFOV=red_FOV(1);
fFOV=red_FOV(2);
bnum_red=nFOV*fFOV;
bcnt_red=ceil(fnum_red/bnum_red)-1;
rindx_red=ceil((fnum_red-bcnt_red*bnum_red)/fFOV);
%---------------------------
nFOV=green_FOV(1);
fFOV=green_FOV(2);
bnum_green=nFOV*fFOV;
bcnt_green=ceil(fnum_green/bnum_green)-1;
rindx_green=ceil((fnum_green-bcnt_green*bnum_green)/fFOV);
if bcnt_green~=bcnt_red || rindx_green~=rindx_red
  fnum_red=bcnt_green*bnum_red+(rindx_green-1)*red_FOV(2)+1;
  set(handles.fnum_red,'string',num2str(fnum_red));
end

%update handles
guidata(hObject, handles);








%-------------------------------------------------
function rv=AOI_overlay(map,image_region)
%pass in the correct map with the selected AOI
%and get the mapped AOI for overlaying images
%
%this function is correct if and only if the magnifications and
%the orientations of the 2 fields are the same; otherwise, image
%transformation is required for precisely overlay the 2 fields.

method='center';    %propagate mapping errors from AOI center
%method='corner';    %propagate mapping errors from AOI corner

if strcmp(method,'corner')
  %map one corner of an AOI; difference in magnification and orientation
  %between the 2 fields will be systematically propagated from one corner. 
  xmin=image_region(1);
  ymin=image_region(3);
  xmapped=round(xmin*map.x(1)+ymin*map.x(2)+map.x(3));
  ymapped=round(xmin*map.y(1)+ymin*map.y(2)+map.y(3));

elseif strcmp(method,'center')
  %map the center of an AOI; difference in magnification and orientation
  %between the 2 fields will be systematically propagated from the center. 
  xmid=sum(image_region(1:2))/2;
  ymid=sum(image_region(3:4))/2;
  %-----------------------------------------------
  xmapped=xmid*map.x(1)+ymid*map.x(2)+map.x(3);
  ymapped=xmid*map.y(1)+ymid*map.y(2)+map.y(3);
  %-----------------------------------------------
  xmapped=round(xmapped-(xmid-image_region(1)));
  ymapped=round(ymapped-(ymid-image_region(3)));
  
end

rv=[ image_region;[xmapped xmapped+abs(diff(image_region(1:2))) ...
                   ymapped ymapped+abs(diff(image_region(3:4)))] ];




%-------------------------------------------------
function rv=overlay_images(handles,fig)
%overlay 2 images

scale1=handles.scalered;
scale2=handles.scalegreen;

%add shift to green channel only
AOI_red=handles.AOI_red+[handles.red_shift(1)*ones(1,2) handles.red_shift(2)*ones(1,2)];

%check to see if red_channel is shifted out of range
imred=handles.imred;
dumx=zeros(size(handles.imred));
%check x shift
if AOI_red(1)<1 
  dumx(:,1-AOI_red(1)+1:end )=imred(:,1:end+AOI_red(1)-1);
  AOI_red(2)=AOI_red(2)-AOI_red(1)+1;
  AOI_red(1)=1;
elseif AOI_red(2)>handles.im_info.width    
  deltaX=AOI_red(2)-handles.im_info.width;
  dumx(:,1:end-deltaX)=imred(:,deltaX+1:end);
  AOI_red(1)=handles.im_info.width-AOI_red(2)+AOI_red(1);
  AOI_red(2)=handles.im_info.width;    
else
  dumx=imred;
end
imred=dumx;
dumy=zeros(size(handles.imred));
%check y shift after x shift
if AOI_red(3)<1 
  dumy(1-AOI_red(3)+1:end,:) = imred(1:end+AOI_red(3)-1,:);
  AOI_red(4)=AOI_red(4)-AOI_red(3)+1;
  AOI_red(3)=1;
elseif AOI_red(4)>handles.im_info.height    
  deltaY=AOI_red(4)-handles.im_info.height;
  dumy(1:end-deltaY,:)=imred(deltaY+1:end,:);
  AOI_red(3)=handles.im_info.height-AOI_red(4)+AOI_red(3);
  AOI_red(4)=handles.im_info.height;    
else
  dumy=imred;
end

%sum of x and y shift
dum1=dumy; 

%-------------------------------------------------
if ~isempty(dum1)
  dum1(dum1<scale1(1))=scale1(1);
  dum1(dum1>scale1(2))=scale1(2);
  dum1=(dum1-scale1(1))/(scale1(2)-scale1(1));
  dum1=dum1(AOI_red(3):AOI_red(4),AOI_red(1):AOI_red(2));
  dum1r=dum1;       %red channel
  dum1r(:,:,2)=zeros(size(dum1));    %green channel
  dum1r(:,:,3)=zeros(size(dum1));    %blue channel
  if fig<2
    axes(handles.axes_red);
    imshow(dum1r);
    title('red channel');
  end
end
%-------------------------------------------------
dum2=handles.imgreen;
if ~isempty(dum2)
  dum2(dum2<scale2(1))=scale2(1);
  dum2(dum2>scale2(2))=scale2(2);
  dum2=(dum2-scale2(1))/(scale2(2)-scale2(1));
  dum2=dum2(handles.AOI_green(3):handles.AOI_green(4),...
            handles.AOI_green(1):handles.AOI_green(2));
  dum2g=zeros(size(dum2));            %red channel
  dum2g(:,:,2)=dum2; %green channel
  dum2g(:,:,3)=zeros(size(dum2));     %blue channel
  if fig<2
    axes(handles.axes_green);
    imshow(dum2g);
    title('green channel');
  end
end
%-------------------------------------------------
if isempty(dum1)
  if isempty (dum2)
    dum3=[];
  else
    dum3=dum2g;
  end
else
  if isempty (dum2)
    dum3=dum1;
  else
    if size(dum1r)==size(dum2g)
      dum3=dum1r+dum2g;
    else
      dum3=[];
    end
  end
end
if ~isempty(dum3) && fig<2
  axes(handles.axes_overlay);
  imshow(dum3);
  title('overlay');
end

rv=dum3;
%-------------------------------------------------
%generate a figure
if fig==1
  figure(1);
  set(1,'position',[440 555 690 245]);
  if ~isempty(dum1)
    subplot('position',[0.05 0.05 0.2666 0.9]);
    imshow(dum1r);
  end
  if ~isempty(dum2)
    subplot('position',[0.3666 0.05 0.2666 0.9]);
    imshow(dum2g);
  end
  if ~isempty(dum3)
    subplot('position',[0.6832 0.05 0.2666 0.9]);
    imshow(dum3);
  end
elseif fig>1
  figure(fig);
  imshow(dum3); 
end
%-------------------------------------------------












%==========================================================================
%==========================================================================
function green_FOV_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
function red_FOV_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
function fpath_red_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
function fpath_green_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
function fpath_map_Callback(hObject, eventdata, handles)
if isempty(get(handles.fpath_map,'string')) 
  [filename, pathname] = uigetfile('*.mat', 'load map path','D:\matlab\vista\maps\');
else
  [filename, pathname] = uigetfile('*.mat', 'load map path',get(handles.fpath_map,'string'));
end
set(handles.fpath_map,'string',[pathname filename]);
wawa=load(get(handles.fpath_map,'string'));
handles.map=wawa.map;
guidata(hObject, handles);
function fpath_map_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
function scale_green_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
function scale_red_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
function fnum_red_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
function fnum_green_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
function fig_Callback(hObject, eventdata, handles)
overlay_images(handles,get(handles.fig,'value'));
function frame_range_Callback(hObject, eventdata, handles)
function frame_range_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
function frames_per_second_Callback(hObject, eventdata, handles)
function frames_per_second_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
function red_shift_option_Callback(hObject, eventdata, handles)
function red_shift_option_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
%==========================================================================
%==========================================================================

