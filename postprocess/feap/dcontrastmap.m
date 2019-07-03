function dcontrastmap(ncw,ncg,inv)
% define high contrast color map, derived from jet
% with both extremes white
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

colormap(jet(nc))
cm = colormap;
cm(1:ncw,:) = 1;
cm(nc-ncw+1:nc,:) = 1;

for i=1:ncg
  ir = ncw+i;
  cm(ir,:) = ( i*cm(ir,:) + (ncg-i)*[1 1 1] ) / ncg;
  ir = nc-ncw+1-i;
  cm(ir,:) = ( i*cm(ir,:) + (ncg-i)*[1 1 1] ) / ncg;
end

colormap(cm)
