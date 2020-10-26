
for total_iter = 1:1

date = datetime('now', 'Format', 'yyyy_MM_dd_h_mm');
folder_name = strcat('spin_glass_switch_fields_intermittent_determinism_', string(date));
mkdir(char(folder_name))
% file = 'driving_disabled.mat';
num_rows = 16;
num_cols = 16;
num_spins = num_rows * num_cols;
% interaction_locs = scale_free_adjacency_matrix(num_spins, .8);
interaction_locs = periodic_adjacency_matrix(num_rows, num_cols);
% interaction_locs = random_adjacency_matrix(num_spins, 16);
interactions_locs = double(interaction_locs) + normrnd(0, .3, size(interaction_locs));
interactions = interaction_locs .* (randi(2, num_spins) * 2 - 3);
for row = 2:num_spins
   for col = 1:(row - 1)
       interactions(row, col) = interactions(col, row);
   end
end
spin_barriers = ones(num_spins, 1) * .25;
spin_barriers(randperm(num_spins, floor(num_spins / 2))) = 1;

initial_spin_list = randi(2, [num_spins, 10]) * 2 - 3;

final_spins = [];
for iter_2 = 1:10
    for iter = 1:1
        file = strcat('driving_disabled_', string(iter_2), '_', string(iter));
        final_spins = [final_spins, spin_glass_function_switch_driving_fields_fast(initial_spin_list(:, iter_2), interactions, spin_barriers, 0, 10, zeros(num_spins, 1), 100, true, 0, 1000000, strcat(folder_name, '/', file))];
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

fast_spins = find(spin_barriers == min(spin_barriers));

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
% number_fields = [2, 5, 10, 25, 100];
% barrier_heights = [.1, .2, .3, .5, .7, 1, 1.3, 1.6, 2, 2.5];
deterministic_probs = [1, .9, .5, .3, .2, .1, .05, .03, .02, .01];

driving_fields = zeros(num_spins, 2);
%driving_fields(fast_spins, :) = normrnd(0, 3, [numel(fast_spins), 2]);
rand_fast_spins = fast_spins(randperm(numel(fast_spins), numel(fast_spins)/2));
driving_fields(rand_fast_spins, 1) = normrnd(0, 3, [numel(rand_fast_spins), 1]);
rand_fast_spins = fast_spins(randperm(numel(fast_spins), numel(fast_spins)/2));
driving_fields(rand_fast_spins, 2) = normrnd(0, 3, [numel(rand_fast_spins), 1]);
% random_order = randi(size(driving_fields, 2) - 1, 10001, 1);

for iter = 1:1
    
    for iter_2 = 1:10
%         random_order = randi(number_fields(iter_2) - 1, 10001, 1);
        
%         semi_random_order(randperm(numel(semi_random_order), floor(numel(semi_random_order) / 10))) = 2;
        
        for iter_3 = 1:10
%             file = strcat('periodic_driving_', string(iter), '_', string(iter_2), '_', string(iter_3));
%             file_2 = strcat('random_driving_', string(iter), '_', string(iter_2), '_', string(iter_3));
            file_3 = strcat('generate_driving_', string(iter), '_', string(iter_2), '_', string(iter_3));
%             final_spins_periodic = spin_glass_function_switch_driving_fields_fast(final_spins(:, iter_3), interactions, spin_barriers, 0, 10, driving_fields(:, 1:number_fields(iter_2)), 100, true, 0, 1000000, strcat(folder_name, '/', file));
%             final_spins_semi_random = spin_glass_function_switch_driving_fields_random_fast(final_spins(:, 1), interactions, spin_barriers, 0, 10, driving_fields, 100, semi_random_order, 0, 100000, strcat(folder_name, '/', file));
%             final_spins_random = spin_glass_function_switch_driving_fields_random_fast(final_spins(:, iter_3), interactions, spin_barriers, 0, 10, driving_fields(:, 1:number_fields(iter_2)), 100, random_order, 0, 1000000, strcat(folder_name, '/', file_2));
            final_spins_generate = spin_glass_function_generate_driving_fields_fast_2(final_spins(:, iter_3), interactions, spin_barriers, 0, 10, 3, 100, driving_fields(:, 1:2), deterministic_probs(iter_2), 0, 1000000, strcat(folder_name, '/', file_3));
        end
    end
end

end
