function labelNodes(ins,col)
% label nodes in existing plot
% using readGmsh and *.msh
% input node number are c++ numbers ranging from 0 to (gnn-1)

global gcoords
global gnn

readMesh

if nargin < 2
  col = 'r';
end
if nargin < 1 || isempty(ins)
  ins = 0:gnn-1;
end

rank = size(gcoords,2);

for i = 1:length(ins)
  in = ins(i);
  x  = gcoords(in+1,1);
  y  = gcoords(in+1,2);
  if ( rank == 2 )
    z  = ones(size(x));
  else
    z = gcoords(in+1,3);
  end
  text(x,y,z,num2str(in),'color',col)
end
