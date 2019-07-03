function colb = recolb(colbIn)
% redraw colorbar for postgaust after rescaling caxis. Arg: colbIn

if nargin > 0
  pos = get(colbIn,'position');
else
  pos = [0.9 0.25 0.02 0.5];
end

colorbar off

colb = colorbar('Position',pos);

set(gca,'Fontsize',8)
