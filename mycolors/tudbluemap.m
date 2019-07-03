function tudbluemap(nc)
% interpolate from white to TUblue

if nargin<1
  nc = 64;
end

cm = zeros(nc,3);

for i = 1:nc
  cm(i,:) = i/nc*tudblue + (nc-i)/nc*[.8 .8 .8];
end

colormap(cm)
