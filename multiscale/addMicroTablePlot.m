function h = addMicroTablePlot(it,filename,comp)
% plot mesh with nodal quantities from OutputModule
% Args: time step, filename, component (name)

%% get global variables or default values

global pxScale

if ( isempty(pxScale) )
  scale = 1;
else
  scale = pxScale;
end

if isempty(it)
  it = getNT;
  fprintf('using last time step by default: %i\n',it)
end

if isempty(comp) || ~ischar(comp)
  error('table component must be given as string')
end

global pxLW

if ( isempty(pxLW) )
  pxLW = .1;
end

%% initialize files

global gcoords
global gconn

readMesh

u = zeros(size(gcoords));

dispUnsrt = getTableDisp(it,filename);
u(dispUnsrt(:,1),:) = dispUnsrt(:,2:end);

% find data in table file
% NB: possibly not all nodes have values, particularly with multiple 
%     models; other nodes then get NaN

if ( strcmp(comp,'ux') )
  fulldata = u(:,1);
elseif ( strcmp(comp,'uy') )
  fulldata = u(:,2);
elseif ( strcmp(comp,'uz') )
  fulldata = u(:,3);
else
  data = evalTableData(filename,it,comp);
  fulldata = NaN*zeros(size(gcoords,1),1);
  fulldata(data(:,1)) = data(:,2);
end

% compute displaced coordinates

try
  coords = gcoords + scale * u;
catch ex
  meshFileQuery(1)
  rethrow(ex)
end

tmp = makePatch(coords,fulldata,gconn);

if nargout > 0
  h = tmp;
end
