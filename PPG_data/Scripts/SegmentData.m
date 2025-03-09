% Measure RR from ECGs and provide labels
addpath E:\Work\Scripts_all\Scripts_mo\EPMapp\GUI_egm_mFiles

clear
close all
do_cathlab = 1;
do_theatre = 1;
ds1 = 'E:\Work\Teaching\KCL\StudentProjects\PPG_ectopics\Segments\Selected\';

%% Cathlab data
if do_cathlab
    d = 'E:\Work\Teaching\KCL\StudentProjects\PPG_ectopics\DATA\';
    ds0 = 'E:\Work\Teaching\KCL\StudentProjects\PPG_ectopics\Segments\Ori\';

    X = dir([d,'*.mat']);
    fntot = string({X.folder})+filesep+string({X.name});

    ParamIn.LabECG = {'SPO2','I','II','III','V1','V2','V3','V4','V5','V6','aVF','aVL','aVR'};
    ParamIn.T = 8; % sec
    ParamIn.Delta = 450; % ms delay between R and pulse
    parfor ifile = 1:length(X)
        disp(['Processing ',fntot{ifile}]);
        [V,V0] = SegmentData_fun(fntot{ifile},ParamIn);

        fns = [ds0,V.Filename,'_ori'];
        save(fns,'-fromstruct',V0)

        fns2 = [ds1,V.Filename,'_selected'];
        save(fns2,'-fromstruct',V)
    end
end

%% do theatre
if do_theatre
    d = 'E:\Work\Teaching\KCL\StudentProjects\PPG_ectopics\DATA_theatre\';
    ds0 = 'E:\Work\Teaching\KCL\StudentProjects\PPG_ectopics\Segments\Ori\';
    ds1 = 'E:\Work\Teaching\KCL\StudentProjects\PPG_ectopics\Segments\Selected\';

    X = dir([d,'*.mat']);
    fntot = string({X.folder})+filesep+string({X.name});

    ParamIn.LabECG = {'SPO2','I','II','III','V1','V2','V3','V4','V5','V6','aVF','aVL','aVR'};
    ParamIn.T = 8; % sec
    ParamIn.Delta = 450; % ms delay between R and pulse
    parfor ifile = 1:length(X)
        disp(['Processing ',fntot{ifile}]);
        [V,V0] = SegmentData_fun(fntot{ifile},ParamIn);

        fns = [ds0,'Theatre_',V.Filename,'_ori'];
        save(fns,'-fromstruct',V0)

        fns2 = [ds1,'Theatre_',V.Filename,'_selected'];
        save(fns2,'-fromstruct',V)
    end
end
%%
disp('-- Put data together ---')

ds2 = 'E:\Work\Teaching\KCL\StudentProjects\PPG_ectopics\Compiled\';
S = [];
spikes_all = [];
X = dir([ds1,'*_selected.mat']);
Tab = [];
fntot = string({X.folder})+filesep+string({X.name});
for ifile = 1:length(fntot)
    V = load(fntot{ifile});
    S = cat(2,S,V.S);
    spikes_all = [spikes_all,V.spikes_all];
    Tab = [Tab;V.Tab];
end

%
x = std(S(:,:,1));
ii = x<0.02;
S(:,ii,:) = [];
spikes_all(ii) = [];
Tab(ii,:) = [];

ECGcat = repmat("NORM",size(spikes_all));
ECGcat(log10(Tab.sdsd)>2) = "ECT";
ECGcat = categorical(ECGcat);
Tab.ECGcat = ECGcat(:);

fs = V.fs;
labels = V.labels;
fns3 = [ds2,'PPGECG_all'];
save(fns3,'S','Tab','spikes_all','fs','labels')

% Figures
% for i = 1:length(spikes_all)
%     sp = round(spikes_all{i}/1000*fs);
%     figure(1)
%     clf(1)
%     ax(1) = subplot(211);
%     plot(S(:,i,2));
%     hold on
%     plot(sp,S(sp,i,2),'o')
%     grid on
%     ax(2) = subplot(212);
%     plot(S(:,i,1));
%     pause
% end