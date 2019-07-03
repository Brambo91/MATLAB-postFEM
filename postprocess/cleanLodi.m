function out = cleanLodi(its)
% arg: its (time steps for markers)

setAxes lodi;

clf

if nargin < 1
  addCleanLodi;
else
  addCleanLodi(its);
end

% layout
set(gcf,'paperposition',[0 0 3 2])
set(gca,'fontsize',8)
xlabel('u [mm]')
ylabel('F [N]')

if nargout > 0
  out = evalin('base','lodi');
end

try
  str = [getDirName(1) 'C'];
  assignin('base',str,evalin('base','lodi'));
  disp(['lodi stored in ''' str ''''])
end

% % transparant for poster
% set(gca,'color','none')
% set(gcf,'color','none')
% set(gcf,'inverthardcopy','off')

nameFig
