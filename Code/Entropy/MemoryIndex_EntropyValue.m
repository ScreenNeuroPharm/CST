%% Evaluation of the Entrophy and the Memory on Spike Train
clear all
clc

% Select the peakTrain files
path = uigetdir(pwd, 'Select PeakDetection folder');
d = dir(path);
dfolders = d([d(:).isdir]);
dfolders = dfolders(~ismember({dfolders(:).name},{'.','..'}));

pk = [];
fs = 10000;
pk = [];

for a = 1:length(dfolders)
    d = dir(fullfile(dfolders(a).folder, dfolders(a).name)); 
    pk = [];
    for b = 3:length(d)
        load(fullfile(d(b).folder,d(b).name));
        peak_train = full(peak_train);
        peak_train(find(peak_train)) = ones(1,length(find(peak_train)));
        % pk = [pk; peak_train'];
        if b == 3
            pk = peak_train;
        else
            pk = pk + peak_train;
        end
        pk_tot{a} = pk;

    end
    
   %% 
    %E = randi(100,[1 1000]);
    bin = 10; %ms
    bin_sample = bin/1000*fs;
    cc = 1;
    for i = 1:bin_sample:length(pk)-bin_sample
        f = pk(i:i+bin_sample);
        E(cc) = length(find(f));
        cc = cc +1;
    end


    % E = [5 2 1 4 7 0 0 2 5 2 1 4 7 0 0 2 5 2 1 4 7 0 0 2 5 2 1 4 7 0 0 2 5 2 1 4 7 0 0 2 5 2 1 4 7 0 0 2 5 2 1 4 7 0 0 2 5 2 1 4 7 0 0 2 5 2 1 4 7 0 0 2 5 2 1 4 7 0 0 2 ]
    S = [0:max(E)];
    % S = [0:max(E)]./max(E);
    % p_hat = hist(E,0:max(E))./length(E);
    p_hat = hist(E,0:max(E));

    % peak_cum = [E 0]./max(E);
    peak_cum = [E E(end)];
    W = diff(peak_cum);
    % G = [-max(E):max(E)]./max(E);
    G = [-max(E):max(E)];
    % E = E/max(E);
    possibility = combvec(G,S)';
    
    to_check = [W' E'];
    
    count = 1;
    count_col = 1;
    for k = 1:size(possibility,1)
        resto = rem((k-1)/length(G), 1);
        
        if resto == 0 && k >1
            count = count + 1;
            count_col = 1;
        end
        p_hat_sg(count, count_col) = sum(ismember(possibility(k,:),to_check,"rows"));
        count_col = count_col + 1;
    end
    % p_hat_sg = p_hat_sg./length(E);

    p_tilde = p_hat_sg./p_hat';
    
    H_MLE = -sum(p_tilde.*log2(p_tilde),2, "omitmissing");
    
    ms = sum(p_tilde>0,2);

    H_MM = H_MLE + (ms-1)./(2*p_hat');
    
    p_hat = p_hat./length(E);
    Entropy_mean = sum(p_hat'.*H_MM,"omitmissing"); 

    E_phases(a) = Entropy_mean;
    clear E G S W possibility p_tilde p_hat p_hat_sg to_check

end

id = strfind(path,'\');
name_folder = strcat(path(1:id(end)),'Entropy_Values');
mkdir(name_folder);
name_file = strcat(name_folder,'\MemoryValues.mat');
save(name_file,'E_phases');



