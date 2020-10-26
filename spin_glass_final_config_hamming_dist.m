
filename = 'spin_glass_switch_fields_vae_same_init_2019_09_30_5_04/random_order_';

load(char(strcat(filename, string(1), '_', string(1), '_', string(1), '/extra_data.mat')))

final_configs = [];
num_considered = 0;

for iter_3 = 1:500
    for iter_4 = 1:1
        statistic = [];
        
        for iter_5 = 1:1
            file_list = dir(char(strcat(filename, string(iter_3), '_', string(iter_4), '_', string(iter_5))));
%             file_list = dir(char(strcat(filename, string(iter_4), '_', string(iter_5))));
            stats = [];
            hist = [];
            flips = [];
            spin_diss = [];
            
            stats_2 = [];
            hist_2 = [];
            flips_2 = [];
            spin_diss_2 = [];
            for iter_6 = 1:(numel(file_list) - 3)
                load(char(strcat(filename, string(iter_3), '_', string(iter_4), '_', string(iter_5), '/data_', string(iter_6), '.mat')))
%                 load(char(strcat(filename, string(iter_4), '_', string(iter_5), '/data_', string(iter_6), '.mat')))
                stats = [stats, statistics];
                flips = [flips, flip_counts];
                hist = [hist, spin_hist];
                spin_diss = [spin_diss, spin_dissipation];

%                     load(char(strcat(filename, 'b_', string(iter_3), '_', string(iter_4), '_', string(iter_5), '/data_', string(iter_6), '.mat')))
%                     stats_2 = [stats_2, statistics];
%                     hist_2 = [hist_2, spin_hist];
                load(char(strcat(filename, string(iter_3), '_', string(iter_4), '_', string(iter_5), '/data_', string(iter_6), '.mat')))
                stats_2 = [stats_2, statistics];
                hist_2 = [hist_2, spin_hist];
                flips_2 = [flips_2, flip_counts];
                spin_diss_2 = [spin_diss_2, spin_dissipation];
                
            end
            load(char(strcat(filename, string(iter_3), '_', string(iter_4), '_', string(iter_5), '/extra_data.mat')))
            
            if random_order(300) == 1
                final_configs = [final_configs, spins];
                num_considered = num_considered + 1;
            end
       
        end
    end
end

mean_hamming_dist = 0;
hamming_dists = [];

for i = 1:(floor(num_considered / 2))
    
    mean_hamming_dist = mean_hamming_dist + mean(sum(abs(final_configs - circshift(final_configs, i, 2)) / 2, 1));
    hamming_dists = [hamming_dists, sum(abs(final_configs - circshift(final_configs, i, 2)) / 2, 1)];
    
end

mean_hamming_dist = mean_hamming_dist / num_considered;

figure()
histogram(hamming_dists(:))
