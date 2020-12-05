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
    for iter_4 = 1:3
        load(char(strcat(filename, '1_', string(iter_4), '_1/extra_data', '.mat')))
        num_driving_fields = size(driving_fields, 2);
        num_switches = ceil(t_max / (num_driving_fields * switch_time));
        
        hists = zeros(1, num_switches);
%         all_data = [];
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
            data_diff = diff(relevant_data, 1, 2); % ./ diff(times);
%             data_diff = relevant_data - mean(relevant_data, 2);
%             data_diff = relevant_data - relevant_data(:, 1);
%             mean_diff = mean(abs(data_diff), 1);
            abs_diff = abs(data_diff);
            mean_diffs = mean_diffs + abs_diff;
            hists = hists + relevant_data;
%             all_data = [all_data, relevant_data];
            
%             mean_rates = [mean_rates, mean(mean_diff .* diff(times))];
        end
        hists = hists / iter_5;
        mean_diffs = mean_diffs / iter_5;
        std_dev = std(hists, 0, 2);
        mean_rates = [mean_rates, mean(mean_diffs .* diff(times))];
        std_rates = [std_rates, std(mean_diffs .* diff(times), 1)];
        
        early_mean_diffs = mean(mean_diffs(:, 10:100), 2);
        late_mean_diffs = mean(mean_diffs(:, (end - 90):end), 2);
        
        figure()
        hold on
        histogram(early_mean_diffs, 0:.0005:.01, 'Normalization', 'probability', 'FaceColor', [0, 0, 1])
        histogram(late_mean_diffs, 0:.0005:.01, 'Normalization', 'probability', 'FaceColor', [0, 1, 0])
        
    end
end