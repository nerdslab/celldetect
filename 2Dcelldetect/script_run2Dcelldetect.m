% script for cell detection in 2D histology

im = imread('100048576_377-crop_Probabilities.tiff'); % V1 image
im2 = imrotate(im(:,:,1),-27);
im3 = im2(1301:2500,1801:3000);

p_threshold = 0.2;
p_residual = 0.1;
sphere_sz = 10;
dilate_sz = 3;
max_numcells = 10000;
[Centroids,Nmap] = OMP_ProbMap2D(im3,p_threshold,p_residual,sphere_sz,dilate_sz,max_numcells);

figure, 
subplot(1,2,1), 
imagesc(im3(500:600,500:600)), 
subplot(1,2,2), 
imagesc(Nmap(500:600,500:600))

