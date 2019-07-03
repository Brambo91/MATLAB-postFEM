function [xit,itOut] = findXOutTimeStep ( file, it )
% finds newXOutput instance closest to time step it
% also returns corresponding real time step number it

eval(['!grep -b new ' file ' > pointers.dat'])
load pointers.dat

if ( isempty(it) )
  xit = size(pointers,1);
  fprintf('no time step specified, using last one: %g\n\n',pointers(xit,2))
else
  xit = find(pointers(:,2)==it);
end

if ( isempty(xit) )
  [~,xit] = min(abs(pointers(:,2)-it));
  fprintf('time step %g not found, using data from time step %g instead\n\n', ...
    it, pointers(xit,2))
end

itOut = pointers(xit,2);

!rm pointers.dat
