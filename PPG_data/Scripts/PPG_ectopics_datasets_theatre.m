clear
d0 = 'D:\sincro\Drive_E2\Data_MEF\Data_ori\Barts';
ds = 'C:\Users\mo24\UCL\Teaching\KCL\StudentProjects\PPG_ectopics\DATA_theatre';
X = dir([d0,'\**\*PLETH-BIN.dat']);

for isbj = 1:length(X)
    d = X(isbj).folder;

    filename = [d,filesep,'GE-WF-ECG1-BIN.dat'];
    fileID = fopen(filename);
    ecg = fread(fileID,'single','ieee-be');
    fclose(fileID);

    filename = [d,filesep,'GE-WF-INVP1-BIN.dat'];
    fileID = fopen(filename);
    bp = fread(fileID,'single','ieee-be');
    fclose(fileID);

    filename = [d,filesep,'GE-WF-PLETH-BIN.dat'];
    fileID = fopen(filename);
    ppg = fread(fileID,'single','ieee-be');
    fclose(fileID);

    ti = [1:length(ppg)]/100;
    t0 = [1:length(ecg)]/300;
    ecgi = interp1(t0,ecg,ti);

    signals = [ecgi(:) bp(:) ppg(:)]; 
    Params.filename = X(isbj).folder;
    Params.SamplingRate = 100;

    save([ds,'\Sig_',num2str(isbj,'%03.0f')],'signals','Params')
    clear signals Params
end