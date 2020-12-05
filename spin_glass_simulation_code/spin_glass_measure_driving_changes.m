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
filename = 'spin_glass_gen_fields_many_2017_08_02_4_56/generate_driving_';
% instrinsic flip rates, two drives


statistic = [];
final_stats = [];
final_std = [];
plot_colors = [linspace(0, 1, 10); zeros(1, 10); linspace(1, 0, 10)]';
probs = [1, .9, .7, .5, .3, .2, .1, .05, .03, .02, .01, 0];

for iter_3 = 4:5
    
    dd_means = [];
    dr_means = [];
    rd_means = [];
    rr_means = [];
    dd_errors = [];
    dr_errors = [];
    rd_errors = [];
    rr_errors = [];
    
    for iter_4 = 1:12
        
        dd_mean = [];
        dr_mean = [];
        rd_mean = [];
        rr_mean = [];
        dd_changes = [];
        dr_changes = [];
        rd_changes = [];
        rr_changes = [];
        
        for iter_5 = 1:10
            
            load(char(strcat(filename, string(iter_3), '_', string(iter_4), '_', string(iter_5), '/extra_data.mat')))
            det_to_det = find((driving_old_field > 0) & (driving_new_field > 0));
            det_to_rand = find((driving_old_field > 0) & (driving_new_field == 0));
            rand_to_det = find((driving_old_field == 0) & (driving_new_field > 0));
            rand_to_rand = find((driving_old_field == 0) & (driving_new_field == 0));
            
            dd_changes = [dd_changes, driving_changes(det_to_det)];
            dr_changes = [dr_changes, driving_changes(rand_to_det)];
            rd_changes = [rd_changes, driving_changes(det_to_rand)];
            rr_changes = [rr_changes, driving_changes(rand_to_rand)];
            
            dd_mean = [dd_mean, mean(driving_changes(det_to_det))];
            dr_mean = [dr_mean, mean(driving_changes(det_to_rand))];
            rd_mean = [rd_mean, mean(driving_changes(rand_to_det))];
            rr_mean = [rr_mean, mean(driving_changes(rand_to_rand))];
            
        end
        
%         figure(1)
%         hold on
%         histogram(dd_changes, 25, 'Normalization', 'probability')
%         
%         figure(2)
%         hold on
%         histogram(dr_changes, 25, 'Normalization', 'probability')
%         
%         figure(3)
%         hold on
%         histogram(rd_changes, 25, 'Normalization', 'probability')
%         
%         figure(4)
%         hold on
%         histogram(rr_changes, 25, 'Normalization', 'probability')
        
        dd_means = [dd_means, mean(dd_mean)];
        dr_means = [dr_means, mean(dr_mean)];
        rd_means = [rd_means, mean(rd_mean)];
        rr_means = [rr_means, mean(rr_mean)];
        dd_errors = [dd_errors, std(dd_mean)];
        dr_errors = [dr_errors, std(dr_mean)];
        rd_errors = [rd_errors, std(rd_mean)];
        rr_errors = [rr_errors, std(rr_mean)];
        
        
    end
    
    figure()
    hold on
    plot(probs, dd_means)
    plot(probs, dr_means)
    plot(probs, rd_means)
    plot(probs, rr_means)
    legend({'dd', 'dr', 'rd', 'rr'})
    
end