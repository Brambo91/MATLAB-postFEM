function makeMovie(its)

% initialize figure

set(gcf,'position',[5 60 900 550])
set(gcf,'paperposition',[0 0 9 4])

load lodi.dat

% global settting

setPxScale 20
setPxExtension stress
setVIEW([30 40])
setXLIM([0 120])
setYLIM([-5 55])

jt = 1;
for it = its

  disp('')
  disp(['PXMovie: time step ' num2str(it) ' ( ' num2str(jt) ...
        ' of ' num2str(length(its)) ' )']);
      
  % make the deformed mesh figure

  pxthick(it,-.5,.5);
  colorbar off
  colormap([.7 .0 .0;.7 .2 .2;.7 .4 .4])
  
  % add load displacement plot

  axes('position',[0.05 0.05 0.23 0.26]);
  plot(lodi(:,2),lodi(:,3));

  % add point for current time step

  hold on;
  plot(lodi(it,2),lodi(it,3),'r.','markersize',15);

  % simplify load displacement layout

  set(gca,'ytick',[])
  set(gca,'xtick',[])
  set(gca,'color','none')
  set(gca,'box','off')
  set(gca,'fontsize',12)
  xlabel('u')
  ylabel('F')
  xlim([0 max(lodi(:,2)*1.2)])
  ylim([0 max(lodi(:,3)*1.2)])
  
  % white background looks better in movie

  set(gcf,'color','w');
  
  % store frame in array

  F(jt) = getframe(gcf);
  jt = jt + 1;

end

% store movie as avi file

disp('storing stuff...')
imwrite(frame2im(F(1)),'pxmovie0.png','png')
movie2avi(F,'pxmovie','fps',5)
disp('...done')

