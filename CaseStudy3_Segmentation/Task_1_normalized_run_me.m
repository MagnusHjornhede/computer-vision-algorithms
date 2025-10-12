% Task 1: Otsu Thresholding Comparison with Image Smoothing and Normalized Goodness Measure

% Load the input images
I1 = imread('cameraman.tif');
I2 = imread('left.jpg');

% Convert images to grayscale if necessary
if size(I2, 3) == 3
    I2 = rgb2gray(I2);
end

% Apply image smoothing (Gaussian filter) to improve global thresholding
I1_smooth = imgaussfilt(I1, 2);  % Apply Gaussian filter to smooth the image
I2_smooth = imgaussfilt(I2, 2);

% Compute the histogram for both images
h1 = imhist(I1_smooth);
h2 = imhist(I2_smooth);

% Custom Otsu implementation with normalized goodness measure
[T1_custom, GM1_custom] = otsu_thresh_with_normalized_GM(I1_smooth);
[T2_custom, GM2_custom] = otsu_thresh_with_normalized_GM(I2_smooth);

% MATLAB's built-in Otsu thresholding
T1_builtin = graythresh(I1_smooth) * 255;  % graythresh returns a value in [0, 1], so we scale it to [0, 255]
T2_builtin = graythresh(I2_smooth) * 255;

% Scale the custom Otsu thresholds to [0, 255] range
T1_custom_scaled = T1_custom * 255;
T2_custom_scaled = T2_custom * 255;

% Apply the thresholds to the images to obtain binary images
I1_binary_custom = imbinarize(I1_smooth, T1_custom_scaled / 255);
I2_binary_custom = imbinarize(I2_smooth, T2_custom_scaled / 255);

I1_binary_builtin = imbinarize(I1_smooth, T1_builtin / 255);
I2_binary_builtin = imbinarize(I2_smooth, T2_builtin / 255);

% Display results
figure;
subplot(2, 2, 1);
imshow(I1_binary_custom);
title('Custom Otsu Threshold (Cameraman)');

subplot(2, 2, 2);
imshow(I1_binary_builtin);
title('Built-in Otsu Threshold (Cameraman)');

subplot(2, 2, 3);
imshow(I2_binary_custom);
title('Custom Otsu Threshold (Left Image)');

subplot(2, 2, 4);
imshow(I2_binary_builtin);
title('Built-in Otsu Threshold (Left Image)');

% Save binary images for report
imwrite(I1_binary_custom, 'binary_custom_cameraman.png');
imwrite(I1_binary_builtin, 'binary_builtin_cameraman.png');
imwrite(I2_binary_custom, 'binary_custom_left.png');
imwrite(I2_binary_builtin, 'binary_builtin_left.png');

% Print the results to compare
disp('Results for: cameraman.tif');
disp(['Custom Otsu Threshold: ', num2str(T1_custom_scaled)]);
disp(['Goodness Measure (Normalized): ', num2str(GM1_custom)]);
disp(['Built-in graythresh Threshold: ', num2str(T1_builtin)]);

disp('Results for: left.jpg');
disp(['Custom Otsu Threshold: ', num2str(T2_custom_scaled)]);
disp(['Goodness Measure (Normalized): ', num2str(GM2_custom)]);
disp(['Built-in graythresh Threshold: ', num2str(T2_builtin)]);