function setNanCol ( rgb )
% set color for nan entries in makePatch (rgb)

global nancol;

if ( nargin < 1 )
  disp('nancol set to [.7 .7 .7]')
  nancol = [.7 .7 .7];
else
  if length(rgb) ~= 3 || max(rgb)>1 || min(rgb)<0
    error('nancol should be given as rgb vector')
  end
  nancol = rgb;
end


