function interpolateCM ( col1, col2 )

% linearly interpolate colormap
% optional args: two rgb vectors, otherwise current map extremes are used

if nargin == 0
  cm = colormap;
  np = length(colormap);
else
  np = 64;
  cm = zeros(np,3);
  cm(1,:) = col1;
  cm(np,:) = col2;
end

for i=2:np-1
  cm(i,:) = ( (i-1)*cm(np,:) + (np-i)*cm(1,:) ) / ( np-1 );
end

colormap(cm);
