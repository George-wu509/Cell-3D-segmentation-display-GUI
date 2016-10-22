function varargout = Raw_image3D(varargin)
% RAW_IMAGE3D MATLAB code for Raw_image3D.fig
%      RAW_IMAGE3D, by itself, creates a new RAW_IMAGE3D or raises the existing
%      singleton*.
%
%      H = RAW_IMAGE3D returns the handle to a new RAW_IMAGE3D or the handle to
%      the existing singleton*.
%
%      RAW_IMAGE3D('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in RAW_IMAGE3D.M with the given input arguments.
%
%      RAW_IMAGE3D('Property','Value',...) creates a new RAW_IMAGE3D or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before Raw_image3D_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to Raw_image3D_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help Raw_image3D

% Last Modified by GUIDE v2.5 21-Oct-2016 22:19:34

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @Raw_image3D_OpeningFcn, ...
                   'gui_OutputFcn',  @Raw_image3D_OutputFcn, ...
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
end

% --- Raw_image 3D open function.
function Raw_image3D_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to Raw_image3D (see VARARGIN)

fprintf('\n');
display('  ------------------------------------------------------   ');
display('  Rawimage_3D, edited by George at 2016.10.21 1041am ');
display('  ------------------------------------------------------   ');
fprintf('\n'); 

%% Choose default command line output for Raw_image3D
handles.output = hObject;
% Update handles structure
guidata(hObject, handles);

% UIWAIT makes Raw_image3D wait for user response (see UIRESUME)
% uiwait(handles.figure1);
end

% --- Open file button --
function pushbutton1_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)%% data folder and image format
set(handles.edit10,'String','Loading data ...');pause(0.1);
imagename{1}=uigetfile({'*.mat','Data Files (*.mat)'});
handles.imagename=imagename;
guidata(hObject, handles);
if imagename{1}==0
    set(handles.edit1,'String','');pause(0.1);
    guidata(hObject, handles);
    return;
end

%% load p.mat
load(handles.imagename{1});


%% set handles.popupmenu1 String = image names
for i=1:size(imagename,2)
    popname{i,1} = imagename{1,i};
end
set(handles.popupmenu1,'String',popname);
image_no= get(handles.popupmenu1,'Value');


%% Default load first image information
handles.NFstk = NFstk{1,1};
handles.xyzintsegdat=xyzintsegdat{1,1};
handles.chal_info=chal_info;
maxpage=size(handles.NFstk,3);


%% setup handles.slider1,edit1, popupmenu2, axes1 property according to image1
% setup popupmenu2
set(handles.popupmenu2,'String',chal_info(:,3));
set(handles.popupmenu2,'Visible','On');
chal_no=get(handles.popupmenu2,'Value');


%% setup handles.slider1 - Z-stack
set(handles.slider1,'Max',size(NFstk{1,1},3));set(handles.slider1,'Min',1);
set(handles.slider1, 'SliderStep', [1/(size(NFstk{1,1},3)-1) , 1/(size(NFstk{1,1},3)-1) ]);
set(handles.slider1,'String',num2str(round(size(NFstk{1},3)/2)));set(handles.slider1,'Value',round(size(NFstk{1},3)/2));
% setup handles.edit1 - Z-stack
eval(['set(handles.edit1,''String'',''' num2str(round(size(NFstk{1,1},3)/2)) ''');']);
page_no=round(size(NFstk{1},3)/2);


%% setup handles.slider3 - 3Dlayer
set(handles.slider3,'Max',round(size(NFstk{1,1},3)));set(handles.slider3,'Min',0);
set(handles.slider3, 'SliderStep', [1/(round(size(NFstk{1,1},3))-1) , 1/(round(size(NFstk{1,1},3))-1) ]);
set(handles.slider3,'String',num2str(round(size(NFstk{1,1},3))));set(handles.slider3,'Value',round(size(NFstk{1,1},3)));
% setup handles.edit4 - 3Dlayer
eval(['set(handles.edit4,''String'',''' num2str(round(size(NFstk{1},3))) ''');']);
max_Ip=round(size(NFstk{1,1},3));


%% Marker properties
% Dault colorbar max value setup
maxcolorbar=256;
if max(max(max(NFstk{1,1})))>500;maxcolorbar =65535;end
maxyo=get(handles.checkbox4,'Value');
if maxyo==1
    set(handles.edit9,'Visible','Off');
    set(handles.edit9,'String','0');
elseif maxyo==0
    set(handles.edit9,'Visible','On');
    maxcolorbar_input=str2num(get(handles.edit9,'String'));
    if maxcolorbar_input~=0;maxcolorbar=maxcolorbar_input;end
end
% marker color setup
color_matrix = {'r','b','k','g'};
mk_size=str2double(get(handles.edit5,'String'));
mk_color=color_matrix{get(handles.popupmenu3,'Value')};
im_alpha=min(max(str2double(get(handles.edit7,'String')),0),1);
flag_on=get(handles.checkbox3,'Value');




%% show axes1
% data prepare
xyzi=xyzintsegdat{1};
xyzi=xyzi(xyzi(:,3)>max(page_no-max_Ip,1)&xyzi(:,3)<min(page_no+max_Ip,maxpage),:);

% axis1
view(3);
[handles.az,handles.el] = view;
set(handles.axes1,'Units','pixels');
resizePos = get(handles.axes1,'Position');
myImage = NFstk{1}(:,:,page_no);
%myImage= imresize(myImage, [resizePos(3) resizePos(3)]);
axes(handles.axes1);
%if maxyo==1
%    scatter3(xyzi(:,1),xyzi(:,2),xyzi(:,3),mk_size,xyzi(:,5),mk_color);
%else
    scatter3(xyzi(:,1),xyzi(:,2),xyzi(:,3),mk_size,xyzi(:,5));
    caxis([0, maxcolorbar]);colormap(jet);colorbar;
%end
if isfield(handles,'az')==1
    view([handles.az,handles.el]);
end
h=rotate3d;
set(h,'Enable','on');hold on;zlim([1, maxpage]);
if flag_on==1
    for i=1:size(xyzi,1)
        line([xyzi(i,1) xyzi(i,1)],[xyzi(i,2) xyzi(i,2)],[xyzi(i,3) xyzi(i,3)+mk_size],'Color',mk_color);hold on
    end
end
surface(ones(size(NFstk{1},1),size(NFstk{1},2)).*page_no,NFstk{1}(:,:,page_no),'Edgecolor','none');alpha(im_alpha);hold off;
xlim([1, size(myImage,1)]);ylim([1, size(myImage,2)]);zlim([1, maxpage]);


%% Choose default command line output for Raw_image3D
set(handles.edit10,'String','Finished!');pause(0.1);
handles.output = hObject;
% Update handles structure
guidata(hObject, handles);

% UIWAIT makes Raw_image3D wait for user response (see UIRESUME)
% uiwait(handles.figure1);
end

% --- text edit --
function edit10_Callback(hObject, eventdata, handles)
% hObject    handle to edit10 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit10 as text
%        str2double(get(hObject,'String')) returns contents of edit10 as a double
end

% --- Image file --
function popupmenu1_Callback(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


%% input popupmenu1% and 2 value
image_no= get(handles.popupmenu1,'Value');
chal_no=get(handles.popupmenu2,'Value');


%% load p.mat
load(handles.imagename{1});
handles.NFstk = NFstk{1,chal_no};
handles.xyzintsegdat=xyzintsegdat{1,chal_no};
handles.chal_info=chal_info;
maxpage=size(handles.NFstk,3);
NFstk=handles.NFstk;
xyzintsegdat=handles.xyzintsegdat;

%% setup handles.slider1 and edit1 - Z-stack
page_no = round(get(handles.slider1,'Value'));
set(handles.slider1,'String',num2str(page_no));
set(handles.edit1,'String',num2str(page_no));


%% setup handles.slider3 and edit4 - 3Dlayer
max_Ip = round(get(handles.slider3,'Value'));
set(handles.slider3,'String',num2str(max_Ip));
set(handles.edit4,'String',num2str(max_Ip));
max_Ip=str2num(get(handles.edit4,'String'));
if isempty(max_Ip)==1
    max_Ip=0;
end


%% Marker properties
% Dault colorbar max value setup
maxcolorbar=256;
if max(max(max(NFstk)))>500;maxcolorbar =65535;end
maxyo=get(handles.checkbox4,'Value');
if maxyo==1
    set(handles.edit9,'Visible','Off');
    set(handles.edit9,'String','0');
elseif maxyo==0
    set(handles.edit9,'Visible','On');
    maxcolorbar_input=str2num(get(handles.edit9,'String'));
    if maxcolorbar_input~=0;maxcolorbar=maxcolorbar_input;end
end
% marker color setup
color_matrix = {'r','b','k','g'};
mk_size=str2double(get(handles.edit5,'String'));
mk_color=color_matrix{get(handles.popupmenu3,'Value')};
im_alpha=min(max(str2double(get(handles.edit7,'String')),0),1);
flag_on=get(handles.checkbox3,'Value');




%% show axes1
% data prepare
xyzi=xyzintsegdat;
xyzi=xyzi(xyzi(:,3)>=max(page_no-max_Ip,1)&xyzi(:,3)<=min(page_no+max_Ip,maxpage),:);

% axis1
[handles.az,handles.el] = view;
set(handles.axes1,'Units','pixels');
resizePos = get(handles.axes1,'Position');
myImage = NFstk(:,:,page_no);
%myImage= imresize(myImage, [resizePos(3) resizePos(3)]);
axes(handles.axes1);
if maxyo==1
    scatter3(xyzi(:,1),xyzi(:,2),xyzi(:,3),mk_size,xyzi(:,5),mk_color);
else
    scatter3(xyzi(:,1),xyzi(:,2),xyzi(:,3),mk_size,xyzi(:,5));
    caxis([0, maxcolorbar]);colormap(jet);colorbar;
end
if isfield(handles,'az')==1
    view([handles.az,handles.el]);
end
h=rotate3d;
set(h,'Enable','on');hold on;zlim([1, maxpage]);
if flag_on==1
    for i=1:size(xyzi,1)
        line([xyzi(i,1) xyzi(i,1)],[xyzi(i,2) xyzi(i,2)],[xyzi(i,3) xyzi(i,3)+mk_size],'Color',mk_color);hold on
    end
end
surface(ones(size(NFstk,1),size(NFstk,2)).*page_no,NFstk(:,:,page_no),'Edgecolor','none');alpha(im_alpha);hold off;
xlim([1, size(myImage,1)]);ylim([1, size(myImage,2)]);zlim([1, maxpage]);

% update handles
guidata(hObject, handles);
end

% --- Image channel ----
function popupmenu2_Callback(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


%% input popupmenu1% and 2 value
image_no= get(handles.popupmenu1,'Value');
chal_no=get(handles.popupmenu2,'Value');


%% load p.mat
load(handles.imagename{1});
handles.NFstk = NFstk{1,chal_no};
handles.xyzintsegdat=xyzintsegdat{1,chal_no};
handles.chal_info=chal_info;
maxpage=size(handles.NFstk,3);
NFstk=handles.NFstk;
xyzintsegdat=handles.xyzintsegdat;

%% setup handles.slider1 and edit1 - Z-stack
page_no = round(get(handles.slider1,'Value'));
set(handles.slider1,'String',num2str(page_no));
set(handles.edit1,'String',num2str(page_no));


%% setup handles.slider3 and edit4 - 3Dlayer
max_Ip = round(get(handles.slider3,'Value'));
set(handles.slider3,'String',num2str(max_Ip));
set(handles.edit4,'String',num2str(max_Ip));
max_Ip=str2num(get(handles.edit4,'String'));
if isempty(max_Ip)==1
    max_Ip=0;
end


%% Marker properties
% Dault colorbar max value setup
maxcolorbar=256;
if max(max(max(NFstk)))>500;maxcolorbar =65535;end
maxyo=get(handles.checkbox4,'Value');
if maxyo==1
    set(handles.edit9,'Visible','Off');
    set(handles.edit9,'String','0');
elseif maxyo==0
    set(handles.edit9,'Visible','On');
    maxcolorbar_input=str2num(get(handles.edit9,'String'));
    if maxcolorbar_input~=0;maxcolorbar=maxcolorbar_input;end
end
% marker color setup
color_matrix = {'r','b','k','g'};
mk_size=str2double(get(handles.edit5,'String'));
mk_color=color_matrix{get(handles.popupmenu3,'Value')};
im_alpha=min(max(str2double(get(handles.edit7,'String')),0),1);
flag_on=get(handles.checkbox3,'Value');




%% show axes1
% data prepare
xyzi=xyzintsegdat;
xyzi=xyzi(xyzi(:,3)>=max(page_no-max_Ip,1)&xyzi(:,3)<=min(page_no+max_Ip,maxpage),:);

% axis1
[handles.az,handles.el] = view;
set(handles.axes1,'Units','pixels');
resizePos = get(handles.axes1,'Position');
myImage = NFstk(:,:,page_no);
%myImage= imresize(myImage, [resizePos(3) resizePos(3)]);
axes(handles.axes1);
if maxyo==1
    scatter3(xyzi(:,1),xyzi(:,2),xyzi(:,3),mk_size,xyzi(:,5),mk_color);
else
    scatter3(xyzi(:,1),xyzi(:,2),xyzi(:,3),mk_size,xyzi(:,5));
    caxis([0, maxcolorbar]);colormap(jet);colorbar;
end
if isfield(handles,'az')==1
    view([handles.az,handles.el]);
end
h=rotate3d;
set(h,'Enable','on');hold on;zlim([1, maxpage]);
if flag_on==1
    for i=1:size(xyzi,1)
        line([xyzi(i,1) xyzi(i,1)],[xyzi(i,2) xyzi(i,2)],[xyzi(i,3) xyzi(i,3)+mk_size],'Color',mk_color);hold on
    end
end
surface(ones(size(NFstk,1),size(NFstk,2)).*page_no,NFstk(:,:,page_no),'Edgecolor','none');alpha(im_alpha);hold off;
xlim([1, size(myImage,1)]);ylim([1, size(myImage,2)]);zlim([1, maxpage]);

% update handles
guidata(hObject, handles);
end

% --- Z-stack edit ----
function edit1_Callback(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


%% input popupmenu1% and 2 value
image_no= get(handles.popupmenu1,'Value');
chal_no=get(handles.popupmenu2,'Value');


%% load p.mat
NFstk = handles.NFstk;
xyzintsegdat=handles.xyzintsegdat;
chal_info=handles.chal_info;
maxpage=size(NFstk,3);


%% setup handles.slider1 and edit1 - Z-stack
page_no = round(str2double(get(handles.edit1,'String')));
set(handles.slider1,'String',num2str(page_no));
set(handles.slider1,'Value',page_no);


%% setup handles.slider3 and edit4 - 3Dlayer
max_Ip = round(get(handles.slider3,'Value'));
set(handles.slider3,'String',num2str(max_Ip));
set(handles.edit4,'String',num2str(max_Ip));
max_Ip=str2num(get(handles.edit4,'String'));
if isempty(max_Ip)==1
    max_Ip=0;
end


%% Marker properties
% Dault colorbar max value setup
maxcolorbar=256;
if max(max(max(NFstk)))>500;maxcolorbar =65535;end
maxyo=get(handles.checkbox4,'Value');
if maxyo==1
    set(handles.edit9,'Visible','Off');
    set(handles.edit9,'String','0');
elseif maxyo==0
    set(handles.edit9,'Visible','On');
    maxcolorbar_input=str2num(get(handles.edit9,'String'));
    if maxcolorbar_input~=0;maxcolorbar=maxcolorbar_input;end
end
% marker color setup
color_matrix = {'r','b','k','g'};
mk_size=str2double(get(handles.edit5,'String'));
mk_color=color_matrix{get(handles.popupmenu3,'Value')};
im_alpha=min(max(str2double(get(handles.edit7,'String')),0),1);
flag_on=get(handles.checkbox3,'Value');




%% show axes1
% data prepare
xyzi=xyzintsegdat;
xyzi=xyzi(xyzi(:,3)>=max(page_no-max_Ip,1)&xyzi(:,3)<=min(page_no+max_Ip,maxpage),:);

% axis1
[handles.az,handles.el] = view;
set(handles.axes1,'Units','pixels');
resizePos = get(handles.axes1,'Position');
myImage = NFstk(:,:,page_no);
%myImage= imresize(myImage, [resizePos(3) resizePos(3)]);
axes(handles.axes1);
if maxyo==1
    scatter3(xyzi(:,1),xyzi(:,2),xyzi(:,3),mk_size,xyzi(:,5),mk_color);
else
    scatter3(xyzi(:,1),xyzi(:,2),xyzi(:,3),mk_size,xyzi(:,5));
    caxis([0, maxcolorbar]);colormap(jet);colorbar;
end
if isfield(handles,'az')==1
    view([handles.az,handles.el]);
end
h=rotate3d;
set(h,'Enable','on');hold on;zlim([1, maxpage]);
if flag_on==1
    for i=1:size(xyzi,1)
        line([xyzi(i,1) xyzi(i,1)],[xyzi(i,2) xyzi(i,2)],[xyzi(i,3) xyzi(i,3)+mk_size],'Color',mk_color);hold on
    end
end
surface(ones(size(NFstk,1),size(NFstk,2)).*page_no,NFstk(:,:,page_no),'Edgecolor','none');alpha(im_alpha);hold off;
xlim([1, size(myImage,1)]);ylim([1, size(myImage,2)]);zlim([1, maxpage]);

% update handles
guidata(hObject, handles);
end

% --- Z-stack bar ----
function slider1_Callback(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


%% input popupmenu1% and 2 value
image_no= get(handles.popupmenu1,'Value');
chal_no=get(handles.popupmenu2,'Value');


%% load p.mat
NFstk = handles.NFstk;
xyzintsegdat=handles.xyzintsegdat;
chal_info=handles.chal_info;
maxpage=size(NFstk,3);


%% setup handles.slider1 and edit1 - Z-stack
page_no = round(get(handles.slider1,'Value'));
set(handles.slider1,'String',num2str(page_no));
set(handles.edit1,'String',num2str(page_no));


%% setup handles.slider3 and edit4 - 3Dlayer
max_Ip = round(get(handles.slider3,'Value'));
set(handles.slider3,'String',num2str(max_Ip));
set(handles.edit4,'String',num2str(max_Ip));
max_Ip=str2num(get(handles.edit4,'String'));
if isempty(max_Ip)==1
    max_Ip=0;
end


%% Marker properties
% Dault colorbar max value setup
maxcolorbar=256;
if max(max(max(NFstk)))>500;maxcolorbar =65535;end
maxyo=get(handles.checkbox4,'Value');
if maxyo==1
    set(handles.edit9,'Visible','Off');
    set(handles.edit9,'String','0');
elseif maxyo==0
    set(handles.edit9,'Visible','On');
    maxcolorbar_input=str2num(get(handles.edit9,'String'));
    if maxcolorbar_input~=0;maxcolorbar=maxcolorbar_input;end
end
% marker color setup
color_matrix = {'r','b','k','g'};
mk_size=str2double(get(handles.edit5,'String'));
mk_color=color_matrix{get(handles.popupmenu3,'Value')};
im_alpha=min(max(str2double(get(handles.edit7,'String')),0),1);
flag_on=get(handles.checkbox3,'Value');




%% show axes1
% data prepare
xyzi=xyzintsegdat;
xyzi=xyzi(xyzi(:,3)>=max(page_no-max_Ip,1)&xyzi(:,3)<=min(page_no+max_Ip,maxpage),:);

% axis1
[handles.az,handles.el] = view;
set(handles.axes1,'Units','pixels');
resizePos = get(handles.axes1,'Position');
myImage = NFstk(:,:,page_no);
%myImage= imresize(myImage, [resizePos(3) resizePos(3)]);
axes(handles.axes1);
if maxyo==1
    scatter3(xyzi(:,1),xyzi(:,2),xyzi(:,3),mk_size,xyzi(:,5),mk_color);
else
    scatter3(xyzi(:,1),xyzi(:,2),xyzi(:,3),mk_size,xyzi(:,5));
    caxis([0, maxcolorbar]);colormap(jet);colorbar;
end
if isfield(handles,'az')==1
    view([handles.az,handles.el]);
end
h=rotate3d;
set(h,'Enable','on');hold on;zlim([1, maxpage]);
if flag_on==1
    for i=1:size(xyzi,1)
        line([xyzi(i,1) xyzi(i,1)],[xyzi(i,2) xyzi(i,2)],[xyzi(i,3) xyzi(i,3)+mk_size],'Color',mk_color);hold on
    end
end
surface(ones(size(NFstk,1),size(NFstk,2)).*page_no,NFstk(:,:,page_no),'Edgecolor','none');alpha(im_alpha);hold off;
xlim([1, size(myImage,1)]);ylim([1, size(myImage,2)]);zlim([1, maxpage]);

% update handles
guidata(hObject, handles);
end

% --- 3D slide bar ----
function slider3_Callback(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


%% input popupmenu1% and 2 value
image_no= get(handles.popupmenu1,'Value');
chal_no=get(handles.popupmenu2,'Value');


%% load p.mat
NFstk = handles.NFstk;
xyzintsegdat=handles.xyzintsegdat;
chal_info=handles.chal_info;
maxpage=size(NFstk,3);


%% setup handles.slider1 and edit1 - Z-stack
page_no = round(get(handles.slider1,'Value'));
set(handles.slider1,'String',num2str(page_no));
set(handles.edit1,'String',num2str(page_no));


%% setup handles.slider3 and edit4 - 3Dlayer
max_Ip = round(get(handles.slider3,'Value'));
set(handles.slider3,'String',num2str(max_Ip));
set(handles.edit4,'String',num2str(max_Ip));
max_Ip=str2num(get(handles.edit4,'String'));
if isempty(max_Ip)==1
    max_Ip=0;
end


%% Marker properties
% Dault colorbar max value setup
maxcolorbar=256;
if max(max(max(NFstk)))>500;maxcolorbar =65535;end
maxyo=get(handles.checkbox4,'Value');
if maxyo==1
    set(handles.edit9,'Visible','Off');
    set(handles.edit9,'String','0');
elseif maxyo==0
    set(handles.edit9,'Visible','On');
    maxcolorbar_input=str2num(get(handles.edit9,'String'));
    if maxcolorbar_input~=0;maxcolorbar=maxcolorbar_input;end
end
% marker color setup
color_matrix = {'r','b','k','g'};
mk_size=str2double(get(handles.edit5,'String'));
mk_color=color_matrix{get(handles.popupmenu3,'Value')};
im_alpha=min(max(str2double(get(handles.edit7,'String')),0),1);
flag_on=get(handles.checkbox3,'Value');




%% show axes1
% data prepare
xyzi=xyzintsegdat;
xyzi=xyzi(xyzi(:,3)>=max(page_no-max_Ip,1)&xyzi(:,3)<=min(page_no+max_Ip,maxpage),:);

% axis1
[handles.az,handles.el] = view;
set(handles.axes1,'Units','pixels');
resizePos = get(handles.axes1,'Position');
myImage = NFstk(:,:,page_no);
%myImage= imresize(myImage, [resizePos(3) resizePos(3)]);
axes(handles.axes1);
if maxyo==1
    scatter3(xyzi(:,1),xyzi(:,2),xyzi(:,3),mk_size,xyzi(:,5),mk_color);
else
    scatter3(xyzi(:,1),xyzi(:,2),xyzi(:,3),mk_size,xyzi(:,5));
    caxis([0, maxcolorbar]);colormap(jet);colorbar;
end
if isfield(handles,'az')==1
    view([handles.az,handles.el]);
end
h=rotate3d;
set(h,'Enable','on');hold on;zlim([1, maxpage]);
if flag_on==1
    for i=1:size(xyzi,1)
        line([xyzi(i,1) xyzi(i,1)],[xyzi(i,2) xyzi(i,2)],[xyzi(i,3) xyzi(i,3)+mk_size],'Color',mk_color);hold on
    end
end
surface(ones(size(NFstk,1),size(NFstk,2)).*page_no,NFstk(:,:,page_no),'Edgecolor','none');alpha(im_alpha);hold off;
xlim([1, size(myImage,1)]);ylim([1, size(myImage,2)]);zlim([1, maxpage]);

% update handles
guidata(hObject, handles);
end

% --- 3D enter edit4 ----
function edit4_Callback(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


%% input popupmenu1% and 2 value
image_no= get(handles.popupmenu1,'Value');
chal_no=get(handles.popupmenu2,'Value');


%% load p.mat
NFstk = handles.NFstk;
xyzintsegdat=handles.xyzintsegdat;
chal_info=handles.chal_info;
maxpage=size(NFstk,3);


%% setup handles.slider1 and edit1 - Z-stack
page_no = round(get(handles.slider1,'Value'));
set(handles.slider1,'String',num2str(page_no));
set(handles.edit1,'String',num2str(page_no));


%% setup handles.slider3 and edit4 - 3Dlayer
max_Ip = round(str2double(get(handles.edit4,'String')));
set(handles.slider3,'String',num2str(max_Ip));
set(handles.slider3,'Value',max_Ip);
if isempty(max_Ip)==1
    max_Ip=0;
end


%% Marker properties
% Dault colorbar max value setup
maxcolorbar=256;
if max(max(max(NFstk)))>500;maxcolorbar =65535;end
maxyo=get(handles.checkbox4,'Value');
if maxyo==1
    set(handles.edit9,'Visible','Off');
    set(handles.edit9,'String','0');
elseif maxyo==0
    set(handles.edit9,'Visible','On');
    maxcolorbar_input=str2num(get(handles.edit9,'String'));
    if maxcolorbar_input~=0;maxcolorbar=maxcolorbar_input;end
end
% marker color setup
color_matrix = {'r','b','k','g'};
mk_size=str2double(get(handles.edit5,'String'));
mk_color=color_matrix{get(handles.popupmenu3,'Value')};
im_alpha=min(max(str2double(get(handles.edit7,'String')),0),1);
flag_on=get(handles.checkbox3,'Value');




%% show axes1
% data prepare
xyzi=xyzintsegdat;
xyzi=xyzi(xyzi(:,3)>=max(page_no-max_Ip,1)&xyzi(:,3)<=min(page_no+max_Ip,maxpage),:);

% axis1
[handles.az,handles.el] = view;
set(handles.axes1,'Units','pixels');
resizePos = get(handles.axes1,'Position');
myImage = NFstk(:,:,page_no);
%myImage= imresize(myImage, [resizePos(3) resizePos(3)]);
axes(handles.axes1);
if maxyo==1
    scatter3(xyzi(:,1),xyzi(:,2),xyzi(:,3),mk_size,xyzi(:,5),mk_color);
else
    scatter3(xyzi(:,1),xyzi(:,2),xyzi(:,3),mk_size,xyzi(:,5));
    caxis([0, maxcolorbar]);colormap(jet);colorbar;
end
if isfield(handles,'az')==1
    view([handles.az,handles.el]);
end
h=rotate3d;
set(h,'Enable','on');hold on;zlim([1, maxpage]);
if flag_on==1
    for i=1:size(xyzi,1)
        line([xyzi(i,1) xyzi(i,1)],[xyzi(i,2) xyzi(i,2)],[xyzi(i,3) xyzi(i,3)+mk_size],'Color',mk_color);hold on
    end
end
surface(ones(size(NFstk,1),size(NFstk,2)).*page_no,NFstk(:,:,page_no),'Edgecolor','none');alpha(im_alpha);hold off;
xlim([1, size(myImage,1)]);ylim([1, size(myImage,2)]);zlim([1, maxpage]);

% update handles
guidata(hObject, handles);
end

% --- Marker size ----
function edit5_Callback(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


%% input popupmenu1% and 2 value
image_no= get(handles.popupmenu1,'Value');
chal_no=get(handles.popupmenu2,'Value');


%% load p.mat
NFstk = handles.NFstk;
xyzintsegdat=handles.xyzintsegdat;
chal_info=handles.chal_info;
maxpage=size(NFstk,3);


%% setup handles.slider1 and edit1 - Z-stack
page_no = round(get(handles.slider1,'Value'));
set(handles.slider1,'String',num2str(page_no));
set(handles.edit1,'String',num2str(page_no));


%% setup handles.slider3 and edit4 - 3Dlayer
max_Ip = round(get(handles.slider3,'Value'));
set(handles.slider3,'String',num2str(max_Ip));
set(handles.edit4,'String',num2str(max_Ip));
max_Ip=str2num(get(handles.edit4,'String'));
if isempty(max_Ip)==1
    max_Ip=0;
end


%% Marker properties
% Dault colorbar max value setup
maxcolorbar=256;
if max(max(max(NFstk)))>500;maxcolorbar =65535;end
maxyo=get(handles.checkbox4,'Value');
if maxyo==1
    set(handles.edit9,'Visible','Off');
    set(handles.edit9,'String','0');
elseif maxyo==0
    set(handles.edit9,'Visible','On');
    maxcolorbar_input=str2num(get(handles.edit9,'String'));
    if maxcolorbar_input~=0;maxcolorbar=maxcolorbar_input;end
end
% marker color setup
color_matrix = {'r','b','k','g'};
mk_size=str2double(get(handles.edit5,'String'));
mk_color=color_matrix{get(handles.popupmenu3,'Value')};
im_alpha=min(max(str2double(get(handles.edit7,'String')),0),1);
flag_on=get(handles.checkbox3,'Value');




%% show axes1
% data prepare
xyzi=xyzintsegdat;
xyzi=xyzi(xyzi(:,3)>=max(page_no-max_Ip,1)&xyzi(:,3)<=min(page_no+max_Ip,maxpage),:);

% axis1
[handles.az,handles.el] = view;
set(handles.axes1,'Units','pixels');
resizePos = get(handles.axes1,'Position');
myImage = NFstk(:,:,page_no);
%myImage= imresize(myImage, [resizePos(3) resizePos(3)]);
axes(handles.axes1);
if maxyo==1
    scatter3(xyzi(:,1),xyzi(:,2),xyzi(:,3),mk_size,xyzi(:,5),mk_color);
else
    scatter3(xyzi(:,1),xyzi(:,2),xyzi(:,3),mk_size,xyzi(:,5));
    caxis([0, maxcolorbar]);colormap(jet);colorbar;
end
if isfield(handles,'az')==1
    view([handles.az,handles.el]);
end
h=rotate3d;
set(h,'Enable','on');hold on;zlim([1, maxpage]);
if flag_on==1
    for i=1:size(xyzi,1)
        line([xyzi(i,1) xyzi(i,1)],[xyzi(i,2) xyzi(i,2)],[xyzi(i,3) xyzi(i,3)+mk_size],'Color',mk_color);hold on
    end
end
surface(ones(size(NFstk,1),size(NFstk,2)).*page_no,NFstk(:,:,page_no),'Edgecolor','none');alpha(im_alpha);hold off;
xlim([1, size(myImage,1)]);ylim([1, size(myImage,2)]);zlim([1, maxpage]);

% update handles
guidata(hObject, handles);
end

% --- Marker color ----
function popupmenu3_Callback(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Event response
set(handles.checkbox4,'Value',1);
guidata(hObject, handles);


%% input popupmenu1% and 2 value
image_no= get(handles.popupmenu1,'Value');
chal_no=get(handles.popupmenu2,'Value');


%% load p.mat
NFstk = handles.NFstk;
xyzintsegdat=handles.xyzintsegdat;
chal_info=handles.chal_info;
maxpage=size(NFstk,3);


%% setup handles.slider1 and edit1 - Z-stack
page_no = round(get(handles.slider1,'Value'));
set(handles.slider1,'String',num2str(page_no));
set(handles.edit1,'String',num2str(page_no));


%% setup handles.slider3 and edit4 - 3Dlayer
max_Ip = round(get(handles.slider3,'Value'));
set(handles.slider3,'String',num2str(max_Ip));
set(handles.edit4,'String',num2str(max_Ip));
max_Ip=str2num(get(handles.edit4,'String'));
if isempty(max_Ip)==1
    max_Ip=0;
end


%% Marker properties
% Dault colorbar max value setup
maxcolorbar=256;
if max(max(max(NFstk)))>500;maxcolorbar =65535;end
maxyo=get(handles.checkbox4,'Value');
if maxyo==1
    set(handles.edit9,'Visible','Off');
    set(handles.edit9,'String','0');
elseif maxyo==0
    set(handles.edit9,'Visible','On');
    maxcolorbar_input=str2num(get(handles.edit9,'String'));
    if maxcolorbar_input~=0;maxcolorbar=maxcolorbar_input;end
end
% marker color setup
color_matrix = {'r','b','k','g'};
mk_size=str2double(get(handles.edit5,'String'));
mk_color=color_matrix{get(handles.popupmenu3,'Value')};
im_alpha=min(max(str2double(get(handles.edit7,'String')),0),1);
flag_on=get(handles.checkbox3,'Value');




%% show axes1
% data prepare
xyzi=xyzintsegdat;
xyzi=xyzi(xyzi(:,3)>=max(page_no-max_Ip,1)&xyzi(:,3)<=min(page_no+max_Ip,maxpage),:);

% axis1
[handles.az,handles.el] = view;
set(handles.axes1,'Units','pixels');
resizePos = get(handles.axes1,'Position');
myImage = NFstk(:,:,page_no);
%myImage= imresize(myImage, [resizePos(3) resizePos(3)]);
axes(handles.axes1);
if maxyo==1
    scatter3(xyzi(:,1),xyzi(:,2),xyzi(:,3),mk_size,xyzi(:,5),mk_color);
else
    scatter3(xyzi(:,1),xyzi(:,2),xyzi(:,3),mk_size,xyzi(:,5));
    caxis([0, maxcolorbar]);colormap(jet);colorbar;
end
if isfield(handles,'az')==1
    view([handles.az,handles.el]);
end
h=rotate3d;
set(h,'Enable','on');hold on;zlim([1, maxpage]);
if flag_on==1
    for i=1:size(xyzi,1)
        line([xyzi(i,1) xyzi(i,1)],[xyzi(i,2) xyzi(i,2)],[xyzi(i,3) xyzi(i,3)+mk_size],'Color',mk_color);hold on
    end
end
surface(ones(size(NFstk,1),size(NFstk,2)).*page_no,NFstk(:,:,page_no),'Edgecolor','none');alpha(im_alpha);hold off;
xlim([1, size(myImage,1)]);ylim([1, size(myImage,2)]);zlim([1, maxpage]);

% update handles
guidata(hObject, handles);
end

% --- Image alpha ----
function edit7_Callback(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


%% input popupmenu1% and 2 value
image_no= get(handles.popupmenu1,'Value');
chal_no=get(handles.popupmenu2,'Value');


%% load p.mat
NFstk = handles.NFstk;
xyzintsegdat=handles.xyzintsegdat;
chal_info=handles.chal_info;
maxpage=size(NFstk,3);


%% setup handles.slider1 and edit1 - Z-stack
page_no = round(get(handles.slider1,'Value'));
set(handles.slider1,'String',num2str(page_no));
set(handles.edit1,'String',num2str(page_no));


%% setup handles.slider3 and edit4 - 3Dlayer
max_Ip = round(get(handles.slider3,'Value'));
set(handles.slider3,'String',num2str(max_Ip));
set(handles.edit4,'String',num2str(max_Ip));
max_Ip=str2num(get(handles.edit4,'String'));
if isempty(max_Ip)==1
    max_Ip=0;
end


%% Marker properties
% Dault colorbar max value setup
maxcolorbar=256;
if max(max(max(NFstk)))>500;maxcolorbar =65535;end
maxyo=get(handles.checkbox4,'Value');
if maxyo==1
    set(handles.edit9,'Visible','Off');
    set(handles.edit9,'String','0');
elseif maxyo==0
    set(handles.edit9,'Visible','On');
    maxcolorbar_input=str2num(get(handles.edit9,'String'));
    if maxcolorbar_input~=0;maxcolorbar=maxcolorbar_input;end
end
% marker color setup
color_matrix = {'r','b','k','g'};
mk_size=str2double(get(handles.edit5,'String'));
mk_color=color_matrix{get(handles.popupmenu3,'Value')};
im_alpha=min(max(str2double(get(handles.edit7,'String')),0),1);
flag_on=get(handles.checkbox3,'Value');




%% show axes1
% data prepare
xyzi=xyzintsegdat;
xyzi=xyzi(xyzi(:,3)>=max(page_no-max_Ip,1)&xyzi(:,3)<=min(page_no+max_Ip,maxpage),:);

% axis1
[handles.az,handles.el] = view;
set(handles.axes1,'Units','pixels');
resizePos = get(handles.axes1,'Position');
myImage = NFstk(:,:,page_no);
%myImage= imresize(myImage, [resizePos(3) resizePos(3)]);
axes(handles.axes1);
if maxyo==1
    scatter3(xyzi(:,1),xyzi(:,2),xyzi(:,3),mk_size,xyzi(:,5),mk_color);
else
    scatter3(xyzi(:,1),xyzi(:,2),xyzi(:,3),mk_size,xyzi(:,5));
    caxis([0, maxcolorbar]);colormap(jet);colorbar;
end
if isfield(handles,'az')==1
    view([handles.az,handles.el]);
end
h=rotate3d;
set(h,'Enable','on');hold on;zlim([1, maxpage]);
if flag_on==1
    for i=1:size(xyzi,1)
        line([xyzi(i,1) xyzi(i,1)],[xyzi(i,2) xyzi(i,2)],[xyzi(i,3) xyzi(i,3)+mk_size],'Color',mk_color);hold on
    end
end
surface(ones(size(NFstk,1),size(NFstk,2)).*page_no,NFstk(:,:,page_no),'Edgecolor','none');alpha(im_alpha);hold off;
xlim([1, size(myImage,1)]);ylim([1, size(myImage,2)]);zlim([1, maxpage]);

% update handles
guidata(hObject, handles);
end

% --- Marker flag on function ----
function checkbox3_Callback(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


%% input popupmenu1% and 2 value
image_no= get(handles.popupmenu1,'Value');
chal_no=get(handles.popupmenu2,'Value');


%% load p.mat
NFstk = handles.NFstk;
xyzintsegdat=handles.xyzintsegdat;
chal_info=handles.chal_info;
maxpage=size(NFstk,3);


%% setup handles.slider1 and edit1 - Z-stack
page_no = round(get(handles.slider1,'Value'));
set(handles.slider1,'String',num2str(page_no));
set(handles.edit1,'String',num2str(page_no));


%% setup handles.slider3 and edit4 - 3Dlayer
max_Ip = round(get(handles.slider3,'Value'));
set(handles.slider3,'String',num2str(max_Ip));
set(handles.edit4,'String',num2str(max_Ip));
max_Ip=str2num(get(handles.edit4,'String'));
if isempty(max_Ip)==1
    max_Ip=0;
end


%% Marker properties
% Dault colorbar max value setup
maxcolorbar=256;
if max(max(max(NFstk)))>500;maxcolorbar =65535;end
maxyo=get(handles.checkbox4,'Value');
if maxyo==1
    set(handles.edit9,'Visible','Off');
    set(handles.edit9,'String','0');
elseif maxyo==0
    set(handles.edit9,'Visible','On');
    maxcolorbar_input=str2num(get(handles.edit9,'String'));
    if maxcolorbar_input~=0;maxcolorbar=maxcolorbar_input;end
end
% marker color setup
color_matrix = {'r','b','k','g'};
mk_size=str2double(get(handles.edit5,'String'));
mk_color=color_matrix{get(handles.popupmenu3,'Value')};
im_alpha=min(max(str2double(get(handles.edit7,'String')),0),1);
flag_on=get(handles.checkbox3,'Value');




%% show axes1
% data prepare
xyzi=xyzintsegdat;
xyzi=xyzi(xyzi(:,3)>=max(page_no-max_Ip,1)&xyzi(:,3)<=min(page_no+max_Ip,maxpage),:);

% axis1
[handles.az,handles.el] = view;
set(handles.axes1,'Units','pixels');
resizePos = get(handles.axes1,'Position');
myImage = NFstk(:,:,page_no);
%myImage= imresize(myImage, [resizePos(3) resizePos(3)]);
axes(handles.axes1);
if maxyo==1
    scatter3(xyzi(:,1),xyzi(:,2),xyzi(:,3),mk_size,xyzi(:,5),mk_color);
else
    scatter3(xyzi(:,1),xyzi(:,2),xyzi(:,3),mk_size,xyzi(:,5));
    caxis([0, maxcolorbar]);colormap(jet);colorbar;
end
if isfield(handles,'az')==1
    view([handles.az,handles.el]);
end
h=rotate3d;
set(h,'Enable','on');hold on;zlim([1, maxpage]);
if flag_on==1
    for i=1:size(xyzi,1)
        line([xyzi(i,1) xyzi(i,1)],[xyzi(i,2) xyzi(i,2)],[xyzi(i,3) xyzi(i,3)+mk_size],'Color',mk_color);hold on
    end
end
surface(ones(size(NFstk,1),size(NFstk,2)).*page_no,NFstk(:,:,page_no),'Edgecolor','none');alpha(im_alpha);hold off;
xlim([1, size(myImage,1)]);ylim([1, size(myImage,2)]);zlim([1, maxpage]);

% update handles
guidata(hObject, handles);
end

% --- Choice to use colorbar color or marker color ----
function checkbox4_Callback(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


%% input popupmenu1% and 2 value
image_no= get(handles.popupmenu1,'Value');
chal_no=get(handles.popupmenu2,'Value');


%% load p.mat
NFstk = handles.NFstk;
xyzintsegdat=handles.xyzintsegdat;
chal_info=handles.chal_info;
maxpage=size(NFstk,3);


%% setup handles.slider1 and edit1 - Z-stack
page_no = round(get(handles.slider1,'Value'));
set(handles.slider1,'String',num2str(page_no));
set(handles.edit1,'String',num2str(page_no));


%% setup handles.slider3 and edit4 - 3Dlayer
max_Ip = round(get(handles.slider3,'Value'));
set(handles.slider3,'String',num2str(max_Ip));
set(handles.edit4,'String',num2str(max_Ip));
max_Ip=str2num(get(handles.edit4,'String'));
if isempty(max_Ip)==1
    max_Ip=0;
end


%% Marker properties
% Dault colorbar max value setup
maxcolorbar=256;
if max(max(max(NFstk)))>500;maxcolorbar =65535;end
maxyo=get(handles.checkbox4,'Value');
if maxyo==1
    set(handles.edit9,'Visible','Off');
    set(handles.edit9,'String','0');
elseif maxyo==0
    set(handles.edit9,'Visible','On');
    maxcolorbar_input=str2num(get(handles.edit9,'String'));
    if maxcolorbar_input~=0;maxcolorbar=maxcolorbar_input;end
end
% marker color setup
color_matrix = {'r','b','k','g'};
mk_size=str2double(get(handles.edit5,'String'));
mk_color=color_matrix{get(handles.popupmenu3,'Value')};
im_alpha=min(max(str2double(get(handles.edit7,'String')),0),1);
flag_on=get(handles.checkbox3,'Value');




%% show axes1
% data prepare
xyzi=xyzintsegdat;
xyzi=xyzi(xyzi(:,3)>=max(page_no-max_Ip,1)&xyzi(:,3)<=min(page_no+max_Ip,maxpage),:);

% axis1
[handles.az,handles.el] = view;
set(handles.axes1,'Units','pixels');
resizePos = get(handles.axes1,'Position');
myImage = NFstk(:,:,page_no);
%myImage= imresize(myImage, [resizePos(3) resizePos(3)]);
axes(handles.axes1);
if maxyo==1
    scatter3(xyzi(:,1),xyzi(:,2),xyzi(:,3),mk_size,xyzi(:,5),mk_color);
else
    scatter3(xyzi(:,1),xyzi(:,2),xyzi(:,3),mk_size,xyzi(:,5));
    caxis([0, maxcolorbar]);colormap(jet);colorbar;
end
if isfield(handles,'az')==1
    view([handles.az,handles.el]);
end
h=rotate3d;
set(h,'Enable','on');hold on;zlim([1, maxpage]);
if flag_on==1
    for i=1:size(xyzi,1)
        line([xyzi(i,1) xyzi(i,1)],[xyzi(i,2) xyzi(i,2)],[xyzi(i,3) xyzi(i,3)+mk_size],'Color',mk_color);hold on
    end
end
surface(ones(size(NFstk,1),size(NFstk,2)).*page_no,NFstk(:,:,page_no),'Edgecolor','none');alpha(im_alpha);hold off;
xlim([1, size(myImage,1)]);ylim([1, size(myImage,2)]);zlim([1, maxpage]);

% update handles
guidata(hObject, handles);
end

% --- input colorbar max value ----
function edit9_Callback(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


%% input popupmenu1% and 2 value
image_no= get(handles.popupmenu1,'Value');
chal_no=get(handles.popupmenu2,'Value');


%% load p.mat
NFstk = handles.NFstk;
xyzintsegdat=handles.xyzintsegdat;
chal_info=handles.chal_info;
maxpage=size(NFstk,3);


%% setup handles.slider1 and edit1 - Z-stack
page_no = round(get(handles.slider1,'Value'));
set(handles.slider1,'String',num2str(page_no));
set(handles.edit1,'String',num2str(page_no));


%% setup handles.slider3 and edit4 - 3Dlayer
max_Ip = round(get(handles.slider3,'Value'));
set(handles.slider3,'String',num2str(max_Ip));
set(handles.edit4,'String',num2str(max_Ip));
max_Ip=str2num(get(handles.edit4,'String'));
if isempty(max_Ip)==1
    max_Ip=0;
end


%% Marker properties
% Dault colorbar max value setup
maxcolorbar=256;
if max(max(max(NFstk)))>500;maxcolorbar =65535;end
maxyo=get(handles.checkbox4,'Value');
if maxyo==1
    set(handles.edit9,'Visible','Off');
    set(handles.edit9,'String','0');
elseif maxyo==0
    set(handles.edit9,'Visible','On');
    maxcolorbar_input=str2num(get(handles.edit9,'String'));
    if maxcolorbar_input~=0;maxcolorbar=maxcolorbar_input;end
end
% marker color setup
color_matrix = {'r','b','k','g'};
mk_size=str2double(get(handles.edit5,'String'));
mk_color=color_matrix{get(handles.popupmenu3,'Value')};
im_alpha=min(max(str2double(get(handles.edit7,'String')),0),1);
flag_on=get(handles.checkbox3,'Value');




%% show axes1
% data prepare
xyzi=xyzintsegdat;
xyzi=xyzi(xyzi(:,3)>=max(page_no-max_Ip,1)&xyzi(:,3)<=min(page_no+max_Ip,maxpage),:);

% axis1
[handles.az,handles.el] = view;
set(handles.axes1,'Units','pixels');
resizePos = get(handles.axes1,'Position');
myImage = NFstk(:,:,page_no);
%myImage= imresize(myImage, [resizePos(3) resizePos(3)]);
axes(handles.axes1);
if maxyo==1
    scatter3(xyzi(:,1),xyzi(:,2),xyzi(:,3),mk_size,xyzi(:,5),mk_color);
else
    scatter3(xyzi(:,1),xyzi(:,2),xyzi(:,3),mk_size,xyzi(:,5));
    caxis([0, maxcolorbar]);colormap(jet);colorbar;
end
if isfield(handles,'az')==1
    view([handles.az,handles.el]);
end
h=rotate3d;
set(h,'Enable','on');hold on;zlim([1, maxpage]);
if flag_on==1
    for i=1:size(xyzi,1)
        line([xyzi(i,1) xyzi(i,1)],[xyzi(i,2) xyzi(i,2)],[xyzi(i,3) xyzi(i,3)+mk_size],'Color',mk_color);hold on
    end
end
surface(ones(size(NFstk,1),size(NFstk,2)).*page_no,NFstk(:,:,page_no),'Edgecolor','none');alpha(im_alpha);hold off;
xlim([1, size(myImage,1)]);ylim([1, size(myImage,2)]);zlim([1, maxpage]);

% update handles
guidata(hObject, handles);
end

% --- Close Raw_image GUI function ----
function figure1_CloseRequestFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%handles=rmfield(handles,'NFstk');
%handles=rmfield(handles,'xyzintsegdat');
guidata(hObject, handles);
% Hint: delete(hObject) closes the figure
delete(hObject);
end








% -------------------------------------------------------------

% --- Outputs from this function are returned to the command line.
function varargout = Raw_image3D_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;
end

% --- Executes during object creation, after setting all properties.
function popupmenu1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
end

% --- Executes during object creation, after setting all properties.
function slider1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end
end

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
end

% --- Executes during object creation, after setting all properties.
function popupmenu2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
end

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
end

% --- Executes during object creation, after setting all properties.
function edit3_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
end

% --- Executes during object creation, after setting all properties.
function slider3_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end
end

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
end

% --- Executes during object creation, after setting all properties.
function edit5_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
end

% --- Executes during object creation, after setting all properties.
function edit6_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
end


% --- Executes during object creation, after setting all properties.
function edit7_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
end

% --- Executes during object creation, after setting all properties.
function popupmenu3_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
end

% --- Executes during object creation, after setting all properties.
function edit9_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit9 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
end

% --- Executes during object creation, after setting all properties.
function edit10_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit10 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
end
