function setLims

global XLIM YLIM

% zoomThis (can be overruled by XLIM, YLIM)

if exist('zoomThis.m','file')
  zoomThis
end

if ~isempty(XLIM)
  xlim(XLIM);
end

if ~isempty(YLIM)
  ylim(YLIM);
end

