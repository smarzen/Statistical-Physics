date = datetime('now', 'Format', 'yyyy_MM_dd_h_mm');
folder_name = strcat('spin_glass_switch_fields_fix_slow_many_realizations_', string(date));
mkdir(char(folder_name))

for total_iter = 1:5000

% date = datetime('now', 'Format', 'yyyy_MM_dd_h_mm');
% folder_name = strcat('spin_glass_switch_fields_perturb_slow_many_', string(date));
% mkdir(char(folder_name))


% file = 'driving_disabled.mat';
num_rows = 8;
num_cols = 8;
num_spins = num_rows * num_cols;
% interaction_locs = scale_free_adjacency_matrix(num_spins, .8);
% interaction_locs = periodic_adjacency_matrix(num_rows, num_cols);
interaction_locs = random_adjacency_matrix(num_spins, 8);
interaction_locs = 1 * (double(interaction_locs) .* (1 + normrnd(0, .3, size(interaction_locs))));
interactions = double(interaction_locs) .* (randi(2, num_spins) * 2 - 3);
for row = 2:num_spins
   for col = 1:(row - 1)
       interactions(row, col) = interactions(col, row);
   end
end
spin_barriers = zeros(num_spins, 1);
spin_barriers(randperm(num_spins, floor(num_spins / 2))) = .5; % + .5 * (total_iter);

initial_spin_list = randi(2, [num_spins, 5]) * 2 - 3;

fast_spins = find(spin_barriers == min(spin_barriers));
slow_spins = find(spin_barriers == max(spin_barriers));
interactions = interactions([slow_spins, fast_spins], [slow_spins, fast_spins]);
spin_barriers = spin_barriers([slow_spins; fast_spins]);

final_spins = [];
for iter_2 = 1:1
    for iter = 1:1
        file = strcat('driving_disabled_', string(total_iter), '_', string(iter_2));
        final_spins = [final_spins, spin_glass_function_switch_driving_fields_fast(initial_spin_list(:, iter_2), interactions, spin_barriers, 0, 10, zeros(num_spins, 1), 100, true, 0, 100000, strcat(folder_name, '/', file))];
    end
end


% load_filename = 'spin_glass_poisson_2016_12_06_3_36/driving_enabled_';
% 
% final_spins = [];
% for iter = 1:10
%     load(char(strcat(load_filename, '1_', num2str(iter), '_1.mat')));
%     final_spins = [final_spins, initial_spins];
% end

% driving_mags = [-5, -3, -2];

% driving_enabled = zeros(num_spins, 1);
% driving_enabled(randperm(num_spins, floor(num_spins / 4))) = 1;

% driving_fields = zeros(num_spins, 10);
% driving_fields(fast_spins, :) = normrnd(0, 1, [numel(fast_spins), size(driving_fields, 2)]);
% % driving_fields(fast_spins(randperm(numel(fast_spins), floor(numel(fast_spins)/2))), :) = normrnd(0, 5, [floor(numel(fast_spins)/2), size(driving_fields, 2)]);
% random_order = randi(size(driving_fields, 2) - 1, 10001, 1);

% driving_enabled_2 = zeros(num_spins,1);
% driving_enabled_2(fast_spins(randperm(numel(fast_spins), min([floor(num_spins / 4), numel(fast_spins)])))) = 1;

% driving_enabled = zeros(num_spins, 1);
% driving_enabled(randperm(num_spins, floor(num_spins / 10))) = 1;

% driving_enabled_2 = zeros(num_spins, 1);
% driving_enabled_2(randperm(num_spins, floor(num_spins / 10))) = 1;

% field_mags = [1, 1.33, 1.66, 2, 2.33, 2.67, 3, 3.33, 3.67, 4];
number_fields = [2, 6, 12, 20, 56, 132, 306, 600];
number_fields_2 = [2, 3, 4, 5, 8, 12, 18, 25];
% barrier_heights = [.1, .2, .3, .5, .7, 1, 1.3, 1.6, 2, 2.5];
% deterministic_probs = [1, .9, .7, .5, .3, .2, .1, .05, .03, .02, .01, 0];
epsilons = [.01, .03, .1, .3, .5, .7, .9, .97, .99, 1];

fast_spins = find(spin_barriers == min(spin_barriers));

num_fields = 5;

driving_fields = zeros(num_spins, num_fields);
driving_fields_2 = zeros(num_spins, num_fields);
rand_fast_spins = fast_spins(randperm(numel(fast_spins), numel(fast_spins)/2));

%random_order = randi(size(driving_fields, 2) - 1, 10001, 1);
periodic_order = ones([10001, 1]);
random_order = [];
while numel(random_order) < 10001
    random_order = [random_order, randperm(num_fields)];
end
random_order = diff(random_order);

random_order_2 = [];
while numel(random_order_2) < 10001
    random_order_2 = [random_order_2, randperm(num_fields)];
end
random_order_2 = diff(random_order_2);

random_order_3 = [];
while numel(random_order_3) < 10001
    random_order_3 = [random_order_3, randperm(num_fields)];
end
random_order_3 = diff(random_order_3);

fixed_spins = zeros(num_spins, 1);
fixed_spins(1:floor(num_spins / 2)) = 1;

% random_order = ones(1, 10001);
% random_order_2 = ones(1, 10001);

for iter = 1:1
    driving_fields(rand_fast_spins, :) = normrnd(0, 2, [numel(rand_fast_spins), num_fields]);
    
    
    for iter_2 = 1:1
%         driving_fields(rand_fast_spins, :) = normrnd(0, 2, [numel(rand_fast_spins), 1]);
        driving_fields_2(rand_fast_spins, :) = normrnd(0, 2, [numel(rand_fast_spins), num_fields]);
        
        
%         semi_random_order(randperm(numel(semi_random_order), floor(numel(semi_random_order) / 10))) = 2;
        
        for iter_3= 1:1
            
%             file_5 = strcat('fixed_slow_', string(total_iter), '_', string(iter_2), '_', string(iter_3));
%             final_spins_fixed = spin_glass_function_switch_driving_fields_fix_spins(final_spins(:, 1), logical(zeros(num_spins, 1)), interactions, spin_barriers, 0, 10, driving_fields_2, 20000, random_order, 0, 100000, strcat(folder_name, '/', file_5));
            
            file = strcat('fixed_slow_', string(total_iter), '_', string(iter_2), '_', string(iter_3));
            final_spins_fixed = spin_glass_function_switch_driving_fields_fix_spins(final_spins(:, 1), logical(zeros(num_spins, 1)), interactions, spin_barriers, 0, 10, driving_fields, 100, random_order, 0, 100000, strcat(folder_name, '/', file));

            file_3 = strcat('unfixed_slow_', string(total_iter), '_', string(iter_2), '_', string(iter_3));
            final_spins_unfixed = spin_glass_function_switch_driving_fields_fix_spins(final_spins(:, 1), logical(zeros(num_spins, 1)), interactions, spin_barriers, 0, 10, driving_fields, 100, random_order, 0, 100000, strcat(folder_name, '/', file_3));
            
            file_2 = strcat('fixed_slow_', string(total_iter), '_', string(iter_2), '_', string(iter_3), 'b');
%             fixed_spins = zeros(num_spins, 1);
%             fixed_spins(iter_3) = 1;
            modified_spins = final_spins_fixed;
%             modified_spins(1) = -1 * modified_spins(1);
            final_spins_fixed = spin_glass_function_switch_driving_fields_fix_spins(modified_spins, logical(fixed_spins), interactions, spin_barriers, 0, 10, driving_fields_2, 100, random_order_2, 0, 100000, strcat(folder_name, '/', file_2));
            
            file_4 = strcat('unfixed_slow_', string(total_iter), '_', string(iter_2), '_', string(iter_3), 'b');
            modified_spins = final_spins_unfixed;
%             modified_spins(1) = -1 * modified_spins(1);
            final_spins_unfixed = spin_glass_function_switch_driving_fields_fix_spins(modified_spins, logical(fixed_spins), interactions, spin_barriers, 0, 10, driving_fields, 100, random_order_2, 0, 100000, strcat(folder_name, '/', file_4));
            
            file_5 = strcat('fixed_slow_', string(total_iter), '_', string(iter_2), '_', string(iter_3), 'c');
            final_spins_fixed_2 = spin_glass_function_switch_driving_fields_fix_spins(final_spins_fixed, logical(fixed_spins), interactions, spin_barriers, 0, 10, driving_fields, 100, random_order_3, 0, 100000, strcat(folder_name, '/', file_5));
            
            file_6 = strcat('fixed_slow_', string(total_iter), '_', string(iter_2), '_', string(iter_3), 'd');
            final_spins_fixed_3 = spin_glass_function_switch_driving_fields_fix_spins(final_spins_fixed, logical(zeros(num_spins, 1)), interactions, spin_barriers, 0, 10, driving_fields_2, 100, random_order_3, 0, 100000, strcat(folder_name, '/', file_6));
        end
    end
end

end
