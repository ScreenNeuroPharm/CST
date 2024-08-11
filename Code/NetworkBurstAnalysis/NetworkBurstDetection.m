%% NETWORK BURST DETECTION 
%Non tiene in considerazione il nome degli elettrodi (da utilizzare in
%questo stato solo per il pattern analisi)

clear all
clc

fs = 10000;
peak = [];
[path_name] = uigetdir ('.mat', 'Select the PeakDetection folder [single phase]');
file_names = dir(path_name);
for k = 3:length(file_names)
    load(fullfile(path_name,file_names(k).name))
    peak_train(find(peak_train)) = 1;
    peak = [peak; peak_train'];
end

bin_ms = 25;
bin = bin_ms*fs/1000; 
num_spikes = 0;
num_el = 0;
for i = 1:bin:size(peak,2)-bin
    num_spikes(i:i+bin-1) = sum(sum(peak(:,i:i+bin))).*ones(1,bin);
    each_el = sum(peak(:,i:i+bin),2);
    num_el(i:i+bin-1) = length(find(each_el)).*ones(1,bin);
end
product = num_spikes.*num_el;
%% New part 
product_smooth = smooth(product, 2000);
[peaks, index] = findpeaks(product_smooth,'MinPeakHeight', 0.05*max(product_smooth), 'MinPeakDistance', 8000);
TF = islocalmin(product_smooth);
index_minima = find(TF);
value_minima = product_smooth(find(TF));

%find for each maximum the previous and the following minimum (il valore del
%minimo deve essere minore dello 0.1% altezza massima del picco)

for k = 1:length(index)-1
    differ = find(TF)-index(k);
    tmp = find(differ<0);
    decrease = 0;
    if ~isempty(tmp)
        while value_minima(tmp(end)+decrease)> 0.05*peaks(k)
            decrease = decrease +1;
            if tmp(end)+decrease > length(value_minima)
                return
            end
        end
        
        prev(k) = index_minima(tmp(end-decrease));
    
        tmp = find(differ>0);
        increase = 0;
        while value_minima(tmp(increase+1))> 0.05*peaks(k)
            increase = increase +1;
            if tmp(increase+1) > length(value_minima)
                return
            end
        end
        foll(k) = index_minima(tmp(1+increase));
    end
end





% %%
% threshold = max(product_smooth).*0.05;
% start = find(product>threshold);
% 
% if  ~isempty(start)
%     count_st = 1;
%     count_fin = 1;
%     check = 0;
%     same_nb = 0;
% 
%     for j = 1:length(start)-1
%         if start(j+1)-start(j)<1000 % 100 ms inter spike intervel inside the burst 
%             if same_nb == 0
%                 st(count_st) = start(j);
%                 count_st = count_st + 1;
%                 same_nb = 1;            
%             end
%         else 
%             if start(j+1)-start(j) > 1500 % 200 ms inter burst interval between two adiacent bursts
%                 fin(count_fin) = start(j);
%                 count_fin = count_fin + 1;
%                 same_nb = 0;
%             end
%         end
%     end
% 
%     count = 1;
%     clear index
%     index = [];
%     for k = 1:length(fin)
%         if fin(k) - st(k) < 1000
%             index(count) = k;
%             count = count +1;
%         end
%     end
% 
%     if ~isempty(index)
%         fin(index) = [];
%         st(index) = [];
%     end
% 
%     if length(st) ~= length(fin)
%         cut = min([length(st) length(fin)]);
%         st = st(1:cut);
%         fin = fin(1:cut);
%     end


    %% Da ogni NB identificare il numero dell'elettrodo e la sua prima attivazione
    % Salvare una variabile natBurstsPattern che contiene delle celle, ogni
    % cella corrisponde a un NB. All'interno la prima colonna contiene il
    % numero di elettrodo, la seconda colonna, invece, contiene il campione di
    % attivazione
    if exist('prev','var') == 1

        st = prev;
        fin = foll;
        st(find(st==0)) = [];
        fin(find(fin==0)) = [];

        for k = 1:length(st)
            peak_cut = peak(:,st(k):fin(k));
            [r,c] = find(peak_cut);
            el = unique(r);
            clear start_el
            for j = 1:length(el)
                index = find(r == el(j));
                start_el(j,:) = [el(j) min(c(index))+st(k)];
            end
            start_el = sortrows(start_el,2);
            netBurstsPattern{k,1} = start_el;
        end
    
        idx = strfind(path_name,'\');
        name = strcat(path_name(1:idx(end-1)),'NetworkBurstDetection');
        mkdir(name);
        phase = path_name(idx(end):end);
    
     
        netBursts(:,1) = st';
        netBursts(:,2) = fin';
        netBursts(:,3) = cellfun('size',netBurstsPattern,1)';
        netBursts(:,4) = fin'-st';
    
        
    end

save(fullfile(name, phase),'netBurstsPattern','netBursts');

