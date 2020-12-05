%choose name for folder to put results in

date = datetime('now', 'Format', 'yyyy_MM_dd_h_mm');
folder_name = strcat('spin_glass_switch_fields_string_order_drive_quarter_per_rand_', string(date));
mkdir(char(folder_name))

for total_iter = 1:10000

%choose number of spins (can either specifiy rows and columns to use with
%periodic adjacency matrix or just total number of spins)
num_rows = 16;
num_cols = 16;
num_spins = num_rows * num_cols;
% interaction_locs = scale_free_adjacency_matrix(num_spins, .8);
% interaction_locs = periodic_adjacency_matrix(num_rows, num_cols);
interaction_locs = random_adjacency_matrix(num_spins, 8);

% sigma of normrnd determines strength of interactions
interaction_locs = 1 * (double(interaction_locs) .* (normrnd(0, 3, size(interaction_locs)))); %.625 for 32 * 32
interactions = double(interaction_locs) .* (randi(2, num_spins) * 2 - 3);
for row = 2:num_spins
   for col = 1:(row - 1)
       interactions(row, col) = interactions(col, row);
   end
end

% choose explicit energetic barrier for each spin to flip
spin_barriers = ones(num_spins, 1) * 1;
fast_spins = randperm(num_spins, floor(num_spins / 4));
slow_spins = 1:num_spins;
slow_spins(fast_spins) = [];
interactions = interactions([fast_spins, slow_spins], [fast_spins, slow_spins]);
spin_barriers(fast_spins) = .25;
spin_barriers = spin_barriers([fast_spins, slow_spins]);

% set initial spin configuration
initial_spin_list = randi(2, [num_spins, 100]) * 2 - 3;

%fast_spins = find(spin_barriers == min(spin_barriers));
%slow_spins = find(spin_barriers == max(spin_barriers));
%interactions = interactions([slow_spins, fast_spins], [slow_spins, fast_spins]);
%spin_barriers = spin_barriers([slow_spins; fast_spins]);

% allow spins to reach quasi-equilibrium without drive
% the function is set up with the following arguments:
%     initial configuration of spins
%     no spins are fixed
%     interaction matrix
%     spin barriers
%     strength of external field
%     inverse temperature beta
%     vector of zeros for driving fields since no drive is applied
%     length of time each driving field is applied
%     order in which fields are applied
%     0 to avoid effects of deprecated code
%     length of simulation
%     folder within top level folder to save results of simulation to
final_spins = [];
for iter_2 = 1:1
    for iter = 1:1
        file = strcat('driving_disabled_', string(total_iter), '_', string(iter_2));
%         final_spins = [final_spins, spin_glass_function_switch_driving_fields_fast(initial_spin_list(:, iter_2), interactions, spin_barriers, 0, 10, zeros(num_spins, 1), 100, true, 0, 100000, strcat(folder_name, '/', file))];
        final_spins = [final_spins, spin_glass_function_switch_driving_fields_fix_spins_2(initial_spin_list(:, iter_2), logical(zeros(num_spins, 1)), interactions, spin_barriers, 0, 10, zeros(num_spins, 1), 100, ones(1, 10000), 0, 100000, strcat(folder_name, '/', file))];
    end
end

% field_mags = [1, 1.33, 1.66, 2, 2.33, 2.67, 3, 3.33, 3.67, 4];
number_fields = [2, 3, 5, 7, 10, 12, 15, 20, 25, 30];
number_fields_2 = [2, 3, 4, 5, 8, 12, 18, 25];
% barrier_heights = [.1, .2, .3, .5, .7, 1, 1.3, 1.6, 2, 2.5];
% deterministic_probs = [1, .9, .7, .5, .3, .2, .1, .05, .03, .02, .01, 0];
epsilons = [.01, .03, .1, .3, .5, .7, .9, .97, .99, 1];
% betas = [50, 20, 10, 5, 3, 2, 1.5, 1, .7, .5];
% betas = [10, 6, 3, 2, 1];
% betas = [25, 10, 5, 2.5, 1, .5, .25, .1, .05, .025];
field_strength = [.25, .5, 1, 2.5, 5, 10, 25];
betas = [2.5, 2, 1.5, .5, .25, .22];
num_fields = [2, 3, 5, 7, 10];

fast_spins = find(spin_barriers == min(spin_barriers));

% num_fields = 5;
num_fields_3 = 5;

driving_fields_3 = zeros(num_spins, num_fields_3);
rand_fast_spins = fast_spins(randperm(numel(fast_spins), numel(fast_spins)/4));



fixed_spins = zeros(num_spins, 1);
fixed_spins(1:floor(num_spins / 2)) = 1;

%simulation is currently set up for drives where each field is seen once
%per cycle before being seen a second time
%to create a drive where a series of fields is seen in a certain order,
%just define the drives as a matrix with fields in each column in the order
%you want to apply them, and define the random_order argument of the
%function to be a vector of ones of length equal to the number of fields to
%be applied

%also currently set up to sweep over drives with different numbers of fields

% the function is set up with the following arguments:
%     initial configuration of spins
%     no spins are fixed
%     interaction matrix
%     spin barriers
%     strength of external field
%     inverse temperature beta
%     matrix with columns which are the fields that make up a drive
%     length of time each driving field is applied
%     order in which fields are applied
%     0 to avoid effects of deprecated code
%     length of simulation
%     folder within top level folder to save results of simulation to


for iter = 1:1
%     driving_fields(rand_fast_spins, :) = normrnd(0, 2, [numel(rand_fast_spins), num_fields]);
    
    
    for iter_2 = 1:1
%         driving_fields(rand_fast_spins, :) = normrnd(0, 2, [numel(rand_fast_spins), 1]);

%         driving_fields_3(rand_fast_spins, :) = normrnd(0, 20, [numel(rand_fast_spins), num_fields_3]);
        
        
%         semi_random_order(randperm(numel(semi_random_order), floor(numel(semi_random_order) / 10))) = 2;
        
        for iter_3= 1:5
            
            driving_fields = zeros(num_spins, num_fields(iter_3) * 2);
            driving_fields(1:floor(num_spins / 4), :) = normrnd(0, 5, floor(num_spins / 4), num_fields(iter_3) * 2);
            
            random_order = [];
            while(numel(random_order) < 300)
                random_order = [random_order, randi(num_fields(iter_3))];
            end
            while(numel(random_order) < 600)
                random_order = [random_order, randi(num_fields(iter_3)) + num_fields(iter_3)];
            end
            while(numel(random_order) < 901)
                random_order = [random_order, randi(num_fields(iter_3))];
            end
            
            periodic_order = [];
            while(numel(periodic_order) < 300)
                periodic_order = [periodic_order, 1:num_fields(iter_3)];
            end
            periodic_order(301:end) = [];
            while(numel(periodic_order) < 600)
                periodic_order = [periodic_order, 1:num_fields(iter_3) + num_fields(iter_3)];
            end
            periodic_order(601:end) = [];
            while(numel(periodic_order) < 901)
                periodic_order = [periodic_order, 1:num_fields(iter_3)];
            end
            
%             driving_fields_2 = zeros(num_spins, num_fields(iter_3) * 3);
%             driving_fields_2(1:floor(num_spins / 4), :) = normrnd(0, 5, floor(num_spins / 4), num_fields(iter_3));

%             random_strings = randi(num_fields(iter_3), [4, 5]);
%             random_order_b = [];
%             while numel(random_order_b) < 10001
%                 random_order_b = [random_order_b, random_strings(randi(size(random_strings, 1)), :)];
%             end
% 
%             markov_matrix = zeros(num_fields(iter_3));
%             for row = 1:size(random_strings, 1)
%                 for col = 1:(size(random_strings, 2) - 1)
%                     initial = random_strings(row, col);
%                     final = random_strings(row, col + 1);
%                     markov_matrix(initial, final) = markov_matrix(initial, final) + 1;
%                 end
%                 initial = random_strings(row, end);
%                 for row_2 = 1:size(random_strings, 1)
%                     final = random_strings(row_2, 1);
%                     markov_matrix(initial, final) = markov_matrix(initial, final) + (1 / size(random_strings, 1));
%                 end
%             end
% 
%             random_start = 1;
%             while sum(markov_matrix(random_start, :)) == 0
%                 random_start = random_start + 1;
%             end
%             for row = 1:size(markov_matrix, 1)
%                 markov_matrix(row, :) = markov_matrix(row, :) / sum(markov_matrix(row, :));
%                 markov_matrix(row, :) = cumsum(markov_matrix(row, :));
%             end
% 
%             random_order = random_start;
%             while numel(random_order) < 10001
%                 r = rand();
%                 next_field = find(markov_matrix(random_order(end), :) > r);
%                 random_order = [random_order, next_field(1)];
%             end
            

%             random_order_1 = repmat(1:number_fields(iter_3), 1, ceil(1000 / number_fields(iter_3)));
%             random_order_1 = random_order_1(randperm(1000));
%             random_order_2 = repmat(1:number_fields(iter_3), 1, ceil(1000 / number_fields(iter_3)));
%             random_order_2 = random_order_2(randperm(1000));
%             random_order_3 = repmat(1:number_fields(iter_3), 1, ceil(1000 / number_fields(iter_3)));
%             random_order_3 = random_order_3(randperm(1000));
%             random_order = [random_order_1, random_order_2, random_order_3, 1];
            
            
%             random_order = diff([random_order_1, random_order_2 + number_fields(iter_3), random_order_3, 1]);
            
%             random_order_b = random_order(randperm(numel(random_order)));
% 
%             random_order_2 = [];
%             while numel(random_order_2) < 10001
%                 random_order_2 = [random_order_2, randperm(10001)];
%             end
%             random_order_2 = diff(random_order_2);
%             random_order_2_b = random_order_2(randperm(numel(random_order_2)));
%             
%             random_order_3 = [];
%             while numel(random_order_3) < 10001
%                 random_order_3 = [random_order_3, randperm(number_fields(iter_3))];
%             end
%             random_order_3 = diff(random_order_3);
%             random_order_3_b = random_order_3(randperm(numel(random_order_3)));
            
%             random_order = ones(1, 10001);
            
%             random_order = [];
%             while numel(random_order) < 10001
%                 random_order = [random_order, randperm(num_fields)];
%             end
%             random_order = diff(random_order);
            
%             file_5 = strcat('fixed_slow_', string(total_iter), '_', string(iter_2), '_', string(iter_3));
%             final_spins_fixed = spin_glass_function_switch_driving_fields_fix_spins(final_spins(:, 1), logical(zeros(num_spins, 1)), interactions, spin_barriers, 0, 10, driving_fields_2, 20000, random_order, 0, 100000, strcat(folder_name, '/', file_5));

            spin_barriers = ones(num_spins, 1) * .5;
            
            file = strcat('random_order_', string(total_iter), '_', string(iter_2), '_', string(iter_3));
            final_spins_same = spin_glass_function_switch_driving_fields_fix_spins_2(final_spins(:, 1), logical(zeros(num_spins, 1)), interactions, spin_barriers, 0, 10, driving_fields, 100, random_order, 0, 90000, strcat(folder_name, '/', file));
            
%             file_3 = strcat('random_order_b_', string(total_iter), '_', string(iter_2), '_', string(iter_3));
%             final_spins_same = spin_glass_function_switch_driving_fields_fix_spins_2(final_spins_same, logical(zeros(num_spins, 1)), interactions, spin_barriers, 0, 10, driving_fields_2, 100, random_order, 0, 10000, strcat(folder_name, '/', file_3));
            
            file_2 = strcat('periodic_order_', string(total_iter), '_', string(iter_2), '_', string(iter_3));
            final_spins_same = spin_glass_function_switch_driving_fields_fix_spins_2(final_spins(:, 1), logical(zeros(num_spins, 1)), interactions, spin_barriers, 0, 10, driving_fields, 100, periodic_order, 0, 90000, strcat(folder_name, '/', file_2));
            
%             file_4 = strcat('string_order_b_', string(total_iter), '_', string(iter_2), '_', string(iter_3));
%             final_spins_same = spin_glass_function_switch_driving_fields_fix_spins_2(final_spins_same, logical(zeros(num_spins, 1)), interactions, spin_barriers, 0, 10, driving_fields_2, 100, random_order_b, 0, 10000, strcat(folder_name, '/', file_4));
            
%             file_3 = strcat('no_drive_', string(total_iter), '_', string(iter_2), '_', string(iter_3));
%             final_spins_same = spin_glass_function_switch_driving_fields_fix_spins_2(final_spins(:, 1), logical(zeros(num_spins, 1)), interactions, spin_barriers, 0, 2.5, zeros(num_spins, 1), 100, ones(1, 10000), 0, 10000, strcat(folder_name, '/', file_3));

%             file_3 = strcat('unfixed_slow_', string(total_iter), '_', string(iter_2), '_', string(iter_3));
%             final_spins_unfixed = spin_glass_function_switch_driving_fields_fix_spins(final_spins(:, iter_3), logical(zeros(num_spins, 1)), interactions, spin_barriers, 0, 10, driving_fields, 100, random_order_b, 0, 100000, strcat(folder_name, '/', file_3));
%             
%             file_2 = strcat('min_model_', string(total_iter), '_', string(iter_2), '_', string(iter_3), 'b');
% %             final_spins_fixed = spin_glass_function_switch_driving_fields_fix_spins(final_spins(:, iter_3), logical(zeros(num_spins, 1)), interactions, spin_barriers, 0, 10, zeros(num_spins, 1), 100, random_order, 0, 100000, strcat(folder_name, '/', file_2));
% %             fixed_spins = zeros(num_spins, 1);
% %             fixed_spins(iter_3) = 1;
%             modified_spins = final_spins_same;
% %             modified_spins(1) = -1 * modified_spins(1);
%             final_spins_same = spin_glass_function_switch_driving_fields_fix_spins(modified_spins, logical(zeros(num_spins, 1)), interactions, spin_barriers, 0, 10, driving_fields_2, 100, random_order_2, 0, 100000, strcat(folder_name, '/', file_2));
%             
%             file_4 = strcat('min_model_', string(total_iter), '_', string(iter_2), '_', string(iter_3), 'c');
% %             modified_spins = final_spins_diff;0
% %             modified_spins(1) = -1 * modified_spins(1);
%             final_spins_diff = spin_glass_function_switch_driving_fields_fix_spins(final_spins_same, logical(zeros(num_spins, 1)), interactions, spin_barriers, 0, 10, driving_fields, 100, random_order_3, 0, 100000, strcat(folder_name, '/', file_4));
%             
%             file_5 = strcat('min_model_', string(total_iter), '_', string(iter_2), '_', string(iter_3), 'd');
%             final_spins_fixed_2 = spin_glass_function_switch_driving_fields_fix_spins(final_spins_same, logical(zeros(num_spins, 1)), interactions, spin_barriers, 0, 10, driving_fields_2, 100, random_order_2, 0, 100000, strcat(folder_name, '/', file_5));
%             
%             file_6 = strcat('different_field_', string(total_iter), '_', string(iter_2), '_', string(iter_3), 'd');
%             final_spins_fixed_3 = spin_glass_function_switch_driving_fields_fix_spins(final_spins_diff, logical(zeros(num_spins, 1)), interactions, spin_barriers, 0, 10, driving_fields_3, 100, random_order_3, 0, 100000, strcat(folder_name, '/', file_6));
        end
    end
end

end
