function varargout = DipGui(varargin)
% DIPGUI MATLAB code for DipGui.fig
%      DIPGUI, by itself, creates a new DIPGUI or raises the existing
%      singleton*.
%
%      H = DIPGUI returns the handle to a new DIPGUI or the handle to
%      the existing singleton*.
%
%      DIPGUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in DIPGUI.M with the given input arguments.
%
%      DIPGUI('Property','Value',...) creates a new DIPGUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before DipGui_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to DipGui_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help DipGui

% Last Modified by GUIDE v2.5 21-May-2019 23:24:09

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @DipGui_OpeningFcn, ...
                   'gui_OutputFcn',  @DipGui_OutputFcn, ...
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


% --- Executes just before DipGui is made visible.
function DipGui_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to DipGui (see VARARGIN)

% Choose default command line output for DipGui
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes DipGui wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = DipGui_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in filter.
function filter_Callback(hObject, eventdata, handles)
% hObject    handle to filter (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

%把上一次处理的结果图设置为当前图片，展示在 axes1
if handles.isProcessed == 1
    cntImg = handles.resultImg;
else
    cntImg = handles.cntImg;
end
axes(handles.axes1)
imshow(cntImg)
%把 axes3 上的图像清空
axes(handles.axes3)
cla

%滤波：
%中值滤波
if get(findobj('tag','medfilt'),'Value') == 1
    resultImg = medfilt2(cntImg);
end
%均值滤波
if get(findobj('tag','avgfilt'),'Value') == 1
    h = fspecial('average',[3 3]);
    resultImg = imfilter(cntImg,h);
end
%高斯滤波
if get(findobj('tag','gaussfilt'),'Value') == 1
    hsigma = findobj('tag','editFiltSigma');
    sigma = str2double(get(hsigma,'String'));
    resultImg = imgaussfilt(cntImg,sigma);
end
%在 axes2 上显示滤波结果
axes(handles.axes2)
imshow(resultImg)

%设置3个axes下的text
ht1 = findobj('tag','textAxes1');
set(ht1,'String','当前图像')
ht2 = findobj('tag','textAxes2');
set(ht2,'String','滤波后的图像')
ht3 = findobj('tag','textAxes3');
set(ht3,'String','Axes3')

%保存
handles.isProcessed = 1;
handles.cntImg = cntImg;
handles.resultImg = resultImg;
guidata(gcf,handles);

% --- Executes on button press in imgread.
function imgread_Callback(hObject, eventdata, handles)
% hObject    handle to imgread (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

%读入图像,转为灰度图,并设置它为当前图像
[filename,pathname]=uigetfile({'*.jpg;*.bmp;*.tif;*.png;*.gif',...
    'All Image Files';'*.*','All Files'});
originalImg = imread([pathname,filename]);
if length(size(originalImg)) == 3
    originalImg = rgb2gray(originalImg);
end
cntImg = originalImg;
%把当前的 axes 设为 axes1,画图
axes(handles.axes1)
imshow(cntImg)
%把 axes2 和 axes3 清空
axes(handles.axes2);cla;
axes(handles.axes3);cla;
%把当前的3个axes下的text初始化
ht1 = findobj('tag','textAxes1');
set(ht1,'String','当前图像')
ht2 = findobj('tag','textAxes2');
set(ht2,'String','Axes2')
ht3 = findobj('tag','textAxes3');
set(ht3,'String','Axes3')
%保存
handles.originalImg = originalImg;
handles.cntImg = cntImg;
handles.isProcessed = 0;
guidata(gcf,handles)



function editFiltSigma_Callback(hObject, eventdata, handles)
% hObject    handle to editFiltSigma (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of editFiltSigma as text
%        str2double(get(hObject,'String')) returns contents of editFiltSigma as a double


% --- Executes during object creation, after setting all properties.
function editFiltSigma_CreateFcn(hObject, eventdata, handles)
% hObject    handle to editFiltSigma (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in medfilt.
function medfilt_Callback(hObject, eventdata, handles)
% hObject    handle to medfilt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of medfilt


% --- Executes on button press in avgfilt.
function avgfilt_Callback(hObject, eventdata, handles)
% hObject    handle to avgfilt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of avgfilt



function editC_Callback(hObject, eventdata, handles)
% hObject    handle to editC (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of editC as text
%        str2double(get(hObject,'String')) returns contents of editC as a double


% --- Executes during object creation, after setting all properties.
function editC_CreateFcn(hObject, eventdata, handles)
% hObject    handle to editC (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in sharpen.
function sharpen_Callback(hObject, eventdata, handles)
% hObject    handle to sharpen (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

%把上一次处理的结果图设置为当前图片，展示在 axes1
if handles.isProcessed == 1
    cntImg = handles.resultImg;
else
    cntImg = handles.cntImg;
end
axes(handles.axes1)
imshow(cntImg)

%利用选取的算子来做卷积，也就是计算梯度,并将结果展示在 axes2
if get(findobj('tag','laplacianSharpen'),'Value') == 1
    h = fspecial('laplacian',0);
end
if get(findobj('tag','sobelSharpen'),'Value') == 1
    h = fspecial('sobel');
end
if get(findobj('tag','prewittSharpen'),'Value') == 1
    h = fspecial('prewitt');
end
convImg = imfilter(handles.cntImg,h,'replicate','conv');
axes(handles.axes2)
imshow(convImg)

%获取锐化系数
hc = findobj('tag','editC');
c = str2double(get(hc,'String'));

%图像减去（c * 锐度图像），就得到锐化后的图像,展示在 axes3
resultImg = imsubtract(cntImg,c*convImg);
axes(handles.axes3)
imshow(resultImg)

%设置3个axes下的text
ht1 = findobj('tag','textAxes1');
set(ht1,'String','当前图像')
ht2 = findobj('tag','textAxes2');
set(ht2,'String','算子作用后的锐度图像')
ht3 = findobj('tag','textAxes3');
set(ht3,'String','锐化后的图像')

%保存
handles.isProcessed = 1;
handles.cntImg = cntImg;
handles.resultImg = resultImg;
guidata(gcf,handles);


% --- Executes on button press in checkparabox.
function checkparabox_Callback(hObject, eventdata, handles)
% hObject    handle to checkparabox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkparabox


% --- Executes on button press in edge.
function edge_Callback(hObject, eventdata, handles)
% hObject    handle to edge (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

%这部分来提取图像边缘：
%把上一次处理的结果图设置为当前图片，展示在 axes1
if handles.isProcessed == 1
    cntImg = handles.resultImg;
else
    cntImg = handles.cntImg;
end
axes(handles.axes1)
imshow(cntImg)
%把 axes3 上的图像清空
axes(handles.axes3)
cla

%调用edge函数来得到边缘，展示在 axes2:
%首先看是否使用用户自己设置的参数：
useDefaultPara = 1;
if get(findobj('tag','checkparabox'),'Value') == 1
    useDefaultPara = 0;
end
%根据用户选择的方法来提取边缘
%Sobel
if get(findobj('tag','sobelEdge'),'Value') == 1
    if useDefaultPara == 1
        resultImg = edge(cntImg,'Sobel');
    else
        h_th = findobj('tag','editSobelThreshold');
        threshold = str2double(get(h_th,'String'));
        resultImg = edge(cntImg,'Sobel',threshold);
    end
end
%LoG
if get(findobj('tag','logEdge'),'Value') == 1
    if useDefaultPara == 1
        resultImg = edge(cntImg,'log');
    else
        h_th2 = findobj('tag','editEdgeThreshold');
        threshold = str2double(get(h_th2,'String'));
        hsigma = findobj('tag','editEdgeSigma');
        sigma = str2double(get(hsigma,'String'));
        resultImg = edge(cntImg,'log',threshold,sigma);
    end
end
%Canny
if get(findobj('tag','cannyEdge'),'Value') == 1
    if useDefaultPara == 1
        resultImg = edge(cntImg,'Canny');
    else
        h_th2 = findobj('tag','editEdgeThreshold');
        threshold = str2double(get(h_th2,'String'));
        hsigma = findobj('tag','editEdgeSigma');
        sigma = str2double(get(hsigma,'String'));
        resultImg = edge(cntImg,'Canny',threshold,sigma);
    end
end
%把提取到的边缘展示在 axes2
axes(handles.axes2)
imshow(resultImg)
%设置3个axes下的text
ht1 = findobj('tag','textAxes1');
set(ht1,'String','当前图像')
ht2 = findobj('tag','textAxes2');
set(ht2,'String','提取的边缘')
ht3 = findobj('tag','textAxes3');
set(ht3,'String','Axes3')

%保存
%这里不认为提取边缘是对图像的处理（因为图像本身没有改变）
handles.isProcessed = 0;  
handles.cntImg = cntImg;
handles.resultImg = resultImg;
guidata(gcf,handles);


% --- Executes on button press in sobelEdge.
function sobelEdge_Callback(hObject, eventdata, handles)
% hObject    handle to sobelEdge (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of sobelEdge


% --- Executes on button press in logEdge.
function logEdge_Callback(hObject, eventdata, handles)
% hObject    handle to logEdge (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of logEdge



function editSobelThreshold_Callback(hObject, eventdata, handles)
% hObject    handle to editSobelThreshold (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of editSobelThreshold as text
%        str2double(get(hObject,'String')) returns contents of editSobelThreshold as a double


% --- Executes during object creation, after setting all properties.
function editSobelThreshold_CreateFcn(hObject, eventdata, handles)
% hObject    handle to editSobelThreshold (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function editEdgeThreshold_Callback(hObject, eventdata, handles)
% hObject    handle to editEdgeThreshold (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of editEdgeThreshold as text
%        str2double(get(hObject,'String')) returns contents of editEdgeThreshold as a double


% --- Executes during object creation, after setting all properties.
function editEdgeThreshold_CreateFcn(hObject, eventdata, handles)
% hObject    handle to editEdgeThreshold (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function editEdgeSigma_Callback(hObject, eventdata, handles)
% hObject    handle to editEdgeSigma (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of editEdgeSigma as text
%        str2double(get(hObject,'String')) returns contents of editEdgeSigma as a double


% --- Executes during object creation, after setting all properties.
function editEdgeSigma_CreateFcn(hObject, eventdata, handles)
% hObject    handle to editEdgeSigma (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in backtoOriginalImg.
function backtoOriginalImg_Callback(hObject, eventdata, handles)
% hObject    handle to backtoOriginalImg (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

%当用户按下这个按钮，把最开始的原始图像取出，设为当前图像,展示在 axes1

%把原图绘在 axes1
axes(handles.axes1)
imshow(handles.originalImg)
%清空 axes2 和 axes3
axes(handles.axes2)
cla
axes(handles.axes3)
cla
%设置3个axes下的text
ht1 = findobj('tag','textAxes1');
set(ht1,'String','当前图像')
ht2 = findobj('tag','textAxes2');
set(ht2,'String','Axes2')
ht3 = findobj('tag','textAxes3');
set(ht3,'String','Axes3')
%重新设置各变量并保存
handles.cntImg = handles.originalImg;
handles.isProcessed = 0;
guidata(gcf,handles);


% --- Executes on button press in saveImg.
function saveImg_Callback(hObject, eventdata, handles)
% hObject    handle to saveImg (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

selpath = uigetdir;
imwrite(handles.resultImg,[selpath,'\','DipResult.jpg'])


% --- If Enable == 'on', executes on mouse press in 5 pixel border.
% --- Otherwise, executes on mouse press in 5 pixel border or over saveImg.
function saveImg_ButtonDownFcn(hObject, eventdata, handles)
% hObject    handle to saveImg (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- If Enable == 'on', executes on mouse press in 5 pixel border.
% --- Otherwise, executes on mouse press in 5 pixel border or over imgread.
function imgread_ButtonDownFcn(hObject, eventdata, handles)
% hObject    handle to imgread (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in close.
function close_Callback(hObject, eventdata, handles)
% hObject    handle to close (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

%关闭当前figure即可
close gcf
