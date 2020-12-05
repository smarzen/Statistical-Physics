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
filename = 'spin_glass_switch_fields_string_order_drive_quarter_per_rand_corr_2019_01_15_8_02/random_order_';
% instrinsic flip rates, two drives

plot_title = 'fixed';

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

for iter_3 = 1:10
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
            
            for next_t = 10:10:29000
                while flip_times(iter_6) < next_t
                    exists = false;
                    index = 0;
%                     for iter_7 = 1:size(states, 2)
%                         if state == states(:, iter_7)
%                             exists = true;
%                             index = iter_7;
%                         end
%                     end
                    if states.isKey(mat2str(state))
                        exists = true;
                        index = states(mat2str(state));
                    end
                    if ~exists
                        index = 1.0 + states.Count;
                        states(mat2str(state)) = index;
%                         states = [states, state];
%                         index = size(states, 2);
                        state_number(index) = 0;
                        state_time(index) = 0;
                    end
                    state_number(index) = state_number(index) + 1;
                    state_time(index) = state_time(index) + flip_times(iter_6) - t;
                    t = flip_times(iter_6);
                    state(flip_order(iter_6)) = state(flip_order(iter_6)) * -1;
                    iter_6 = iter_6 + 1;
                    last_state = index;
                    last_revisit = state_number(index);
                    last_duration = state_time(index);
                end
                state_snaps = [state_snaps, last_state];
                revisit_snaps = [revisit_snaps, last_revisit];
                duration_snaps = [duration_snaps, last_duration];
            end
%             
%             figure(31)
%             hold on
%             plot(revisit_snaps)
            
            mean_states = mean_states + typecast(state_snaps, 'double');
            mean_revisits = mean_revisits + revisit_snaps;
            mean_durations = mean_durations + duration_snaps;
            
%             mean_numbers(1:numel(state_number)) = mean_numbers(1:numel(state_number)) + state_number;
%             mean_times(1:numel(state_time)) = mean_times(1:numel(state_time)) + state_time;
%             totals(1:numel(state_time)) = totals(1:numel(state_time)) + 1;
            

%             load(char(strcat(filename, string(iter_4), '_', string(iter_5), '/extra_data.mat')))
%             interp_stats = diff(interp1(stats(1, t_index), stats(5, t_index), 0:100:t_max));
             interp_stats = interp1(stats(1, t_index), stats(8, t_index), 10:100:t_max);
%              interp_stats = interp_stats(1:(end - 1)) .* interp_stats(2:end) / mean(interp_stats .^2);

            [temp, t_index, temp_2] = unique(stats_2(1, :));
            interp_stats_2 = interp1(stats_2(1, t_index), stats_2(3, t_index), 0:100:t_max);

%             interp_stats_2 = interp1(stats_2(1, t_index), stats_2(3, t_index), 0:1000:t_max);
            
            
%             interp_stats_4 = interp1(stats_2(1, t_index), stats_2(3, t_index), 0:100:t_max);
% % %             
%             interp_stats = interp1(stats(1, t_index), spin_diss(1:32, t_index)', 0:100:t_max);
%             interp_stats = interp_stats';
%             interp_stats_2 = interp1(stats_2(1, t_index), spin_diss_2(1:32, t_index)', 0:100:t_max);
%             interp_stats_2 = interp_stats_2';
%             
%             interp_hist = interp1(stats(1, t_index)', hist(:, t_index)', 0:100:t_max);
% %             interp_hist_2 = interp1(stats_2(1, t_index)', hist_2(:, t_index)', 0:100:t_max);
%             
%             interp_hist = interp_hist';
            
%             interp_flips = diff(interp1(stats(1, t_index)', flips(:, t_index)', 0:100:t_max), 1, 1);
%             interp_flips = interp_flips';
%             slow_flips_i = mean(interp_flips(1:floor(num_spins / 2), 1:100));
%             slow_flips_f = mean(interp_flips(1:floor(num_spins / 2), 4950:5050));
%             fast_flips_i = mean(interp_flips((floor(num_spins / 2) + 1):end, 1:100));
%             fast_flips_f = mean(interp_flips((floor(num_spins / 2) + 1):end, 4950:5050));

%             reshape_stats = reshape(interp_stats(1:(floor(numel(interp_stats) / size(driving_fields, 2)) * size(driving_fields, 2))), [], size(driving_fields, 2));
%             reshape_stats_2 = reshape(interp_stats_2(1:(floor(numel(interp_stats_2) / size(driving_fields, 2)) * size(driving_fields, 2))), [], size(driving_fields, 2));
            
            if iter_5 > 0
                if iter_5 <= 64 %&& flips_2(iter_5, end) > 10
%                     stat_means_i{1} = [stat_means_i{1}, mean(interp_stats_2((end - 199):(end - 99)))];
%                     stat_means_i{iter_3} = [stat_means_i{iter_3}, sum(flips(33:64, end) - flips(33:64, (end - 1000)))];%
%                     stat_means_f{iter_3} = [stat_means_f{iter_3}, sum(flips_2(33:64, end) - flips_2(33:64, (end - 1000)))];%
%                     stat_means_i{iter_3} = [stat_means_i{iter_3}, mean(interp_stats(:, (end - 99):end), 2)];
%                     stat_means_f{iter_3} = [stat_means_f{iter_3}, mean(interp_stats_2(:, (end - 99):end), 2)];
                    
%                     stat_means_i{iter_3} = [stat_means_i{iter_3}, mean(interp_stats((end - 99):end))];
%                     stat_means_f{iter_3} = [stat_means_f{iter_3}, mean(interp_stats_2((end - 99):end))];
                    
%                     stat_means_i{iter_5} = stat_means_i{iter_5} + mean(reshape_stats(floor(size(reshape_stats, 1) / 2):end, :), 1);
%                     interp_stats = reshape(interp_stats, 5, 600);
                    stat_means_f{iter_5} = stat_means_f{iter_5} + interp_stats; %std(interp_stats, 0, 1);
                    
%                     stat_means_i{iter_3} = [stat_means_i{iter_3}, mean(abs(mean(interp_stats(:, 101:200), 2) - mean(interp_stats(:, 1:100), 2)))];
%                     stat_means_f{iter_3} = [stat_means_f{iter_3}, mean(abs(mean(interp_stats(:, 901:end), 2) - mean(interp_stats(:, 801:900), 2)))];

%                     stat_means_i{iter_3} = [stat_means_i{iter_3}, interp_stats(:, 100)' - interp_stats(:, 1)'];
%                     stat_means_f{iter_3} = [stat_means_f{iter_3}, interp_stats(:, end)' - interp_stats(:, end - 99)'];
%                     
%                     stat_means_2_i{iter_5} = stat_means_2_i{iter_5} + mean(reshape_stats_2(floor(size(reshape_stats, 1) / 2):end, :), 1);
                    stat_means_2_f{iter_5} = stat_means_2_f{iter_5} + interp_stats_2;

%                     stat_means_2_i{iter_3} = [stat_means_2_i{iter_3}, interp_stats_2(:, 100)' - interp_stats_2(:, 1)'];
%                     stat_means_2_f{iter_3} = [stat_means_2_f{iter_3}, interp_stats_2(:, end)' - interp_stats_2(:, end - 99)'];
                    has_flips(iter_3, iter_4, iter_5) = 1;
                elseif driving_fields(iter_5, 1) == 0
%                     stat_means_i{2} = [stat_means_i{2}, mean(interp_stats_2((end - 199):(end - 99)))];
%                     stat_means_i{2} = [stat_means_i{2}, mean(interp_stats_2((end - 99):end))];
%                     stat_means_f{2} = [stat_means_f{2}, mean(interp_stats(1:100))];
                end
            else
%                 stat_means_i{1} = [stat_means_i{1}, (flips_2(1:32, 1000) - flips_2(1:32, 1))'];
%                 stat_means_f{1} = [stat_means_f{1}, (flips_2(1:32, end) - flips_2(1:32, end - 999))'];
            end

%             stat_means_i{iter_4} = [stat_means_i{iter_4}, mean(interp_stats_2(4951:5050))];
%             stat_means_f{iter_4} = [stat_means_f{iter_4}, mean(interp_stats_2((end - 99):end))];
            
%             stat_means_f{iter_4} = [stat_means_f{iter_4}, mean(interp_stats((end - 99):end))];
%             stat_means_i{iter_4} = [stat_means_i{iter_4}, mean(interp_stats(1:100).^2) - mean(interp_stats(1:1000))^2];
%             stat_means_f{iter_4} = [stat_means_f{iter_4}, mean(interp_stats((end - 99):end).^2) - mean(interp_stats((end - 999):end))^2];
            %t, energy, internal energy, mean mag, work, heat lost,
            %internal work, hamming_dist, slow_energy
        end
%         stat_means{iter_4} = stat_means{iter_4} + mean(statistic, 1);
%         figure(2)
%         hold on
        %%plot(0:100:t_max, mean(statistic, 1), 'Color', plot_colors(iter_4, :), 'LineWidth', 1.5)
%          plot(0:1000:t_max, mean(statistic, 1), 'Color', [0, 0, 1])
%        title('mean dissipation rate', 'FontSize', 20)
%        xlabel('t', 'FontSize', 20)
%        ylabel('diss', 'FontSize', 20)
%         
%         final_stats = [final_stats, mean(statistic(:, end))];
%         final_std = [final_std, std(statistic(:, end), 1)];
%         
%         stat_mean = [stat_mean, mean(mean(statistic))];
%         stat_sq_mean = [stat_sq_mean, mean(mean(statistic .^2))];
        
        
    end
end

% figure()
% plot(mean_numbers ./ totals)
% figure()
% plot(mean_times ./ totals)

figure()
plot(mean_states / 100, 'LineWidth', 2)
xlabel('t', 'FontSize', 20)
ylabel('number state', 'FontSize', 20)

figure()
plot(mean_revisits / 100, 'LineWidth', 2)
xlabel('t', 'FontSize', 20)
ylabel('number of visits to current state', 'FontSize', 20)

figure()
plot(mean_durations / 100, 'LineWidth', 2)
xlabel('t', 'FontSize', 20)
ylabel('total duration spent in current state', 'FontSize', 20)

% 
% filename = 'spin_glass_switch_fields_min_model_gen_2018_05_02_3_05/min_model_';
% % instrinsic flip rates, two drives
% 
% plot_title = 'fixed';
% 
% statistic = [];
% final_stats = [];
% final_std = [];
% plot_colors = [linspace(0, 1, 10); zeros(1, 10); linspace(1, 0, 10)]';
% 
% stat_means_i_2 = {};
% stat_means_f_2 = {};
% for iter_4 = 1:10
%     stat_means_i_2{iter_4} = zeros(1, number_fields(iter_4));
%     stat_means_f_2{iter_4} = zeros(1, numel(0:100:t_max) -1);
%     stat_means_2_i_2{iter_4} = zeros(1, number_fields(iter_4));
%     stat_means_2_f_2{iter_4} = zeros(1, numel(0:100:t_max) -1);
% %     stat_means_i_2{iter_4} = [];
% %     stat_means_f_2{iter_4} = [];
% %     stat_means_2_i_2{iter_4} = [];
% %     stat_means_2_f_2{iter_4} = [];
% end
% % stat_sq_mean = [];
% 
% for iter_3 = 1:0 %1000
%     for iter_4 = 1:1
%         statistic = [];
%         
%         for iter_5 = 1:10
%             file_list = dir(char(strcat(filename, string(iter_3), '_', string(iter_4), '_', string(iter_5))));
% %             file_list = dir(char(strcat(filename, string(iter_4), '_', string(iter_5))));
%             stats = [];
%             hist = [];
%             flips = [];
%             spin_diss = [];
%             
%             stats_2 = [];
%             hist_2 = [];
%             flips_2 = [];
%             spin_diss_2 = [];
%             for iter_6 = 1:(numel(file_list) - 3)
%                
%                 load(char(strcat(filename, string(iter_3), '_', string(iter_4), '_', string(iter_5), 'd/data_', string(iter_6), '.mat')))
% %                 load(char(strcat(filename, string(iter_4), '_', string(iter_5), '/data_', string(iter_6), '.mat')))
%                 stats = [stats, statistics];
%                 flips = [flips, flip_counts];
%                 hist = [hist, spin_hist];
%                 spin_diss = [spin_diss, spin_dissipation];
% 
% %                     load(char(strcat(filename, 'b_', string(iter_3), '_', string(iter_4), '_', string(iter_5), '/data_', string(iter_6), '.mat')))
% %                     stats_2 = [stats_2, statistics];
% %                     hist_2 = [hist_2, spin_hist];
% 
%                 load(char(strcat(filename, string(iter_3), '_', string(iter_4), '_', string(iter_5), 'd/data_', string(iter_6), '.mat')))
%                 stats_2 = [stats_2, statistics];
%                 hist_2 = [hist_2, spin_hist];
%                 flips_2 = [flips_2, flip_counts];
%                 spin_diss_2 = [spin_diss_2, spin_dissipation];
%                 
%                 
%             end
%             load(char(strcat(filename, string(iter_3), '_', string(iter_4), '_', string(iter_5), '/extra_data.mat')))
%             [temp, t_index, temp_2] = unique(stats(1, :));
% 
% %             load(char(strcat(filename, string(iter_4), '_', string(iter_5), '/extra_data.mat')))
%             interp_stats = diff(interp1(stats(1, t_index), stats(5, t_index), 0:100:t_max));
% %             interp_stats = interp1(stats(1, t_index), stats(3, t_index), 0:100:t_max);
% %             [temp, t_index, temp_2] = unique(stats_2(1, :));
%             interp_stats_2 = diff(interp1(stats_2(1, t_index), stats_2(5, t_index), 0:100:t_max));
% %             interp_stats_2 = interp1(stats_2(1, t_index), stats_2(3, t_index), 0:100:t_max);
% %             interp_stats_4 = interp1(stats_2(1, t_index), stats_2(3, t_index), 0:100:t_max);
% 
% %             interp_stats = interp1(stats(1, t_index), spin_diss(1:32, t_index)', 0:100:t_max);
% %             interp_stats = interp_stats';
% %             interp_stats_2 = interp1(stats_2(1, t_index), spin_diss(1:32, t_index)', 0:100:t_max);
% %             interp_stats_2 = interp_stats_2';
%                 
%             
% %             interp_hist = interp1(stats(1, t_index)', hist(:, t_index)', 0:100:t_max);
% % %             interp_hist_2 = interp1(stats_2(1, t_index)', hist_2(:, t_index)', 0:100:t_max);
% %             
% %             interp_hist = interp_hist';
%             
% %             interp_flips = diff(interp1(stats(1, t_index)', flips(:, t_index)', 0:100:t_max), 1, 1);
% %             interp_flips = interp_flips';
% %             slow_flips_i = mean(interp_flips(1:floor(num_spins / 2), 1:100));
% %             slow_flips_f = mean(interp_flips(1:floor(num_spins / 2), 4950:5050));
% %             fast_flips_i = mean(interp_flips((floor(num_spins / 2) + 1):end, 1:100));
% %             fast_flips_f = mean(interp_flips((floor(num_spins / 2) + 1):end, 4950:5050));
%             
%             if iter_5 > 0
%                 if iter_5 <= 64 %&& has_flips(iter_3, iter_4, iter_5) == 1
% %                     stat_means_i{1} = [stat_means_i{1}, mean(interp_stats_2((end - 199):(end - 99)))];
% %                     stat_means_i_2{iter_3} = [stat_means_i_2{iter_3}, sum(flips(33:64, end) - flips(33:64, (end - 1000)))];%
% %                     stat_means_f_2{iter_3} = [stat_means_f_2{iter_3}, sum(flips_2(33:64, end) - flips_2(33:64, (end - 1000)))];%
% %                     stat_means_i_2{iter_3} = [stat_means_i_2{iter_3}, mean(interp_stats(:, (end - 99):end), 2)];
% %                     stat_means_f_2{iter_3} = [stat_means_f_2{iter_3}, mean(interp_stats(:, (end - 99):end), 2)];
%                     
% %                     stat_means_i_2{iter_3} = [stat_means_i_2{iter_3}, mean(interp_stats(1:100))];
% %                     stat_means_f_2{iter_3} = [stat_means_f_2{iter_3}, mean(interp_stats((end - 99):end))];
%                     
% %                     stat_means_i_2{iter_3} = [stat_means_i_2{iter_3}, mean(interp_stats(1:100))];
%                     stat_means_f_2{iter_5} = stat_means_f_2{iter_5} + interp_stats;
% 
% %                     stat_means_i_2{iter_3} = [stat_means_i_2{iter_3}, mean(abs(mean(interp_stats(:, 101:200), 2) - mean(interp_stats(:, 1:100), 2)))];
% %                     stat_means_f_2{iter_3} = [stat_means_f_2{iter_3}, mean(abs(mean(interp_stats(:, 901:end), 2) - mean(interp_stats(:, 801:900), 2)))];
% 
% %                     stat_means_i_2{iter_3} = [stat_means_i_2{iter_3}, interp_stats(:, 100)' - interp_stats(:, 1)'];
% %                     stat_means_f_2{iter_3} = [stat_means_f_2{iter_3}, interp_stats(:, end)' - interp_stats(:, end - 99)'];
%                     
% %                     stat_means_2_i_2{iter_3} = [stat_means_2_i_2{iter_3}, mean(interp_stats_2(1:100))];
%                     stat_means_2_f_2{iter_5} = stat_means_2_f_2{iter_5} + interp_stats_2;
%                 elseif driving_fields(iter_5, 1) == 0
% %                     stat_means_i{2} = [stat_means_i{2}, mean(interp_stats_2((end - 199):(end - 99)))];
% %                     stat_means_i{2} = [stat_means_i{2}, mean(interp_stats_2((end - 99):end))];
% %                     stat_means_f{2} = [stat_means_f{2}, mean(interp_stats(1:100))];
%                 end
%             else
% %                 stat_means_i{1} = [stat_means_i{1}, (flips_2(1:32, 1000) - flips_2(1:32, 1))'];
% %                 stat_means_f{1} = [stat_means_f{1}, (flips_2(1:32, end) - flips_2(1:32, end - 999))'];
%             end
% 
% %             stat_means_i{iter_4} = [stat_means_i{iter_4}, mean(interp_stats_2(4951:5050))];
% %             stat_means_f{iter_4} = [stat_means_f{iter_4}, mean(interp_stats_2((end - 99):end))];
%             
% %             stat_means_f{iter_4} = [stat_means_f{iter_4}, mean(interp_stats((end - 99):end))];
% %             stat_means_i{iter_4} = [stat_means_i{iter_4}, mean(interp_stats(1:100).^2) - mean(interp_stats(1:1000))^2];
% %             stat_means_f{iter_4} = [stat_means_f{iter_4}, mean(interp_stats((end - 99):end).^2) - mean(interp_stats((end - 999):end))^2];
%             %t, energy, internal energy, mean mag, work, heat lost,
%             %internal work, hamming_dist, slow_energy
%         end
% %         stat_means{iter_4} = stat_means{iter_4} + mean(statistic, 1);
% %         figure(2)
% %         hold on
%         %%plot(0:100:t_max, mean(statistic, 1), 'Color', plot_colors(iter_4, :), 'LineWidth', 1.5)
% %          plot(0:1000:t_max, mean(statistic, 1), 'Color', [0, 0, 1])
% %        title('mean dissipation rate', 'FontSize', 20)
% %        xlabel('t', 'FontSize', 20)
% %        ylabel('diss', 'FontSize', 20)
% %         
% %         final_stats = [final_stats, mean(statistic(:, end))];
% %         final_std = [final_std, std(statistic(:, end), 1)];
% %         
% %         stat_mean = [stat_mean, mean(mean(statistic))];
% %         stat_sq_mean = [stat_sq_mean, mean(mean(statistic .^2))];
%         
%         
%     end
% end

% all_means_i = [];
% all_means_i_2 = [];
% all_means_f = [];
% all_means_f_2 = [];
% all_means_2_i = [];
% all_means_2_f = [];
% all_means_2_i_2 = [];
% all_means_2_f_2 = [];
% 
% diff_means = [];
% diff_stds = [];
% diff_frac = [];
% 
% low_diss_fraction = [];
% 
% for iter_4 = 1:5
% %     figure(13)
% %     hold on
% %     scatter(stat_means_i{iter_4}, stat_means_f{iter_4}, 'filled')%, 'MarkerEdgeColor', plot_colors(iter_4, :))
% %     
% %     
% %     xlabel('pre-switch dissipation', 'FontSize', 20)
% %     ylabel('post-switch dissipation', 'FontSize', 20)
% %     title('unfixed', 'FontSize', 20)
% %     
% %     figure(14)
% %     hold on
% %     scatter(stat_means_i_2{iter_4}, stat_means_f_2{iter_4}, 'filled')%, 'MarkerEdgeColor', plot_colors(iter_4, :))
% %     
% %     
% %     xlabel('pre-switch dissipation', 'FontSize', 20)
% %     ylabel('post-switch dissipation', 'FontSize', 20)
% %     title('fixed', 'FontSize', 20)
% %     
% %     
% %     mean_pre_switch(iter_4) = mean(stat_means_i{iter_4});
% %     std_pre_switch(iter_4) = std(stat_means_i{iter_4});
% %     
% %     mean_post_switch(iter_4) = mean(stat_means_f{iter_4});
% %     std_post_switch(iter_4) = std(stat_means_f{iter_4});
% %     
% %     randomized_means_f_2 = stat_means_f_2{iter_4};
% %     randomized_means_f_2 = randomized_means_f_2(randperm(numel(randomized_means_f_2)));
%     
% %     figure(2 + iter_4)
% %     hold on
% %     histogram(stat_means_f{iter_4} - stat_means_f_2{iter_4}, -15.25:.5:15.25, 'Normalization', 'probability')
% %     histogram(stat_means_f{iter_4} - randomized_means_f_2, -15.25:.5:15.25, 'Normalization', 'probability')
% % %     histogram(stat_means_f{iter_4}, -.25:.5:19.75, 'Normalization', 'probability')
% %     title('diff between fixed and unfixed', 'FontSize', 20)
% %     xlabel('fixed post-switch dissipation', 'FontSize', 20)
% %     ylabel('unfixed post-switch dissipation', 'FontSize', 20)
% 
%     all_means_i = [all_means_i, stat_means_i{iter_4}];
% %     all_means_i_2 = [all_means_i_2, stat_means_i_2{iter_4}];
%     all_means_f = [all_means_f, stat_means_f{iter_4}];
% %     all_means_f_2 = [all_means_f_2, stat_means_f_2{iter_4}];
% %     diff_means = [diff_means, mean(abs(stat_means_f_2{iter_4} - stat_means_f{iter_4}))];
% %     diff_stds = [diff_stds, std(stat_means_f_2{iter_4} - stat_means_f{iter_4})];
% %     diff_frac = [diff_frac, sum(abs(stat_means_f_2{iter_4} - stat_means_f{iter_4}) > 5) / 300];
%     all_means_2_i = [all_means_2_i, stat_means_2_i{iter_4}];
%     all_means_2_f = [all_means_2_f, stat_means_2_f{iter_4}];
% %     all_means_2_i_2 = [all_means_2_i_2, stat_means_2_i_2{iter_4}];
% %     all_means_2_f_2 = [all_means_2_f_2, stat_means_2_f_2{iter_4}];
% 
% %     exp_fit = @(x)sum((stat_means_f{iter_4}(101:1000) - (x(1) * exp((101:1000) * x(2)) + x(3))).^2);
% %     exp_fit_2 = @(x)sum((stat_means_2_f{iter_4} - (x(1) * exp((1:1000) * x(2)) + x(3))).^2);
% %     
% %     fit_1 = fminsearch(exp_fit, [2.5E5, .1, .5E5]);
%     
%     field_numbers = [2, 3, 5, 7, 10];
%     figure(31)
%     hold on
% %     plot(100:100:t_max, [stat_means_f{iter_4}], 'LineWidth', 2)%, 'Color', [iter_4 / 5, 0, 1 - iter_4 / 5])
%     plot([stat_means_f{iter_4}] / iter_3, 'LineWidth', 2, 'Color', [iter_4 / 5, 0, 1 - iter_4 / 5])
% %     plot([stat_means_f{iter_4} / ((field_numbers(iter_4) - 1) / field_numbers(iter_4))], 'LineWidth', 2, 'Color', [iter_4 / 5, 0, 1 - iter_4 / 5])
% 
% %     figure(10)
% %     subplot(3, 4, iter_4)
% %     hold off
% %     plot(stat_means_f{iter_4}, '-b', 'LineWidth', 2)
% %     hold on
% % %     plot(1:1000, fit_1(1) * exp((1:1000) * fit_1(2)) + fit_1(3), '-r', 'LineWidth', 2)
% %     
% %     figure(11)
% %     subplot(3, 4, iter_4)
% %     hold off
% %     plot(stat_means_2_f{iter_4}, '-b', 'LineWidth', 2)
% %     hold on
%     
% %     figure(26)
% %     subplot(3, 4, iter_4)
% %     hold off
% % %     histogram(stat_means_i{iter_4}, -50:10:400, 'Normalization', 'probability')
% %     plot(stat_means_i{iter_4}, '-b', 'LineWidth', 2)
% %     hold on
% %     histogram(stat_means_f{iter_4}, -50:10:400, 'Normalization', 'probability')
% %     plot(100:100:t_max, stat_means_i{iter_4} + (stat_means_f{iter_4} - stat_means_i{iter_4}.^2), '--b', 'LineWidth', 2)
% %     plot(100:100:t_max, stat_means_i{iter_4} - (stat_means_f{iter_4} - stat_means_i{iter_4}.^2), '--b', 'LineWidth', 2)
%     
% %     figure(27)
% %     subplot(3, 4, iter_4)
% %     hold off
% % %     histogram(stat_means_2_i{iter_4}, -50:10:400, 'Normalization', 'probability')
% %     plot(stat_means_2_i{iter_4}, '-b', 'LineWidth', 2)
% %     hold on
% %     histogram(stat_means_2_f{iter_4}, -50:10:400, 'Normalization', 'probability')
% %     plot(100:100:t_max, stat_means_2_i{iter_4} + (stat_means_2_f{iter_4} - stat_means_2_i{iter_4}.^2), '--b', 'LineWidth', 2)
% %     plot(100:100:t_max, stat_means_2_i{iter_4} - (stat_means_2_f{iter_4} - stat_means_2_i{iter_4}.^2), '--b', 'LineWidth', 2)
%     
% %     low_diss_fraction = [low_diss_fraction, sum(stat_means_f{iter_4} < 10) / numel(stat_means_2_f{iter_4})];
%     
% %     figure(2)
% %     hold on
% %     histogram(stat_means_i{iter_4}, 25, 'FaceColor', plot_colors(iter_4, :))
% %     
% %     figure(3)
% %     hold on
% %     histogram(stat_means_f{iter_4} - stat_means_i{iter_4}, -10.5:1:10.5, 'FaceColor', plot_colors(iter_4, :))
% %     title('switching set of \mu''s ', 'FontSize', 20)
%     
% %     figure(iter_4)
% %     histogram(stat_means_i{iter_4}, -1:20, 'Normalization', 'probability', 'FaceColor', plot_colors(iter_4, :))
% %     title('initial dissipation rate')
% %     figure(iter_4 + 3)
% %     histogram(stat_means_f{iter_4}, -1:20, 'Normalization', 'probability', 'FaceColor', plot_colors(iter_4, :))
% %     title('final dissipation rate')
% %     figure(iter_4 + 10)
% %     histogram(stat_means_f{iter_4} - stat_means_i{iter_4}, 25, 'Normalization', 'probability', 'FaceColor', plot_colors(iter_4, :))
% %     title('final - initial dissipation rate')
%     
% %     plot(0:1000:t_max, stat_means{iter_4}, 'Color', plot_colors(iter_4, :), 'LineWidth', 1)
% %     plot(1000:1000:t_max, diff(stat_means{iter_4}), 'Color', plot_colors(iter_4, :), 'LineWidth', 1)
% end
% 
% % figure(19)
% % leg = legend({'2', '3', '5', '7', '10'}, 'FontSize', 16);
% % title(leg, 'number of driving fields')
% % xlabel('time', 'FontSize', 20)
% % ylabel('internal energy', 'FontSize', 20)
% % title('internal energy over time', 'FontSize', 20)
% 
% % figure(6)
% % hold on
% % plot(low_diss_fraction)
% 
% % figure(1)
% % hold off
% % histogram(all_means_f, 'Normalization', 'probability')
% % hold on
% % histogram(all_means_f_2, 'Normalization', 'probability')
% % 
% % figure(2)
% % hold off
% % histogram(all_means_i, 'Normalization', 'probability')
% % hold on
% % histogram(all_means_f, 'Normalization', 'probability')
% % 
% % figure(3)
% % hold off
% % histogram(all_means_i_2, 'Normalization', 'probability')
% % hold on
% % histogram(all_means_f_2, 'Normalization', 'probability')
% 
% % figure(5)
% % hold off
% % histogram(all_means_i, 'Normalization', 'probability', 'FaceColor', [0, 0, 1])
% % hold on
% % histogram(all_means_f, 'Normalization', 'probability', 'FaceColor', [0, 1, .6])
% % xlabel('work absorption rate', 'FontSize', 20)
% % ylabel('p(work absorption rate)', 'FontSize', 20)
% % title('drive 1', 'FontSize', 20)
% % legend({'initial', 'final'}, 'FontSize', 12)
% % 
% % figure(6)
% % hold off
% % histogram(all_means_i_2, 'Normalization', 'probability', 'FaceColor', [0, 0, 1])
% % hold on
% % histogram(all_means_f_2, 'Normalization', 'probability', 'FaceColor', [0, 1, .6])
% % xlabel('work absorption rate', 'FontSize', 20)
% % ylabel('p(work absorption rate)', 'FontSize', 20)
% % title('drive 1 (after drive 2)', 'FontSize', 20)
% % legend({'initial', 'final'}, 'FontSize', 12)
% % 
% % figure(7)
% % hold off
% % histogram(all_means_2_i, 'Normalization', 'probability', 'FaceColor', [0, 0, 1])
% % hold on
% % histogram(all_means_2_f, 'Normalization', 'probability', 'FaceColor', [0, 1, .6])
% % xlabel('work absorption rate', 'FontSize', 20)
% % ylabel('p(work absorption rate)', 'FontSize', 20)
% % title('drive 2 (after drive 1)', 'FontSize', 20)
% % legend({'initial', 'final'}, 'FontSize', 12)
% % 
% % figure(8)
% % hold off
% % histogram(all_means_2_i_2, 'Normalization', 'probability', 'FaceColor', [0, 0, 1])
% % hold on
% % histogram(all_means_2_f_2, 'Normalization', 'probability', 'FaceColor', [0, 1, .6])
% % xlabel('work absorption rate', 'FontSize', 20)
% % ylabel('p(work absorption rate)', 'FontSize', 20)
% % title('drive 3 (after drive 2)', 'FontSize', 20)
% % legend({'initial', 'final'}, 'FontSize', 12)
% % 
% % figure(9)
% % hold off
% % histogram(all_means_2_i - all_means_f, 'Normalization', 'probability', 'FaceColor', [0, .8, 0])
% % hold on
% % histogram(all_means_i_2 - all_means_f, 'Normalization', 'probability', 'FaceColor', [0, 0, 1])
% % legend({ 'drive 2 initial - drive 1 final', 'drive 1'' initial - drive 1 final'}, 'FontSize', 12)
% % xlabel('change in work absorption rate', 'FontSize', 20)
% % ylabel('p(change in work absorption rate', 'FontSize', 20)
% % title('system memory', 'FontSize', 20)
% 
% % figure(5)
% % hold off
% % histogram(all_means_i, 'Normalization', 'probability', 'FaceColor', [1, 0, 0])
% % hold on
% % histogram(all_means_2_i_2, 'Normalization', 'probability', 'FaceColor', [1, .41, .7])
% % xlabel('work absorption rate', 'FontSize', 20)
% % ylabel('p(work absorption rate)', 'FontSize', 20)
% % title('generated drive alone vs. after normal drive', 'FontSize', 20)
% % legend({'alone', 'after normal drive'}, 'FontSize', 12)
% % 
% % figure(6)
% % hold off
% % histogram(all_means_i_2, 'Normalization', 'probability', 'FaceColor', [0, 0, 1])
% % hold on
% % histogram(all_means_2_i, 'Normalization', 'probability', 'FaceColor', [.5, 0. .5])
% % xlabel('work absorption rate', 'FontSize', 20)
% % ylabel('p(work absorption rate)', 'FontSize', 20)
% % title('normal drive alone vs. after generated drive', 'FontSize', 20)
% % legend({'alone', 'after generated drive'}, 'FontSize', 12)
% % 
% % figure(7)
% % hold off
% % histogram(all_means_f, 'Normalization', 'probability')
% % hold on
% % histogram(all_means_2_f_2, 'Normalization', 'probability')
% % 
% % figure(8)
% % hold off
% % histogram(all_means_f_2, 'Normalization', 'probability')
% % hold on
% % histogram(all_means_2_f, 'Normalization', 'probability')
% % 
% % figure(9)
% % hold off
% % histogram(all_means_2_i, -150:-50, 'Normalization', 'probability', 'FaceColor', [1, 0, 0])
% % hold on
% % histogram(all_means_2_f, -150:-50, 'Normalization', 'probability', 'FaceColor', [1, .8, 0])
% % xlabel('internal energy', 'FontSize', 20)
% % ylabel('p(internal energy)', 'FontSize', 20)
% % title('generated drive energy', 'FontSize', 20)
% % legend({'initial', 'final'}, 'FontSize', 12)
% % 
% % figure(10)
% % hold off
% % histogram(all_means_2_i_2, -150:-50, 'Normalization', 'probability', 'FaceColor', [0, 0, 1])
% % hold on
% % histogram(all_means_2_f_2, -150:-50, 'Normalization', 'probability', 'FaceColor', [0, 1, .6])
% % xlabel('internal energy', 'FontSize', 20)
% % ylabel('p(internal energy)', 'FontSize', 20)
% % title('normal drive energy', 'FontSize', 20)
% % legend({'initial', 'final'}, 'FontSize', 12)
% % 
% % figure(11)
% % scatter(all_means_2_f - all_means_2_i, all_means_f - all_means_i, 20, [1, 0, 0], 'Filled')
% % xlabel('change in internal energy', 'FontSize', 20)
% % ylabel('change in work absorption', 'FontSize', 20)
% % title('generated drive change', 'FontSize', 20)
% % legend({'r_{pearson} = .28'}, 'FontSize', 20)
% % 
% % figure(12)
% % scatter(all_means_2_f_2 - all_means_2_i_2, all_means_f_2 - all_means_i_2, 20, [0, 0, 1], 'Filled')
% % xlabel('change in internal energy', 'FontSize', 20)
% % ylabel('change in work absorption', 'FontSize', 20)
% % title('normal drive change', 'FontSize', 20)
% % legend({'r_{pearson} = .19'}, 'FontSize', 20)
% % 
% % figure(13)
% % scatter(all_means_2_f, all_means_f, 20, [1, 0, 0], 'Filled')
% % xlabel('final internal energy', 'FontSize', 20)
% % ylabel('final work absorption', 'FontSize', 20)
% % title('generated drive energy vs. absorption', 'FontSize', 20)
% % legend({'r_{pearson} = .35'}, 'FontSize', 20)
% % 
% % figure(14)
% % scatter(all_means_2_f_2, all_means_f_2, 20, [0, 0, 1], 'Filled')
% % xlabel('final internal energy', 'FontSize', 20)
% % ylabel('final in work absorption', 'FontSize', 20)
% % title('normal drive energy vs. absorption', 'FontSize', 20)
% % legend({'r_{pearson} = .27'}, 'FontSize', 20)
% 
% % figure(53)
% % scatter(all_means_2_i, all_means_i, 'Filled')
% % 
% % figure(54)
% % scatter(all_means_2_f, all_means_f, 'Filled')
% % 
% % figure(55)
% % scatter(all_means_2_f - all_means_2_i, all_means_f - all_means_i)
% % 
% % figure(56)
% % hold off
% % histogram(all_means_2_i, 'Normalization', 'probability')
% % hold on
% % histogram(all_means_2_f, 'Normalization', 'probability')
% 
% % figure(58)
% % hold off
% % histogram(all_means_i, -10:2:300, 'Normalization', 'probability')
% % hold on
% % histogram(all_means_f, -10:2:300, 'Normalization', 'probability')
% % 
% % figure(59)
% % hold off
% % histogram(all_means_2_i, -140:2.5:-70, 'Normalization', 'probability')
% % hold on
% % histogram(all_means_2_f, -140:2.5:-70, 'Normalization', 'probability')
% 
% % figure(29)
% % hold off
% % histogram(all_means_i, 'Normalization', 'probability')
% % hold on
% % histogram(all_means_f, 'Normalization', 'probability')
% % 
% % figure(30)
% % hold off
% % histogram(all_means_2_i, 'Normalization', 'probability')
% % hold on
% % histogram(all_means_2_f, 'Normalization', 'probability')
% % 
% % figure(31)
% % hold off
% % histogram(all_means_i_2, 'Normalization', 'probability')
% % hold on
% % histogram(all_means_f_2, 'Normalization', 'probability')
% 
% % figure(33)
% % hold off
% % histogram(log(all_means_f(all_means_i > 0 & all_means_f > 0) ./ all_means_i(all_means_i > 0 & all_means_f > 0)), 'Normalization', 'probability')
% 
% % figure(45)
% % hold off
% % histogram(all_means_i, 'Normalization', 'probability')
% % hold on
% % histogram(all_means_f, 'Normalization', 'probability')
% % xlabel('work absorption rate', 'FontSize', 20)
% % ylabel('p(work absorption rate', 'FontSize', 20)
% % title('drive 1', 'FontSize', 20)
% % 
% % figure(46)
% % hold off
% % histogram(all_means_2_i, 'Normalization', 'probability')
% % hold on
% % histogram(all_means_2_f, 'Normalization', 'probability')
% % xlabel('work absorption rate', 'FontSize', 20)
% % ylabel('p(work absorption rate', 'FontSize', 20)
% % title('drive 2 (after drive 1)', 'FontSize', 20)
% % 
% % figure(47)
% % hold off
% % histogram(all_means_i_2, 'Normalization', 'probability')
% % hold on
% % histogram(all_means_f_2, 'Normalization', 'probability')
% % xlabel('work absorption rate', 'FontSize', 20)
% % ylabel('p(work absorption rate', 'FontSize', 20)
% % title('drive 1 (after drive 2)', 'FontSize', 20)
% % 
% % figure(48)
% % hold off
% % histogram(all_means_2_i_2, 'Normalization', 'probability')
% % hold on
% % histogram(all_means_2_f_2, 'Normalization', 'probability')
% % xlabel('work absorption rate', 'FontSize', 20)
% % ylabel('p(work absorption rate', 'FontSize', 20)
% % title('drive 3 (after drive 2)', 'FontSize', 20)
% 
% % figure(41)
% % hold off
% % histogram(all_means_2_f - all_means_f, 'Normalization', 'probability')
% % 
% % figure(42)
% % histogram(all_means_f_2 - all_means_f, 'Normalization', 'probability')
% % 
% % figure(43)
% % histogram(all_means_2_f_2 - all_means_f, 'Normalization', 'probability')
% 
% % figure(44)
% % hold off
% % histogram(all_means_i_2, 'Normalization', 'probability')
% % hold on
% % histogram(all_means_2_i, 'Normalization', 'probability')
% 
% %
% % bucket_size = 1;
% % bucket_min = -1;
% % same_bucket = zeros([1, 25]);
% % total_bucket = zeros([1, 25]);
% % for iter_6 = 1:5000
% %     if abs(all_means_f_2(iter_6) - all_means_i(iter_6)) < 1
% %         same_bucket(floor((all_means_i(iter_6) - bucket_min) / bucket_size) + 1) = same_bucket(floor((all_means_i(iter_6) - bucket_min) / bucket_size) + 1) + 1;
% %     end
% %     total_bucket(floor((all_means_i(iter_6) - bucket_min) / bucket_size) + 1) = total_bucket(floor((all_means_i(iter_6) - bucket_min) / bucket_size) + 1) + 1;
% % end
% % figure(6)
% % bar(0:24, same_bucket ./ total_bucket)
% % xlabel('work absorption rate', 'FontSize', 20)
% % ylabel('p(work abs rate in drive 1 #2 - drive 1 #1 < 1)', 'FontSize', 20)
% % title('memory vs. pre-freezing work absorption rate', 'FontSize', 20)
% % 
% % figure(8)
% % bar(total_bucket)
% % 
% % bucket_size = 1;
% % bucket_min = -1;
% % same_bucket = zeros([1, 25]);
% % total_bucket = zeros([1, 25]);
% % for iter_6 = 1:5000
% %     if abs(all_means_i_2(iter_6) - all_means_i(iter_6)) < 1
% %         same_bucket(floor((all_means_i(iter_6) - bucket_min) / bucket_size) + 1) = same_bucket(floor((all_means_i(iter_6) - bucket_min) / bucket_size) + 1) + 1;
% %     end
% %     total_bucket(floor((all_means_i(iter_6) - bucket_min) / bucket_size) + 1) = total_bucket(floor((all_means_i(iter_6) - bucket_min) / bucket_size) + 1) + 1;
% % end
% % figure(7)
% % bar(0:24, same_bucket ./ total_bucket)
% % xlabel('work absorption rate', 'FontSize', 20)
% % ylabel('p(work abs rate in drive 2 - drive 1 < 1)', 'FontSize', 20)
% % title('specificity vs. pre-freezing work absorption rate', 'FontSize', 20)
% 
% 
% % bucket_size = 1;
% % buckets = zeros(1000);
% % min_x_index = floor(min(all_means_f) / 2);
% % min_y_index = floor(min(all_means_2_f_2) / 2);
% % 
% % for iter_6 = 1:numel(all_means_f)
% %     buckets(floor(all_means_f(iter_6) / bucket_size) - min_x_index + 1, floor(all_means_2_f_2(iter_6) / bucket_size) - min_y_index + 1) = buckets(floor(all_means_f(iter_6) / bucket_size) - min_x_index + 1, floor(all_means_2_f_2(iter_6) / bucket_size) - min_y_index + 1) + 1;
% % end
% % 
% % norm_buckets = buckets ./ sum(buckets);
% % norm_buckets = norm_buckets(end:-1:1, :);
% % figure(19)
% % imshow(buckets / max(max(buckets)))
% % 
% % figure(20)
% % imshow(norm_buckets)
% 
% 
% 
