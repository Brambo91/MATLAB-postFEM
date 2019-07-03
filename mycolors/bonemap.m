function bonemap(arg,frac)
% inverted bone colormap with darkest part removed. Arg: ntotal
% arg interpreted as fraction when smaller than 1
% arg ignored when between 1 and 64

if nargin < 2
  if nargin < 1
    ntotal = 82;
    frac = .8;
  elseif arg < 1
    ntotal = 64;
    frac = arg;
  else
    ntotal = max([ntotal,64]);
    frac = 1.;
  end
else
  ntotal = arg;
end

colormap(bone(ntotal))
Cm=colormap;
for i=1:64
  Cmi(i,:)= frac * Cm(ntotal+1-i,:) + ( 1 - frac ) * [ 1 1 1 ];
end
colormap(Cmi);
