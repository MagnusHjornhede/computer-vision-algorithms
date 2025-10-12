% Part 2: SLIC Superpixels and Custom K-means Clustering on Superpixels

% Start with a clean slate
clear;
clc;

% Load the grayscale image
I = imread('lake_gray.png');
I = im2double(I);  % Convert the image to double precision

% Get the image dimensions
[rows, cols] = size(I);  % Get the number of rows and columns
total_pixels = rows * cols;  % Total number of pixels in the image

% Define a range of superpixel numbers and k values
superpixel_nums = [100, 200, 300];  % Different superpixel numbers to try
k_values = [2, 3, 4];  % Different numbers of clusters to try
compactness = 20;  % Compactness parameter for SLIC
max_iters = 100;  % Set max iterations for K-means

% Loop through each superpixel number for SLIC + K-means segmentation
for i = 1:length(superpixel_nums)
    num_superpixels = superpixel_nums(i);

    % Compute SLIC superpixels
    [L, N] = superpixels(I, num_superpixels, 'Compactness', compactness);
    
    % Display and save the SLIC superpixel boundaries
    BW = boundarymask(L);
    figure;
    imshow(imoverlay(I, BW, 'cyan'));
    title(['SLIC Superpixels (Number of Superpixels = ', num2str(num_superpixels), ')']);
    saveas(gcf, ['slic_superpixels_', num2str(num_superpixels), '.png']);  % Save the superpixel boundary image

    % Reshape the image for clustering
    pixelData = reshape(I, total_pixels, 1);  % Reshape image into a 1D vector of pixels

    % Loop through each k value for custom K-means clustering on SLIC superpixels
    for j = 1:length(k_values)
        k = k_values(j);

        disp(['Applying custom K-means clustering to SLIC superpixels with k = ', num2str(k), ' and superpixels = ', num2str(num_superpixels)]);
        
        % Apply custom K-means clustering to the SLIC superpixel regions
        [cluster_idx, ~] = custom_kmeans(pixelData, k, max_iters);
        
        % Reshape the cluster index into the original image size
        if length(cluster_idx) == total_pixels
            segmentedImage = reshape(cluster_idx, rows, cols);
            
            % Display and save the segmented superpixel image for each combination of k and superpixels
            figure;
            imagesc(segmentedImage);
            colormap('gray');
            title(['Custom K-means clustering on SLIC superpixels (k = ', num2str(k), ', superpixels = ', num2str(num_superpixels), ')']);
            saveas(gcf, ['custom_kmeans_slic_superpixels_k', num2str(k), '_superpixels_', num2str(num_superpixels), '.png']);  % Save the custom K-means result
        else
            disp('Error: The number of cluster assignments does not match the number of pixels in the image.');
            disp(['Number of pixels: ', num2str(total_pixels)]);
            disp(['Number of cluster assignments: ', num2str(length(cluster_idx))]);
        end
    end
end
