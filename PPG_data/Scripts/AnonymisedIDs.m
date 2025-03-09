% Measure RR from ECGs and provide labels
clear
d = 'E:\Work\Teaching\KCL\StudentProjects\PPG_ectopics\DATA\';

X = dir([d,'*.mat']);
fntot = string({X.folder})+filesep+string({X.name});

% Get the IDs
IDtot = strings(1,length(X));
IDtot2 = strings(1,length(X));
for ifile = 1 : length(X)
    V = load(fntot{ifile},'Params');
    IDtot{ifile} = V.Params.ID;
end

idsu = unique(IDtot);
idsu2 = strings(1,length(idsu));
for i = 1:length(idsu)
    idsu2{i} = ['ID_',num2str(i,'%02.0f')];
end
for j=1:length(idsu)
    IDtot2(IDtot==idsu{j}) = idsu2(j);
end

% save
for ifile = 1 : length(X)
    V = load(fntot{ifile},'Params');
    if isequal(V.Params.ID,IDtot{ifile})
        Params = V.Params;
        Params.ID2 = IDtot2{ifile};
        save(fntot{ifile},'Params','-append');
    else
        error('Problem with IDs')
    end
end
