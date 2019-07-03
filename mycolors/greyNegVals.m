
cm = colormap;
if cm(1,:) ~= [.7 .7 .7]
  cm = [.7 .7 .7;cm];
  colormap(cm);
  nc = size(cm,1);
  caxis([-1/(nc-1) 1])
end

