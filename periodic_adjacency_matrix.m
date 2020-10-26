function adj_matrix = periodic_adjacency_matrix(num_rows, num_cols)

    [spin_rows, spin_cols] = meshgrid(1:num_rows, 1:num_cols);
    spin_rows = spin_rows(:);
    spin_cols = spin_cols(:);
%     adj_matrix = sparse(squareform(pdist([spin_rows, spin_cols], 'cityblock') == 1));
    adj_matrix = squareform(pdist([spin_rows, spin_cols], 'cityblock') == 1);
    for i = 1:num_rows
        adj_matrix((i - 1) * num_cols + 1, i * num_cols) = 1;
        adj_matrix(i * num_cols, (i - 1) * num_cols + 1) = 1;
    end
    for i = 1:num_cols
        adj_matrix(i, (num_rows - 1) * num_cols + i) = 1;
        adj_matrix((num_rows - 1) * num_cols + i, i) = 1;
    end

end