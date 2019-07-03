function picmovie(its)

% postprocessing for jemjive with xfem. Arg; its

%% initialize

set(gcf,'position',[5 60 900 550])
set(gcf,'paperposition',[0 0 9 4])
% setPxOption(4)
% setPxScale(10)
% setPxLW(0.)

if nargin < 1 || isempty(its)

  sfile = findFile('stress',1);
  eval(['!grep -b new ' sfile ' > hpointers.dat'])
  load hpointers.dat
  if ( nargin < 3 ) 
    nt = length(hpointers)-1;
  end
  clear hpointers;
  !rm *pointers.dat

  its = 1:nt;

end

jt = 1;
for it = its
  disp('')
  disp(['PicMovie: time step ' num2str(it) ' ( ' num2str(jt) ...
        ' of ' num2str(length(its)) ' )']);
    
  pic(it,6,1)
%   colormap default
%   caxis([0 40])

%   % add load displacement plot
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
% %   xlim([0 0.3])   % NB: these are still problem dependent!
% %   ylim([0 2000])
%   h = findobj(gca,'color','r');
%   set(h,'markersize',15)
  
  set(gcf,'color','w');
  
  F(jt) = getframe(gcf);
  jt = jt + 1;

end

assignin('base','F',F)

% disp('storing stuff...')
% imwrite(frame2im(F(1)),'pxmovie0.png','png')
% movie2avi(F,'pxmovie','fps',5)
% disp('...done')
