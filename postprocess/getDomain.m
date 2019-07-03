function region = getDomain
% obtain domain from mesh
% plot mesh (from gmsh file) 
% and add labels of nodes and elements (possibly phantom/doubled coords/elems)
% labels correspond with c++ numbering (gmsh-1)
% args: iels, ins

global gconn
global gcoords
global gnn
global gnel
global meshLW;

global meshCol;

if meshLW == 0
  return
end

if isempty(meshCol)
  meshCol = [.7 .7 .7];
end

if isempty(meshLW)
  meshLW = .1;
end

% read mesh

readMesh

% read additional nodes and elements

xmin = min(gcoords(:,1));
xmax = max(gcoords(:,1));
ymin = min(gcoords(:,2));
ymax = max(gcoords(:,2));

if ( nargout > 0 )
  region = [ xmin, ymin, xmax, ymax];
else
  fprintf('xlim: [ %g, %g ]\nylim: [ %g, %g ]\n',xmin,xmax,ymin,ymax);
end
