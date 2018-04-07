function ProbMap = gmmposterior_im(IM,numcomp,numselect,cellclass)
%%%%%
% Input
% IM = (N1 x N2 x N3) cube of image data
% numcomp = number of components used in GMM (# classes for segmentation)
% numselect = number of voxels to select to train GMM (e.g. 50,000)
% cellclass = 0 if cells are brighter than background (closer to white), 1 if cells are
% darker than background (default)
%%%%%
% Output
% ProbMap = output probability cube (cell prob. class)

if nargin<4
    cellclass = 1;
end

dataN = IM;
id_select = randi(numel(dataN),numselect,1);
traind = dataN(id_select);
gm = fitgmdist(traind,numcomp);
Probx = posterior(gm,dataN(:));

if cellclass == 1
    [~,whichcell] = min(mean(gm.mu,2));
else
    [~,whichcell] = max(mean(gm.mu,2));
end

ProbMap = reshape(Probx(:,whichcell),size(dataN));

end % end main function







