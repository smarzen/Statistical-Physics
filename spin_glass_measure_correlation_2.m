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
filename = 'spin_glass_switch_fields_perturb_slow_2017_11_08_10_20/random_driving_';
% instrinsic flip rates, two drives

load(char(strcat(filename, string(1), '_', string(1), '_', string(0), '/extra_data.mat')))

fields = mod(cumsum([1, random_order]), 5);
fields(fields == 0) = 5;

statistic = [];
final_stats = [];
final_std = [];
plot_colors = [linspace(0, 1, 5); zeros(1, 5); linspace(1, 0, 5)]';

slow_mean_i = [];
slow_mean_f = [];
fast_mean_i = [];
fast_mean_f = [];

results = [];

stat_means_i = {};
stat_means_f = {};
for iter_4 = 1:10
    stat_means_i{iter_4} = 0;
    stat_means_f{iter_4} = 0;
end

number_fields = [2, 6, 12, 20, 56, 132, 306, 600];
relevant_times = (find(fields == 1)) * switch_time / save_time + 1;
relevant_times = relevant_times(relevant_times < (t_max / save_time));

for iter_3 = 1:10
    for iter_4 = 1:10
        statistic = [];
        for iter_5 = 0:0
            file_list = dir(char(strcat(filename, string(iter_3), '_', string(iter_4), '_', string(iter_5))));
%             file_list = dir(char(strcat(filename, string(iter_4), '_', string(iter_5))));
            stats = [];
            diss = [];
            hist = [];
            
            stats_2 = [];
            hist_2 = [];
            for iter_6 = 1:(numel(file_list) - 3)
                load(char(strcat(filename, string(iter_3), '_', string(iter_4), '_', string(iter_5), '/data_', string(iter_6), '.mat')))
%                 load(char(strcat(filename, string(iter_4), '_', string(iter_5), '/data_', string(iter_6), '.mat')))
                stats = [stats, statistics];
                diss = [diss, spin_dissipation];
                hist = [hist, spin_hist];
                
%                 load(char(strcat(filename, 'b_', string(iter_3), '_', string(iter_4), '_', string(iter_5), '/data_', string(iter_6), '.mat')))
%                 stats_2 = [stats_2, statistics];
%                 hist_2 = [hist_2, spin_hist];
            end
            [temp, t_index, temp_2] = unique(stats(1, :));
            load(char(strcat(filename, string(iter_3), '_', string(iter_4), '_', string(iter_5), '/extra_data.mat')))
            
            relevant_hist = hist(:, relevant_times);
            initial_std = std(relevant_hist(:, 1:100), 0, 2);
            final_std = std(relevant_hist(:, 101:end), 0, 2);
            
%             relevant_hist_2 = hist_2(:, relevant_times);
%             initial_std_2 = std(relevant_hist_2(:, 1:800), 0, 2);
%             final_std_2 = std(relevant_hist_2(:, 801:end), 0, 2);
            
            slow_mean_i = mean(initial_std(1:floor(num_spins / 2)));
            slow_mean_f = mean(final_std(1:floor(num_spins / 2)));
            fast_mean_i = mean(initial_std((floor(num_spins / 2) + 1):end));
            fast_mean_f = mean(final_std((floor(num_spins / 2) + 1):end));
            
%             slow_mean_i_2 = mean(initial_std_2(1:floor(num_spins / 2)));
%             slow_mean_f_2 = mean(final_std_2(1:floor(num_spins / 2)));
%             fast_mean_i_2 = mean(initial_std_2((floor(num_spins / 2) + 1):end));
%             fast_mean_f_2 = mean(final_std_2((floor(num_spins / 2) + 1):end));
            
            stat_means_i{iter_3} = [stat_means_i{iter_3}, slow_mean_i];
            stat_means_f{iter_3} = [stat_means_f{iter_3}, slow_mean_f];
            
            
%             load(char(strcat(filename, string(iter_4), '_', string(iter_5), '/extra_data.mat')))
%             statistic = [statistic; interp1(stats(1, t_index), stats(3, t_index), 0:1000:t_max)];
            %t, energy, internal energy, mean mag, work, heat lost, internal work
        end
%         figure(2)
%         hold on
%         %%plot(0:100:t_max, mean(statistic, 1), 'Color', plot_colors(iter_4, :), 'LineWidth', 1.5)
%          plot(0:1000:t_max, mean(statistic, 1), 'Color', [0, 0, 1])
% %        title('mean dissipation rate', 'FontSize', 20)
% %        xlabel('t', 'FontSize', 20)
% %        ylabel('diss', 'FontSize', 20)
%         
%         final_stats = [final_stats, mean(statistic(:, end))];
%         final_std = [final_std, std(statistic(:, end), 1)];
%         
%         stat_mean = [stat_mean, mean(mean(statistic))];
%         stat_sq_mean = [stat_sq_mean, mean(mean(statistic .^2))];
        
        
    end
end

for iter_4 = 1:10
    figure(7)
    hold on
    scatter(stat_means_i{iter_4}, stat_means_f{iter_4}, 'filled')%, 'MarkerEdgeColor', plot_colors(iter_4, :))
    
    xlabel('first half std', 'FontSize', 20)
    ylabel('second half std', 'FontSize', 20)
    title('aperiodic', 'FontSize', 20)
end

% figure(1)
% hold on
% % plot([10, 15, 20, 30, 50, 70, 100], final_stats, 'Color', [0, 0, 1])
% % errorbar([2, 3, 4, 5, 7, 10, 12, 15, 17, 20, 25, 30, 50, 70, 100], final_stats, final_std, 'Color', [1, 0, 0])
% errorbar([2, 5, 10, 25, 100], final_stats, final_std, 'Color', [1, 0, 0])

%figure(7)
%hold on
%plot([1, 1.33, 1.66, 2, 2.33], stat_sq_mean - stat_mean.^2, 'Color', [0, 0, 1])
% axis([0, 100000, 0, .18])

% figure(1)
% subplot(2, 1, 1)
% plot(0:100:t_max, mean(work, 1));
% title('total energy dissipated over time', 'FontSize', 20)
% xlabel('t', 'FontSize', 20)
% ylabel('total energy dissipated', 'FontSize', 20)
% 
% subplot(2, 1, 2)
% plot(0:100:(t_max - 100), diff(mean(work, 1))/100);
% title('rate of energy dissipation', 'FontSize', 20)
% xlabel('t', 'FontSize', 20)
% ylabel('rate of energy dissipated', 'FontSize', 20)
% axis([0, 100000, 0, 0.01])