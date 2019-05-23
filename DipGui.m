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

%����һ�δ���Ľ��ͼ����Ϊ��ǰͼƬ��չʾ�� axes1
if handles.isProcessed == 1
    cntImg = handles.resultImg;
else
    cntImg = handles.cntImg;
end
axes(handles.axes1)
imshow(cntImg)
%�� axes3 �ϵ�ͼ�����
axes(handles.axes3)
cla

%�˲���
%��ֵ�˲�
if get(findobj('tag','medfilt'),'Value') == 1
    resultImg = medfilt2(cntImg);
end
%��ֵ�˲�
if get(findobj('tag','avgfilt'),'Value') == 1
    h = fspecial('average',[3 3]);
    resultImg = imfilter(cntImg,h);
end
%��˹�˲�
if get(findobj('tag','gaussfilt'),'Value') == 1
    hsigma = findobj('tag','editFiltSigma');
    sigma = str2double(get(hsigma,'String'));
    resultImg = imgaussfilt(cntImg,sigma);
end
%�� axes2 ����ʾ�˲����
axes(handles.axes2)
imshow(resultImg)

%����3��axes�µ�text
ht1 = findobj('tag','textAxes1');
set(ht1,'String','��ǰͼ��')
ht2 = findobj('tag','textAxes2');
set(ht2,'String','�˲����ͼ��')
ht3 = findobj('tag','textAxes3');
set(ht3,'String','Axes3')

%����
handles.isProcessed = 1;
handles.cntImg = cntImg;
handles.resultImg = resultImg;
guidata(gcf,handles);

% --- Executes on button press in imgread.
function imgread_Callback(hObject, eventdata, handles)
% hObject    handle to imgread (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

%����ͼ��,תΪ�Ҷ�ͼ,��������Ϊ��ǰͼ��
[filename,pathname]=uigetfile({'*.jpg;*.bmp;*.tif;*.png;*.gif',...
    'All Image Files';'*.*','All Files'});
originalImg = imread([pathname,filename]);
if length(size(originalImg)) == 3
    originalImg = rgb2gray(originalImg);
end
cntImg = originalImg;
%�ѵ�ǰ�� axes ��Ϊ axes1,��ͼ
axes(handles.axes1)
imshow(cntImg)
%�� axes2 �� axes3 ���
axes(handles.axes2);cla;
axes(handles.axes3);cla;
%�ѵ�ǰ��3��axes�µ�text��ʼ��
ht1 = findobj('tag','textAxes1');
set(ht1,'String','��ǰͼ��')
ht2 = findobj('tag','textAxes2');
set(ht2,'String','Axes2')
ht3 = findobj('tag','textAxes3');
set(ht3,'String','Axes3')
%����
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

%����һ�δ���Ľ��ͼ����Ϊ��ǰͼƬ��չʾ�� axes1
if handles.isProcessed == 1
    cntImg = handles.resultImg;
else
    cntImg = handles.cntImg;
end
axes(handles.axes1)
imshow(cntImg)

%����ѡȡ���������������Ҳ���Ǽ����ݶ�,�������չʾ�� axes2
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

%��ȡ��ϵ��
hc = findobj('tag','editC');
c = str2double(get(hc,'String'));

%ͼ���ȥ��c * ���ͼ�񣩣��͵õ��񻯺��ͼ��,չʾ�� axes3
resultImg = imsubtract(cntImg,c*convImg);
axes(handles.axes3)
imshow(resultImg)

%����3��axes�µ�text
ht1 = findobj('tag','textAxes1');
set(ht1,'String','��ǰͼ��')
ht2 = findobj('tag','textAxes2');
set(ht2,'String','�������ú�����ͼ��')
ht3 = findobj('tag','textAxes3');
set(ht3,'String','�񻯺��ͼ��')

%����
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

%�ⲿ������ȡͼ���Ե��
%����һ�δ���Ľ��ͼ����Ϊ��ǰͼƬ��չʾ�� axes1
if handles.isProcessed == 1
    cntImg = handles.resultImg;
else
    cntImg = handles.cntImg;
end
axes(handles.axes1)
imshow(cntImg)
%�� axes3 �ϵ�ͼ�����
axes(handles.axes3)
cla

%����edge�������õ���Ե��չʾ�� axes2:
%���ȿ��Ƿ�ʹ���û��Լ����õĲ�����
useDefaultPara = 1;
if get(findobj('tag','checkparabox'),'Value') == 1
    useDefaultPara = 0;
end
%�����û�ѡ��ķ�������ȡ��Ե
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
%����ȡ���ı�Եչʾ�� axes2
axes(handles.axes2)
imshow(resultImg)
%����3��axes�µ�text
ht1 = findobj('tag','textAxes1');
set(ht1,'String','��ǰͼ��')
ht2 = findobj('tag','textAxes2');
set(ht2,'String','��ȡ�ı�Ե')
ht3 = findobj('tag','textAxes3');
set(ht3,'String','Axes3')

%����
%���ﲻ��Ϊ��ȡ��Ե�Ƕ�ͼ��Ĵ�����Ϊͼ����û�иı䣩
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

%���û����������ť�����ʼ��ԭʼͼ��ȡ������Ϊ��ǰͼ��,չʾ�� axes1

%��ԭͼ���� axes1
axes(handles.axes1)
imshow(handles.originalImg)
%��� axes2 �� axes3
axes(handles.axes2)
cla
axes(handles.axes3)
cla
%����3��axes�µ�text
ht1 = findobj('tag','textAxes1');
set(ht1,'String','��ǰͼ��')
ht2 = findobj('tag','textAxes2');
set(ht2,'String','Axes2')
ht3 = findobj('tag','textAxes3');
set(ht3,'String','Axes3')
%�������ø�����������
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

%�رյ�ǰfigure����
close gcf
