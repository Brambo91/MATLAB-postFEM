function pxmovie(it0,dit,nt)

% postprocessing for jemjive with xfem. Args; it0,dit,nt.
% plot of deformed mesh with fancy crack vizualization for single time step

disp('PX: deformed mesh with fancy crack vizualization for single time step')
disp('Optional arguments: first time step, d(time step), last time step')
% disp('Time step: Default is final time step')
% disp('Component: Default is 1')

%% initialize

set(gcf,'position',[5 60 900 550])
set(gcf,'paperposition',[0 0 9 4])

if nargin == 1 && length(it0)>1

  its = it0;

else

  if ( nargin < 2 ) 
    dit = 1;
  end
  if ( nargin < 1 ) 
    it0 = 1;
  end

  !grep -b new stress.dat > hpointers.dat
  load hpointers.dat
  if ( nargin < 3 ) 
    nt = length(hpointers)-1;
  end
  clear hpointers;
  !rm *pointers.dat

  its = it0:dit:nt;

end

jt = 1;
for it = its
  disp('')
  disp(['PXMovie: time step ' num2str(it) ' ( ' num2str(jt) ...
        ' of ' num2str(length(its)) ' )']);
  px(it);
%   xlim([-5 50])
%   pxthick(it)
  
%   bbox = [0.05 0.05 0.23 0.26];
% 
%   axes('position',bbox,'color','none','box','off')
%   addCleanLodi(it)
%   set(gca,'ytick',[])
%   set(gca,'xtick',[])
%   set(gca,'color','none')
%   set(gca,'box','off')
%   set(gca,'fontsize',12)
%   xlabel('u')
%   ylabel('F')
% %   xlim([0 0.5])
% %   ylim([0 1200])
%   xlim([0 0.3])
%   ylim([0 800])
%   h = findobj(gca,'color','r');
%   set(h,'markersize',20)
%   
%   set(gcf,'color','w');
  
  F(jt) = getframe(gcf);
  jt = jt + 1;
end

assignin('base','F',F)

% disp('storing stuff...')
% imwrite(frame2im(F(2)),'pxmovie0.png','png')
% movie2avi(F,'pxmovie','fps',5)
% disp('...done')