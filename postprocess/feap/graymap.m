function graymap
% inverted gray colormap with darkest part removed

colormap gray(102)
Cm=colormap;
for i=1:64
  Cmi(i,:)=Cm(103-i,:);
end
colormap(Cmi);

