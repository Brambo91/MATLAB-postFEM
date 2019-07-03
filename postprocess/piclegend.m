function piclegend

%% postintf legend

clf('reset')
set(gcf,'paperposition',[0 0 4 .6])

% crack legend
axes('position',[0.45 0 0.5 1])
set(gca,'fontsize',8)
set(gca,'dataaspectratio',[1 1 1])
hold on
plot([0 1],[.5 1.5],'color',[0 0 1],'linewidth',1)
plot([0 1],[-.5 -1.5],'color',[0 .5 0],'linewidth',1)
text(1.1,1.2,'top')
text(1.1,-.8,'bot')
% text(1.1,1.2,'Split in top ply')
% text(1.1,-.8,'Split in bottom ply')
xlim([0 8])
axis off

% colorbar
caxis([0 1])
pastelmap(2,1,10)
colb = colorbar('south');
set(colb,'position',[0.05 0.4 0.3 0.2])
set(colb,'xtick',[0 0.5 1])
set(colb,'xticklabel',['0';'i';'1'])
set(colb,'ticklength',[0 0])
set(colb,'fontsize',8)

% % transparant for poster
% set(gca,'color','none')
% set(gcf,'color','none')
% set(gcf,'inverthardcopy','off')

print -depsc piclegend

