function graymapInv(dark)
% gray colormap with darkest part removed

ntotal = 128;
frac = .8;

colormap(gray(ntotal))
Cm=colormap;
for i=1:64
  Cmi(i,:)= frac * Cm(ntotal+1-i,:) + ( 1 - frac ) * [ 1 1 1 ];
end
colormap(Cmi);
