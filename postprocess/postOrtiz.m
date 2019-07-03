function postOrtiz(it)
% plot ortiz-style cohesive cracks
% input: it

global crackLW

if ( nargin < 1 || isempty(it) )
  it = getNT;
end

if ( isempty(crackLW) )
  lw = 1.;
else
  lw = crackLW;
end

% plotMesh on background (only if meshLW manually set to nonzero value!)

global meshLW

if ~isempty(meshLW)
  plotMesh
end

% find out edge information from global mesh data (set in plotMesh)

edges = drawOutline(.5);
axis off

% find out which edge are cracked and plot those

global gcoords
global gnn

load xnodes.dat
nlines = size(xnodes,1);

for i = 1:nlines

  if xnodes(i,1)>it
    break
  end

  iedge = xnodes(i,3)+1;  % incremented for c++ to matlab

  if ( iedge <= gnn && ~isempty(edges{iedge}) )
    j0 = edges{iedge}(1);
    j2 = edges{iedge}(2);
    v  = [j0,iedge,j2];
    xs = gcoords ( v,1 );
    ys = gcoords ( v,2 );

    hold on
    plot(xs,ys,'r','linewidth',lw);
  end
end
  



