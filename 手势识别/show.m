function varargout = show(varargin)
% SHOW MATLAB code for show.fig
%      SHOW, by itself, creates a new SHOW or raises the existing
%      singleton*.
%
%      H = SHOW returns the handle to a new SHOW or the handle to
%      the existing singleton*.
%
%      SHOW('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in SHOW.M with the given input arguments.
%
%      SHOW('Property','Value',...) creates a new SHOW or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before show_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to show_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help show

% Last Modified by GUIDE v2.5 03-Jan-2018 20:17:07

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @show_OpeningFcn, ...
                   'gui_OutputFcn',  @show_OutputFcn, ...
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


% --- Executes just before show is made visible.
function show_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to show (see VARARGIN)

% Choose default command line output for show
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes show wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = show_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in button_start.
function button_start_Callback(hObject, eventdata, handles)
% hObject    handle to button_start (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

%1.Get the hardware information //获取硬件信息
global obj;%obj在其他地方要调用，所以设为全局变量
info=imaqhwinfo('winvideo');%获得摄像头硬件信息
obj=videoinput('winvideo',info.DeviceIDs{1});%创建视频对象
set(obj,'FramesPerTrigger',1);%每次触发存储一张相片
set(obj,'ReturnedColorSpace','RGB');%接收图像为RGB模式

%get(obj)%获取obj信息，查看设置是否成功，最后注释掉
axes(handles.axes1);

%2.show the video //动态显示视频图像
Resolution=get(obj,'videoResolution');%分辨率
nBands=get(obj,'NumberOfBands');%频段
hImage=image(zeros(Resolution(2),Resolution(1),nBands));
preview(obj,hImage);%在特定的位置（hImage）显示

% --- Executes on button press in button_catch.
function button_catch_Callback(hObject, eventdata, handles)
% hObject    handle to button_catch (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global obj;
catch_pic=getsnapshot(obj);%摄取图像
catch_pic=imresize(catch_pic,[240, 320]);  %统一图片大小
axes(handles.axes2);
imshow(catch_pic);%在axes2显示摄取的图片
setappdata(gcf,'pic',catch_pic);%把catch_pic变成全局变量

% --- Executes on button press in button_cut.
function button_cut_Callback(hObject, eventdata, handles)
% hObject    handle to button_cut (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
pic = getappdata(gcf,'pic'); %获取全局变量
l = get(handles.popupmenu_choose,'value'); %获取下拉菜单选中项
if l==1  %基于阈值分割（尤其适用于纯背景）
    graypic = rgb2gray(pic); %灰度图像
%     graypic = localenhance(graypic); %局部增强
%     figure,imshow(graypic);
    pic_filt=medfilt2(graypic,[3 3]); %3*3中值滤波
    axes(handles.axes3);imshow(pic_filt);
    pause(1);%延迟1s
    pic_cut = threshold_cut(pic_filt);
end
if l==2  %基于YCgCr肤色分割（适用于较复杂背景）
    pic_cut = colour_cut(pic);
end
axes(handles.axes3);
imshow(pic_cut);
setappdata(gcf,'pic_cut',pic_cut);%把catch_pic变成全局变量

% --- Executes on selection change in popupmenu_choose.
function popupmenu_choose_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu_choose (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu_choose contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu_choose


% --- Executes during object creation, after setting all properties.
function popupmenu_choose_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu_choose (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton_open.
function pushbutton_open_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_open (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[filename, pathname] = uigetfile( ...
{'*.bmp;*.jpg;*.fig;*.tif','MATLAB Files (*.bmp;*.jpg;*.fig;*.tif)';
   '*.*',  'All Files (*.*)'}, ...
   'Pick a file');
pic=imread([pathname,filename]);%读取图片给im
pic=imresize(pic,[240, 320]);  %统一图片大小
axes(handles.axes2);
imshow(pic);%在axes2显示摄取的图片
setappdata(gcf,'pic',pic);%把pic变成全局变量


% --- Executes on button press in pushbutton_denoise.
function pushbutton_denoise_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_denoise (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
pic_cut = getappdata(gcf,'pic_cut'); %获取全局变量
pic_denoise = denoise(pic_cut);
axes(handles.axes4);
imshow(pic_denoise);
setappdata(gcf,'pic_denoise',pic_denoise);%把pic变成全局变量

% --- Executes on selection change in popupmenu_operator.
function popupmenu_operator_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu_operator (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu_operator contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu_operator


% --- Executes during object creation, after setting all properties.
function popupmenu_operator_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu_operator (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton_edge.
function pushbutton_edge_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_edge (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%轮廓图像
pic = getappdata(gcf,'pic_denoise'); %获取全局变量
l = get(handles.popupmenu_operator,'value'); %获取下拉菜单选中项
if l == 1  %Sobel算子
    pic_edge = edge(pic,'sobel');
end
if l == 2 %Prewitt算子
    pic_edge = edge(pic,'prewitt');
end
if l == 3 %Roberts算子
    pic_edge = edge(pic,'roberts');
end
if l == 4 %log算子
    pic_edge = edge(pic,'log');
end
if l == 5 %Canny算子
    se=fspecial('gaussian',5); %高斯滤波
    pic=imfilter(pic,se);
    pic_edge = edge(pic,'canny');
end
[r c]=find(pic_edge==1);  
% 'a'是按面积算的最小矩形，如果按边长用'p'  
[rectx,recty,area,perimeter] = minboundrect(c,r,'p');   
axes(handles.axes5);
imshow(pic_edge);
hold on  
line(rectx,recty); 
setappdata(gcf,'pic_edge',pic_edge);%把pic_edge变成全局变量

% --- Executes on button press in pushbutton_feature.
function pushbutton_feature_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_feature (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
pic = getappdata(gcf,'pic_edge'); %获取全局变量
feature=fourierdescriptors(pic); %对轮廓图提取傅里叶描述子2-8共7个系数
Hu = Humoment(pic); %对轮廓图像提取Hu矩特征
fdedit = ['傅里叶描述子：',10];
huedit = [10,'Hu矩特征：',10];
for i = 1:7
    fdedit = [fdedit,[num2str(feature(i)),10]];
    huedit = [huedit,[num2str(Hu(i)),10]];
end
set(handles.edit_feature,'string',strcat(fdedit,huedit));
Allfeature = [feature,Hu];
setappdata(gcf,'feature',Allfeature);

% --- Executes on button press in pushbutton_result.
function pushbutton_result_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_result (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
feature = getappdata(gcf,'feature');
if isempty(feature)
    msgbox('请先提取手势图像特征值！', '提示');
else
    flag = exist('data.mat','file'); %判断文件是否存在
    if flag == 0 %文件不存在
        msgbox('未找到手势模板特征库！', '提示');
    else
        all = load('data.mat'); %加载mat文件
        names = fieldnames(all); % 获取mat中所有变量的名字
        data = all.(names{1}); %把第一个变量赋给before
        [row,col] = size(data);
        results = zeros(row,2);
        for i = 1:row;
            results(i,1) = ModHausdorffDist(feature,data(i,1:col-1));
            results(i,2) = data(i,col);
        end
    end
    [m,row] = min(results,[],1);
    result = results(row(1,1),2);
    %disp(result);
    %result = 8;
    set(handles.edit_result,'string',num2str(result));
    data = [feature,result];
    setappdata(gcf,'data',data);
end

function edit_result_Callback(hObject, eventdata, handles)
% hObject    handle to edit_result (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_result as text
%        str2double(get(hObject,'String')) returns contents of edit_result as a double


% --- Executes during object creation, after setting all properties.
function edit_result_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_result (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_feature_Callback(hObject, eventdata, handles)
% hObject    handle to edit_feature (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_feature as text
%        str2double(get(hObject,'String')) returns contents of edit_feature as a double


% --- Executes during object creation, after setting all properties.
function edit_feature_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_feature (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton_add.
function pushbutton_add_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_add (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
data = getappdata(gcf,'data');
if isempty(data)
    msgbox('请先进行提取特征值，并进行手势识别后，再添加模板库！', '提示');
else
    flag = exist('data.mat','file'); %判断文件是否存在
    if flag == 0 %文件不存在
        save data data; %保存mat文件
    else
        all = load('data.mat'); %加载mat文件
        names = fieldnames(all); % 获取mat中所有变量的名字
        before = all.(names{1}); %把第一个变量赋给before
        data = [before;data]; %追加数据
        save data data; %重新存储
    end
end