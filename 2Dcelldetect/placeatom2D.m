function X = placeatom2D(vec,Lbox,which_loc,stacksz)

tmp = zeros(stacksz);
tmp(which_loc)=1;
tmp = padarray(tmp,[Lbox,Lbox]);
whichloc2 = find(tmp);
[center_loc(1),center_loc(2)] = ind2sub(size(tmp),whichloc2);
        tmp(center_loc(1)-round(Lbox/2)+1:center_loc(1)+round(Lbox/2)-1,...
        center_loc(2)-round(Lbox/2)+1:center_loc(2)+round(Lbox/2)-1) = ...
        reshape(vec,Lbox,Lbox);    
X = tmp;
end
