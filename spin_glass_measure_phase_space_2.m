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
filename = 'spin_glass_switch_fields_gauss_num_fields_2017_07_13_2_00/periodic_driving_';
% instrinsic flip rates, two drives

load(char(strcat(filename, '1_1_1/extra_data', '.mat')))
slow_spins = find(spin_barriers == max(spin_barriers));
% num_driving_fields = size(driving_fields, 2);
% num_switches = floor(t_max / (num_driving_fields * switch_time));

field_num = 1;
mean_rates = [];
std_rates = [];

plot_colors = [linspace(0, 1, 17); zeros(1, 17); linspace(1, 0, 17)]';

for iter_3 = 1:1
    for iter_4 = 1:17
        load(char(strcat(filename, '1_', string(iter_4), '_1/extra_data', '.mat')))
        num_driving_fields = size(driving_fields, 2);
        num_switches = ceil(t_max / (num_driving_fields * switch_time));
        
        hists = zeros(1, num_switches);
        all_data = [];
        mean_diffs = zeros(1, num_switches - 1);
        statistic = [];
        for iter_5 = 1:10
            file_list = dir(char(strcat(filename, string(iter_3), '_', string(iter_4), '_', string(iter_5))));
            hist = [];
            stats = [];
            for iter_6 = 1:(numel(file_list) - 3)
                load(char(strcat(filename, string(iter_3), '_', string(iter_4), '_', string(iter_5), '/data_', string(iter_6), '.mat')))
                hist = [hist, spin_hist];
                stats = [stats, statistics];
                
            end
            load(char(strcat(filename, string(iter_3), '_', string(iter_4), '_', string(iter_5), '/extra_data.mat')))
            relevant_data = hist(slow_spins, (switch_time / save_time * field_num):(num_driving_fields * switch_time / save_time):end);
            times = stats(1, (switch_time / save_time * field_num):(num_driving_fields * switch_time / save_time):end);
            data_diff = diff(relevant_data, 1, 2) ./ diff(times);
%             data_diff = relevant_data - mean(relevant_data, 2);
%             data_diff = relevant_data - relevant_data(:, 1);
            mean_diff = mean(abs(data_diff), 1);
            mean_diffs = mean_diffs + mean_diff;
            hists = hists + relevant_data;
            all_data = [all_data, relevant_data];
            
%             mean_rates = [mean_rates, mean(mean_diff .* diff(times))];
        end
        hists = hists / iter_5;
        mean_diffs = mean_diffs / iter_5;
        std_dev = std(hists, 0, 2);
        mean_rates = [mean_rates, mean(mean_diffs .* diff(times))];
        std_rates = [std_rates, std(mean_diffs .* diff(times), 1)];
        
%         figure(4)
%         plot(hists(1:10, :)')
%         
        figure(5)
        hold on
        plot(times(2:end), mean_diffs, 'Color', plot_colors(iter_4, :))
%         hold on
%         plot(0:100:(t_max - 100), mean(diff(statistic, 1, 2), 1));
%         plot(0:100:t_max, mean(hists, 1))
%         hists = hists';
%         plot(hists(:, slow_spins))
%         plot(hists(1:50, :)')
%         plot(std_dev);
%         title('periodic driving', 'FontSize', 20)
%         xlabel('t', 'FontSize', 20)
%         ylabel('<s_i>', 'FontSize', 20)
        title('periodic driving pairwise change rate')
% % %         
%         [coeff, score, latent] = pca(all_data');
%         [idx, c_means] = kmeans(all_data', 5);
% % 
% %         
%         figure(8)
%         semilogy(latent / sum(latent), 'LineWidth', 2, 'Color', plot_colors(iter_4, :))
%         hold on
%         title('spin configuration PCA', 'FontSize', 20)
%         xlabel('component number', 'FontSize', 20)
%         ylabel('var_i / (total var)', 'FontSize', 20)
%         legend({'periodic driving', 'random driving'}, 'FontSize', 20)
%         
        new_times = linspace(times(1), times(end), 30);
        interp_accum_diff = interp1(times, [0, cumsum(mean_diffs .* diff(times))], new_times);
        
        figure(10)
        hold on
        periodic_plot = plot([0, times(2:end)], [0, cumsum(mean_diffs .* diff(times))], 'LineWidth', 1, 'Color', plot_colors(iter_4, :));
%         plot(new_times(2:end), diff(interp_accum_diff) / ((times(end) - times(1)) / 100))
% 
        figure(11)
        hold on
        periodic_plot_2 = plot(new_times(2:end), diff(interp_accum_diff) / ((times(end) - times(1)) / 100), 'LineWidth', 1, 'Color', plot_colors(iter_4, :));
    
        
    end
end

num_fields = [2, 3, 4, 5, 7, 10, 12, 15, 17, 20, 25, 30, 50, 70, 100, 125, 150];
% num_fields = [2, 3, 4];

figure(7)
% histogram(mean_rates, 20, 'Normalization', 'probability')
hold on
errorbar(num_fields, mean_rates, std_rates, 'Color', [0, 0, 1])

figure(8)
hold on
errorbar(num_fields, mean_rates ./ num_fields, std_rates ./ num_fields, 'Color', [0, 0, 1])

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