function func2Movie(funcIn,its,fps,lodi,bbox)
% abstract movie generator
% inputs: funcIn (function name or handle), its, frames per second
% it is possible to define layout options in configFrame.m

%% check input

nf = length(its);
nt = getNT;

if nargin < 3 
  fps = 5;
end

if any(its>nt)
  warning(['purging input time steps to nt = ' nt])
  its = its(its<=nt);
end

if isa(funcIn,'function_handle')
  func = funcIn;
  name = func2string(func);
elseif ischar(funcIn)
  name = funcIn;
  func = str2func(funcIn);
else
  error('funcIn is of unrecognized type')
end
%% initialize

set(gcf,'position',[80 60 900 550])
h = gcf;

iframe = 1;
nframe = length(its);

doConfig = exist('configFrame','file');

for it = its
  fprintf('func2Movie: %s time step %i (%i of %i)\n',name,it,iframe,nframe)

  try
    get(h,'type'); % to stop execution after closing figure
  catch ex
    fprintf('\nfunc2Movie detects that the figure has been closed')
    fprintf('\n       ... stopping execution\n\n')
    return
  end

  func(it);
  set(gcf,'color','w')
  set(gca,'position',[0 0 1 1])

  % add load displacement plot

  if nargin > 3

    axes('position',bbox)
    
    plot(lodi(:,2),lodi(:,3),'color',dblue,'linewidth',1);
    hold on
    plot(lodi(it+1,2),lodi(it+1,3),'r.');
    xl = xlim;
    yl = ylim;
    plot([0 0],yl,'k')
    plot(xl,[0 0],'k')
    xlim(xl-0.01*xl(2))
    ylim(yl-0.01*yl(2))

    set(gca,'ytick',[])
    set(gca,'xtick',[])
    set(gca,'color','none')
    set(gca,'box','off')
    set(gca,'fontsize',12)
    xlabel('t')
    ylabel('F')
    h = findobj(gca,'color','r');
    set(h,'markersize',15)
 
  end

  if doConfig
    configFrame;
  end

  % store frame and move on

  F(iframe) = getframe(gcf);

  iframe = iframe + 1;

end


disp('writing video to file...')

if length(name) < 5
  filename = strcat(name,'movie.avi');
else
  filename = strcat(name,'.avi');
end

myVideo = VideoWriter(filename);
myVideo.FrameRate = fps;
open(myVideo);
writeVideo(myVideo,F);

disp(['...done, movie stored as ' filename])

