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
filename = 'spin_glass_switch_fields_record_spin_diss_2017_10_10_4_33/periodic_driving_';
% instrinsic flip rates, two drives


statistic = [];
final_stats = [];
final_std = [];
plot_colors = [linspace(0, 1, 5); zeros(1, 5); linspace(1, 0, 5)]';

stat_mean = [];
stat_sq_mean = [];

results = [];

for iter_3 = 1:100
    for iter_4 = 1:3
        statistic = [];
        for iter_5 = 1:1
            file_list = dir(char(strcat(filename, string(iter_3), '_', string(iter_4), '_', string(iter_5))));
%             file_list = dir(char(strcat(filename, string(iter_4), '_', string(iter_5))));
            stats = [];
            diss = [];
            hist = [];
            for iter_6 = 1:(numel(file_list) - 3)
                load(char(strcat(filename, string(iter_3), '_', string(iter_4), '_', string(iter_5), '/data_', string(iter_6), '.mat')))
%                 load(char(strcat(filename, string(iter_4), '_', string(iter_5), '/data_', string(iter_6), '.mat')))
                stats = [stats, statistics];
                diss = [diss, spin_dissipation];
                hist = [hist, spin_hist];
            end
            [temp, t_index, temp_2] = unique(stats(1, :));
            load(char(strcat(filename, string(iter_3), '_', string(iter_4), '_', string(iter_5), '/extra_data.mat')))
            interp_diss = [0, diff(interp1(stats(1, t_index), stats(5, t_index), 0:1000:t_max))];
            interp_diss_2 = diff(interp1(stats(1, t_index), diss', 0:1000:t_max));
            interp_hist = interp1(stats(1, t_index), hist', 0:1000:t_max);
            
            smoothed_diss = movsum(interp_diss, 10);
            smoothed_diss = smoothed_diss(11:(end - 10));
            smoothed_hist = interp_hist(11:(end - 10), :)';
%             pca_data = mean(interp_diss .* interp_hist', 2) - mean(interp_diss) * mean(interp_hist', 2);
%             pca_data = [interp_diss' / std(interp_diss), interp_hist(:, 33:end)];
            
%             [coeff, score, latent] = pca(pca_data);
%             [temp, best_diss_predictor] = max(coeff(:, 1) .* latent);

%             local_std = zeros(1, numel(smoothed_diss) - 100);
%             local_mean = zeros(1, numel(smoothed_diss) - 100);
            diss_state = zeros(1, numel(smoothed_diss));
            current_state_start = 1;
            current_state = 1;
            state_starts = [1];
            window_size = 50;
            local_std = [];
            for iter_6 = 1:(numel(smoothed_diss) - window_size)
                local_std = [local_std, std(smoothed_diss(iter_6:(iter_6 + window_size)))];
            end
            [temp, state_starts] = findpeaks(local_std, 'MinPeakDistance', 20);
            new_starts = [];
            for iter_7 = 1:(numel(state_starts) - 2)
                mean_1 = mean(smoothed_diss(state_starts(iter_7):state_starts(iter_7 + 1)));
                std_1 = std(smoothed_diss(state_starts(iter_7):state_starts(iter_7 + 1)));
                mean_2 = mean(smoothed_diss(state_starts(iter_7 + 1):state_starts(iter_7 + 2)));
                std_2 = std(smoothed_diss(state_starts(iter_7 + 1):state_starts(iter_7 + 2)));
                if abs(mean_1 - mean_2) > 1 * (std_1 + std_2) || (min([std_1, std_2]) / max([std_1, std_2]) < .2)
                    new_starts = [new_starts, state_starts(iter_7 + 1)];
                end
            end
            new_starts = [1, new_starts, numel(local_std)];
            
            
            
            for iter_7 = 1:numel(new_starts)
                diss_state(new_starts(iter_7):end) = diss_state(new_starts(iter_7):end) + 1;
            end
            
            global_std = std(smoothed_diss);
            
%             figure(1)
%             hold off
%             plot(smoothed_diss)
%             hold on
%             
%             figure(2)
%             plot(local_std)
% 
%             figure(3)
%             plot(diss_state)
            
            for iter_7 = 1:(numel(new_starts) - 2)
                mean_state_1 = mean(smoothed_hist(:, (new_starts(iter_7) + floor(window_size / 2)):(new_starts(iter_7 + 1) + floor(window_size / 2))), 2);
                mean_state_2 = mean(smoothed_hist(:, (new_starts(iter_7 + 1) + floor(window_size / 2)):(new_starts(iter_7 + 2) + floor(window_size / 2))), 2);
                state_diff = mean_state_1 - mean_state_2;
                significant_spins = find(abs(state_diff) > 1.5);
                if(numel(significant_spins) > 0)
                    other_spins = find(abs(state_diff) <= 1.5);
                    int_energy_1 = mean_state_1(significant_spins)' * interactions(significant_spins, significant_spins) * mean_state_1(significant_spins);
                    ext_energy_1 = mean_state_1(significant_spins)' * interactions(significant_spins, other_spins) * mean_state_1(other_spins);
                    int_energy_2 = mean_state_2(significant_spins)' * interactions(significant_spins, significant_spins) * mean_state_2(significant_spins);
                    ext_energy_2 = mean_state_2(significant_spins)' * interactions(significant_spins, other_spins) * mean_state_2(other_spins);
                    other_energy_1 = mean_state_1(other_spins)' * interactions(other_spins, other_spins) * mean_state_1(other_spins);
                    other_energy_2 = mean_state_2(other_spins)' * interactions(other_spins, other_spins) * mean_state_2(other_spins);
                    
                    mean_diss_1 = mean(smoothed_diss((new_starts(iter_7) + floor(window_size / 2)):(new_starts(iter_7 + 1) + floor(window_size / 2))));
                    mean_diss_2 = mean(smoothed_diss((new_starts(iter_7 + 1) + floor(window_size / 2)):(new_starts(iter_7 + 2) + floor(window_size / 2))));
                    spin_std_1 = std(smoothed_hist(:, (new_starts(iter_7) + floor(window_size / 2)):(new_starts(iter_7 + 1) + floor(window_size / 2))), 0, 2);
                    spin_std_2 = std(smoothed_hist(:, (new_starts(iter_7 + 1) + floor(window_size / 2)):(new_starts(iter_7 + 2) + floor(window_size / 2))), 0, 2);
                    
                    results = [results, [mean_diss_1; mean_diss_2; mean(spin_std_1); mean(spin_std_2); int_energy_1; int_energy_2; ext_energy_1; ext_energy_2; other_energy_1; other_energy_2]];
                end
            end
            
            
            
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