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
filename = 'spin_glass_switch_fields_drive_all_increase_temp_2019_05_16_1_25/random_order_';
% instrinsic flip rates, two drives

plot_title = 'fixed';

mean_early_counts = zeros(1, 256);
mean_late_counts = zeros(1, 256);
mean_early_frac = zeros(1, 256);
mean_late_frac = zeros(1, 256);
mean_early_diss = zeros(1, 256);
mean_late_diss = zeros(1, 256);
all_early = [];
all_late = [];
spin_of_interest = 247;
flip_trajectory = zeros(1, 30);
flip_trajectory_sqr = zeros(1, 30);
local_energy_full_list = zeros(256, 31);
local_energy_trajectory = zeros(1, 31);
local_energy_trajectory_sqr = zeros(1, 31);
local_energy_counts = zeros(1, 30);

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

num_extract = 3000;
% fprintf(config_id, '%u %u\n', num_extract * 100, num_spins);
% fprintf(field_id, '%u %u\n', num_extract * 100, num_spins);
% fprintf(stat_id, '%u\n', num_extract * 100);

for iter_3 = 1:num_extract
    for iter_4 = 1:1
        statistic = [];
        
        for iter_5 = 2:2
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
            
            early_counts = zeros(1, 256);
            late_counts = zeros(1, 256);
            early_diss = zeros(1, 256);
            late_diss = zeros(1, 256);
            current_local_energy = state .* (interactions * state);
            local_energy_list = [current_local_energy];
            
            for next_t = 1000:1000:10000
                while flip_times(iter_6) < next_t
                    field_number = random_order(floor(flip_times(iter_6) / switch_time) + 1);
                    spin_num = flip_order(iter_6);
                    state(flip_order(iter_6)) = state(flip_order(iter_6)) * -1;
                    early_counts(flip_order(iter_6)) = early_counts(flip_order(iter_6)) + 1;
                    early_diss(spin_num) = early_diss(spin_num) - 2 * state(spin_num) * (interactions(spin_num, :) * state + driving_fields(spin_num, field_number));
                    iter_6 = iter_6 + 1;
                    neighbors = find(interactions(:, spin_num) ~= 0);
                    for neighbor = neighbors'
                        current_local_energy(neighbor) = current_local_energy(neighbor) + 2 * state(neighbor) * interactions(neighbor, spin_num) * state(spin_num);
                    end
                    current_local_energy(spin_num) = -1 * current_local_energy(spin_num);
                end

                local_energy_list = [local_energy_list, current_local_energy];

            end
            
            for next_t = 11000:1000:20000
                while iter_6 <= numel(flip_times) && flip_times(iter_6) < next_t
                    state(flip_order(iter_6)) = state(flip_order(iter_6)) * -1;
                    spin_num = flip_order(iter_6);
                    iter_6 = iter_6 + 1;
                    neighbors = find(interactions(:, spin_num) ~= 0);
                    for neighbor = neighbors'
                        current_local_energy(neighbor) = current_local_energy(neighbor) + 2 * state(neighbor) * interactions(neighbor, spin_num) * state(spin_num);
                    end
                    current_local_energy(spin_num) = -1 * current_local_energy(spin_num);
                end

                local_energy_list = [local_energy_list, current_local_energy];
            end
            
            for next_t = 21000:1000:30000
                while iter_6 <= numel(flip_times) && flip_times(iter_6) < next_t
                    field_number = random_order(floor(flip_times(iter_6) / switch_time) + 1);
                    spin_num = flip_order(iter_6);
                    state(flip_order(iter_6)) = state(flip_order(iter_6)) * -1;
                    late_counts(flip_order(iter_6)) = late_counts(flip_order(iter_6)) + 1;
                    late_diss(spin_num) = late_diss(spin_num) - 2 * state(spin_num) * (interactions(spin_num, :) * state + driving_fields(spin_num, field_number));
                    iter_6 = iter_6 + 1;
                    neighbors = find(interactions(:, spin_num) ~= 0);
                    for neighbor = neighbors'
                        current_local_energy(neighbor) = current_local_energy(neighbor) + 2 * state(neighbor) * interactions(neighbor, spin_num) * state(spin_num);
                    end
                    current_local_energy(spin_num) = -1 * current_local_energy(spin_num);
                end

                local_energy_list = [local_energy_list, current_local_energy];
            end
            
            [early_counts, early_count_indices] = sort(early_counts);
            [late_counts, late_count_indices] = sort(late_counts);
            [temp, late_count_indices] = sort(flip_count);
            early_diss = sort(early_diss);
            late_diss = sort(late_diss);
            
%             relevant_times = flip_times(flip_order == late_count_indices(spin_of_interest));
            new_flip_order = flip_order;
            for iter_6 = 1:num_spins
                new_flip_order(flip_order == late_count_indices(iter_6)) = iter_6;
            end
%             flip_order = flip_order(late_count_indices);
            relevant_times = flip_times(new_flip_order >= spin_of_interest);
            
            temp_flip_trajectory = zeros(1, 30);
            for iter_6 = 1:30
                temp_flip_trajectory(iter_6) = temp_flip_trajectory(iter_6) + sum(relevant_times < 1000 * iter_6) - sum(relevant_times < 1000 * (iter_6 - 1));
            end
            flip_trajectory = flip_trajectory + temp_flip_trajectory;
            flip_trajectory_sqr = flip_trajectory_sqr + temp_flip_trajectory.^2;
            
            local_energy_list = local_energy_list(late_count_indices, :);
            
            temp_energy_trajectory = zeros(1, 31);
            for iter_6 = 1:31
                temp_energy_trajectory(iter_6) = temp_energy_trajectory(iter_6) + mean(local_energy_list(spin_of_interest:end, iter_6));
            end
            local_energy_trajectory = local_energy_trajectory + temp_energy_trajectory;
            local_energy_trajectory_sqr = local_energy_trajectory_sqr + temp_energy_trajectory.^2;
            
            mean_early_counts = mean_early_counts + early_counts;
            mean_late_counts = mean_late_counts + late_counts;
            mean_early_frac = mean_early_frac + early_counts / sum(early_counts);
            mean_late_frac = mean_late_frac + late_counts / sum(late_counts);
            mean_early_diss = mean_early_diss + early_diss;
            mean_late_diss = mean_late_diss + late_diss;
            
            local_energy_full_list = local_energy_full_list + local_energy_list(late_count_indices, :);
            
%             all_early = [all_early, early_diss];
%             all_late = [all_late, late_diss];
        end
    end
end

mean_early_counts = mean_early_counts / num_extract;
mean_late_counts = mean_late_counts / num_extract;
mean_early_frac = mean_early_frac / num_extract;
mean_late_frac = mean_late_frac / num_extract;
mean_early_diss = mean_early_diss / num_extract;
mean_late_diss = mean_late_diss / num_extract;

% figure()
% plot(mean_early_counts, 'b', 'LineWidth', 2)
% hold on
% plot(mean_late_counts, 'r', 'LineWidth', 2)
% % % bar([mean_early_counts; mean_late_counts]', 'b', 'r')
% % % bar(mean_late_counts)
% % 
% figure()
% plot(mean_early_frac, 'b', 'LineWidth', 2)
% hold on
% plot(mean_late_frac, 'r', 'LineWidth', 2)
% % % bar(mean_early_frac)
% % % hold on
% % % bar(mean_late_frac)
% % 
% figure()
% plot(mean_early_diss, 'b', 'LineWidth', 2)
% hold on
% plot(mean_late_diss, 'r', 'LineWidth', 2)
% 
% figure()
% plot(mean_late_diss ./ mean_early_diss, 'LineWidth', 2)

dev = (flip_trajectory_sqr / num_extract - (flip_trajectory / num_extract).^2).^(1/2);
h = figure();
set(h, 'defaultAxesColorOrder', [[0, 0, 1]; [1, 0, 0]])
yyaxis left
% plot(1000:1000:30000, flip_trajectory / num_extract / 10, 'LineWidth', 2)
% errorbar(10:10:300, flip_trajectory / num_extract / 100, dev / 100, 'x-', 'Color', 'b', 'LineWidth', 2)
hold on
plot(10:10:300, flip_trajectory / num_extract / 100, 'Color', 'b', 'LineWidth', 2)
fill([10:10:300, 300:-10:10], [flip_trajectory / num_extract / 100 + dev/100, flip_trajectory(end:-1:1) / num_extract / 100 - dev(end:-1:1)/100], 'b', 'FaceAlpha', .4, 'EdgeColor', 'none')
xlabel('field switches', 'FontSize', 20, 'FontName', 'Helvetica Neue')
ylabel('flips/switch', 'FontSize', 20, 'FontName', 'Helvetica Neue', 'Color', 'b')
title('tempered high flip rate average', 'FontSize', 20, 'FontName', 'Helvetica Neue')
axis([0, 300, 0, .16])

ticklabels = get(gca, 'YTickLabel');
ticklabels_new = cell(size(ticklabels));
for i = 1:length(ticklabels)
    ticklabels_new{i} = ['\color{blue} ' ticklabels{i}];
end
set(gca, 'YTickLabel', ticklabels_new);

dev_2 = (local_energy_trajectory_sqr / num_extract - (local_energy_trajectory / num_extract).^2).^(1/2);
yyaxis right
% plot(0:1000:30000, local_energy_trajectory / num_extract, 'LineWidth', 2)
% errorbar(0:10:300, local_energy_trajectory / num_extract, dev_2, 'x-', 'Color', 'r', 'LineWidth', 2)
hold on
plot(0:10:300, local_energy_trajectory / num_extract, 'Color', 'r', 'LineWidth', 2)
fill([0:10:300, 300:-10:0], [local_energy_trajectory / num_extract + dev_2, local_energy_trajectory(end:-1:1) / num_extract - dev_2(end:-1:1)], 'r', 'FaceAlpha', .4, 'EdgeColor', 'none')
ylabel('E_{int}', 'FontSize', 20, 'FontName', 'Helvetica Neue', 'Color', 'r')
axis([0, 300, -.25, .35])
ticklabels = get(gca, 'YTickLabel');
ticklabels_new = cell(size(ticklabels));
for i = 1:length(ticklabels)
    ticklabels_new{i} = ['\color{red} ' ticklabels{i}];
end
set(gca, 'YTickLabel', ticklabels_new);

% 
% figure()
% plot(local_energy_full_list(:, 1) / num_extract, 'b', 'LineWidth', 2)
% hold on
% plot(local_energy_full_list(:, 31) / num_extract, 'r', 'LineWidth', 2)
% xlabel('final flip rate spin rank', 'FontSize', 20)
% ylabel('local energy', 'FontSize', 20)
% title('increased temp local energy', 'FontSize', 20)
% legend({'initial distribution', 'final distribution'}, 'FontSize', 20)

% figure()
% histogram(all_early)
% hold on
% histogram(all_late)
% 
% figure()
% histogram(all_late - all_early)

% figure()
% scatter(all_early, all_late)
