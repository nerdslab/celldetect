%%%%%%%%%%%%%%%%%%%%%%
% script_run2Dcelldetect.m = script for cell detection in 2D histology
%%%%%%%%%%%%%%%%%%%%%%

%% init
clc; clear all; close all;

%% load in // set variables

% original image
im_original = imread('100048576_377-crop.jpg'); %original image
im_original2 = imrotate(im_original(:,:,1),-27); % rotated 27 degrees to take slice we can potentially see layers
im_original3 = im_original2(1301:2500,1801:3000); % crop to 1200x1200 with roughly 8000 cells

% probability map of original image
im_prob = imread('100048576_377-crop_Probabilities.tiff');
im_prob2 = imrotate(im_prob(:,:,1),-27); % rotated 27 degrees to take slice we can potentially see layers
im_prob3 = im_prob2(1301:2500,1801:3000); % crop to 1200x1200 with roughly 8000 cells


p_threshold = 0.2; %keep low <.2
p_residual = 0.1; %residual to compare graph to image
max_numcells = 10000; %the guess of cells is ~8000, will stop if residual is reachde
sphere_sz = 8; %fixed diameter size of predicted cell
dilate_sz = 5; %adding the removal area around cell
[Centroids2,Nmap2,NumCellDetected] = OMP_ProbMap2D(im_prob3,p_threshold,p_residual,sphere_sz,dilate_sz,max_numcells);


%% graphing

% generating the circles from OMP_ProbMap2D
stats = regionprops('table',Nmap2,'Centroid',...
    'MajorAxisLength','MinorAxisLength');
centers = stats.Centroid;
diameters = mean([stats.MajorAxisLength stats.MinorAxisLength],2);
radii_4 = diameters/(2*4); %radius 4x smaller for better showing on overall graph


figure(1),
subplot(2,5,[1,2,6,7]),
image(im_original), title("Original Image")
axis off


subplot(2,5,3),
out = imrotate(im_original,-27);
out2 = out(1301:2500,1801:3000,:);
image(out2),title("Zoomed Image"),
axis off

subplot(2,5,4),
imshow(im_original3), title("Probablity Map"),


subplot(2,5,5),
imshow(im_original3), title("Cell count"),
viscircles(centers, radii_4),

subplot(2,5,8),
image(out2(500:600,500:600,:)),title("Zoomed Image"),
axis off

subplot(2,5,9), 
imshow(im_original3(500:600,500:600)), title("Probablity Map Zoomed"),

subplot(2,5,10),
imshow(im_original3(500:600,500:600)), title("Cell Count Zoomed"),
%finding corrisponding detected cells with smaller zoomed picture
stats2 = regionprops('table',Nmap2(500:600,500:600),'Centroid',...
    'MajorAxisLength','MinorAxisLength');
centers2 = stats2.Centroid;
diameters2 = mean([stats2.MajorAxisLength stats2.MinorAxisLength],2);
radii2 = diameters2/2;
viscircles(centers2, radii2); %overlaying the predicted cells

