clear;
clc;

% Load the input image
I = imread('redball.jpeg');  % Load  image

% Save the original image 
figure;
imshow(I);
title('Original Image: Red Christmas Balls');
saveas(gcf, 'redball_original.png');  % Save the original image

%  Convert to HSV color space
hsvImage = rgb2hsv(I);

% Step 3: Threshold the HSV image to isolate red color
% Red color has a hue around 0 and 1
hueChannel = hsvImage(:, :, 1);  % Extract the Hue channel

% Define the red color thresholds (adjust as needed)
lowerRed1 = 0.95;  % Lower threshold for red (wraps around near 1)
upperRed1 = 1.0;   % Upper threshold for red (wraps around near 1)
lowerRed2 = 0.0;   % Lower threshold for red (wraps around near 0)
upperRed2 = 0.05;  % Upper threshold for red (wraps around near 0)

% Create binary mask for red pixels
redMask = (hueChannel >= lowerRed1 | hueChannel <= upperRed2);  % Find red pixels

% Post-processing clean the binary mask
% clean up the mask (remove noise)
redMask = imfill(redMask, 'holes');  % Fill holes in the red areas
redMask = bwareaopen(redMask, 500);  % Remove small objects

% Step 5: Display and save the binary classification image (red balls as white)
figure;
imshow(redMask);
title('Classification Image (Red Balls Detected)');
saveas(gcf, 'red_balls_classification.png');  % Save the result 

% Step 6: Count the number of connected components 
connectedComponents = bwconncomp(redMask);  % Find connected components
numBalls = connectedComponents.NumObjects;  % Get the number of objects (red balls)

% Display the number of red balls detected
disp(['Number of red balls detected: ', num2str(numBalls)]);

