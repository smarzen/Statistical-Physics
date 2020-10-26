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
filename = 'spin_glass_switch_fields_record_force_2017_09_05_3_00/periodic_driving_';
% instrinsic flip rates, two drives


statistic = [];
final_stats = [];
final_std = [];
plot_colors = [linspace(0, 1, 5); zeros(1, 5); linspace(1, 0, 5)]';

stat_means = {};
for iter_4 = 1:5
    stat_means{iter_4} = 0;
end
% stat_sq_mean = [];

for iter_3 = 1:20
    for iter_4 = 1:5
        statistic = [];
        for iter_5 = 1:5
            file_list = dir(char(strcat(filename, string(iter_3), '_', string(iter_4), '_', string(iter_5))));
%             file_list = dir(char(strcat(filename, string(iter_4), '_', string(iter_5))));
            stats = [];
            for iter_6 = 1:(numel(file_list) - 3)
                load(char(strcat(filename, string(iter_3), '_', string(iter_4), '_', string(iter_5), '/data_', string(iter_6), '.mat')))
%                 load(char(strcat(filename, string(iter_4), '_', string(iter_5), '/data_', string(iter_6), '.mat')))
                stats = [stats, statistics];
                
            end
            [temp, t_index, temp_2] = unique(stats(1, :));
            load(char(strcat(filename, string(iter_3), '_', string(iter_4), '_', string(iter_5), '/extra_data.mat')))
%             load(char(strcat(filename, string(iter_4), '_', string(iter_5), '/extra_data.mat')))
            statistic = [statistic; interp1(stats(1, t_index), stats(6, t_index), 0:1000:t_max)];
            %t, energy, internal energy, mean mag, work, heat lost,
            %internal work, hamming_dist, slow_energy
        end
        stat_means{iter_4} = stat_means{iter_4} + mean(statistic, 1);
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

for iter_4 = 1:5
    figure(8)
    hold on
%     plot(0:1000:t_max, stat_means{iter_4}, 'Color', plot_colors(iter_4, :), 'LineWidth', 1)
    plot(1000:1000:t_max, diff(stat_means{iter_4}), 'Color', plot_colors(iter_4, :), 'LineWidth', 1)
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