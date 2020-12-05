function adj_matrix = random_adjacency_matrix(num_spins, average_neighbors)

    p_edge = average_neighbors / (num_spins - 1);
    
    rand_mat = rand(num_spins) < p_edge;
    adj_matrix = triu(rand_mat, 1);

end