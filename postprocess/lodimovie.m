function lodimovie

% make a movie of a load-displacement plot with moving dot

%% initialize

load lodi.dat

nt = length(lodi);

for it = 1:nt

  clf
  hold on
  plot(lodi(1:it,1),lodi(1:it,2),'b-');
  plot(lodi(it:nt,1),lodi(it:nt,2),'b:');
  plot(lodi(it,1),lodi(it,2),'r.','markersize',10);

%   set(gcf,'position',[0 0 4 3]);
  set(gcf,'position',[520 680 560 420]);
  
  xlabel('u')
  ylabel('F')
  
  F(it) = getframe(gcf);
  
end

movie2avi(F,'lodimovie','fps',5)