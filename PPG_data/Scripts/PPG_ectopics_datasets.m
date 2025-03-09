d = 'D:\sincro\Drive_F\Data_Barts_VT\';
ds = 'C:\Users\mo24\UCL\Teaching\KCL\StudentProjects\PPG_ectopics\DATA\';
X = dir([d,'\**\*.inf']);
fn = string({X.folder}) + filesep + string({X.name});
T_interval = 30; % Durat

for isbj = 79:length(fn)
    fid = fopen(fn{isbj});
    a = fgetl(fid);
    Params.ID = a(11:end);
    fgetl(fid);
    a = fgetl(fid);ii = find(a=='=');
    Params.Date = datetime(a(ii+2:end-1),'Format','MM/dd/uuuu hh:mm:ss aa');
    a = fgetl(fid);ii = find(a=='=');
    Params.N_chan = str2double(a(ii+1:end-1));
    a = fgetl(fid);ii = find(a=='=');
    Params.N_points = str2double(a(ii+1:end-1));
    a = fgetl(fid);a(isletter(a)|isspace(a)|a=='/'|a=='=')=[];
    Params.SamplingRate = str2double(a);
    a = fgetl(fid);ii = find(a=='=');
    Params.Time_Start = datetime(a(ii+2:end),'Format','MM/dd/uuuu hh:mm:ss aa');
    a = fgetl(fid);ii = find(a=='=');
    Params.Time_End = datetime(a(ii+2:end),'Format','MM/dd/uuuu hh:mm:ss aa');
    a = fgetl(fid);ii = find(a==':');
    Params.Units = a(ii+2:end);
    a = fgetl(fid);
    Params.Labels = cell(1,20);
    ind = 0;
    while 1
        ind = ind+1;
        a = fgetl(fid);
        if isequal(a,-1)
            break
        end
        a(1:2)=[];
        a(isspace(a))=[];
        Params.Labels{ind} = a;
    end
    Params.Labels(cellfun(@isempty,Params.Labels)) = [];

    fnsig = [fn{isbj}(1:end-4),'.txt'];
    if ~exist(fnsig,'file')
        continue
    end
    signals = readmatrix(fnsig);
    t = (1:size(signals,1))/Params.SamplingRate;

    Xdata = nan(Params.SamplingRate*T_interval,size(signals,2)+1,fix(t(end)/T_interval)-1);
    for i = 1 : fix(t(end)/T_interval)-1
        ii = (i-1)*T_interval*Params.SamplingRate+1 : i*T_interval*Params.SamplingRate;
        Xdata(:,:,i) = [t(ii)' signals(ii,:)];
    end

    save([ds,'Sig_',num2str(isbj,'%03.0f')],'signals','Params')
    fclose(fid);
    clear Params signals Xdata
end
