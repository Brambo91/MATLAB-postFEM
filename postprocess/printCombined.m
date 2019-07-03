function printCombined(vh,rh,filename,r)
% this function uses the epscombined plot to make an eps that is 
% partially vector file and partially rasterized
% input:
%  - vh: handles to be vectorized (annotation)
%  - rh: handles to be rasterized (plot)
%  - filename: name of combined file without extension [combined]
%  - r: resolution [400]

% fix lims (to ensure the two eps files match)
xlim(xlim)
ylim(ylim)

% check resolution input
if nargin < 4
  res = '-r400';
else
  if isnumeric(r)
    res = ['-r' num2str(r)];
  end
end

% check filename input
if nargin < 3
  filename = 'combined.eps';
else
  if length(filename) <= 4 || ~strcmp(filename(end-3:end),'.eps')
    filename = [filename '.eps'];
  end
end

% first plot, rasterized
set(gcf,'color','w')
% set(gca,'position',[0.1 0.1 0.8 0.8])
for ( i = 1:length(vh) )
  set(vh(i),'visible','off')
end
% [~,visibility,~] = axis('state')
visibility = get(gca,'visible');
boxstate = get(gca,'box');
t=get(gca,'title');
tstr=get(t,'string');
set(t,'string','')
axis off
print('-depsc','-opengl',res,'tmp2')

% second plot, vector (annotation)
axis(visibility)
set(t,'string',tstr);
set(gca,'box',boxstate)
set(gcf,'color','none','inverthardcopy','off')
set(gca,'color','none')
for i = 1:length(vh)
  set(vh(i),'visible','on')
end
for i = 1:length(rh)
  set(rh(i),'visible','off')
end
print -depsc -painters tmp1

% combine
epscombine('tmp1','tmp2',filename)
!rm tmp1.eps tmp2.eps

% restore figure settings
for i = 1:length(rh)
  set(rh(i),'visible','on')
end
set(gca,'color','w')
set(gcf,'color',[.8 .8 .8])
set(gcf,'inverthardcopy','on')
