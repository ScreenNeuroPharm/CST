%% Burstiness Index (BI)
clear all
clc

start_folder = uigetdir(pwd,'Select Join PeakTrain folder:');
cd(start_folder);

d_phase = dir;

pk = [];

for k = 3:length(d_phase)
    cd(fullfile(d_phase(k).folder, d_phase(k). name));
    d_pk = dir;
    pk = [];
    for j = 3:length(d_pk)
        load(d_pk(j).name);
        pk(find(pk))=1;
        pk = [pk; peak_train'];
    end
    cd ..
    
    cd ..
    mkdir('BurstingIndexAnalysis');
    cd('BurstingIndexAnalysis');

    cum_pk = full(sum(pk));
    tot_sp = sum(cum_pk);

    % Parameters
    fs = 10000;
    T_rec_samples = size(pk,2); % samples
    T_rec_s = size(pk,2)/fs;    % seconds
    T_rec_min = T_rec_s /60;    % minutes
    nBurst_max = ceil(10* T_rec_min);    % 10 burst/min

    bin_dur = 1*fs;                % 1 second
    nbin = floor(T_rec_samples/bin_dur);
    perc_bursting_bin = round(nBurst_max/nbin,2);

    % BI
    count = 1;
    for i = 1:bin_dur:T_rec_samples-bin_dur
        binned_pk(count) = sum(cum_pk(i:bin_dur+i-1));
        count = count +1;
    end

    sorted_bin = sort(binned_pk,'descend');
    f = sum(sorted_bin(1:nBurst_max))/tot_sp;
    BI = (f-perc_bursting_bin)/(1-perc_bursting_bin);

    Parameters.f = f;
    Parameters.MBRmax = 10;
    Parameters.bin_durSamples = bin_dur;
    Parameters.binned_pk = binned_pk;
    Parameters.BI = BI;
    Parameters.percBin = perc_bursting_bin;
    phase_name = split(d_phase(k).name,'_');
    phase_name = phase_name{end};
    save(strcat('BurstingIndex_', phase_name),'Parameters');

    display(strcat('BI value = ', string(BI)));
end

