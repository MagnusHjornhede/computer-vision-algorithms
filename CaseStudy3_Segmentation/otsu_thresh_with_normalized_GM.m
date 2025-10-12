function [T, GM_normalized] = otsu_thresh_with_normalized_GM(I)
    % Step 1: Calculate the histogram
    counts = imhist(I);
    total = sum(counts);
    
    % Step 2: Normalize the histogram
    normalized_hist = counts / total;
    
    % Step 3: Cumulative sums for class probabilities
    P1 = cumsum(normalized_hist);
    P2 = 1 - P1; % Cumulative sum for the second class
    
    % Step 4: Cumulative means
    bin_centers = (0:255)';
    m = cumsum(bin_centers .* normalized_hist); % Cumulative mean intensity for each bin, weighted by probability
    mT = m(end); % Total mean intensity
    
    % Step 5: Between-class variance calculation
    sigma_B_squared = (mT * P1 - m).^2 ./ (P1 .* P2 + eps); % Avoid division by zero
    
    % Step 6: Find the optimal threshold that maximizes between-class variance
    [max_sigma_B_squared, T] = max(sigma_B_squared);
    
    % Step 7: Total variance of the image
    total_variance = sum(((bin_centers - mT).^2) .* normalized_hist);
    
    % Step 8: Goodness measure (GM) calculation and normalization by total pixels
    GM_normalized = max_sigma_B_squared / total_variance * (1 / total); % Normalize by image size
    
    % Normalize threshold between 0 and 1 for MATLAB binary image functions
    T = T / 255;
end
