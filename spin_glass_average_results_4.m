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
filename = 'spin_glass_gen_fields_many_2017_08_01_10_50/generate_driving_';
% instrinsic flip rates, two drives


statistic = [];
final_stats = [];
final_std = [];
plot_colors = [linspace(0, 1, 10); zeros(1, 10); linspace(1, 0, 10)]';

stat_mean = [];
stat_sq_mean = [];

for iter_3 = 1:10
    for iter_4 = 1:11
        
        for iter_5 = 1:10
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
            relevant_indices = find(mod(stats(1, t_index), switch_time) == 0);
            relevant_indices_2 = find(mod(stats(1, t_index), switch_time) == (switch_time - save_time));
            driving_energy_changes = stats(2, relevant_indices(2:end)) - stats(2, relevant_indices_2);
            field_numbers = stats(9, relevant_indices(2:end));
            random_to_det = find(field_numbers == 1);
            det_to_det = random_to_det + 1;
            det_to_random = det_to_det + 1;
            rand_to_rand = 1:numel(relevant_indices);
            rand_to_rand([random_to_det, det_to_det, det_to_random]) = [];
            mean_random_to_det = mean(driving_energy_changes(random_to_det));
            mean_det_to_det = mean(driving_energy_changes(det_to_det));
            mean_det_to_random = mean(driving_energy_changes(det_to_random(1:(end - 1))));
            mean_rand_to_rand = mean(driving_energy_changes(rand_to_rand));
            interpolated = interp1(stats(1, t_index), stats(6, t_index), 0:1000:t_max);
            final_stats(iter_4, iter_3, iter_5) = interpolated(end);
%             load(char(strcat(filename, string(iter_4), '_', string(iter_5), '/extra_data.mat')))
%             statistic = [statistic; interp1(stats(1, t_index), stats(6, t_index), 0:1000:t_max)];
            %t, energy, internal energy, mean mag, work, heat lost, internal work
        end
        
        
        
    end
%     figure(6)
%         hold on
% %          plot(0:1000:(t_max - 1000), mean(diff(statistic, 1, 2), 1), 'Color', plot_colors(iter_4, :));
%       plot(0:1000:t_max, mean(statistic, 1), 'Color', plot_colors(iter_4, :), 'LineWidth', 1.5)
% %         plot(0:1000:t_max, mean(statistic, 1), 'Color', [0, 0, 1])
%         title('mean dissipation rate', 'FontSize', 20)
%         xlabel('t', 'FontSize', 20)
%         ylabel('diss', 'FontSize', 20)
%         
%         final_stats = [final_stats, mean(statistic(:, end))];
%         final_std = [final_std, std(statistic(:, end), 1)];
%         
%         stat_mean = [stat_mean, mean(mean(statistic))];
%         stat_sq_mean = [stat_sq_mean, mean(mean(statistic .^2))];
end

max_stats = final_stats(end, :, :);
max_stats = mean(max_stats, 3);
final_stats = final_stats ./ max_stats;
final_stats = reshape(final_stats, [11, 100, 1]);
final_std = std(final_stats, 0, 2);
final_stats_mean = mean(final_stats, 2);

figure(5)
hold on
% plot([10, 15, 20, 30, 50, 70, 100], final_stats, 'Color', [0, 0, 1])
% errorbar([2, 3, 4, 5, 7, 10, 12, 15, 17, 20, 25, 30, 50, 70, 100], final_stats, final_std, 'Color', [1, 0, 0])
errorbar([1, .9, .7, .5, .3, .2, .1, .05, .03, .02, .01], final_stats_mean, final_std, 'Color', [0, 0, 1])

figure(6)
hold on
histogram(final_stats(11, :), linspace(.2, 1.6, 25), 'Normalization', 'probability')
histogram(final_stats(4, :), linspace(.2, 1.6, 25), 'Normalization', 'probability')
histogram(final_stats(1, :), linspace(.2, 1.6, 25), 'Normalization', 'probability')

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