function bonemap
% inverted bone colormap with darkest part removed

colormap bone(82)
Cm=colormap;
for i=1:64
  Cmi(i,:)=Cm(83-i,:);
end
colormap(Cmi);

