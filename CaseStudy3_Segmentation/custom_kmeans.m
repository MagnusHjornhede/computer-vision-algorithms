% Custom K-means function
function [cluster_idx, centroids, wcss] = custom_kmeans(X, k, max_iters)
    % X: data matrix (rows = data points, columns = features)
    % k: number of clusters
    % max_iters: maximum number of iterations

    % Get the number of data points (rows) and features (columns)
    [n, d] = size(X);
    
    % Step 1: Randomly initialize centroids by selecting k random points
    random_indices = randperm(n, k);
    centroids = X(random_indices, :);
    
    % Initialize variables
    cluster_idx = zeros(n, 1);  % Store cluster assignments for each point
    prev_centroids = centroids;  % Store the centroids from the previous iteration
    wcss = 0;  % Initialize WCSS (within-cluster sum of squares)

    for iter = 1:max_iters
        % Step 2: Assign points to the closest centroid
        for i = 1:n
            distances = sum((centroids - X(i, :)).^2, 2);  % Compute squared Euclidean distance to each centroid
            [~, cluster_idx(i)] = min(distances);  % Assign point to the closest centroid
        end
        
        % Step 3: Recompute centroids as the mean of points in each cluster
        for j = 1:k
            cluster_points = X(cluster_idx == j, :);  % Points in cluster j
            if ~isempty(cluster_points)
                centroids(j, :) = mean(cluster_points, 1);  % Mean of the cluster points
            end
        end
        
        % Check for convergence (if centroids have stopped changing)
        if max(max(abs(centroids - prev_centroids))) < 1e-4
            disp(['Converged after ', num2str(iter), ' iterations']);
            break;
        end
        
        % Store centroids for the next iteration
        prev_centroids = centroids;
    end

    if iter == max_iters
        disp('Max iterations reached without convergence');
    end

    % Compute WCSS (within-cluster sum of squares)
    for i = 1:k
        cluster_points = X(cluster_idx == i, :);
        wcss = wcss + sum(sum((cluster_points - centroids(i, :)).^2));
    end
end

