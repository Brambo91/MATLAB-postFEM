function contrastmap(ncw,ncg,inv)
% define high contrast color map, derived from jet. Args: ncw,ncg,inv
% lowest values white, [ncw] defines how many
% then gradient from white to jet, [ncg] defines how many
% if inv==1: invert colormap (for negative values)

%%

nc = 64;

if nargin<3
  inv = 0;
  if nargin<2
    ncg=round(nc/3);
    if nargin<1
      ncw=1;
    end
  end
end


%% 

colormap(jet(nc))
cm = colormap;
cm(1:ncw,:) = 1;

for i=1:min(ncg,nc-ncw)
  ir = ncw+i;
  if ( ir >= 1 )
    cm(ir,:) = ( i*cm(ir,:) + (ncg-i)*[1 1 1] ) / ncg;
  end
end

if inv
  for i=1:nc
    cmi(i,:) = cm(nc+1-i,:);
  end
  colormap(cmi)
else
  colormap(cm)
end
