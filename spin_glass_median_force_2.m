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
filename = 'spin_glass_switch_fields_record_force_2017_09_07_9_41/periodic_driving_';
% instrinsic flip rates, two drives

num_spins = 64;

statistic = [];
final_stats = [];
final_std = [];
plot_colors = [linspace(0, 1, 5); zeros(1, 5); linspace(1, 0, 5)];

stat_mean = [];
stat_sq_mean = [];
force_vector_means = {};
for iter_4 = 1:5
    force_vector_means{iter_4} = [];
end

for iter_3 = 1:10
    for iter_4 = 1:5
        force_vector_mean = zeros(num_spins, 1);
        for iter_5 = 1:3
            file_list = dir(char(strcat(filename, string(iter_3), '_', string(iter_4), '_', string(iter_5))));
            force_vector = [];
            for iter_6 = 1:(numel(file_list) - 3)
                load(char(strcat(filename, string(iter_3), '_', string(iter_4), '_', string(iter_5), '/data_', string(iter_6), '.mat')))
                force_vector = [force_vector, force_vecs];
            end
            load(char(strcat(filename, string(iter_3), '_', string(iter_4), '_', string(iter_5), '/extra_data.mat')))
            force_vector_mean = force_vector_mean + movsum(force_vector, 10, 2);
            %t, energy, internal energy, mean mag, work, heat lost, internal work
        end
        
        fast_spins = find(spin_barriers == min(spin_barriers));
        slow_spins = find(spin_barriers == max(spin_barriers));
        
        force_vector_means{iter_4} = [force_vector_means{iter_4} ; sqrt(sum(force_vector_mean(slow_spins, :).^2, 1))];
%         force_vector_mean = force_vector_mean / iter_5;
        
%         
%         final_stats = [final_stats, mean(statistic(:, end))];
%         final_std = [final_std, std(statistic(:, end), 1)];
%         
%         stat_mean = [stat_mean, mean(mean(statistic))];
%         stat_sq_mean = [stat_sq_mean, mean(mean(statistic .^2))];
        
        
    end
end


for iter_4 = 1:5
force_vector_mean = median(force_vector_means{iter_4}, 1);

figure(10)
hold on
plot((10 * save_time):save_time:(t_max - 10 * save_time), force_vector_mean(10:(end - 10)), 'Color', plot_colors(:, iter_4), 'LineWidth', 1)

%     figure(10)
%     hold on
%     plot(sqrt(sum(force_vector_mean(slow_spins, :).^2, 1)), 'Color', plot_colors(:, iter_4))
% 
%     figure(11)
%     hold on
%     plot(sqrt(sum(force_vector_mean(fast_spins, :).^2, 1)), 'Color', plot_colors(:, iter_4))
% 
%     fluctuation_mean = zeros(floor(num_spins / 2), size(force_vector_mean, 2) - 100);
%     for iter_6 = 1:100
%         fluctuation_mean = fluctuation_mean + force_vector_mean(slow_spins, iter_6:(end - 101 + iter_6)).^2;
%     end
%     fluctuation_mean = fluctuation_mean / 100;
% 
%     figure(12)
%     hold on
%     plot(sum((force_vector_mean(slow_spins, 1:(end - 10)) .* force_vector_mean(slow_spins, 11:end)), 1), 'Color', plot_colors(:, iter_4))
% 
%     figure(13)
%     hold on
%     plot(sqrt(sum(diff(force_vector_mean(slow_spins, :), 1, 2).^2, 1)), 'Color', plot_colors(:, iter_4))
    
end

% figure(5)
% hold on
% % plot([10, 15, 20, 30, 50, 70, 100], final_stats, 'Color', [0, 0, 1])
% % errorbar([2, 3, 4, 5, 7, 10, 12, 15, 17, 20, 25, 30, 50, 70, 100], final_stats, final_std, 'Color', [1, 0, 0])
% errorbar([1, .9, .7, .5, .3, .2, .1, .05, .03, .02, .01, 0], final_stats, final_std, 'Color', [0, 0, 1])

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