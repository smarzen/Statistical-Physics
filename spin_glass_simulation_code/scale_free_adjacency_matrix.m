function adj_matrix = scale_free_adjacency_matrix(num_spins, p_two_new_edges)

    adj_matrix = zeros(num_spins);
    num_edges = zeros(num_spins, 1);
    
    adj_matrix(1, 2) = 1;
    adj_matrix(2, 1) = 1;
    num_edges(1) = 1;
    num_edges(2) = 1;
    
    for i = 3:num_spins
        if rand(1) < p_two_new_edges
            p_connect = cumsum(num_edges) / sum(num_edges);
            connected_node = find(p_connect > rand(1));
            connected_node = connected_node(1);
            
            num_other_edges = num_edges;
            num_other_edges(connected_node) = 0;
            p_connect_2 = cumsum(num_other_edges) / sum(num_other_edges);
            connected_node_2 = find(p_connect_2 > rand(1));
            connected_node_2 = connected_node_2(1);
            
            adj_matrix(connected_node, i) = 1;
            adj_matrix(i, connected_node) = 1;
            num_edges(connected_node) = num_edges(connected_node) + 1;
            num_edges(i) = num_edges(i) + 1;
            
            adj_matrix(connected_node_2, i) = 1;
            adj_matrix(i, connected_node_2) = 1;
            num_edges(connected_node_2) = num_edges(connected_node_2) + 1;
            num_edges(i) = num_edges(i) + 1;
        else
            p_connect = cumsum(num_edges) / sum(num_edges);
            connected_node = find(p_connect > rand(1));
            connected_node = connected_node(1);
            adj_matrix(connected_node, i) = 1;
            adj_matrix(i, connected_node) = 1;
            num_edges(connected_node) = num_edges(connected_node) + 1;
            num_edges(i) = num_edges(i) + 1;
        end
    end

end