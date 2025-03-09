function [V,V0] = SegmentData_fun(fn,ParamIn)

V = load(fn);
% filter
fs = V.Params.SamplingRate;

if fs ~= 240 % This is to resample data collected in the theatre
    V.signals = resample(V.signals,240,fs);
    fs = 240;
    V.Params.SamplingRate = 240;
end
[b,a] = butter(3,[.5 10]/(fs/2));
V.signals = filtfilt(b,a,V.signals);

N = fix(length(V.signals)/fs/ParamIn.T);

TimeStart = nan(1,N);
spikes_all = cell(1,N);
if isfield(V.Params,'Labels')
    [~,iilab1,iilab2] = intersect(ParamIn.LabECG,V.Params.Labels,'stable');
    S = nan(fs*ParamIn.T,N,length(ParamIn.LabECG));
else
    iilab1 = 1:2;
    iilab2 = [3,1];
    S = nan(fs*ParamIn.T,N,2);
end
t = (1:size(V.signals,1))/fs;
for i = 2 : N-1
    hecg = (i-1)*fs*ParamIn.T + (1 : fs*ParamIn.T);
    hppg = hecg + (ParamIn.Delta/1000*fs); % Cature pulses Delta ms later

    xecg = V.signals(hecg,iilab2(2:end));
    xppg = V.signals(hppg,iilab2(1));
    S(:,i,iilab1) = [xppg,xecg];
    TimeStart(i) = t(hecg(1));

    iecg = min([2,size(xecg,2)]);
    [spikes] = spikes_detection_PPG_project(xecg(:,iecg),fs); % Lead II
    spikes(diff(spikes)<100) = []; % remove QRS too closes
    % % figure
    % sp = round(spikes/1000*fs);
    % figure(1)
    % clf(1)
    % plot(xecg(:,iecg));
    % hold on
    % plot(sp,xecg(sp,iecg),'o')
    % grid on

    spikes_all{i} = spikes;
end
% Remove segments with nans
iiko = mean(isnan(S(:,:,1)))>0 | cellfun(@isempty,spikes_all);
S(:,iiko,:) = [];
spikes_all(iiko) = [];
TimeStart(iiko)  = [];

% save original values
[~,filename] = fileparts(fn);
V0.Filename = filename;
V0.S = S;
V0.spikes_all = spikes_all;
V0.rrmed = cellfun(@(x) median(diff(x)),spikes_all);
V0.hrmed = cellfun(@(x) median(60000./diff(x)),spikes_all);
V0.sdsd = cellfun(@(x) std(diff(diff(x))),spikes_all);
V0.madsd = cellfun(@(x) mad(diff(diff(x)),1),spikes_all);
V0.fs = fs;
if isfield(V.Params,'ID2')
    V0.ID = V.Params.ID2;
else
    V0.ID = ['Theatre_',filename];
end
V0.Labels = ParamIn.LabECG;
V0.TimeStart = TimeStart;
% fns = [ds,V.Params.ID2,'_ori'];
% save(fns,'-struct','V0')


% filtering
ii1 = V0.hrmed<130 & V0.sdsd>1; % crieria to remove VT
N = round(0.100*fs);
sat = movmean(abs(diff(V0.S(:,:,1),N)),N)==0;
ii2 = sum(sat)==0; % criteria to remove saturation (for longer than 100 ms)
ii3 = cellfun(@length,spikes_all)>4; % remove when there are too few beats
ii4 = cellfun(@min,spikes_all)<2500 & cellfun(@(x) max(x),spikes_all)>(ParamIn.T*1000)-2500;
ii5 = cellfun(@(x) max(diff(x)),spikes_all)<2500;
ii6 = cellfun(@(x) sum(diff(x)<400),spikes_all)<=3; % more than 3 beats < 400

iiok = ii1 & ii2 & ii3 & ii4 & ii5 & ii6;
disp(['Keeping ',num2str(sum(iiok)),' signals; Removing ',num2str(100*mean(~iiok),3),'%'])
% reducing data (no VT, no PPG saturation, only lead II)
if size(V0.S,3)>2
S = V0.S(:,iiok,[1,3]);
else
S = V0.S(:,iiok,[1,2]);
end
spikes_all = V0.spikes_all(iiok);
labels = ParamIn.LabECG([1,3]);
rrmed = V0.rrmed(iiok);
hrmed = V0.hrmed(iiok);
sdsd = V0.sdsd(iiok);
madsd = V0.madsd(iiok);
TimeStart = V0.TimeStart(iiok);

Tab.ID0 = repmat(string(V0.ID),[length(spikes_all),1]);
Tab.ID = string(V0.ID) + "_"+ (1:length(spikes_all))';
Tab.Filename = string(V0.Filename) + "_"+ (1:length(spikes_all))';
Tab.rrmed = rrmed(:);
Tab.hrmed = hrmed(:);
Tab.sdsd = sdsd(:);
Tab.madsd = madsd(:);
Tab.TimeStart = seconds(TimeStart(:));
Tab.TimeStart.Format = 'hh:mm:ss';
Tab = struct2table(Tab);

clear V
V.ID = V0.ID;
V.S = S;
V.fs = fs;
V.spikes_all = spikes_all;
V.Tab = Tab;
V.labels = labels;
V.Filename = V0.Filename;
% fns2 = [ds,V.Params.ID2,'_selected'];
% save(fns2,'S','spikes_all','labels',"Tab",'fs')