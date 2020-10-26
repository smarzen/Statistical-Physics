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
filename = 'spin_glass_switch_fields_fix_slow_many_realizations_2018_01_23_5_52/unfixed_slow_';
% instrinsic flip rates, two drives

plot_title = 'fixed';

statistic = [];
final_stats = [];
final_std = [];
plot_colors = [linspace(0, 1, 10); zeros(1, 10); linspace(1, 0, 10)]';

stat_means_i = {};
stat_means_f = {};
for iter_4 = 1:5000
    stat_means_i{iter_4} = [];
    stat_means_f{iter_4} = [];
    stat_means_2_i{iter_4} = [];
    stat_means_2_f{iter_4} = [];
end
% stat_sq_mean = [];

has_flips = zeros(10, 10, 32);

flip_dist_slow = zeros([32, 1]);
flip_dist_fast = zeros([32, 1]);
flip_dist_slow_2 = [];
flip_dist_fast_2 = [];

for iter_3 = 1:5000
    for iter_4 = 1:1
        statistic = [];
        
        for iter_5 = 1:1
            file_list = dir(char(strcat(filename, string(iter_3), '_', string(iter_4), '_', string(iter_5))));
%             file_list = dir(char(strcat(filename, string(iter_4), '_', string(iter_5))));
            stats = [];
            hist = [];
            flips = [];
            
            stats_2 = [];
            hist_2 = [];
            flips_2 = [];
            for iter_6 = 1:(numel(file_list) - 3)
                load(char(strcat(filename, string(iter_3), '_', string(iter_4), '_', string(iter_5), '/data_', string(iter_6), '.mat')))
%                 load(char(strcat(filename, string(iter_4), '_', string(iter_5), '/data_', string(iter_6), '.mat')))
                stats = [stats, statistics];
                flips = [flips, flip_counts];
                hist = [hist, spin_hist];

%                     load(char(strcat(filename, 'b_', string(iter_3), '_', string(iter_4), '_', string(iter_5), '/data_', string(iter_6), '.mat')))
%                     stats_2 = [stats_2, statistics];
%                     hist_2 = [hist_2, spin_hist];
                load(char(strcat(filename, string(iter_3), '_', string(iter_4), '_', string(iter_5), 'b/data_', string(iter_6), '.mat')))
                stats_2 = [stats_2, statistics];
                hist_2 = [hist_2, spin_hist];
                flips_2 = [flips_2, flip_counts];
                
            end
            load(char(strcat(filename, string(iter_3), '_', string(iter_4), '_', string(iter_5), '/extra_data.mat')))
            [temp, t_index, temp_2] = unique(stats(1, :));
            
            flip_dist_slow = flip_dist_slow + sort(flip_count(1:32, end));
            flip_dist_fast = flip_dist_fast + sort(flip_count(33:64, end));
            flip_dist_slow_2 = [flip_dist_slow_2, max(flip_count(1:32))];
            flip_dist_fast_2 = [flip_dist_fast_2, max(flip_count(33:64))];

%             load(char(strcat(filename, string(iter_4), '_', string(iter_5), '/extra_data.mat')))
            interp_stats = diff(interp1(stats(1, t_index), stats(5, t_index), 0:100:t_max));
%             interp_stats_3 = interp1(stats(1, t_index), stats(3, t_index), 0:100:t_max);

            [temp, t_index, temp_2] = unique(stats_2(1, :));
            interp_stats_2 = diff(interp1(stats_2(1, t_index), stats_2(5, t_index), 0:100:t_max));
%             interp_stats_4 = interp1(stats_2(1, t_index), stats_2(3, t_index), 0:100:t_max);
% %             
%             interp_stats = interp1(stats(1, t_index), hist(33:64, t_index)', 0:100:t_max);
%             interp_stats = interp_stats';
%             interp_stats_2 = interp1(stats_2(1, t_index), hist_2(33:64, t_index)', 0:100:t_max);
%             interp_stats_2 = interp_stats_2';
            
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
%                     stat_means_i{iter_3} = [stat_means_i{iter_3}, sum(flips(33:64, end) - flips(33:64, (end - 1000)))];%
%                     stat_means_f{iter_3} = [stat_means_f{iter_3}, sum(flips_2(33:64, end) - flips_2(33:64, (end - 1000)))];%
%                     stat_means_i{iter_3} = [stat_means_i{iter_3}, mean(interp_stats(:, (end - 99):end), 2)];
%                     stat_means_f{iter_3} = [stat_means_f{iter_3}, mean(interp_stats_2(:, (end - 99):end), 2)];
                    
                    stat_means_i{iter_3} = [stat_means_i{iter_3}, mean(interp_stats((end - 99):end))];
                    stat_means_f{iter_3} = [stat_means_f{iter_3}, mean(interp_stats_2((end - 99):end))];
                    
%                     stat_means_i{iter_3} = [stat_means_i{iter_3}, mean(interp_stats(1:100))];
%                     stat_means_f{iter_3} = [stat_means_f{iter_3}, mean(interp_stats((end - 99):end))];
%                     
                    stat_means_2_i{iter_3} = [stat_means_2_i{iter_3}, mean(interp_stats((end - 99):end))];
                    stat_means_2_f{iter_3} = [stat_means_2_f{iter_3}, mean(interp_stats_2((end - 99):end))];
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

filename = 'spin_glass_switch_fields_fix_slow_many_realizations_2018_01_23_5_52/fixed_slow_';
% instrinsic flip rates, two drives

plot_title = 'fixed';

statistic = [];
final_stats = [];
final_std = [];
plot_colors = [linspace(0, 1, 10); zeros(1, 10); linspace(1, 0, 10)]';

stat_means_i_2 = {};
stat_means_f_2 = {};
for iter_4 = 1:5000
    stat_means_i_2{iter_4} = [];
    stat_means_f_2{iter_4} = [];
    stat_means_2_i_2{iter_4} = [];
    stat_means_2_f_2{iter_4} = [];
end
% stat_sq_mean = [];

for iter_3 = 1:5000
    for iter_4 = 1:1
        statistic = [];
        
        for iter_5 = 1:1
            file_list = dir(char(strcat(filename, string(iter_3), '_', string(iter_4), '_', string(iter_5), 'b')));
%             file_list = dir(char(strcat(filename, string(iter_4), '_', string(iter_5))));
            stats = [];
            hist = [];
            flips = [];
            
            stats_2 = [];
            hist_2 = [];
            flips_2 = [];
            for iter_6 = 1:(numel(file_list) - 3)
               
                load(char(strcat(filename, string(iter_3), '_', string(iter_4), '_', string(iter_5), 'b/data_', string(iter_6), '.mat')))
%                 load(char(strcat(filename, string(iter_4), '_', string(iter_5), '/data_', string(iter_6), '.mat')))
                stats = [stats, statistics];
                flips = [flips, flip_counts];
                hist = [hist, spin_hist];

%                     load(char(strcat(filename, 'b_', string(iter_3), '_', string(iter_4), '_', string(iter_5), '/data_', string(iter_6), '.mat')))
%                     stats_2 = [stats_2, statistics];
%                     hist_2 = [hist_2, spin_hist];

                load(char(strcat(filename, string(iter_3), '_', string(iter_4), '_', string(iter_5), 'c/data_', string(iter_6), '.mat')))
                stats_2 = [stats_2, statistics];
                hist_2 = [hist_2, spin_hist];
                flips_2 = [flips_2, flip_counts];
                
                
            end
            load(char(strcat(filename, string(iter_3), '_', string(iter_4), '_', string(iter_5), 'b/extra_data.mat')))
            [temp, t_index, temp_2] = unique(stats(1, :));

%             load(char(strcat(filename, string(iter_4), '_', string(iter_5), '/extra_data.mat')))
            interp_stats = diff(interp1(stats(1, t_index), stats(5, t_index), 0:100:t_max));
%             interp_stats_3 = interp1(stats(1, t_index), stats(3, t_index), 0:100:t_max);
            [temp, t_index, temp_2] = unique(stats_2(1, :));
            interp_stats_2 = diff(interp1(stats_2(1, t_index), stats_2(5, t_index), 0:100:t_max));
%             interp_stats_4 = interp1(stats_2(1, t_index), stats_2(3, t_index), 0:100:t_max);

%             interp_stats = interp1(stats(1, t_index), hist(33:64, t_index)', 0:100:t_max);
%             interp_stats = interp_stats';
%             interp_stats_2 = interp1(stats_2(1, t_index), hist_2(33:64, t_index)', 0:100:t_max);
%             interp_stats_2 = interp_stats_2';
                
            
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
                if iter_5 <= 64 %&& has_flips(iter_3, iter_4, iter_5) == 1
%                     stat_means_i{1} = [stat_means_i{1}, mean(interp_stats_2((end - 199):(end - 99)))];
%                     stat_means_i_2{iter_3} = [stat_means_i_2{iter_3}, sum(flips(33:64, end) - flips(33:64, (end - 1000)))];%
%                     stat_means_f_2{iter_3} = [stat_means_f_2{iter_3}, sum(flips_2(33:64, end) - flips_2(33:64, (end - 1000)))];%
%                     stat_means_i_2{iter_3} = [stat_means_i_2{iter_3}, mean(interp_stats(:, (end - 99):end), 2)];
%                     stat_means_f_2{iter_3} = [stat_means_f_2{iter_3}, mean(interp_stats_2(:, (end - 99):end), 2)];
                    
                    stat_means_i_2{iter_3} = [stat_means_i_2{iter_3}, mean(interp_stats((end - 99):end))];
                    stat_means_f_2{iter_3} = [stat_means_f_2{iter_3}, mean(interp_stats_2((end - 99):end))];
                    
%                     stat_means_i_2{iter_3} = [stat_means_i_2{iter_3}, mean(interp_stats(1:100))];
%                     stat_means_f_2{iter_3} = [stat_means_f_2{iter_3}, mean(interp_stats((end - 99):end))];
                    
                    stat_means_2_i_2{iter_3} = [stat_means_2_i_2{iter_3}, mean(interp_stats((end - 99):end))];
                    stat_means_2_f_2{iter_3} = [stat_means_2_f_2{iter_3}, mean(interp_stats_2((end - 99):end))];
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

all_means_i = [];
all_means_i_2 = [];
all_means_f = [];
all_means_f_2 = [];
all_means_2_i = [];
all_means_2_f = [];
all_means_2_i_2 = [];
all_means_2_f_2 = [];

diff_means = [];
diff_stds = [];
diff_frac = [];

for iter_4 = 1:5000
%     figure(13)
%     hold on
%     scatter(stat_means_i{iter_4}, stat_means_f{iter_4}, 'filled')%, 'MarkerEdgeColor', plot_colors(iter_4, :))
%     
%     
%     xlabel('pre-switch dissipation', 'FontSize', 20)
%     ylabel('post-switch dissipation', 'FontSize', 20)
%     title('unfixed', 'FontSize', 20)
%     
%     figure(14)
%     hold on
%     scatter(stat_means_i_2{iter_4}, stat_means_f_2{iter_4}, 'filled')%, 'MarkerEdgeColor', plot_colors(iter_4, :))
%     
%     
%     xlabel('pre-switch dissipation', 'FontSize', 20)
%     ylabel('post-switch dissipation', 'FontSize', 20)
%     title('fixed', 'FontSize', 20)
%     
%     
%     mean_pre_switch(iter_4) = mean(stat_means_i{iter_4});
%     std_pre_switch(iter_4) = std(stat_means_i{iter_4});
%     
%     mean_post_switch(iter_4) = mean(stat_means_f{iter_4});
%     std_post_switch(iter_4) = std(stat_means_f{iter_4});
%     
%     randomized_means_f_2 = stat_means_f_2{iter_4};
%     randomized_means_f_2 = randomized_means_f_2(randperm(numel(randomized_means_f_2)));
    
%     figure(2 + iter_4)
%     hold on
%     histogram(stat_means_f{iter_4} - stat_means_f_2{iter_4}, -15.25:.5:15.25, 'Normalization', 'probability')
%     histogram(stat_means_f{iter_4} - randomized_means_f_2, -15.25:.5:15.25, 'Normalization', 'probability')
% %     histogram(stat_means_f{iter_4}, -.25:.5:19.75, 'Normalization', 'probability')
%     title('diff between fixed and unfixed', 'FontSize', 20)
%     xlabel('fixed post-switch dissipation', 'FontSize', 20)
%     ylabel('unfixed post-switch dissipation', 'FontSize', 20)

    all_means_i = [all_means_i, stat_means_i{iter_4}];
    all_means_i_2 = [all_means_i_2, stat_means_i_2{iter_4}];
    all_means_f = [all_means_f, stat_means_f{iter_4}];
    all_means_f_2 = [all_means_f_2, stat_means_f_2{iter_4}];
    diff_means = [diff_means, mean(abs(stat_means_f_2{iter_4} - stat_means_f{iter_4}))];
    diff_stds = [diff_stds, std(stat_means_f_2{iter_4} - stat_means_f{iter_4})];
    diff_frac = [diff_frac, sum(abs(stat_means_f_2{iter_4} - stat_means_f{iter_4}) > 5) / 300];
    all_means_2_i = [all_means_2_i, stat_means_2_i{iter_4}];
    all_means_2_f = [all_means_2_f, stat_means_2_f{iter_4}];
    all_means_2_i_2 = [all_means_2_i_2, stat_means_2_i_2{iter_4}];
    all_means_2_f_2 = [all_means_2_f_2, stat_means_2_f_2{iter_4}];
    
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

figure(7)
bar(flip_dist_slow / 5000)

figure(8)
bar(flip_dist_fast / 5000)

figure(9)
histogram(flip_dist_slow_2, logspace(0, 3, 50))
set(gca, 'xscale', 'log')

figure(10)
histogram(flip_dist_fast_2, logspace(0, 6, 50))
set(gca, 'xscale', 'log')


figure(11)
subplot(1, 2, 1)
histogram(flip_dist_slow_2 / 500, logspace(-3, 1, 50))
set(gca, 'xscale', 'log')
xlabel('flips per "period" of slow spin with most flips', 'FontSize', 20)
ylabel('p(max slow flips)', 'FontSize', 20)
title('flipping rate of slow spins', 'FontSize', 20)

subplot(1, 2, 2)
histogram(flip_dist_fast_2 / 500, logspace(-3, 3, 50))
set(gca, 'xscale', 'log')
xlabel('flips per "period" of fast spin with most flips', 'FontSize', 20)
ylabel('p(max fast flips)', 'FontSize', 20)
title('flipping rate of fast spins', 'FontSize', 20)


% figure(3)
% scatter(all_means_i, all_means_f, 'Filled')
% 
% figure(4)
% scatter(all_means_i, all_means_i_2, 'Filled')
% 
% figure(6)
% scatter(all_means_i_2 - all_means_i, all_means_f_2 - all_means_i, 'Filled')

% figure(40)
% hold off
% histogram(all_means_i, -.75:.5:19.75, 'Normalization', 'probability')
% hold on
% histogram(all_means_i_2, -.75:.5:19.75, 'Normalization', 'probability')
% legend({'unfixed', 'fixed'}, 'FontSize', 12)
% title('pre-perturbation flip rate')
% 
% figure(41)
% hold off
% histogram(all_means_f, -.75:.5:19.75, 'Normalization', 'probability')
% hold on
% histogram(all_means_f_2, -.75:.5:19.75, 'Normalization', 'probability')
% legend({'unfixed', 'fixed'}, 'FontSize', 12)
% title('post-perturbation flip rate')

% figure(33)
% hold off
% histogram(all_means_i, 'Normalization', 'probability')
% hold on
% histogram(all_means_i_2, 'Normalization', 'probability')
% legend({'unfixed', 'fixed'}, 'FontSize', 12)
% title('pre-perturbation flip rate')
% 
% figure(34)
% hold off
% histogram(all_means_f, 'Normalization', 'probability')
% hold on
% histogram(all_means_f_2, 'Normalization', 'probability')
% legend({'unfixed', 'fixed'}, 'FontSize', 12)
% title('post-perturbation flip rate')
% 
% figure(35)
% hold off
% histogram(all_means_f_2 - all_means_i_2, 'Normalization', 'probability')

% figure(44)
% hold off
% histogram(mean(abs(all_means_f - all_means_i)), 0:.025:1.5, 'Normalization', 'probability')
% hold on
% histogram(mean(abs(all_means_f_2 - all_means_i)), 0:.025:1.5, 'Normalization', 'probability')

% figure(9)
% histogram(diff_means, 10)
% 
% figure(10)
% histogram(diff_stds, 10)
% 
% figure(13)
% histogram(diff_frac, 10)

% figure(14)
% scatter(all_means_i_2 - all_means_f, all_means_f_2 - all_means_f, 'Filled')

% figure(8) 
% figure(9)
% subplot(1, 2, 1)
% histogram(all_means_f - all_means_i, -15:15, 'Normalization', 'probability', 'FaceColor', [0, 0, 1])

% bucket_size = 1;
% buckets = zeros(1000);
% min_x_index = floor(min(all_means_f) / 2);
% min_y_index = floor(min(all_means_2_f_2) / 2);
% 
% for iter_6 = 1:numel(all_means_f)
%     buckets(floor(all_means_f(iter_6) / bucket_size) - min_x_index + 1, floor(all_means_2_f_2(iter_6) / bucket_size) - min_y_index + 1) = buckets(floor(all_means_f(iter_6) / bucket_size) - min_x_index + 1, floor(all_means_2_f_2(iter_6) / bucket_size) - min_y_index + 1) + 1;
% end
% 
% norm_buckets = buckets ./ sum(buckets);
% norm_buckets = norm_buckets(end:-1:1, :);
% figure(19)
% imshow(buckets / max(max(buckets)))
% 
% figure(20)
% imshow(norm_buckets)
% 
% figure(21)
% scatter(all_means_f, all_means_2_f_2, 'Filled')
% 
% figure(9)
% scatter(all_means_f, all_means_2_f_2 - all_means_f, 'Filled')
% 
% 
% figure(10)
% scatter(all_means_f - all_means_i, all_means_2_f - all_means_f, 'Filled')
% 
% figure(11)
% scatter(all_means_f - all_means_i, all_means_f_2 - all_means_f, 'Filled')
% 
% figure(12)
% scatter(all_means_f - all_means_i, all_means_2_f - all_means_f)
% hold on
% scatter(all_means_f - all_means_i, all_means_f_2 - all_means_f)
% 
% figure(18)
% subplot(2, 2, 1)
% imshow('Grant Report Fields.png')
% subplot(2, 2, 2)
% imshow('Grant Report Diagram v2.png')
% subplot(2, 2, 3)
% scatter(all_means_f, all_means_2_f, 'Filled')
% axis([0, 20, 0, 25])
% set(gca, 'fontsize', 12)
% xlabel('work absorption rate before freezing', 'FontSize', 20)
% ylabel('work absorption rate after freezing', 'FontSize', 20)
% title('same drive before and after freezing', 'FontSize', 20)
% subplot(2, 2, 4)
% scatter(all_means_f, all_means_f_2, 'Filled')
% axis([0, 20, 0, 25])
% set(gca, 'fontsize', 12)
% xlabel('work absorption rate before freezing', 'FontSize', 20)
% ylabel('work absorption rate after freezing', 'FontSize', 20)
% title('different drive before and after freezing', 'FontSize', 20)
% 
% 
% figure(14)
% subplot(1, 2, 1)
% hist3([all_means_f', all_means_2_f'], [10, 10])
% xlabel('work absorption rate before freezing', 'FontSize', 20)
% ylabel('work absorption rate after freezing', 'FontSize', 20)
% title('same drive before and after freezing slow spins', 'FontSize', 20)
% set(get(gca, 'child'), 'FaceColor', 'interp', 'CDataMode', 'auto')
% subplot(1, 2, 2)
% hist3([all_means_f', all_means_f_2'], [10, 10])
% xlabel('work absorption rate before freezing', 'FontSize', 20)
% ylabel('work absorption rate after freezing', 'FontSize', 20)
% title('different drive before and after freezing slow spins', 'FontSize', 20)
% set(get(gca, 'child'), 'FaceColor', 'interp', 'CDataMode', 'auto')

% figure(1)
% hold off
% scatter(all_means_2_i, all_means_2_f, 'Filled')
% 
% figure(2)
% scatter(all_means_2_i_2, all_means_2_f_2, 'Filled')
% 
% figure(3)
% scatter(all_means_2_i, all_means_i, 'Filled')
% 
% figure(4)
% scatter(all_means_2_i_2, all_means_i_2, 'Filled')
% 
% figure(5)
% scatter(all_means_2_f, all_means_f, 'Filled')
% 
% figure(6)
% scatter(all_means_2_f_2, all_means_f_2, 'Filled')
% 
% figure(7)
% hist3([all_means_2_i', all_means_i'], [10, 10])
% set(get(gca, 'child'), 'FaceColor', 'interp', 'CDataMode', 'auto')
% 
% figure(8)
% hist3([all_means_2_f', all_means_f'], [10, 10])
% set(get(gca, 'child'), 'FaceColor', 'interp', 'CDataMode', 'auto')
% 
% figure(9)
% hist3([all_means_2_i_2', all_means_i_2'], [10, 10])
% set(get(gca, 'child'), 'FaceColor', 'interp', 'CDataMode', 'auto')
% 
% figure(10)
% hist3([all_means_2_f_2', all_means_f_2'], [10, 10])
% set(get(gca, 'child'), 'FaceColor', 'interp', 'CDataMode', 'auto')
% 
% figure(11)
% scatter(all_means_i, all_means_f, 'Filled');
% 
% figure(12)
% scatter(all_means_i, all_means_f_2, 'Filled');
% 
% figure(13)
% hist3([all_means_i', all_means_f'], [10, 10])
% set(get(gca, 'child'), 'FaceColor', 'interp', 'CDataMode', 'auto')
% 
% figure(14)
% hist3([all_means_i', all_means_f_2'], [10, 10])
% set(get(gca, 'child'), 'FaceColor', 'interp', 'CDataMode', 'auto')
% figure(47)
% hold off
% histogram(all_means_f - all_means_i, -15:.5:15, 'Normalization', 'probability')
% hold on
% histogram(all_means_f_2 - all_means_i_2, -15:.5:15, 'Normalization', 'probability')

% figure(48)
% hist3([all_means_i', all_means_f'], [10, 10])
% 
% figure(49)
% hist3([all_means_i_2', all_means_f_2'], [10, 10])
% figure(2)
% histogram(all_means_2, -.25:.5:19.75, 'Normalization', 'probability')
% hold on
% histogram(all_means, -.25:.5:19.75, 'Normalization', 'probability')
% title('Distribution of dissipation rates', 'FontSize', 20)
% xlabel('Post-perturbation dissipation rate', 'FontSize', 20)
% ylabel('p(dissipation rate)', 'FontSize', 20)
% legend({'slow spins fixed pre-perturb', 'slow spins free pre-perturb'}, 'FontSize', 12)

% figure(2)
% errorbar(mean_pre_switch, std_pre_switch);
% title(plot_title, 'FontSize', 20)
% xlabel('drive number', 'FontSize', 20)
% ylabel('pre-switch dissipation', 'FontSize', 20)
% 
% figure(3)
% errorbar(mean_post_switch, std_post_switch);
% title(plot_title, 'FontSize', 20)
% xlabel('drive number', 'FontSize', 20)
% ylabel('post-switch dissipation', 'FontSize', 20)



