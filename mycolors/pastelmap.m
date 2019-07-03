function pastelmap(fac,ncw,ncg)
% define light color map derived from hsv. Args: fac,ncw,ncg ;
% optional argument: scaling factor

%%

nc = 64;

if nargin<1
  fac = 2;
end

colormap(jet(nc))
cm = colormap;
cm = (cm + fac*ones(length(cm),3) ) / (1+fac);

if nargin > 2
  for ir=1:ncw
    cm(ir,:) = [1 1 1];
  end
  for i=1:min(ncg,nc-ncw)
    ir = ncw+i;
    if ir > 0
      cm(ir,:) = ( i*cm(ir,:) + (ncg-i)*[1 1 1] ) / ncg;
    end
  end
end

colormap(cm)
