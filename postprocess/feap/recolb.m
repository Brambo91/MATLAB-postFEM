function colb = recolb
% redraw colorbar for postgaust after rescaling caxis

colorbar off

set(gca,'Position',[0.05 0. 0.8 1])

colb = colorbar('Position',[0.9 0.3 0.02 0.4]);

set(gca,'Fontsize',8)
