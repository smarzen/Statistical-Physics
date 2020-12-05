% filename = 'spin_glass_poisson_2016_12_06_3_36/driving_enabled_';
% t_max = 100000
% filename = 'spin_glass_poisson_2016_12_07_2_46/driving_enabled_';
% t_max = 1000000
% filename = 'spin_glass_poisson_2016_12_09_12_31/driving_enabled_';
% internal energy measured separately
% filename = 'spin_glass_poisson_2016_12_09_3_46/driving_enabled_';
% new equilibration, barriers instead of rates
% filename = 'spin_glass_poisson_2017_01_17_10_32/driving_enabled_';
%test of total_spin_work
% filename = 'spin_glass_switch_fields_switch_drive_2018_03_06_4_31/same_field_';
filename = 'spin_glass_switch_fields_vae_rand_init_subset_drive_2019_10_18_4_51/random_order_';
% instrinsic flip rates, two drives

plot_title = 'fixed';

mean_frac_aligned = zeros(1, 299);

mean_numbers = zeros(1, 10000);
mean_times = zeros(1, 10000);
totals = zeros(1, 10000);

mean_states = zeros(1, 2900);
mean_revisits = zeros(1, 2900);
mean_durations = zeros(1, 2900);

statistic = [];
final_stats = [];
final_std = [];
plot_colors = [linspace(0, 1, 10); zeros(1, 10); linspace(1, 0, 10)]';

load(char(strcat(filename, string(1), '_', string(1), '_', string(1), '/extra_data.mat')))

stat_means_i = {};
stat_means_f = {};
number_fields = [2, 3, 5, 7, 10, 12, 15, 20, 25, 30];
for iter_4 = 1:10
    stat_means_i{iter_4} = zeros(1, numel(0:100:t_max));
    stat_means_f{iter_4} = zeros(1, numel(10:100:t_max));
%     stat_means_f{iter_4} = zeros(1, 600);
    stat_means_2_i{iter_4} = zeros(1, numel(0:100:t_max));
    stat_means_2_f{iter_4} = zeros(1, numel(0:100:t_max));
end
% stat_sq_mean = [];

has_flips = zeros(10, 10, 32);

num_extract = 500;
% fprintf(config_id, '%u %u\n', num_extract * 100, num_spins);
% fprintf(field_id, '%u %u\n', num_extract * 100, num_spins);
% fprintf(stat_id, '%u\n', num_extract * 100);


for iter_3 = 1:num_extract
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
            [temp, t_index, temp_2] = unique(stats(1, :));
            
            state = initial_spins;
            t = 0;
            states = containers.Map('KeyType', 'char', 'ValueType', 'double');
            state_number = [];
            state_time = [];
            iter_6 = 1;
            last_state = 0;
            state_snaps = [];
            revisit_snaps = [];
            duration_snaps = [];
            
            frac_aligned = [];
            for next_t = 100:100:29900
                while flip_times(iter_6) < next_t
                    state(flip_order(iter_6)) = state(flip_order(iter_6)) * -1;
                    iter_6 = iter_6 + 1;
                end

                field_number = random_order(floor(next_t / switch_time));
                field_config = driving_fields(:, field_number);
%                 prev_field_number = random_order(floor(next_t / switch_time) - 1);
%                 prev_field_config = driving_fields(:, prev_field_number);
                current_stats = statistics(:, floor(next_t / save_time) + 1);
                frac_aligned = [frac_aligned, sum((field_config .* state) < 0) / num_spins];
                
%                 fprintf(prev_field_id, '\n');
            end
            
            mean_frac_aligned = mean_frac_aligned + frac_aligned;
            
        end
    end
end

mean_frac_aligned = mean_frac_aligned / num_extract;

figure()
plot(mean_frac_aligned, 'LineWidth', 2)
set(gca, 'FontSize', 10)
%title('mean fraction of spins aligned with field')
xlabel('Field switches', 'FontSize', 20, 'FontName', 'Times New Roman')
ylabel('Spin fraction aligned with field', 'FontSize', 20, 'FontName', 'Times New Roman')
