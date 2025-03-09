function varargout = GUI_PPG_label(varargin)
% GUI_PPG_LABEL MATLAB code for GUI_PPG_label.fig
%      GUI_PPG_LABEL, by itself, creates a new GUI_PPG_LABEL or raises the existing
%      singleton*.
%
%      H = GUI_PPG_LABEL returns the handle to a new GUI_PPG_LABEL or the handle to
%      the existing singleton*.
%
%      GUI_PPG_LABEL('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in GUI_PPG_LABEL.M with the given input arguments.
%
%      GUI_PPG_LABEL('Property','Value',...) creates a new GUI_PPG_LABEL or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before GUI_PPG_label_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to GUI_PPG_label_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help GUI_PPG_label

% Last Modified by GUIDE v2.5 03-Feb-2025 20:18:12

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @GUI_PPG_label_OpeningFcn, ...
                   'gui_OutputFcn',  @GUI_PPG_label_OutputFcn, ...
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


% --- Executes just before GUI_PPG_label is made visible.
function GUI_PPG_label_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to GUI_PPG_label (see VARARGIN)

% Choose default command line output for GUI_PPG_label
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes GUI_PPG_label wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = GUI_PPG_label_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on selection change in listbox1.
function listbox1_Callback(hObject, eventdata, handles)
% hObject    handle to listbox1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns listbox1 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from listbox1
pushbutton_plot_Callback(hObject, eventdata, handles)

handles.radiobutton_SR.Value = 0;
handles.radiobutton_Ect.Value = 0;
handles.radiobutton_Noise.Value = 0;
handles.radiobutton_PAC.Value = 0;
handles.radiobutton_PVC.Value = 0;
handles.radiobutton_VT.Value = 0;
handles.radiobutton_und.Value = 0;


switch handles.data.Tab.ECGcat(handles.listbox1.Value)
    case "NORM"
    handles.radiobutton_SR.Value = 1;
    case "Ectopics"
    handles.radiobutton_Ect.Value = 1;
    case "PAC"
    handles.radiobutton_PAC.Value = 1;
    case "PVC"
    handles.radiobutton_PVC.Value = 1;
    case "Noise"
    handles.radiobutton_Noise.Value = 1;
    case "VT"
    handles.radiobutton_VT.Value = 1;
    case "UND"
    handles.radiobutton_und.Value = 1;
end

% --- Executes during object creation, after setting all properties.
function listbox1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to listbox1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in radiobutton_SR.
function radiobutton_SR_Callback(hObject, eventdata, handles)
% hObject    handle to radiobutton_SR (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of radiobutton_SR


% --- Executes on button press in radiobutton_PAC.
function radiobutton_PAC_Callback(hObject, eventdata, handles)
% hObject    handle to radiobutton_PAC (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of radiobutton_PAC


% --- Executes on button press in radiobutton_PVC.
function radiobutton_PVC_Callback(hObject, eventdata, handles)
% hObject    handle to radiobutton_PVC (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of radiobutton_PVC


% --- Executes on button press in radiobutton_Noise.
function radiobutton_Noise_Callback(hObject, eventdata, handles)
% hObject    handle to radiobutton_Noise (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of radiobutton_Noise


% --- Executes on button press in radiobutton_VT.
function radiobutton_VT_Callback(hObject, eventdata, handles)
% hObject    handle to radiobutton_VT (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of radiobutton_VT


% --- Executes on button press in radiobutton_Ect.
function radiobutton_Ect_Callback(hObject, eventdata, handles)
% hObject    handle to radiobutton_Ect (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of radiobutton_Ect


% --- Executes on button press in pushbutton_load.
function pushbutton_load_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_load (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[n,p] = uigetfile('*.mat');
V = load([p,filesep,n]);
List = "n"+(1:length(V.spikes_all))' + "_" + V.Tab.ID ;
handles.listbox1.String = List;
handles.data = V;
guidata(hObject, handles);


% --- Executes on button press in pushbutton_save.
function pushbutton_save_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_save (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in pushbutton_plot.
function pushbutton_plot_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_plot (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

ic = handles.listbox1.Value;
spikes = handles.data.spikes_all{ic};
sp = round(spikes/1000*handles.data.fs);
t = (1:size(handles.data.S,1))/handles.data.fs;
hold(handles.axes1,'off')
plot(handles.axes1,t,handles.data.S(:,ic,2),'k');
hold(handles.axes1,'on')
plot(handles.axes1,t(sp),handles.data.S(sp,ic,2),'ok','MarkerFacecolor','r');

plot(handles.axes2,t,handles.data.S(:,ic,1));
plot(handles.axes3,t(sp(2:end)),diff(spikes),'-ok','MarkerFacecolor','r');
set([handles.axes1,handles.axes2,handles.axes3],'xlim',[t(1)-.1 t(end)+.1],'ygrid','on','xgrid','on')
set(handles.axes3,'ylim',[min(diff(spikes)) max(diff(spikes))]+[-1 1]*range(diff(spikes))*.1)


% --- Executes on key press with focus on figure1 and none of its controls.
function figure1_KeyPressFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  structure with the following fields (see MATLAB.UI.FIGURE)
%	Key: name of the key that was pressed, in lower case
%	Character: character interpretation of the key(s) that was pressed
%	Modifier: name(s) of the modifier key(s) (i.e., control, shift) pressed
% handles    structure with handles and user data (see GUIDATA)
isbj = handles.tag_List.Value;
go = 'null';
switch eventdata.Key
    case {'q'}
        handles.radiobutton_pvc.Value=1;
        handles.ECGcat(isbj) = 'PVC';
        
    case {'a'}
        handles.radiobutton_pac.Value=1;
        handles.ECGcat(isbj) = 'PAC';
        
    case {'z'}
        handles.radiobutton_abn.Value=1;
        handles.ECGcat(isbj) = 'ABN';
        
    case {'w'}
        handles.radiobutton_noise.Value=1;
        handles.ECGcat(isbj) = 'NOISE';
        
    case {'s'}
        handles.radiobutton_und.Value=1;
        handles.ECGcat(isbj) = 'UND';
        
    case {'x'}
        handles.radiobutton_norm.Value=1;
        handles.ECGcat(isbj) = 'NORM';
        
    case {'e'}
        handles.radiobutton_BB.Value=1;
        handles.ECGcat(isbj) = 'BB';
        
    case {'d'}
        handles.radiobutton_SND.Value=1;
        handles.ECGcat(isbj) = 'SND';
        
    case {'c'}
        handles.radiobutton_AF.Value=1;
        handles.ECGcat(isbj) = 'AF';
        
    case 'downarrow'
        go = 'down';
        
    case 'uparrow'
        go = 'up';
        
end
handles.text_cat.String = [num2str(handles.tag_List.Value),' - ',char(handles.ECGcat(isbj))];
switch go
    case 'down'
        if handles.tag_List.Value<size(handles.sig,2)
            handles.tag_List.Value=handles.tag_List.Value+1;
            tag_List_Callback(hObject,[], handles)
        end
    case 'up'
        if handles.tag_List.Value>1
            handles.tag_List.Value=handles.tag_List.Value-1;
            tag_List_Callback(hObject,[], handles)
        end
end

if isequal(eventdata.Key,'hyphen')
    handles.spikes_all{handles.tag_List.Value}(1) = [];
    guidata(hObject, handles);
    cla(handles.tag_ax_sig)
    cla(handles.tag_ax_spikes)
    tag_Plot_Callback(hObject,[],handles);
end


if ~isnan(str2double(eventdata.Key))
    handles.tag_n_ectopics.String = eventdata.Key;
    handles.N_Ectopics(handles.tag_List.Value) = str2double(eventdata.Key);
    %     pause(.5)
    %     handles.tag_List.Value=handles.tag_List.Value+1;
    %     tag_List_Callback(hObject,[], handles)
end
guidata(hObject, handles);


if isequal(eventdata.Key,'l')
    cla(handles.tag_ax_sig)
    cla(handles.tag_ax_spikes)
    tag_localize_Callback(hObject,[],handles);
end


% --- Executes on button press in radiobutton_und.
function radiobutton_und_Callback(hObject, eventdata, handles)
% hObject    handle to radiobutton_und (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of radiobutton_und
