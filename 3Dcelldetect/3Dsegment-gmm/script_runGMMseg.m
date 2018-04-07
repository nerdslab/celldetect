load('GroundTruth_V1.mat')
viz = 1; % visualize output

%% Run Gaussian Mixture Model (GMM) Segmentation 

numcomp = 2; % number of gaussian mixtures
numsamp = 2e5; % number of voxels to sample to train GMM
vessel_ptr =0.8; % threshold for GMM probability map
minsz = 0.5; % percentage of slices that vessel should run through

ProbMap = gmmposterior_im(IM,numcomp,numselect);

%% segment cells/vessels
[ProbMap_out, Vmap] = remove_vessels(ProbMap, vessel_ptr, minsz);

%% visualize

if viz == 1
    figure,
    for i=1:size(IM,3) 
        subplot(1,3,1), imagesc(IM(:,:,i)), axis off, 
        subplot(1,3,2), imagesc(Vmap(:,:,i)), colormap gray, 
        subplot(1,3,3), imagesc(ProbMap_out(:,:,i)), colormap gray, 
        pause, 
    end
end

