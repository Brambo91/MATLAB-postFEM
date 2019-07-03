function pimovie(it0,dit,nt)

% postprocessing for jemjive with interface elements. Args: it0,dit,nt

disp('pimovie: create movie of subsequent postintf calls')
disp('Optional arguments: first time step, d(time step), last time step')
% disp('Time step: Default is final time step')
% disp('Component: Default is 1')

%% initialize

% set(gcf,'position',[5 60 900 600])

if ( nargin < 2 ) 
  dit = 1;
end
if ( nargin < 1 ) 
  it0 = 1;
end

!grep -b new interface0.dat > hpointers.dat
load hpointers.dat
if ( nargin < 3 ) 
  nt = length(hpointers)-1;
end
clear hpointers;
!rm *pointers.dat

clear F
jt = 1;
if length(it0)>1
  its = it0;
else
  its = it0:dit:nt;
end

for it = its
  
  disp('')
  disp(['PIMovie: time step ' num2str(it) ' ( ' num2str(jt) ...
        ' of ' num2str(length(its)) ' )']);
  postncintf(it,7)
%   caxis([0 20])

%   xp = [-9 -4];
%   yp = [.5 4];
%   
%   patch(xp([1 2 2 1]),yp([1 1 2 2]),1*ones(1,4),0,'facealpha',.95,...
%     'linestyle','none')
%   
%   abox = [xp(1) yp(1) diff(xp) diff(yp)];
%   
%   [bbox] = dsxy2figxy(gca, abox);
% %   bbox = [0.16 0.5563 0.23 0.225];
%   bbox(1) = bbox(1) + 0.04;
%   bbox(3) = bbox(3) - 0.04;
%   bbox(2) = bbox(2) + 0.02;
%   bbox(4) = bbox(4) - 0.04;
% 
%   axes('position',bbox,'color','none','box','off')
%   addCleanLodi(it)
%   set(gca,'ytick',[])
%   set(gca,'xtick',[])
%   set(gca,'color','none')
% %   xlim([0 max(lodi(:,2))*1.2])
%   h = findobj(gca,'color','r');
%   set(h,'markersize',20)
  
  
  F(jt) = getframe(gcf);
  jt = jt + 1;
  
end

assignin('base','F',F)

