function out=plotMesh(iels,ins)
% postprocessing: visualize mesh
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

np = size(gconn,2);

v = [ 1:np, 1 ];

rank = size(gcoords,2);

coords = gcoords;
conn = gconn;

x = reshape( coords(conn,1), size(conn) );
y = reshape( coords(conn,2), size(conn) );
if ( rank == 2 )
  z = -1 * ones ( size(conn) );
else
  z = reshape( coords(conn,3), size(conn) );
end

% if ( nargin > 0 )  
%   nfile = findFile('nodes',1);
%   efile = findFile('elems',1);
%   xcoords = load(nfile);
%   coords = [ coords ; xcoords(:,(1:rank)+1) ];
% 
%   xelems = load(efile);
% 
%   conn = [ conn(:,v) ; xelems(:,3:6)+1 ];   % +1 for c++ to matlab
% end


%% plot mesh

% clf
% axis off
set(gca,'dataaspectratio',[1 1 1])

% line(x(:,v)',y(:,v)',z(:,v)','linewidth',.1,'color','k')
h = line(x(:,v)',y(:,v)',z(:,v)','linewidth',meshLW,'color',meshCol);

setLims
nameFig

%% add labels

xm = mean(x,2);
ym = mean(y,2);
gnel = length(xm);

if nargin > 0
  if isempty(iels)
    iels = 0:(gnel-1);
  end
  iels = mod(iels,gnel)+1;
  for i=iels
    text(xm(i),ym(i),num2str(i-1),...
         'HorizontalAlignment','center','color','b');
  end
end

if nargin > 1
  if isempty(ins)
    ins = 0:gnn;
  end
  ins = ins + 1;
  for i = ins
    text(coords(i,1),coords(i,2),num2str(i-1),'color','r')
  end
end

if nargout > 0
  out = h;
end
