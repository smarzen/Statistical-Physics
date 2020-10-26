function final_spins = spin_glass_function_switch_driving_fields_fix_spins_2(spins, fixed_spins, interactions, spin_barriers, external_field, beta, driving_fields, switch_time, random_order, driving_strength, t_max, file_name)

save_per_spin_data = false;

%spins is a vector of values +-1 corresponding whether spin i is pointing
%up or down, respectively

%fixed_spins is a vector of boolean values indicating whether spin i can
%flip

%interactions is a matrix Jij of the energetic interactions between spins i
%and j

%spin_barriers is a vector of the explicit energetic barrier spin i must
%overcome to flip

%external_field is a vector of the magnetic field applied to spin i that is
%fixed in time

%beta is the inverse temperature of the system

%driving_fields is a matrix, the columns of which are the magnetic field
%applied to spin i; the system is driven by intermittently switching which column vector of
%fields is applied

%switch_time is how long to wait before switching the driving field

%random_order is the order in which fields are applied; it is a vector of
%the changes in the number identifying the column of driving_fields to
%apply, e.g. if the first switch in the drive is from field 2 to field 5,
%the first element of random_order will be 3. the numbers indicating which
%field to switch to work modulo the number of field vectors

%driving_strength is deprecated and should be 0

%t_max is when to end the simulation

%file_name is the name of the file in which you wish to save statistics
%from the simulation in

driving_field = driving_fields(:, random_order(1));
field_number = random_order(1);
switch_number = 1;

%deprecated
plotting_on = false;
saving_on = true;
display_time = true;

mkdir(char(file_name))
iterations_per_save = 10000;
save_time = 10; %change to choose how often data about state is saved
file_num = 1;

%initialize important parameters
num_spins = numel(spins);

%+1 is spin up, -1 is spin down
initial_spins = spins;

%calculate initial energy of the system
energy = spins' * interactions * spins / 2 + sum(spins .* (external_field + driving_field));
internal_energy = spins' * interactions * spins / 2 + sum(spins .* external_field);
slow_energy = spins(1:floor(num_spins / 2))' * interactions(1:floor(num_spins / 2), :) * spins / 2 + sum(spins(1:floor(num_spins / 2)) .* external_field);

%calculate initial change in energy as a result of each flip
local_energy = spins .* (interactions * spins) + spins .* external_field;
driving_energy = spins .* driving_field;

%find barrier heights for each spin based on state of neighboring spins
neighbors_up = zeros(num_spins, 1);
num_neighbors = zeros(num_spins, 1);
for i = 1:num_spins
    
    interacting_spins = (spins(interactions(:, i) ~= 0) + 1)'/2;
    num_neighbors(i) = numel(interacting_spins);
    neighbors_up(i) = sum(interacting_spins);
    
end

%deprecated, but might break some things if you delete it
driving_time = 100;
driving_duration = 30;
% driving_strength = -1.2;
% driving_enabled = ones(num_spins, 1) * is_driving_enabled;
% driving_enabled = zeros(num_spins, 1);
driving_enabled = zeros(num_spins, 1);

driving_on = zeros(num_spins, 1);
driving_rate = 1/driving_time;
driving_remaining = inf;% * ones(num_spins, 1);

%calculate propensities and interarrival time distribution
total_energy = local_energy + driving_energy;
flip_probability = exp((total_energy - spin_barriers) * beta);
flip_probability(fixed_spins) = 0;
flip_rates = zeros(ceil(log2(num_spins)), 2^ceil(log2(num_spins)));
for i = 1:num_spins
    index = 1;
    remainder = i;
    for j = 1:size(flip_rates, 1)
        index = index + floor((remainder - 1) / 2^(size(flip_rates, 1) - j)) * 2^(size(flip_rates, 1) - j);
        remainder = remainder - floor((remainder - 1) / 2^(size(flip_rates, 1) - j)) * 2^(size(flip_rates, 1) - j);
        flip_rates(j, index) = flip_rates(j, index) + flip_probability(i);
    end
end
% total_flip_rate = sum(flip_probability) + driving_rate * sum(driving_enabled - driving_on);
total_flip_rate = flip_rates(1, 1) + flip_rates(1, floor(size(flip_rates, 2) / 2) + 1);
% flip_numbers = cumsum([flip_probability; driving_rate * (driving_enabled - driving_on)]) / total_flip_rate;
total_driving_rate = 0;

%track various statistics
t = 0;
mean_mag = sum(spins)/num_spins;
total_work = 0;
total_spin_work = zeros(num_spins, 1);
total_spin_dissipation = zeros(num_spins, 1);
spin_dissipation = total_spin_dissipation;
% excess_work = 0;
total_heat_lost = 0;
internal_work = 0;
hamming_dist = 0;
last_config = spins;
% force_vec = zeros([num_spins, 1]);
% force_vecs = [];
statistics = [t; energy; internal_energy; mean_mag; total_work; total_heat_lost; internal_work; hamming_dist; slow_energy];

for field_iter = 1:size(driving_fields, 2)
    next_drive_energy(field_iter, 1) = sum(spins .* driving_fields(:, field_iter));
end

spin_hist = spins;
% spin_work_hist = zeros(num_spins, 1);
flip_count = zeros(num_spins, 1);
flip_counts = flip_count;
% prev_flip_count = zeros(num_spins, 1);
% flip_times = zeros(num_spins, 1);
driving_count = zeros(num_spins, 1);
% prev_driving_count = zeros(num_spins, 1);
% driving_times = zeros(num_spins, 1);

% neighbor_dist_save = neighbor_dist;
% statistics_save = statistics;
% flip_times_save = flip_times;
% driving_times_save = driving_times;
% save(char(file_name), 'neighbor_dist_save', 'statistics_save', 'flip_times_save', 'driving_times_save');
iterations_since_last_save = 0;
total_iterations = 0;
%run simulation

while t < t_max
    
    
    
    %calculate time til next event
    delta_t = log(1/ (1 - rand(1))) / total_flip_rate;
    
    %if time is greater than time next force would turn off, disregard it
    
    if(delta_t > min(driving_remaining) || delta_t > (switch_time - mod(t, switch_time)) || delta_t > (save_time - mod(t, save_time)))
        if(min(driving_remaining) < (switch_time - mod(t, switch_time)) && min(driving_remaining) < (save_time - mod(t, save_time)))
        
            %turn off next driving force
            [delta_t, min_index] = min(driving_remaining);
            driving_on(min_index) = 0;
            driving_remaining(min_index) = inf;
            driving_energy(min_index) = 0;
            energy = energy - spins(min_index) * driving_strength;
            total_work = total_work - spins(min_index) * driving_strength;
            total_spin_work(min_index) = total_spin_work(min_index) - spins(min_index) * driving_strength;

            t = t + delta_t;
            driving_remaining = driving_remaining - delta_t;
        
        elseif (save_time - mod(t, save_time)) <= (switch_time - mod(t, switch_time))
            delta_t = (save_time - mod(t, save_time));
            t = t + delta_t;
%             force_vec = force_vec - total_energy .* (total_energy < 0) .* spins * delta_t;
%             force_vec = force_vec / save_time;
%             force_vecs = [force_vecs, force_vec];
%             force_vec = zeros([num_spins, 1]);
            hamming_dist = mean(abs(spins - last_config));
            last_config = spins;
            statistics = [statistics, [t; energy; internal_energy; mean_mag; total_work; total_heat_lost; internal_work; hamming_dist; slow_energy]];
            for field_iter = 1:size(driving_fields, 2)
                next_drive_energy_temp(field_iter) = sum(spins .* driving_fields(:, field_iter));
            end
            next_drive_energy = [next_drive_energy, next_drive_energy_temp'];
            if save_per_spin_data
                spin_hist = [spin_hist, spins];
    %             spin_work_hist = [spin_work_hist, total_spin_work];
                spin_dissipation = [spin_dissipation, total_spin_dissipation];
                flip_counts = [flip_counts, flip_count];
            end
            iterations_since_last_save = iterations_since_last_save + 1;
            total_iterations = total_iterations + 1;
            if iterations_since_last_save >= iterations_per_save
                save(char(strcat(file_name, '/data_', num2str(file_num))), 'statistics', 'spin_dissipation', 'spin_hist', 'flip_counts', 'next_drive_energy')%, 'force_vecs')%, 'spin_hist', 'flip_counts', 'spin_dissipation')
                iterations_since_last_save = 0;
                statistics = [];
                spin_hist = [];
                spin_dissipation = [];
                flip_counts = [];
                next_drive_energy = [];
%                 force_vecs = [];
            file_num = file_num + 1;
            end
            
            if (save_time - mod(t, save_time)) == (switch_time - mod(t, switch_time))
%                 delta_t = (switch_time - mod(t, switch_time));
                driving_on(:) = 0;
                driving_remaining(:) = inf;
                energy = energy - sum(driving_energy);
                total_work = total_work - sum(driving_energy);
                total_spin_work = total_spin_work - driving_energy;
                driving_energy(:) = 0;

%                 t = t + delta_t;

%                 field_number = mod(field_number + random_order(switch_number) - 1, size(driving_fields, 2)) + 1;
                switch_number = switch_number + 1;
                field_number = random_order(switch_number);

                driving_field = driving_fields(:, field_number);
                driving_energy = spins .* driving_field;
                energy = energy + sum(driving_energy);
                total_work = total_work + sum(driving_energy);
                total_spin_work = total_spin_work + driving_energy;
                
                total_energy = local_energy + driving_energy;
                flip_probability = exp((total_energy - spin_barriers) * beta);
                flip_probability(fixed_spins) = 0;
                flip_rates = zeros(ceil(log2(num_spins)), 2^ceil(log2(num_spins)));

                for i = 1:num_spins
                    index = 1;
                    remainder = i;
                    for j = 1:size(flip_rates, 1)
                        index = index + floor((remainder - 1) / 2^(size(flip_rates, 1) - j)) * 2^(size(flip_rates, 1) - j);
                        remainder = remainder - floor((remainder - 1) / 2^(size(flip_rates, 1) - j)) * 2^(size(flip_rates, 1) - j);
                        flip_rates(j, index) = flip_rates(j, index) + flip_probability(i);
                    end
                end
                
                total_flip_rate = flip_rates(1, 1) + flip_rates(1, floor(size(flip_rates, 2) / 2) + 1);
            end
            
            
        elseif (save_time - mod(t, save_time)) >= (switch_time - mod(t, switch_time))
            
            delta_t = (switch_time - mod(t, switch_time));
%             force_vec = force_vec - total_energy .* (total_energy < 0) .* spins * delta_t;
            driving_on(:) = 0;
            driving_remaining(:) = inf;
            energy = energy - sum(driving_energy);
            total_work = total_work - sum(driving_energy);
            total_spin_work = total_spin_work - driving_energy;
            
            driving_energy(:) = 0;
            
            t = t + delta_t;
            
%             field_number = mod(field_number + random_order(switch_number) - 1, size(driving_fields, 2)) + 1;
            switch_number = switch_number + 1;
            field_number = random_order(switch_number);
            
            driving_field = driving_fields(:, field_number);
            driving_energy = spins .* driving_field;
            energy = energy + sum(driving_energy);
            total_work = total_work + sum(driving_energy);
            total_spin_work = total_spin_work + driving_energy;
            
            total_energy = local_energy + driving_energy;
            flip_probability = exp((total_energy - spin_barriers) * beta);
            flip_probability(fixed_spins) = 0;
            flip_rates = zeros(ceil(log2(num_spins)), 2^ceil(log2(num_spins)));
            
            for i = 1:num_spins
                index = 1;
                remainder = i;
                for j = 1:size(flip_rates, 1)
                    index = index + floor((remainder - 1) / 2^(size(flip_rates, 1) - j)) * 2^(size(flip_rates, 1) - j);
                    remainder = remainder - floor((remainder - 1) / 2^(size(flip_rates, 1) - j)) * 2^(size(flip_rates, 1) - j);
                    flip_rates(j, index) = flip_rates(j, index) + flip_probability(i);
                end
            end
            
            total_flip_rate = flip_rates(1, 1) + flip_rates(1, floor(size(flip_rates, 2) / 2) + 1);
        end
        
    %otherwise do event as normal
    
    else
        
%         toc
        
        t = t + delta_t;
%         force_vec = force_vec - total_energy .* (total_energy < 0) .* spins * delta_t;
        driving_remaining = driving_remaining - delta_t;
        
        %determine which event happens next
        flip_rand = rand(1);
        
        index = 1;
        prob = 0;
        for i = 1:size(flip_rates, 1)
            binary_prob = flip_rates(i, index) / total_flip_rate;
            if prob + binary_prob < flip_rand
                index = index + 2^(size(flip_rates, 1) - i);
                prob = prob + binary_prob;
            end
        end
        flip_spin = index;
        
%         flip_spin = find(flip_numbers > flip_rand);
        if(numel(flip_spin) > 0)
            flip_spin = flip_spin(1);
            
            %maybe flip a spin
            if flip_spin <= num_spins
                
                

                spins(flip_spin) = spins(flip_spin) * -1;
                
                local_energy = local_energy + spins .* interactions(:, flip_spin) * spins(flip_spin) * 2;
                slow_energy = slow_energy + sum(spins(1:floor(num_spins / 2)) .* interactions(1:floor(num_spins / 2), flip_spin) * spins(flip_spin) * 2);
%                 local_energy = local_energy + interactions(flip_spin, :) .* spins * spins(flip_spin) * 2;
                
                neighbors = find(interactions(:, flip_spin) ~= 0);
%                 local_energy(neighbors) = local_energy(neighbors) + spins(neighbors) .* interactions(neighbors, flip_spin) * spins(flip_spin);
%                 for i = 1:numel(neighbors)
%                     spin_num = neighbors(i);
%                     local_energy(spin_num) = local_energy(spin_num) + interactions(spin_num, flip_spin) * spins(spin_num) * spins(flip_spin) * 2;
%                 end
                
                local_energy(flip_spin) = -local_energy(flip_spin);
                driving_energy(flip_spin) = -driving_energy(flip_spin);
                
                total_heat_lost = total_heat_lost - 2 * local_energy(flip_spin) - 2 * driving_energy(flip_spin);
                total_spin_dissipation(flip_spin) = total_spin_dissipation(flip_spin) - 2 * local_energy(flip_spin) - 2 * driving_energy(flip_spin);
                if driving_on(flip_spin)
                    internal_work = internal_work + 2 * local_energy(flip_spin);
                end
                
                mean_mag = mean_mag + 2 * spins(flip_spin)/num_spins;
                energy = energy + 2 * local_energy(flip_spin) + 2 * driving_energy(flip_spin);
                internal_energy = internal_energy + 2 * local_energy(flip_spin);
                if flip_spin <= num_spins / 2
                    slow_energy = slow_energy + 2 * local_energy(flip_spin);
                end
                
%                 new_neighbor_dist = neighbor_dist(:, end);
%                 for i = 1:numel(neighbors)
%                     new_neighbor_dist(neighbors_up(neighbors(i)) + 2) = new_neighbor_dist(neighbors_up(neighbors(i)) + 2) - 1;
%                 end
%                 neighbors_up(neighbors) = neighbors_up(neighbors) + spins(flip_spin);
%                 for i = 1:numel(neighbors)
%                     new_neighbor_dist(neighbors_up(neighbors(i)) + 2) = new_neighbor_dist(neighbors_up(neighbors(i)) + 2) + 1;
%                 end
%                 facilitated_rates(neighbors) = neighbors_up(neighbors) .* (neighbors_up(neighbors) - 1) / 12;
%                 facilitated_rates(neighbors) = 10 .^ (neighbors_up(neighbors)) * 10E-4;
%                 spin_barriers(neighbors) = .2 * num_neighbors(neighbors) - .2 * neighbors_up(neighbors);
                
                
%                 new_neighbor_dist(1) = t;
%                 neighbor_dist = new_neighbor_dist;
%                 neighbor_dist = [neighbor_dist, new_neighbor_dist];
                
                neighbors = [flip_spin; neighbors];
                
                
                for i = 1:numel(neighbors)
                    neighbor_num = neighbors(i);
                    if fixed_spins(neighbor_num) == 0
    %                     old_rate = flip_rates(end, neighbor_num);
                        new_rate = exp((local_energy(neighbor_num) + driving_energy(neighbor_num) - spin_barriers(neighbor_num)) * beta);
                        flip_rates(end, neighbor_num) = new_rate;
                        for j = 1:(size(flip_rates, 1) - 1)
                            if mod(neighbor_num, 2^j) ~= 1
                                neighbor_num = neighbor_num - 2^(j - 1);
                            end
                            flip_rates(end - j, neighbor_num) = flip_rates(end - (j - 1), neighbor_num) + flip_rates(end - (j - 1), neighbor_num + 2^(j - 1));
                        end
    %                     index = 1;
    %                     remainder = neighbor_num;
    %                     for j = 1:size(flip_rates, 1)
    %                         index = index + floor((remainder - 1) / 2^(size(flip_rates, 1) - j)) * 2^(size(flip_rates, 1) - j);
    %                         remainder = remainder - floor((remainder - 1) / 2^(size(flip_rates, 1) - j)) * 2^(size(flip_rates, 1) - j);
    %                         flip_rates(j, index) = flip_rates(j, index) - old_rate;
    %                         flip_rates(j, index) = flip_rates(j, index) + new_rate;
    %                     end
                    end
                    
                    
                end
                
                
                total_flip_rate = flip_rates(1, 1) + flip_rates(1, floor(size(flip_rates, 2) / 2) + 1);
                
                flip_count(flip_spin) = flip_count(flip_spin) + 1;
%                 flip_times(flip_spin, flip_count(flip_spin) - prev_flip_count(flip_spin) + 1) = t;
%                 test_time = test_time + toc;
                
            %maybe turn on a driving force
            else
                flip_spin = flip_spin - num_spins;
                driving_on(flip_spin) = 1;
                driving_remaining(flip_spin) = driving_duration;
                driving_energy(flip_spin) = spins(flip_spin) * driving_strength;
                energy = energy + spins(flip_spin) * driving_strength;
                total_work = total_work + spins(flip_spin) * driving_strength;
                total_spin_work(flip_spin) = total_spin_work(flip_spin) + spins(flip_spin) * driving_strength;
                
                driving_count(flip_spin) = driving_count(flip_spin) + 1;
%                 driving_times(flip_spin, driving_count(flip_spin) - prev_driving_count(flip_spin) + 1) = t;
            end
        end
        
    end

    
    %update propensities
%     total_energy = local_energy + driving_energy;
%     flip_probability = exp((total_energy - spin_barriers) * beta);
%     total_flip_rate = sum(flip_probability) + driving_rate * sum(driving_enabled - driving_on);
%     flip_numbers = cumsum([flip_probability; driving_rate * (driving_enabled - driving_on)]) / total_flip_rate;
    
    

    %record statistics
%     statistics = [statistics, [t; energy; internal_energy; mean_mag; total_work; total_heat_lost; internal_work]];
    
%     iterations_since_last_save = iterations_since_last_save + 1;
%     total_iterations = total_iterations + 1;
    
%     if iterations_since_last_save >= iterations_per_save % + total_iterations / 10
%         load(char(file_name))
%         neighbor_dist_save = [neighbor_dist_save, neighbor_dist];
%         statistics_save = [statistics_save, statistics];
%         flip_times_save = [flip_times_save, flip_times];
%         driving_times_save = [driving_times_save, driving_times];
%         neighbor_dist_save = neighbor_dist;
%         statistics_save = statistics;
%         flip_times_save = flip_times;
%         driving_times_save = driving_times;
%         save(char(strcat(file_name, '/data_', num2str(file_num))), 'neighbor_dist_save', 'statistics_save');
        
%         neighbor_dist = neighbor_dist(:, end);
%         statistics = statistics(:, end);
%         flip_times = zeros(num_spins, 1);
%         prev_flip_count = flip_count;
%         driving_times = zeros(num_spins, 1);
%         prev_driving_count = driving_count;
        
%         clear_vars = {'neighbor_dist_save', 'statistics_save'};
%         clear(clear_vars{:});
        
%         iterations_since_last_save = 0;
%         file_num = file_num + 1;
%     end
    
end

% load(char(file_name))
% neighbor_dist_save = [neighbor_dist_save, neighbor_dist];
% statistics_save = [statistics_save, statistics];
% flip_times_save = [flip_times_save, flip_times];
% driving_times_save = [driving_times_save, driving_times];
% neighbor_dist_save = neighbor_dist;
% statistics_save = statistics;
% flip_times_save = flip_times;
% driving_times_save = driving_times;
% save(char(file_name));
save(char(strcat(file_name, '/data_', num2str(file_num))), 'statistics', 'spin_hist', 'flip_count', 'spin_dissipation')
save(char(strcat(file_name, '/extra_data')))

final_spins = spins;

end
