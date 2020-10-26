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
filename = 'spin_glass_gen_fields_vary_correlation_2017_08_15_1_54/uncorrelated_driving_';
% instrinsic flip rates, two drives


statistic = [];
final_stats = [];
final_std = [];
plot_colors = [linspace(0, 1, 10); zeros(1, 10); linspace(1, 0, 10)]';
probs = [1, .9, .7, .5, .3, .2, .1, .05, .03, .02, .01, 0];

for iter_3 = 1:3
    
    fon_means = [];
    foff_means = [];
    son_means = [];
    soff_means = [];
    
    for iter_4 = 1:12
        
        fon_mean = [];
        foff_mean = [];
        son_mean = [];
        soff_mean = [];

        for iter_5 = 1:10
            
            load(char(strcat(filename, string(iter_3), '_', string(iter_4), '_', string(iter_5), '/extra_data.mat')))
            first_on = find(driving_new_field == 1);
            first_off = find(driving_old_field == 1);
            second_on = find(driving_new_field == 3);
            second_off = find(driving_old_field == 3);
            
            fon_mean = [fon_mean, mean(driving_changes(first_on))];
            foff_mean = [foff_mean, mean(driving_changes(first_off))];
            son_mean = [son_mean, mean(driving_changes(second_on))];
            soff_mean = [soff_mean, mean(driving_changes(second_off))];
            
%             figure()
%             hold on
%             plot(driving_changes(first_on))
%             plot(driving_changes(first_off))
%             plot(driving_changes(second_on))
%             plot(driving_changes(second_off))
            
        end
        
        fon_means = [fon_means, mean(fon_mean)];
        foff_means = [foff_means, mean(foff_mean)];
        son_means = [son_means, mean(son_mean)];
        soff_means = [soff_means, mean(soff_mean)];
        
    end
    
    figure()
    hold on
    plot(probs, fon_means)
    plot(probs, foff_means)
    plot(probs, son_means)
    plot(probs, soff_means)
    legend({'first on', 'first off', 'second on', 'second off'})
    
end