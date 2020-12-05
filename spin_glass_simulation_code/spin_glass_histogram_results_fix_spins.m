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
filename = 'spin_glass_switch_fields_perturb_slow_2017_11_08_7_10/unfixed_slow_';
% instrinsic flip rates, two drives

plot_title = 'fixed';

statistic = [];
final_stats = [];
final_std = [];
plot_colors = [linspace(0, 1, 10); zeros(1, 10); linspace(1, 0, 10)]';

stat_means_i = {};
stat_means_f = {};
for iter_4 = 1:10
    stat_means_i{iter_4} = 0;
    stat_means_f{iter_4} = 0;
end
% stat_sq_mean = [];

for iter_3 = 1:10
    for iter_4 = 1:10
        statistic = [];
        stats_2 = [];
        hist_2 = [];
        flips_2 = [];
        for iter_5 = 0:32
            file_list = dir(char(strcat(filename, string(iter_3), '_', string(iter_4), '_', string(iter_5))));
%             file_list = dir(char(strcat(filename, string(iter_4), '_', string(iter_5))));
            stats = [];
            hist = [];
            flips = [];
            for iter_6 = 1:(numel(file_list) - 3)
                if iter_5 > 0
                    load(char(strcat(filename, string(iter_3), '_', string(iter_4), '_', string(iter_5), '/data_', string(iter_6), '.mat')))
    %                 load(char(strcat(filename, string(iter_4), '_', string(iter_5), '/data_', string(iter_6), '.mat')))
                    stats = [stats, statistics];
                    flips = [flips, flip_counts];
                    hist = [hist, spin_hist];

%                     load(char(strcat(filename, 'b_', string(iter_3), '_', string(iter_4), '_', string(iter_5), '/data_', string(iter_6), '.mat')))
%                     stats_2 = [stats_2, statistics];
%                     hist_2 = [hist_2, spin_hist];
                else
                    load(char(strcat(filename, string(iter_3), '_', string(iter_4), '_', string(iter_5), '/data_', string(iter_6), '.mat')))
                    stats_2 = [stats_2, statistics];
                    hist_2 = [hist_2, spin_hist];
                    flips_2 = [flips_2, flip_counts];
                end
                
            end
            load(char(strcat(filename, string(iter_3), '_', string(iter_4), '_', string(iter_5), '/extra_data.mat')))
            if iter_5 > 0
                [temp, t_index, temp_2] = unique(stats(1, :));
                
    %             load(char(strcat(filename, string(iter_4), '_', string(iter_5), '/extra_data.mat')))
                interp_stats = diff(interp1(stats(1, t_index), stats(5, t_index), 0:100:t_max));
            else
                [temp, t_index, temp_2] = unique(stats_2(1, :));
                interp_stats_2 = diff(interp1(stats_2(1, t_index), stats_2(5, t_index), 0:100:t_max));
                
            end
            
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
            
            if iter_5 > 0
                if iter_5 <= 64 %&& flips_2(iter_5, end) > 10
%                     stat_means_i{1} = [stat_means_i{1}, mean(interp_stats_2((end - 199):(end - 99)))];
                    stat_means_i{iter_3} = [stat_means_i{iter_3}, mean(interp_stats_2((end - 99):end))];
                    stat_means_f{iter_3} = [stat_means_f{iter_3}, mean(interp_stats(1:100))];
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

for iter_4 = 1:10
    figure(4)
    hold on
    scatter(stat_means_i{iter_4}, stat_means_f{iter_4}, 'filled')%, 'MarkerEdgeColor', plot_colors(iter_4, :))
    
    
    xlabel('pre-switch dissipation', 'FontSize', 20)
    ylabel('post-switch dissipation', 'FontSize', 20)
    title(plot_title, 'FontSize', 20)
    
    mean_pre_switch(iter_4) = mean(stat_means_i{iter_4});
    std_pre_switch(iter_4) = std(stat_means_i{iter_4});
    
    mean_post_switch(iter_4) = mean(stat_means_f{iter_4});
    std_post_switch(iter_4) = std(stat_means_f{iter_4});
    
%     figure(2)
%     hold on
%     histogram(stat_means_i{iter_4}, 25, 'FaceColor', plot_colors(iter_4, :))
%     
%     figure(3)
%     hold on
%     histogram(stat_means_f{iter_4} - stat_means_i{iter_4}, -10.5:1:10.5, 'FaceColor', plot_colors(iter_4, :))
%     title('switching set of \mu''s ', 'FontSize', 20)
    
%     figure(iter_4)
%     histogram(stat_means_i{iter_4}, -1:20, 'Normalization', 'probability', 'FaceColor', plot_colors(iter_4, :))
%     title('initial dissipation rate')
%     figure(iter_4 + 3)
%     histogram(stat_means_f{iter_4}, -1:20, 'Normalization', 'probability', 'FaceColor', plot_colors(iter_4, :))
%     title('final dissipation rate')
%     figure(iter_4 + 10)
%     histogram(stat_means_f{iter_4} - stat_means_i{iter_4}, 25, 'Normalization', 'probability', 'FaceColor', plot_colors(iter_4, :))
%     title('final - initial dissipation rate')
    
%     plot(0:1000:t_max, stat_means{iter_4}, 'Color', plot_colors(iter_4, :), 'LineWidth', 1)
%     plot(1000:1000:t_max, diff(stat_means{iter_4}), 'Color', plot_colors(iter_4, :), 'LineWidth', 1)
end

figure(5)
errorbar(mean_pre_switch, std_pre_switch);
title(plot_title, 'FontSize', 20)
xlabel('drive number', 'FontSize', 20)
ylabel('pre-switch dissipation', 'FontSize', 20)

figure(6)
errorbar(mean_post_switch, std_post_switch);
title(plot_title, 'FontSize', 20)
xlabel('drive number', 'FontSize', 20)
ylabel('post-switch dissipation', 'FontSize', 20)
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