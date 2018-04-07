% script to run cell finder (on test data)
% Input = Prob (cell probability map for V1)

load('GroundTruth_V1.mat')

ptr = 0.2; % threshold Prob > ptr
presid = 0.47; 
startsz = 18; 
dilatesz = 8;
kmax = 10; % find first 10 cells only

[Centroids_out,Nmap_out] = OMP_ProbMap(Probmap,ptr,presid,startsz,dilatesz,kmax);
