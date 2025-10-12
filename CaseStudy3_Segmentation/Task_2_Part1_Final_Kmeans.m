% Part 1: Custom K-means Clustering on the Entire Image

% Start with a clean slate
clear;
clc;

% Load the grayscale image
I = imread('lake_gray.png');
I = im2double(I);  % Convert the image to double precision

% Get the image dimensions
[rows, cols] = size(I);  % Get the number of rows and columns
total_pixels = rows * cols;  % Total number of pixels in the image

% Reshape the image into a 1D vector for K-means clustering
pixelData = reshape(I, total_pixels, 1);  % Reshape into a column vector (1D)

% Define a range of k values for experimentation
k_values = [2, 3, 4];  % Different numbers of clusters to try
max_iters = 100;  % Set max iterations for K-means

% Apply custom K-means clustering directly on the original image with different k values
for k = k_values
    disp(['Applying custom K-means clustering with k = ', num2str(k), ' on the original image...']);
    
    % Apply custom K-means clustering to the reshaped pixel data
    [cluster_idx, ~] = custom_kmeans(pixelData, k, max_iters);
    
    % Check if the number of cluster assignments matches the number of pixels
    if length(cluster_idx) == total_pixels
        % Reshape the cluster index back into the original image dimensions
        segmentedImage = reshape(cluster_idx, rows, cols);
        
        % Display and save the K-means segmented image for each k value
        figure;
        imagesc(segmentedImage);
        colormap('gray');
        title(['Custom K-means clustering with k = ', num2str(k), ' on lake\_gray.png']);
        saveas(gcf, ['custom_kmeans_lake_gray_k', num2str(k), '.png']);  % Save the custom K-means result for each k value
    else
        disp('Error: The number of cluster assignments does not match the number of pixels in the image.');
        disp(['Number of pixels: ', num2str(total_pixels)]);
        disp(['Number of cluster assignments: ', num2str(length(cluster_idx))]);
    end
end
