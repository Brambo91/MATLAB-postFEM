function readOldMesh
% read mesh from all.nodes and *.elems

global gconn gcoords

coords = load('all.nodes');
gcoords = coords(:,2:3);

i = 1;
iel = 0;

while ( i > 0 )
  try
    filename = findFile('elems',i);
    conn = load(filename);
    ne = size(conn,1);
    gconn(iel+(1:ne),:) = conn(:,2:end)+1;
    iel = iel+ne;
    i = i+1;
  catch
    i = -1;
  end
end

assert(iel>0);


