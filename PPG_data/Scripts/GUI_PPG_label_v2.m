function varargout = GUI_PPG_label_v2(varargin)
% GUI_PPG_LABEL_V2 MATLAB code for GUI_PPG_label_v2.fig
%      GUI_PPG_LABEL_V2, by itself, creates a new GUI_PPG_LABEL_V2 or raises the existing
%      singleton*.
%
%      H = GUI_PPG_LABEL_V2 returns the handle to a new GUI_PPG_LABEL_V2 or the handle to
%      the existing singleton*.
%
%      GUI_PPG_LABEL_V2('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in GUI_PPG_LABEL_V2.M with the given input arguments.
%
%      GUI_PPG_LABEL_V2('Property','Value',...) creates a new GUI_PPG_LABEL_V2 or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before GUI_PPG_label_v2_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to GUI_PPG_label_v2_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help GUI_PPG_label_v2

% Last Modified by GUIDE v2.5 03-Feb-2025 22:40:23

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
    'gui_Singleton',  gui_Singleton, ...
    'gui_OpeningFcn', @GUI_PPG_label_v2_OpeningFcn, ...
    'gui_OutputFcn',  @GUI_PPG_label_v2_OutputFcn, ...
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

% --- Executes just before GUI_PPG_label_v2 is made visible.
function GUI_PPG_label_v2_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to GUI_PPG_label_v2 (see VARARGIN)

% Choose default command line output for GUI_PPG_label_v2
handles.output = hObject;
%% ADD DATA

% load('E:\UCL\Data&People\Data_UKBB_RR\UKBB_HRV\UKBB_HRV_Results_200715\STAT_HRV_Rest\SAECG.mat','t','SAECGm')
% handles.Template.x = SAECGm;
% handles.Template.t = t;



% Update handles structure
addpath E:\Work\Scripts_all\Scripts_mo\EPMapp\GUI_egm_mFiles
guidata(hObject, handles);
% UIWAIT makes GUI_PPG_label_v2 wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = GUI_PPG_label_v2_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;



% --- Executes on selection change in tag_List.
function tag_List_Callback(hObject, eventdata, handles)
% hObject    handle to tag_List (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns tag_List contents as cell array
%        contents{get(hObject,'Value')} returns selected item from tag_List
cla(handles.tag_ax_sig)
cla(handles.tag_ax_spikes)

isbj = handles.tag_List.Value;
handles.text_cat.String = [num2str(handles.tag_List.Value),' - ',char(handles.mat.Tab.ECGcat(isbj))];
switch handles.mat.Tab.ECGcat(isbj)
    case 'PVC'
        handles.radiobutton_pvc.Value=1;
    case 'PAC'
        handles.radiobutton_pac.Value=1;
    case 'ECT'
        handles.radiobutton_ect.Value=1;
    case 'NOISE'
        handles.radiobutton_noise.Value=1;
    case 'UND'
        handles.radiobutton_und.Value=1;
    case 'NORM'
        handles.radiobutton_norm.Value=1;
    case 'SND'
        handles.radiobutton_SND.Value=1;
    case 'PPG_N'
        handles.radiobutton_ppg_noise.Value=1;
    case 'VT'
        handles.radiobutton_VT.Value=1;
end

tag_Plot_Callback(hObject,[],handles);


% --- Executes during object creation, after setting all properties.
function tag_List_CreateFcn(hObject, eventdata, handles)
% hObject    handle to tag_List (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in tag_Refresh.
function tag_Refresh_Callback(hObject, eventdata, handles)
% hObject    handle to tag_Refresh (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% hold(handles.tag_ax_spikes,'off')
% hold(handles.tag_ax_sig,'off')
cla(handles.tag_ax_spikes)
cla(handles.tag_ax_sig)
set([handles.tag_ax_sig,handles.tag_ax_spikes],'xlim',[0 1])
% --- Executes on button press in tag_Eliminate.
function tag_Eliminate_Callback(hObject, eventdata, handles)
% hObject    handle to tag_Eliminate (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
dcm_obj = datacursormode(handles.figure1);
info_struct = getCursorInfo(dcm_obj);
ic = handles.tag_List.Value;
SpikesUpdated = handles.mat.spikes_all{ic};
fs = handles.mat.fs;
ii_out = nan(1,length(info_struct));
spikes_out = nan(1,length(info_struct));
for i = 1:length(info_struct)
    spikes_out(i) = info_struct(i).Position(1);
    switch handles.tag_do_xtick.String{handles.tag_do_xtick.Value}
        case 'Seconds'
            sp = SpikesUpdated/1000;
            spikes_out(i) = spikes_out(i)*1000;
        case 'Minutes'
            sp = SpikesUpdated/1000/60;
            spikes_out(i) = spikes_out(i)*1000*60;
        case 'Hours'
            sp = SpikesUpdated/1000/60/60;
            spikes_out(i) = spikes_out(i)*1000*60*60;
    end
    ii = find(abs(SpikesUpdated-spikes_out(i))<=2/fs*1000);
    if ~isempty(ii)
        ii_out(i)= min(ii); % min only because in theory ii can be a vector
        set(info_struct(i).Target,'visible','off')
    end
end
ii_out(isnan(ii_out))=[];
plot(handles.tag_ax_sig,sp(ii_out),handles.yym,'xr','linewidth',2,'markersize',10)
SpikesUpdated(ii_out)=[];
sp(ii_out)=[];
hold(handles.tag_ax_spikes,'on')
if handles.do_plot_bpm.Value==0
    plot(handles.tag_ax_spikes,sp(2:end),diff(SpikesUpdated),'o-r')
else
    plot(handles.tag_ax_spikes,sp(2:end),60000./diff(SpikesUpdated),'o-r')
end

handles.mat.spikes_all{ic}=SpikesUpdated;
%
set(handles.tag_sdsd,'string',num2str(std(diff(diff(SpikesUpdated)),'omitnan'),3));
set(handles.tag_SDNN,'string',num2str(std((diff(SpikesUpdated)),'omitnan'),3));

set(handles.axes3,'XTickLabel',[])
set(handles.tag_ax_sig,'XTickLabel',[])
% remove all datatips
delete(findall(gca,'Type','hggroup','HandleVisibility','off'));
% update
guidata(hObject, handles);


% --- Executes on button press in tag_Add.
function tag_Add_Callback(hObject, eventdata, handles)
% hObject    handle to tag_Add (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
dcm_obj = datacursormode(handles.figure1);
info_struct = getCursorInfo(dcm_obj);

ic = handles.tag_List.Value;
SpikesUpdated = handles.mat.spikes_all{ic};
spikes_in = nan(1,length(info_struct));
for i = 1:length(info_struct)
    spikes_in(i) = info_struct(i).Position(1);
end

switch handles.tag_do_xtick.String{handles.tag_do_xtick.Value}
    case 'Seconds'
        SpikesUpdated = sort([SpikesUpdated,spikes_in*1000],'ascend');
        sp_plot = SpikesUpdated/1000;
    case 'Minutes'
        SpikesUpdated = sort([SpikesUpdated,spikes_in*1000*60],'ascend');
        sp_plot = SpikesUpdated/1000/60;
    case 'Hours'
        SpikesUpdated = sort([SpikesUpdated,spikes_in*1000*60*60],'ascend');
        sp_plot = SpikesUpdated/1000/60/60;
end

plot(handles.tag_ax_sig,spikes_in,handles.yym,'vg','linewidth',2,'markersize',6,'markerfacecolor','g')
hold(handles.tag_ax_spikes,'on')
if handles.do_plot_bpm.Value==0
    plot(handles.tag_ax_spikes,sp_plot(2:end),diff(SpikesUpdated),'o-r')
else
    plot(handles.tag_ax_spikes,sp_plot(2:end),60000./diff(SpikesUpdated),'o-r')
end
% set(handles.tag_ax_sig,'xtick',sp_plot(2:end),'xticklabel',[],'xgrid','on')
handles.mat.spikes_all{ic}=SpikesUpdated;

set(handles.tag_sdsd,'string',num2str(std(diff(diff(SpikesUpdated)),'omitnan'),3));
set(handles.tag_SDNN,'string',num2str(std((diff(SpikesUpdated)),'omitnan'),3));


% remove all datatips
delete(findall(gca,'Type','hggroup','HandleVisibility','off'));
% update
guidata(hObject, handles);


% --- Executes on button press in tag_Plot.
function tag_Plot_Callback(hObject, eventdata, handles)
% hObject    handle to tag_Plot (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

ic = handles.tag_List.Value;
handles.tag_n_ectopics.String = handles.N_Ectopics(ic);
handles.spikes = handles.mat.spikes_all{ic};
handles.SpikesUpdated = handles.spikes;
fs = handles.mat.fs;

xx = get(handles.tag_ax_sig,'xlim');
te = size(handles.mat.sig,1)/(fs/1000);
if xx(2)>te
    xx(2)=te;
end



switch handles.tag_do_xtick.String{handles.tag_do_xtick.Value}
    case 'Seconds'
        tms = [0:size(handles.mat.sig,1)-1]/fs;
        sp_plot = handles.spikes/1000;
        sp_plot_upd = handles.SpikesUpdated/1000;
    case 'Minutes'
        tms = [0:size(handles.mat.sig,1)-1]/fs/60;
        sp_plot = handles.spikes/1000/60;
        sp_plot_upd = handles.SpikesUpdated/1000/60;
    case 'Hours'
        tms = [0:size(handles.mat.sig,1)-1]/fs/60/60;
        sp_plot = handles.spikes/1000/60/60;
        sp_plot_upd = handles.SpikesUpdated/1000/60/60;
end

if isempty(sp_plot)
    sp_plot = nan;
end
sdsd = std(diff(diff(handles.spikes)),'omitnan');
sdnn = std(diff(handles.spikes),'omitnan');
handles.tag_sdsd.String = num2str(sdsd,3);
handles.tag_SDNN.String = num2str(sdnn,3);

ap2=plot(handles.tag_ax_sig,[1 1]'*sp_plot,[min(handles.mat.sig(:,ic));max(handles.mat.sig(:,ic))]*ones(1,length(sp_plot)),'--','color',[1 1 1]*.7);
hold(handles.tag_ax_sig,'on')
aa = plot(handles.tag_ax_sig,tms,handles.mat.sig(:,ic,2),'k');

set([handles.tag_ax_sig,handles.tag_ax_spikes],'xlim',[tms(1) tms(end)])
zoom(handles.tag_ax_sig,'reset')
zoom(handles.tag_ax_spikes,'reset')
zoom(handles.tag_ax_spikes,'out')
zoom(handles.tag_ax_sig,'out')

% vstr = get(handles.tag_List,'string');
% vstr=vstr(ic);
% set(aa(setdiff([1:length(aa)],iiv)),'visible','off')
% ll = legend(aa,vstr);
yy =get(handles.tag_ax_sig,'ylim');
yym = max(.8*max(yy));

if ~isfield(handles,'spikes')|isnan(sp_plot)
    return
end
% plot(handles.tag_ax_sig,sp_plot,yym,'ok','markerfacecolor','r');
ii = round(handles.spikes/1000*fs);
plot(handles.tag_ax_sig,tms(ii),handles.mat.sig(ii,ic,2),'ok','markerfacecolor','r');
clear yy


if handles.do_plot_bpm.Value==0
    y = diff(handles.spikes);
else
    y = 60000./diff(handles.spikes);
end
ap1=plot(handles.tag_ax_spikes,[1 1]'*sp_plot,[min(y)-range(y)*.1;max(y)+range(y)*.1]*ones(1,length(sp_plot)),'--','color',[1 1 1]*.7);
hold(handles.tag_ax_spikes,'on')
aori = plot(handles.tag_ax_spikes,sp_plot(2:end),y,'o-k','markerfacecolor','r');
set(handles.tag_ax_spikes,'ylim',[min(y)-range(y)*.1 max(y)+range(y)*.1])

if ~isempty(handles.mat.TimeEct.PAC{ic})
    [~,i1] = intersect(sp_plot,handles.mat.TimeEct.PAC{ic});
        plot(handles.tag_ax_sig,sp_plot(i1),yym,'xk','MarkerSize',12,'LineWidth',1);
    plot(handles.tag_ax_spikes,sp_plot(i1),y(i1),'xk','MarkerSize',12,'LineWidth',1);
end
if ~isempty(handles.mat.TimeEct.PVC{ic})
    [~,i1] = intersect(sp_plot,handles.mat.TimeEct.PVC{ic});
        plot(handles.tag_ax_sig,sp_plot(i1),yym,'xk','MarkerSize',12,'LineWidth',1);
    plot(handles.tag_ax_spikes,sp_plot(i1),y(i1),'+k','MarkerSize',12,'LineWidth',1);
end

plot(handles.axes3,tms,handles.mat.sig(:,ic,1),'Color',[.1 .4 .9],'LineWidth',1)
xx = [tms(1) tms(end)]+[-1 1]*range(tms)*0.01; % only for this
if ~isequal(xx,[0 1])
    xlim(handles.tag_ax_sig,xx);
    xlim(handles.tag_ax_spikes,xx);
end
handles.yym = yym;

set(handles.tag_ax_sig,'ylim',[min(handles.mat.sig(:,ic,2))-range(handles.mat.sig(:,ic,2))*.1 max(handles.mat.sig(:,ic,2))+range(handles.mat.sig(:,ic,2))*.1])

guidata(hObject, handles);
linkaxes([handles.tag_ax_spikes,handles.tag_ax_sig],'x')
set(handles.axes3,'XTickLabel',[])
set(handles.tag_ax_sig,'XTickLabel',[])



% --- Executes on button press in tag_done.
function tag_done_Callback(hObject, eventdata, handles)
% hObject    handle to tag_done (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

n0 = handles.filename(1:end-4);
if handles.tag_List.Value>length(handles.tag_List.String)
    handles.tag_List.Value = length(handles.tag_List.String);
end
[n,p] = uiputfile([n0,'_',handles.tag_List.String{handles.tag_List.Value},'.mat']);

signals = handles.mat.sig;
sp_all = handles.mat.spikes_all;
ParamSig = handles.ParamSig;
ic_final = handles.tag_List.Value;
ECGcat = handles.mat.Tab.ECGcat;
N_Ectopics = handles.N_Ectopics;

save([p,n],'signals','sp_all','ParamSig','ic_final','ECGcat','N_Ectopics');



% --- Executes on button press in tag_localize.
function tag_localize_Callback(hObject, eventdata, handles)
% hObject    handle to tag_localize (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

hold(handles.tag_ax_sig,'off')
plot(handles.tag_ax_sig,nan,nan)
text(.5,.5,' ... Localizing Spikes ....')

hold(handles.tag_ax_spikes,'off')
plot(handles.tag_ax_spikes,nan,nan)
text(.5,.5,' ... Localizing Spikes ....')

set([handles.tag_ax_spikes,handles.tag_ax_sig],'xtick',[],'ytick',[])

ichan = get(handles.tag_List,'value');
%
Hwb = waitbar(0,'Estimating Spikes');
signals = handles.mat.sig(:,ichan);
signals(isnan(signals))=[];

%% Sinus Rhythm
[spikes] = spikes_detection_SR_CinC(signals,fs);
% update
handles.mat.spikes_all{ichan}=spikes;
guidata(hObject, handles);
close(Hwb)

tag_Plot_Callback(hObject,[], handles)



% --- Executes on button press in tag_do_QRS.
function tag_do_QRS_Callback(hObject, eventdata, handles)
% hObject    handle to tag_do_QRS (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of tag_do_QRS
if handles.tag_do_QRS.Value == 1
    handles.tag_sensitivity_thr.String = '0.1';
    handles.tag_control.Value = 0;
    handles.tag_VT_check.Value = 0;
    handles.tag_do_QRSAuto.Value = 0;
end

% --- Executes on button press in tag_Eliminate_all.
function tag_Eliminate_all_Callback(hObject, eventdata, handles)
% hObject    handle to tag_Eliminate_all (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

answ = questdlg('Eliminate all markers currently visualized?');
if isequal(answ,'Yes')
    ic = handles.tag_List.Value;
    
    SpikesUpdated = handles.mat.spikes_all{ic};
    
    xx = get(handles.tag_ax_sig,'xlim');
    switch handles.tag_do_xtick.Value
        case 1
            ii_out = SpikesUpdated/1000<xx(2) & SpikesUpdated/1000>xx(1);
        case 2
            ii_out = SpikesUpdated/1000/60<xx(2) & SpikesUpdated/1000/60>xx(1);
        case 3
            ii_out = SpikesUpdated/1000/60/60<xx(2) & SpikesUpdated/1000/60/60>xx(1);
    end
    
    plot(handles.tag_ax_sig,SpikesUpdated(ii_out),handles.yym,'xr','linewidth',2,'markersize',10)
    SpikesUpdated(ii_out)=[];
    hold(handles.tag_ax_spikes,'on')
    plot(handles.tag_ax_spikes,SpikesUpdated(2:end),diff(SpikesUpdated),'o-r')
    set(handles.tag_ax_sig,'xtick',SpikesUpdated(2:end),'xticklabel',[],'xgrid','on')
    
    handles.mat.spikes_all{ic}=SpikesUpdated;
    
    set(handles.tag_sdsd,'string',num2str(std(diff(diff(handles.spikes)),'omitnan'),3));
    set(handles.tag_SDNN,'string',num2str(std((diff(handles.spikes)),'omitnan'),3));
    
    % remove all datatips
    delete(findall(gca,'Type','hggroup','HandleVisibility','off'));
    % update
    guidata(hObject, handles);
    
    %
    cla(handles.tag_ax_sig);
    cla(handles.tag_ax_spikes);
    tag_Plot_Callback(hObject,[], handles)
    %
    handles.tag_List.Value = handles.tag_List.Value+1;
    tag_List_Callback(hObject,[], handles)
end

function tag_sensitivity_thr_Callback(hObject, eventdata, handles)
% hObject    handle to tag_sensitivity_thr (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of tag_sensitivity_thr as text
%        str2double(get(hObject,'String')) returns contents of tag_sensitivity_thr as a double


% --- Executes during object creation, after setting all properties.
function tag_sensitivity_thr_CreateFcn(hObject, eventdata, handles)
% hObject    handle to tag_sensitivity_thr (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function tag_sdsd_Callback(hObject, eventdata, handles)
% hObject    handle to tag_sdsd (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of tag_sdsd as text
%        str2double(get(hObject,'String')) returns contents of tag_sdsd as a double


% --- Executes during object creation, after setting all properties.
function tag_sdsd_CreateFcn(hObject, eventdata, handles)
% hObject    handle to tag_sdsd (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end






% --- Executes on button press in tag_VT_check.
function tag_VT_check_Callback(hObject, eventdata, handles)
% hObject    handle to tag_VT_check (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of tag_VT_check
if handles.tag_VT_check.Value == 1
    handles.tag_sensitivity_thr.String = '0.5';
    handles.tag_do_QRS.Value = 0;
    handles.tag_do_QRSAuto.Value = 0;
    handles.tag_control.Value = 0;
end


% --- Executes on button press in tag_do_QRSAuto.
function tag_do_QRSAuto_Callback(hObject, eventdata, handles)
% hObject    handle to tag_do_QRSAuto (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if handles.tag_do_QRSAuto.Value == 1
    handles.tag_sensitivity_thr.String = 'NA';
    handles.tag_do_QRS.Value = 0;
    handles.tag_control.Value = 0;
    handles.tag_VT_check.Value = 0;
end

% --- Executes on button press in tag_control.
function tag_control_Callback(hObject, eventdata, handles)
% hObject    handle to tag_control (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of tag_control
if handles.tag_control.Value == 1
    handles.tag_sensitivity_thr.String = '0.7';
    handles.tag_do_QRS.Value = 0;
    handles.tag_VT_check.Value = 0;
    handles.tag_do_QRSAuto.Value = 0;
end


% --- Executes on button press in do_plot_bpm.
function do_plot_bpm_Callback(hObject, eventdata, handles)
% hObject    handle to do_plot_bpm (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of do_plot_bpm


% --- Executes on selection change in tag_do_xtick.
function tag_do_xtick_Callback(hObject, eventdata, handles)
% hObject    handle to tag_do_xtick (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns tag_do_xtick contents as cell array
%        contents{get(hObject,'Value')} returns selected item from tag_do_xtick


% --- Executes during object creation, after setting all properties.
function tag_do_xtick_CreateFcn(hObject, eventdata, handles)
% hObject    handle to tag_do_xtick (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in tag_load.
function tag_load_Callback(hObject, eventdata, handles)
% hObject    handle to tag_load (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[f,p] = uigetfile('*.mat');
V = load([p,f]);
handles.mat.sig = V.S;
handles.mat.spikes_all = V.spikes_all;
handles.mat.fs = V.fs;
handles.mat.Tab = V.Tab;
% handles.mat.Tab.ECGcat = V.ECGcat;
if isfield(V,'TimeEct')
handles.mat.TimeEct = V.TimeEct;
else
handles.mat.TimeEct.PAC = cell(1,length(V.spikes_all));
handles.mat.TimeEct.PVC = cell(1,length(V.spikes_all));
end

handles.filename = [p,f];
p = "Seg_"+string(num2str((1:length(V.spikes_all))','%05.0f'))+"_"+handles.mat.Tab.ID0;
set(handles.tag_List,'string',p);

if ~isfield(V,'N_Ectopics')
    handles.N_Ectopics = nan(size(p));
else
    handles.N_Ectopics = V.N_Ectopics;
end

guidata(hObject, handles);




function tag_SDNN_Callback(hObject, eventdata, handles)
% hObject    handle to tag_SDNN (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of tag_SDNN as text
%        str2double(get(hObject,'String')) returns contents of tag_SDNN as a double


% --- Executes during object creation, after setting all properties.
function tag_SDNN_CreateFcn(hObject, eventdata, handles)
% hObject    handle to tag_SDNN (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


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
        handles.mat.Tab.ECGcat(isbj) = 'PVC';
        
    case {'a'}
        handles.radiobutton_pac.Value=1;
        handles.mat.Tab.ECGcat(isbj) = 'PAC';
        
    case {'z'}
        handles.radiobutton_ect.Value=1;
        handles.mat.Tab.ECGcat(isbj) = 'ECT';
        
    case {'w'}
        handles.radiobutton_noise.Value=1;
        handles.mat.Tab.ECGcat(isbj) = 'NOISE';
        
    case {'s'}
        handles.radiobutton_und.Value=1;
        handles.mat.Tab.ECGcat(isbj) = 'UND';
        
    case {'x'}
        handles.radiobutton_norm.Value=1;
        handles.mat.Tab.ECGcat(isbj) = 'NORM';
        
    case {'e'}
        handles.radiobutton_VT.Value=1;
        handles.mat.Tab.ECGcat(isbj) = 'VT';
        
    case {'d'}
        handles.radiobutton_SND.Value=1;
        handles.mat.Tab.ECGcat(isbj) = 'SND';
        
    case {'c'}
        handles.radiobutton_ppg_noise.Value=1;
        handles.mat.Tab.ECGcat(isbj) = 'PPG_N';
        
    case 'downarrow'
        go = 'down';
        
    case 'uparrow'
        go = 'up';
        
end
handles.text_cat.String = [num2str(handles.tag_List.Value),' - ',char(handles.mat.Tab.ECGcat(isbj))];
switch go
    case 'down'
        if handles.tag_List.Value<size(handles.mat.sig,2)
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
    handles.mat.spikes_all{handles.tag_List.Value}(1) = [];
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





% --- Executes when selected object is changed in uibuttongroup3.
function uibuttongroup3_SelectionChangedFcn(hObject, eventdata, handles)
% hObject    handle to the selected object in uibuttongroup3
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.text_cat.String = [num2str(handles.tag_List.Value),' - ',eventdata.NewValue.String];
isbj = handles.tag_List.Value;
switch eventdata.NewValue.String
    case 'PVC'
        handles.mat.Tab.ECGcat(isbj) = 'PVC';
    case 'PAC'
        handles.mat.Tab.ECGcat(isbj) = 'PAC';
    case 'ECT'
        handles.mat.Tab.ECGcat(isbj) = 'ECT';
    case 'NOISE'
        handles.mat.Tab.ECGcat(isbj) = 'NOISE';
    case 'NORM'
        handles.mat.Tab.ECGcat(isbj) = 'NORM';
    case 'UND'
        handles.mat.Tab.ECGcat(isbj) = 'UND';
    case 'VT'
        handles.mat.Tab.ECGcat(isbj) = 'VT';
    case 'SND'
        handles.mat.Tab.ECGcat(isbj) = 'SND';
    case 'PPG_N'
        handles.mat.Tab.ECGcat(isbj) = 'PPG_N';
        
end
guidata(hObject, handles);


% --- Executes on button press in tag_show_template.
function tag_show_template_Callback(hObject, eventdata, handles)
% hObject    handle to tag_show_template (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
sp = handles.mat.spikes_all{handles.tag_List.Value};
hold(handles.tag_ax_sig,'on');
for ib = 1:length(sp)
    switch handles.tag_do_xtick.String{handles.tag_do_xtick.Value}
        case 'Seconds'
            ii = [sp(ib)+ handles.Template.t]/1000;
        case 'Minutes'
            ii = [sp(ib)+ handles.Template.t]/1000/60;
        case 'Hours'
            ii = [sp(ib)+ handles.Template.t]/1000/60/60;
    end
    plot(handles.tag_ax_sig,ii,handles.Template.x,'color',[1 0 0 .5],'LineWidth',2);
end



function tag_n_ectopics_Callback(hObject, eventdata, handles)
% hObject    handle to tag_n_ectopics (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of tag_n_ectopics as text
%        str2double(get(hObject,'String')) returns contents of tag_n_ectopics as a double


% --- Executes during object creation, after setting all properties.
function tag_n_ectopics_CreateFcn(hObject, eventdata, handles)
% hObject    handle to tag_n_ectopics (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in tag_beat_type.
function tag_beat_type_Callback(hObject, eventdata, handles)
% hObject    handle to tag_beat_type (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns tag_beat_type contents as cell array
%        contents{get(hObject,'Value')} returns selected item from tag_beat_type

dcm_obj = datacursormode(handles.figure1);
info_struct = getCursorInfo(dcm_obj);
x = [info_struct.Position];
x = x(1:2:end);

switch handles.tag_beat_type.String{handles.tag_beat_type.Value}
    case 'PAC'
    handles.mat.TimeEct.PAC{handles.tag_List.Value} = sort(x);
    case 'PVC'
    handles.mat.TimeEct.PVC{handles.tag_List.Value} = sort(x);
end
guidata(hObject, handles);



% --- Executes during object creation, after setting all properties.
function tag_beat_type_CreateFcn(hObject, eventdata, handles)
% hObject    handle to tag_beat_type (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
