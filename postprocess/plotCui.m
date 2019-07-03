function OUT = plotCui

cui = [ 1 2 4 8; 0.86 1.08 1.37 1.47]';

plot12(cui,'-ko','markerfacecolor','k')

if nargout > 0
  OUT = cui;
end
