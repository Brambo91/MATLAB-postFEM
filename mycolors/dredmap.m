function  dredmap(nc,col0)
% interpolate from col0 to dred. Args: nc, col0
% use col0 = [.8 .8 .8] for grey background

if nargin < 2
  col0 = [1 1 1];
end

if nargin<1
  nc = 64;
end

cm = zeros(nc,3);

for i = 1:nc
  cm(i,:) = (i-1)/(nc-1)*[.7 0 0] + (nc-i)/(nc-1)*col0;
end

colormap(cm)
