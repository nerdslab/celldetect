function [ProbMap_out, Vmap] = remove_vessels(ProbMap, vessel_ptr, minsz)

PmapT = ProbMap.*(ProbMap>vessel_ptr);
PmapT = imerode(PmapT,strel3d(1));

CC = bwconncomp(PmapT,6);
numcc = length(CC.PixelIdxList); 

numslices = zeros(numcc,1);
for i=1:numcc
   [~, ~, v3] = ind2sub(size(ProbMap), CC.PixelIdxList{1,i});
   numslices(i) = length(unique(v3));   
end

for i=1:numcc
    if numslices(i) < round(minsz*size(ProbMap,3))
        PmapT(CC.PixelIdxList{1,i}) = 0;
    end
end

Vmap = imdilate(PmapT,strel3d(3));
ProbMap_out = ProbMap.*(Vmap==0);

end