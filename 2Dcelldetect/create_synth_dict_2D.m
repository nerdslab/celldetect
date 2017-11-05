function Dict = create_synth_dict_2D(radii,box_radius)

Lbox = box_radius*2 +1;
Dict = zeros(Lbox^2,length(radii));
cvox = (Lbox-1)/2 + 1;

for i=1:length(radii)
   tmp =zeros(Lbox,Lbox,Lbox);
   tmp(cvox,cvox,cvox)=1;
   spheremat = strel3d(radii(i));
   tmp2 = imdilate(tmp,spheremat);
   Dict(:,i) = reshape(tmp2(:,:,cvox),Lbox^2,1);
   Dict(:,i) = Dict(:,i)./norm(Dict(:,i));
end


end