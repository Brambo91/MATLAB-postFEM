function EDGES = drawOutline(lw,col)
% draw outline of geometry
% arguments: lw, col
% output: edges
% NB: set lw=0 to skip the drawing and get edge information

if nargin < 2
  col = 'k';
end

if nargin < 1
  lw = 0.5;
end

global gconn
global gcoords
global gnn
global gnel

readMesh

edges = cell(gnn,1);
boundaryEdge = false(gnn,1);

for i = 1:gnel
  inodes = gconn(i,:);
  for j = 2:2:6
    inode = inodes(j);
    boundaryEdge(inode) = ~boundaryEdge(inode);
    if ( isempty(edges{inode}) )
      j0 = j-1;
      j2 = mod(j,6)+1;
      edges{inode} = [inodes(j0),inodes(j2)];
    end
  end
end

hold on
set(gca,'dataaspectratio',[1 1 1])

for i = 1:gnn
  if boundaryEdge(i)
    v = [ edges{i}(1), i, edges{i}(2) ];
    xs = gcoords ( v, 1 );
    ys = gcoords ( v, 2 );

    plot(xs,ys,'color',col,'linewidth',lw);
  end
end

if nargout > 0
  EDGES = edges;
end
