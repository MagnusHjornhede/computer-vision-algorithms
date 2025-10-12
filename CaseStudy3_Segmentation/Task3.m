
clear;
clc;

% Load the grayscale image
I = imread('left.jpg'); 

% Step 1: Apply Canny edge detection
edges = edge(I, 'Canny');  % Perform Canny edge detection

% Save the Canny edge detection image
figure;
imshow(edges);
title('Canny Edge Detection');
saveas(gcf, 'canny_edge_detection.png');  

% Step 2: Perform the Hough transform on the edges
[H, theta, rho] = hough(edges);  

% Save  plot
figure;
imshow(imadjust(rescale(H)), 'XData', theta, 'YData', rho, 'InitialMagnification', 'fit');
xlabel('\theta (degrees)');
ylabel('\rho');
title('Hough Transform of Canny Edges');
axis on;
axis normal;
colormap(gca, hot);
saveas(gcf, 'hough_transform.png');  

% Step 3: Detect peaks in the Hough transform
numPeaks = 5;  
peaks = houghpeaks(H, numPeaks);

% Plot the peaks on the Hough transform
figure;
imshow(imadjust(rescale(H)), 'XData', theta, 'YData', rho, 'InitialMagnification', 'fit');
xlabel('\theta (degrees)');
ylabel('\rho');
title('Hough Transform with Peaks Marked');
hold on;
plot(theta(peaks(:, 2)), rho(peaks(:, 1)), 's', 'color', 'blue');
saveas(gcf, 'hough_peaks.png');  % Save  with peaks marked

% Step 4: Detect lines based on the Hough transform peaks
lines = houghlines(edges, theta, rho, peaks, 'FillGap', 5, 'MinLength', 7);

% Save the detected lines on the original image
figure;
imshow(I);
hold on;
title('Detected Lines on Grayscale Image');

% Plot the lines on the image
for k = 1:length(lines)
   xy = [lines(k).point1; lines(k).point2];
   plot(xy(:, 1), xy(:, 2), 'LineWidth', 2, 'Color', 'green');
   
   % Plot the beginnings and ends of the lines
   plot(xy(1, 1), xy(1, 2), 'x', 'LineWidth', 2, 'Color', 'yellow');
   plot(xy(2, 1), xy(2, 2), 'x', 'LineWidth', 2, 'Color', 'red');
end
hold off;
saveas(gcf, 'detected_lines.png'); 
