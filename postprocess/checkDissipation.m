% check global energy dissipation versus total dissipation in models

plotDissipation

nm = size(dissipation,2);
if nm > 2
  plot(dissipation(:,nm),sum(dissipation(:,1:(nm-1))'),'m');
end
plot(ylim,ylim,'k--');



