
filename = 'spin_glass_switch_fields_string_order_drive_quarter_2018_08_20_5_00/driving_disabled_';

plot_title = 'fixed';

statistic = [];
final_stats = [];
final_std = [];
plot_colors = [linspace(0, 1, 10); zeros(1, 10); linspace(1, 0, 10)]';

% load(char(strcat(filename, string(1), '_', string(1), '_', string(1), '/extra_data.mat')))
load(char(strcat(filename, string(1), '_', string(1), '/extra_data.mat')))

stat_means_i = {};
stat_means_f = {};
number_fields = [2, 3, 5, 7, 10, 12, 15, 20, 25, 30];
for iter_4 = 1:10
    stat_means_i{iter_4} = zeros(1, numel(0:100:t_max));
    stat_means_f{iter_4} = zeros(1, numel(0:100:t_max));
%     stat_means_f{iter_4} = zeros(1, 600);
    stat_means_2_i{iter_4} = zeros(1, numel(0:100:t_max));
    stat_means_2_f{iter_4} = zeros(1, numel(0:100:t_max));
end
% stat_sq_mean = [];

has_flips = zeros(10, 10, 32);

for iter_3 = 1:1000
    for iter_4 = 1:1
        statistic = [];
        
        for iter_5 = 1:1
%             file_list = dir(char(strcat(filename, string(iter_3), '_', string(iter_4), '_', string(iter_5))));
            file_list = dir(char(strcat(filename, string(iter_3), '_', string(iter_5))));
            stats = [];
            hist = [];
            flips = [];
            spin_diss = [];
            
            stats_2 = [];
            hist_2 = [];
            flips_2 = [];
            spin_diss_2 = [];
            for iter_6 = 1:(numel(file_list) - 3)
%                 load(char(strcat(filename, string(iter_3), '_', string(iter_4), '_', string(iter_5), '/data_', string(iter_6), '.mat')))
                load(char(strcat(filename, string(iter_3), '_', string(iter_5), '/data_', string(iter_6), '.mat')))
                stats = [stats, statistics];
                flips = [flips, flip_counts];
                hist = [hist, spin_hist];
                spin_diss = [spin_diss, spin_dissipation];

%                     load(char(strcat(filename, 'b_', string(iter_3), '_', string(iter_4), '_', string(iter_5), '/data_', string(iter_6), '.mat')))
%                     stats_2 = [stats_2, statistics];
%                     hist_2 = [hist_2, spin_hist];
%                 load(char(strcat(filename, string(iter_3), '_', string(iter_4), '_', string(iter_5), '/data_', string(iter_6), '.mat')))
%                 stats_2 = [stats_2, statistics];
%                 hist_2 = [hist_2, spin_hist];
%                 flips_2 = [flips_2, flip_counts];
%                 spin_diss_2 = [spin_diss_2, spin_dissipation];
                
            end
%             load(char(strcat(filename, string(iter_3), '_', string(iter_4), '_', string(iter_5), '/extra_data.mat')))
            load(char(strcat(filename, string(iter_3), '_', string(iter_5), '/extra_data.mat')))
            [temp, t_index, temp_2] = unique(stats(1, :));

%             load(char(strcat(filename, string(iter_4), '_', string(iter_5), '/extra_data.mat')))
%             interp_stats = diff(interp1(stats(1, t_index), stats(5, t_index), 0:10000:t_max));
             interp_stats = interp1(stats(1, t_index), stats(3, t_index), 0:100:t_max);

%             [temp, t_index, temp_2] = unique(stats_2(1, :));
%             interp_stats_2 = interp1(stats_2(1, t_index), stats_2(3, t_index), 0:100:t_max);

%             interp_stats_2 = interp1(stats_2(1, t_index), stats_2(3, t_index), 0:1000:t_max);
            
            
%             interp_stats_4 = interp1(stats_2(1, t_index), stats_2(3, t_index), 0:100:t_max);
% % %             
%             interp_stats = interp1(stats(1, t_index), spin_diss(1:32, t_index)', 0:100:t_max);
%             interp_stats = interp_stats';
%             interp_stats_2 = interp1(stats_2(1, t_index), spin_diss_2(1:32, t_index)', 0:100:t_max);
%             interp_stats_2 = interp_stats_2';
%             

            
            if iter_5 > 0
                if iter_5 <= 64 %&& flips_2(iter_5, end) > 10
%                     stat_means_i{1} = [stat_means_i{1}, mean(interp_stats_2((end - 199):(end - 99)))];
%                     stat_means_i{iter_3} = [stat_means_i{iter_3}, sum(flips(33:64, end) - flips(33:64, (end - 1000)))];%
%                     stat_means_f{iter_3} = [stat_means_f{iter_3}, sum(flips_2(33:64, end) - flips_2(33:64, (end - 1000)))];%
%                     stat_means_i{iter_3} = [stat_means_i{iter_3}, mean(interp_stats(:, (end - 99):end), 2)];
%                     stat_means_f{iter_3} = [stat_means_f{iter_3}, mean(interp_stats_2(:, (end - 99):end), 2)];
                    
%                     stat_means_i{iter_3} = [stat_means_i{iter_3}, mean(interp_stats((end - 99):end))];
%                     stat_means_f{iter_3} = [stat_means_f{iter_3}, mean(interp_stats_2((end - 99):end))];
                    
%                     stat_means_i{iter_5} = stat_means_i{iter_5} + mean(reshape_stats(floor(size(reshape_stats, 1) / 2):end, :), 1);
%                     interp_stats = reshape(interp_stats, 5, 600);
                    stat_means_f{iter_5} = stat_means_f{iter_5} + interp_stats; %std(interp_stats, 0, 1);
                    
%                     stat_means_i{iter_3} = [stat_means_i{iter_3}, mean(abs(mean(interp_stats(:, 101:200), 2) - mean(interp_stats(:, 1:100), 2)))];
%                     stat_means_f{iter_3} = [stat_means_f{iter_3}, mean(abs(mean(interp_stats(:, 901:end), 2) - mean(interp_stats(:, 801:900), 2)))];

%                     stat_means_i{iter_3} = [stat_means_i{iter_3}, interp_stats(:, 100)' - interp_stats(:, 1)'];
%                     stat_means_f{iter_3} = [stat_means_f{iter_3}, interp_stats(:, end)' - interp_stats(:, end - 99)'];
%                     
%                     stat_means_2_i{iter_5} = stat_means_2_i{iter_5} + mean(reshape_stats_2(floor(size(reshape_stats, 1) / 2):end, :), 1);
%                     stat_means_2_f{iter_5} = stat_means_2_f{iter_5} + interp_stats_2;

%                     stat_means_2_i{iter_3} = [stat_means_2_i{iter_3}, interp_stats_2(:, 100)' - interp_stats_2(:, 1)'];
%                     stat_means_2_f{iter_3} = [stat_means_2_f{iter_3}, interp_stats_2(:, end)' - interp_stats_2(:, end - 99)'];
                    has_flips(iter_3, iter_4, iter_5) = 1;
                end
            end

        end
        
        
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

low_diss_fraction = [];

for iter_4 = 1:1


    all_means_i = [all_means_i, stat_means_i{iter_4}];
%     all_means_i_2 = [all_means_i_2, stat_means_i_2{iter_4}];
    all_means_f = [all_means_f, stat_means_f{iter_4}];
%     all_means_f_2 = [all_means_f_2, stat_means_f_2{iter_4}];
%     diff_means = [diff_means, mean(abs(stat_means_f_2{iter_4} - stat_means_f{iter_4}))];
%     diff_stds = [diff_stds, std(stat_means_f_2{iter_4} - stat_means_f{iter_4})];
%     diff_frac = [diff_frac, sum(abs(stat_means_f_2{iter_4} - stat_means_f{iter_4}) > 5) / 300];
    all_means_2_i = [all_means_2_i, stat_means_2_i{iter_4}];
    all_means_2_f = [all_means_2_f, stat_means_2_f{iter_4}];
%     all_means_2_i_2 = [all_means_2_i_2, stat_means_2_i_2{iter_4}];
%     all_means_2_f_2 = [all_means_2_f_2, stat_means_2_f_2{iter_4}];

%     exp_fit = @(x)sum((stat_means_f{iter_4}(101:1000) - (x(1) * exp((101:1000) * x(2)) + x(3))).^2);
%     exp_fit_2 = @(x)sum((stat_means_2_f{iter_4} - (x(1) * exp((1:1000) * x(2)) + x(3))).^2);
%     
%     fit_1 = fminsearch(exp_fit, [2.5E5, .1, .5E5]);
    
    figure(16)
    hold on
%     plot(100:100:t_max, [stat_means_f{iter_4}], 'LineWidth', 2)%, 'Color', [iter_4 / 5, 0, 1 - iter_4 / 5])
    plot(0:100:100000, stat_means_f{iter_4}, 'LineWidth', 2.5, 'Color', [0, 0, 1])


end

filename = 'spin_glass_switch_fields_string_order_drive_quarter_2018_08_20_5_00/no_drive_';

plot_title = 'fixed';

statistic = [];
final_stats = [];
final_std = [];
plot_colors = [linspace(0, 1, 10); zeros(1, 10); linspace(1, 0, 10)]';

load(char(strcat(filename, string(1), '_', string(1), '_', string(1), '/extra_data.mat')))
% load(char(strcat(filename, string(1), '_', string(1), '/extra_data.mat')))

stat_means_i = {};
stat_means_f = {};
number_fields = [2, 3, 5, 7, 10, 12, 15, 20, 25, 30];
for iter_4 = 1:10
    stat_means_i{iter_4} = zeros(1, numel(0:100:t_max));
    stat_means_f{iter_4} = zeros(1, numel(0:100:t_max));
%     stat_means_f{iter_4} = zeros(1, 600);
    stat_means_2_i{iter_4} = zeros(1, numel(0:100:t_max));
    stat_means_2_f{iter_4} = zeros(1, numel(0:100:t_max));
end
% stat_sq_mean = [];

has_flips = zeros(10, 10, 32);

for iter_3 = 1:1000
    for iter_4 = 1:1
        statistic = [];
        
        for iter_5 = 2:2
            file_list = dir(char(strcat(filename, string(iter_3), '_', string(iter_4), '_', string(iter_5))));
%             file_list = dir(char(strcat(filename, string(iter_3), '_', string(iter_5))));
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
%                 load(char(strcat(filename, string(iter_3), '_', string(iter_5), '/data_', string(iter_6), '.mat')))
                stats = [stats, statistics];
                flips = [flips, flip_counts];
                hist = [hist, spin_hist];
                spin_diss = [spin_diss, spin_dissipation];

%                     load(char(strcat(filename, 'b_', string(iter_3), '_', string(iter_4), '_', string(iter_5), '/data_', string(iter_6), '.mat')))
%                     stats_2 = [stats_2, statistics];
%                     hist_2 = [hist_2, spin_hist];
%                 load(char(strcat(filename, string(iter_3), '_', string(iter_4), '_', string(iter_5), '/data_', string(iter_6), '.mat')))
%                 stats_2 = [stats_2, statistics];
%                 hist_2 = [hist_2, spin_hist];
%                 flips_2 = [flips_2, flip_counts];
%                 spin_diss_2 = [spin_diss_2, spin_dissipation];
                
            end
            load(char(strcat(filename, string(iter_3), '_', string(iter_4), '_', string(iter_5), '/extra_data.mat')))
%             load(char(strcat(filename, string(iter_3), '_', string(iter_5), '/extra_data.mat')))
            [temp, t_index, temp_2] = unique(stats(1, :));

%             load(char(strcat(filename, string(iter_4), '_', string(iter_5), '/extra_data.mat')))
%             interp_stats = diff(interp1(stats(1, t_index), stats(5, t_index), 0:10000:t_max));
             interp_stats = interp1(stats(1, t_index), stats(3, t_index), 0:100:t_max);

%             [temp, t_index, temp_2] = unique(stats_2(1, :));
%             interp_stats_2 = interp1(stats_2(1, t_index), stats_2(3, t_index), 0:100:t_max);

%             interp_stats_2 = interp1(stats_2(1, t_index), stats_2(3, t_index), 0:1000:t_max);
            
            
%             interp_stats_4 = interp1(stats_2(1, t_index), stats_2(3, t_index), 0:100:t_max);
% % %             
%             interp_stats = interp1(stats(1, t_index), spin_diss(1:32, t_index)', 0:100:t_max);
%             interp_stats = interp_stats';
%             interp_stats_2 = interp1(stats_2(1, t_index), spin_diss_2(1:32, t_index)', 0:100:t_max);
%             interp_stats_2 = interp_stats_2';
%             

            
            if iter_5 > 0
                if iter_5 <= 64 %&& flips_2(iter_5, end) > 10
%                     stat_means_i{1} = [stat_means_i{1}, mean(interp_stats_2((end - 199):(end - 99)))];
%                     stat_means_i{iter_3} = [stat_means_i{iter_3}, sum(flips(33:64, end) - flips(33:64, (end - 1000)))];%
%                     stat_means_f{iter_3} = [stat_means_f{iter_3}, sum(flips_2(33:64, end) - flips_2(33:64, (end - 1000)))];%
%                     stat_means_i{iter_3} = [stat_means_i{iter_3}, mean(interp_stats(:, (end - 99):end), 2)];
%                     stat_means_f{iter_3} = [stat_means_f{iter_3}, mean(interp_stats_2(:, (end - 99):end), 2)];
                    
%                     stat_means_i{iter_3} = [stat_means_i{iter_3}, mean(interp_stats((end - 99):end))];
%                     stat_means_f{iter_3} = [stat_means_f{iter_3}, mean(interp_stats_2((end - 99):end))];
                    
%                     stat_means_i{iter_5} = stat_means_i{iter_5} + mean(reshape_stats(floor(size(reshape_stats, 1) / 2):end, :), 1);
%                     interp_stats = reshape(interp_stats, 5, 600);
                    stat_means_f{iter_5} = stat_means_f{iter_5} + interp_stats; %std(interp_stats, 0, 1);
                    
%                     stat_means_i{iter_3} = [stat_means_i{iter_3}, mean(abs(mean(interp_stats(:, 101:200), 2) - mean(interp_stats(:, 1:100), 2)))];
%                     stat_means_f{iter_3} = [stat_means_f{iter_3}, mean(abs(mean(interp_stats(:, 901:end), 2) - mean(interp_stats(:, 801:900), 2)))];

%                     stat_means_i{iter_3} = [stat_means_i{iter_3}, interp_stats(:, 100)' - interp_stats(:, 1)'];
%                     stat_means_f{iter_3} = [stat_means_f{iter_3}, interp_stats(:, end)' - interp_stats(:, end - 99)'];
%                     
%                     stat_means_2_i{iter_5} = stat_means_2_i{iter_5} + mean(reshape_stats_2(floor(size(reshape_stats, 1) / 2):end, :), 1);
%                     stat_means_2_f{iter_5} = stat_means_2_f{iter_5} + interp_stats_2;

%                     stat_means_2_i{iter_3} = [stat_means_2_i{iter_3}, interp_stats_2(:, 100)' - interp_stats_2(:, 1)'];
%                     stat_means_2_f{iter_3} = [stat_means_2_f{iter_3}, interp_stats_2(:, end)' - interp_stats_2(:, end - 99)'];
                    has_flips(iter_3, iter_4, iter_5) = 1;
                end
            end

        end
        
        
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

low_diss_fraction = [];

for iter_4 = 2:2


    all_means_i = [all_means_i, stat_means_i{iter_4}];
%     all_means_i_2 = [all_means_i_2, stat_means_i_2{iter_4}];
    all_means_f = [all_means_f, stat_means_f{iter_4}];
%     all_means_f_2 = [all_means_f_2, stat_means_f_2{iter_4}];
%     diff_means = [diff_means, mean(abs(stat_means_f_2{iter_4} - stat_means_f{iter_4}))];
%     diff_stds = [diff_stds, std(stat_means_f_2{iter_4} - stat_means_f{iter_4})];
%     diff_frac = [diff_frac, sum(abs(stat_means_f_2{iter_4} - stat_means_f{iter_4}) > 5) / 300];
    all_means_2_i = [all_means_2_i, stat_means_2_i{iter_4}];
    all_means_2_f = [all_means_2_f, stat_means_2_f{iter_4}];
%     all_means_2_i_2 = [all_means_2_i_2, stat_means_2_i_2{iter_4}];
%     all_means_2_f_2 = [all_means_2_f_2, stat_means_2_f_2{iter_4}];

%     exp_fit = @(x)sum((stat_means_f{iter_4}(101:1000) - (x(1) * exp((101:1000) * x(2)) + x(3))).^2);
%     exp_fit_2 = @(x)sum((stat_means_2_f{iter_4} - (x(1) * exp((1:1000) * x(2)) + x(3))).^2);
%     
%     fit_1 = fminsearch(exp_fit, [2.5E5, .1, .5E5]);
    
    figure(16)
    hold on
%     plot(100:100:t_max, [stat_means_f{iter_4}], 'LineWidth', 2)%, 'Color', [iter_4 / 5, 0, 1 - iter_4 / 5])
    plot(100000:100:110000, stat_means_f{iter_4}, 'LineWidth', 2.5, 'Color', [.7, 0, .7])


end

filename = 'spin_glass_switch_fields_string_order_drive_quarter_2018_08_20_5_00/no_drive_';

plot_title = 'fixed';

statistic = [];
final_stats = [];
final_std = [];
plot_colors = [linspace(0, 1, 10); zeros(1, 10); linspace(1, 0, 10)]';

load(char(strcat(filename, string(1), '_', string(1), '_', string(1), '/extra_data.mat')))
% load(char(strcat(filename, string(1), '_', string(1), '/extra_data.mat')))

stat_means_i = {};
stat_means_f = {};
number_fields = [2, 3, 5, 7, 10, 12, 15, 20, 25, 30];
for iter_4 = 1:10
    stat_means_i{iter_4} = zeros(1, numel(0:100:t_max));
    stat_means_f{iter_4} = zeros(1, numel(0:100:t_max));
%     stat_means_f{iter_4} = zeros(1, 600);
    stat_means_2_i{iter_4} = zeros(1, numel(0:100:t_max));
    stat_means_2_f{iter_4} = zeros(1, numel(0:100:t_max));
end
% stat_sq_mean = [];

has_flips = zeros(10, 10, 32);

for iter_3 = 1:1000
    for iter_4 = 1:1
        statistic = [];
        
        for iter_5 = 5:5
            file_list = dir(char(strcat(filename, string(iter_3), '_', string(iter_4), '_', string(iter_5))));
%             file_list = dir(char(strcat(filename, string(iter_3), '_', string(iter_5))));
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
%                 load(char(strcat(filename, string(iter_3), '_', string(iter_5), '/data_', string(iter_6), '.mat')))
                stats = [stats, statistics];
                flips = [flips, flip_counts];
                hist = [hist, spin_hist];
                spin_diss = [spin_diss, spin_dissipation];

%                     load(char(strcat(filename, 'b_', string(iter_3), '_', string(iter_4), '_', string(iter_5), '/data_', string(iter_6), '.mat')))
%                     stats_2 = [stats_2, statistics];
%                     hist_2 = [hist_2, spin_hist];
%                 load(char(strcat(filename, string(iter_3), '_', string(iter_4), '_', string(iter_5), '/data_', string(iter_6), '.mat')))
%                 stats_2 = [stats_2, statistics];
%                 hist_2 = [hist_2, spin_hist];
%                 flips_2 = [flips_2, flip_counts];
%                 spin_diss_2 = [spin_diss_2, spin_dissipation];
                
            end
            load(char(strcat(filename, string(iter_3), '_', string(iter_4), '_', string(iter_5), '/extra_data.mat')))
%             load(char(strcat(filename, string(iter_3), '_', string(iter_5), '/extra_data.mat')))
            [temp, t_index, temp_2] = unique(stats(1, :));

%             load(char(strcat(filename, string(iter_4), '_', string(iter_5), '/extra_data.mat')))
%             interp_stats = diff(interp1(stats(1, t_index), stats(5, t_index), 0:10000:t_max));
             interp_stats = interp1(stats(1, t_index), stats(3, t_index), 0:100:t_max);

%             [temp, t_index, temp_2] = unique(stats_2(1, :));
%             interp_stats_2 = interp1(stats_2(1, t_index), stats_2(3, t_index), 0:100:t_max);

%             interp_stats_2 = interp1(stats_2(1, t_index), stats_2(3, t_index), 0:1000:t_max);
            
            
%             interp_stats_4 = interp1(stats_2(1, t_index), stats_2(3, t_index), 0:100:t_max);
% % %             
%             interp_stats = interp1(stats(1, t_index), spin_diss(1:32, t_index)', 0:100:t_max);
%             interp_stats = interp_stats';
%             interp_stats_2 = interp1(stats_2(1, t_index), spin_diss_2(1:32, t_index)', 0:100:t_max);
%             interp_stats_2 = interp_stats_2';
%             

            
            if iter_5 > 0
                if iter_5 <= 64 %&& flips_2(iter_5, end) > 10
%                     stat_means_i{1} = [stat_means_i{1}, mean(interp_stats_2((end - 199):(end - 99)))];
%                     stat_means_i{iter_3} = [stat_means_i{iter_3}, sum(flips(33:64, end) - flips(33:64, (end - 1000)))];%
%                     stat_means_f{iter_3} = [stat_means_f{iter_3}, sum(flips_2(33:64, end) - flips_2(33:64, (end - 1000)))];%
%                     stat_means_i{iter_3} = [stat_means_i{iter_3}, mean(interp_stats(:, (end - 99):end), 2)];
%                     stat_means_f{iter_3} = [stat_means_f{iter_3}, mean(interp_stats_2(:, (end - 99):end), 2)];
                    
%                     stat_means_i{iter_3} = [stat_means_i{iter_3}, mean(interp_stats((end - 99):end))];
%                     stat_means_f{iter_3} = [stat_means_f{iter_3}, mean(interp_stats_2((end - 99):end))];
                    
%                     stat_means_i{iter_5} = stat_means_i{iter_5} + mean(reshape_stats(floor(size(reshape_stats, 1) / 2):end, :), 1);
%                     interp_stats = reshape(interp_stats, 5, 600);
                    stat_means_f{iter_5} = stat_means_f{iter_5} + interp_stats; %std(interp_stats, 0, 1);
                    
%                     stat_means_i{iter_3} = [stat_means_i{iter_3}, mean(abs(mean(interp_stats(:, 101:200), 2) - mean(interp_stats(:, 1:100), 2)))];
%                     stat_means_f{iter_3} = [stat_means_f{iter_3}, mean(abs(mean(interp_stats(:, 901:end), 2) - mean(interp_stats(:, 801:900), 2)))];

%                     stat_means_i{iter_3} = [stat_means_i{iter_3}, interp_stats(:, 100)' - interp_stats(:, 1)'];
%                     stat_means_f{iter_3} = [stat_means_f{iter_3}, interp_stats(:, end)' - interp_stats(:, end - 99)'];
%                     
%                     stat_means_2_i{iter_5} = stat_means_2_i{iter_5} + mean(reshape_stats_2(floor(size(reshape_stats, 1) / 2):end, :), 1);
%                     stat_means_2_f{iter_5} = stat_means_2_f{iter_5} + interp_stats_2;

%                     stat_means_2_i{iter_3} = [stat_means_2_i{iter_3}, interp_stats_2(:, 100)' - interp_stats_2(:, 1)'];
%                     stat_means_2_f{iter_3} = [stat_means_2_f{iter_3}, interp_stats_2(:, end)' - interp_stats_2(:, end - 99)'];
                    has_flips(iter_3, iter_4, iter_5) = 1;
                end
            end

        end
        
        
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

low_diss_fraction = [];

for iter_4 = 5:5


    all_means_i = [all_means_i, stat_means_i{iter_4}];
%     all_means_i_2 = [all_means_i_2, stat_means_i_2{iter_4}];
    all_means_f = [all_means_f, stat_means_f{iter_4}];
%     all_means_f_2 = [all_means_f_2, stat_means_f_2{iter_4}];
%     diff_means = [diff_means, mean(abs(stat_means_f_2{iter_4} - stat_means_f{iter_4}))];
%     diff_stds = [diff_stds, std(stat_means_f_2{iter_4} - stat_means_f{iter_4})];
%     diff_frac = [diff_frac, sum(abs(stat_means_f_2{iter_4} - stat_means_f{iter_4}) > 5) / 300];
    all_means_2_i = [all_means_2_i, stat_means_2_i{iter_4}];
    all_means_2_f = [all_means_2_f, stat_means_2_f{iter_4}];
%     all_means_2_i_2 = [all_means_2_i_2, stat_means_2_i_2{iter_4}];
%     all_means_2_f_2 = [all_means_2_f_2, stat_means_2_f_2{iter_4}];

%     exp_fit = @(x)sum((stat_means_f{iter_4}(101:1000) - (x(1) * exp((101:1000) * x(2)) + x(3))).^2);
%     exp_fit_2 = @(x)sum((stat_means_2_f{iter_4} - (x(1) * exp((1:1000) * x(2)) + x(3))).^2);
%     
%     fit_1 = fminsearch(exp_fit, [2.5E5, .1, .5E5]);
    
    figure(16)
    hold on
%     plot(100:100:t_max, [stat_means_f{iter_4}], 'LineWidth', 2)%, 'Color', [iter_4 / 5, 0, 1 - iter_4 / 5])
    plot(100000:100:110000, stat_means_f{iter_4}, 'LineWidth', 2.5, 'Color', [1, 0, 0])


end


filename = 'spin_glass_switch_fields_string_order_drive_quarter_2018_08_20_5_00/random_order_';

plot_title = 'fixed';

statistic = [];
final_stats = [];
final_std = [];
plot_colors = [linspace(0, 1, 10); zeros(1, 10); linspace(1, 0, 10)]';

load(char(strcat(filename, string(1), '_', string(1), '_', string(1), '/extra_data.mat')))
% load(char(strcat(filename, string(1), '_', string(1), '/extra_data.mat')))

stat_means_i = {};
stat_means_f = {};
number_fields = [2, 3, 5, 7, 10, 12, 15, 20, 25, 30];
for iter_4 = 1:10
    stat_means_i{iter_4} = zeros(1, numel(0:100:t_max));
    stat_means_f{iter_4} = zeros(1, numel(0:100:t_max));
%     stat_means_f{iter_4} = zeros(1, 600);
    stat_means_2_i{iter_4} = zeros(1, numel(0:100:t_max));
    stat_means_2_f{iter_4} = zeros(1, numel(0:100:t_max));
end
% stat_sq_mean = [];

has_flips = zeros(10, 10, 32);

for iter_3 = 1:1000
    for iter_4 = 1:1
        statistic = [];
        
        for iter_5 = 1:1
            file_list = dir(char(strcat(filename, string(iter_3), '_', string(iter_4), '_', string(iter_5))));
%             file_list = dir(char(strcat(filename, string(iter_3), '_', string(iter_5))));
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
%                 load(char(strcat(filename, string(iter_3), '_', string(iter_5), '/data_', string(iter_6), '.mat')))
                stats = [stats, statistics];
                flips = [flips, flip_counts];
                hist = [hist, spin_hist];
                spin_diss = [spin_diss, spin_dissipation];

%                     load(char(strcat(filename, 'b_', string(iter_3), '_', string(iter_4), '_', string(iter_5), '/data_', string(iter_6), '.mat')))
%                     stats_2 = [stats_2, statistics];
%                     hist_2 = [hist_2, spin_hist];
%                 load(char(strcat(filename, string(iter_3), '_', string(iter_4), '_', string(iter_5), '/data_', string(iter_6), '.mat')))
%                 stats_2 = [stats_2, statistics];
%                 hist_2 = [hist_2, spin_hist];
%                 flips_2 = [flips_2, flip_counts];
%                 spin_diss_2 = [spin_diss_2, spin_dissipation];
                
            end
            load(char(strcat(filename, string(iter_3), '_', string(iter_4), '_', string(iter_5), '/extra_data.mat')))
%             load(char(strcat(filename, string(iter_3), '_', string(iter_5), '/extra_data.mat')))
            [temp, t_index, temp_2] = unique(stats(1, :));

%             load(char(strcat(filename, string(iter_4), '_', string(iter_5), '/extra_data.mat')))
%             interp_stats = diff(interp1(stats(1, t_index), stats(5, t_index), 0:10000:t_max));
             interp_stats = interp1(stats(1, t_index), stats(3, t_index), 0:100:t_max);

%             [temp, t_index, temp_2] = unique(stats_2(1, :));
%             interp_stats_2 = interp1(stats_2(1, t_index), stats_2(3, t_index), 0:100:t_max);

%             interp_stats_2 = interp1(stats_2(1, t_index), stats_2(3, t_index), 0:1000:t_max);
            
            
%             interp_stats_4 = interp1(stats_2(1, t_index), stats_2(3, t_index), 0:100:t_max);
% % %             
%             interp_stats = interp1(stats(1, t_index), spin_diss(1:32, t_index)', 0:100:t_max);
%             interp_stats = interp_stats';
%             interp_stats_2 = interp1(stats_2(1, t_index), spin_diss_2(1:32, t_index)', 0:100:t_max);
%             interp_stats_2 = interp_stats_2';
%             

            
            if iter_5 > 0
                if iter_5 <= 64 %&& flips_2(iter_5, end) > 10
%                     stat_means_i{1} = [stat_means_i{1}, mean(interp_stats_2((end - 199):(end - 99)))];
%                     stat_means_i{iter_3} = [stat_means_i{iter_3}, sum(flips(33:64, end) - flips(33:64, (end - 1000)))];%
%                     stat_means_f{iter_3} = [stat_means_f{iter_3}, sum(flips_2(33:64, end) - flips_2(33:64, (end - 1000)))];%
%                     stat_means_i{iter_3} = [stat_means_i{iter_3}, mean(interp_stats(:, (end - 99):end), 2)];
%                     stat_means_f{iter_3} = [stat_means_f{iter_3}, mean(interp_stats_2(:, (end - 99):end), 2)];
                    
%                     stat_means_i{iter_3} = [stat_means_i{iter_3}, mean(interp_stats((end - 99):end))];
%                     stat_means_f{iter_3} = [stat_means_f{iter_3}, mean(interp_stats_2((end - 99):end))];
                    
%                     stat_means_i{iter_5} = stat_means_i{iter_5} + mean(reshape_stats(floor(size(reshape_stats, 1) / 2):end, :), 1);
%                     interp_stats = reshape(interp_stats, 5, 600);
                    stat_means_f{iter_5} = stat_means_f{iter_5} + interp_stats; %std(interp_stats, 0, 1);
                    
%                     stat_means_i{iter_3} = [stat_means_i{iter_3}, mean(abs(mean(interp_stats(:, 101:200), 2) - mean(interp_stats(:, 1:100), 2)))];
%                     stat_means_f{iter_3} = [stat_means_f{iter_3}, mean(abs(mean(interp_stats(:, 901:end), 2) - mean(interp_stats(:, 801:900), 2)))];

%                     stat_means_i{iter_3} = [stat_means_i{iter_3}, interp_stats(:, 100)' - interp_stats(:, 1)'];
%                     stat_means_f{iter_3} = [stat_means_f{iter_3}, interp_stats(:, end)' - interp_stats(:, end - 99)'];
%                     
%                     stat_means_2_i{iter_5} = stat_means_2_i{iter_5} + mean(reshape_stats_2(floor(size(reshape_stats, 1) / 2):end, :), 1);
%                     stat_means_2_f{iter_5} = stat_means_2_f{iter_5} + interp_stats_2;

%                     stat_means_2_i{iter_3} = [stat_means_2_i{iter_3}, interp_stats_2(:, 100)' - interp_stats_2(:, 1)'];
%                     stat_means_2_f{iter_3} = [stat_means_2_f{iter_3}, interp_stats_2(:, end)' - interp_stats_2(:, end - 99)'];
                    has_flips(iter_3, iter_4, iter_5) = 1;
                end
            end

        end
        
        
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

low_diss_fraction = [];

for iter_4 = 1:1


    all_means_i = [all_means_i, stat_means_i{iter_4}];
%     all_means_i_2 = [all_means_i_2, stat_means_i_2{iter_4}];
    all_means_f = [all_means_f, stat_means_f{iter_4}];
%     all_means_f_2 = [all_means_f_2, stat_means_f_2{iter_4}];
%     diff_means = [diff_means, mean(abs(stat_means_f_2{iter_4} - stat_means_f{iter_4}))];
%     diff_stds = [diff_stds, std(stat_means_f_2{iter_4} - stat_means_f{iter_4})];
%     diff_frac = [diff_frac, sum(abs(stat_means_f_2{iter_4} - stat_means_f{iter_4}) > 5) / 300];
    all_means_2_i = [all_means_2_i, stat_means_2_i{iter_4}];
    all_means_2_f = [all_means_2_f, stat_means_2_f{iter_4}];
%     all_means_2_i_2 = [all_means_2_i_2, stat_means_2_i_2{iter_4}];
%     all_means_2_f_2 = [all_means_2_f_2, stat_means_2_f_2{iter_4}];

%     exp_fit = @(x)sum((stat_means_f{iter_4}(101:1000) - (x(1) * exp((101:1000) * x(2)) + x(3))).^2);
%     exp_fit_2 = @(x)sum((stat_means_2_f{iter_4} - (x(1) * exp((1:1000) * x(2)) + x(3))).^2);
%     
%     fit_1 = fminsearch(exp_fit, [2.5E5, .1, .5E5]);
    
    figure(16)
    hold on
%     plot(100:100:t_max, [stat_means_f{iter_4}], 'LineWidth', 2)%, 'Color', [iter_4 / 5, 0, 1 - iter_4 / 5])
    plot(100000:100:110000, stat_means_f{iter_4}, 'LineWidth', 2.5, 'Color', [0, .8, 0])


end

xlabel('time', 'FontSize', 20)
ylabel('internal energy', 'FontSize', 20)
legend({'\beta = 2.5', '\beta = 2.0', '\beta = 0.25', '\beta = 2.5, <\mu^2> = 25'}, 'FontSize', 20)
axis([95000, 110000, -1.192E5, -1.172E5])







