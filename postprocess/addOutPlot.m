function h = addOutPlot(it,comp)
% plot mesh with nodal quantities from OutputModule
% Args: time step, component (name)

%% get global variables or default values

global pxScale scaleOrder

if ( isempty(pxScale) )
  scale = 1;
else
  scale = pxScale;
end

if ( isempty(scaleOrder) )
  order = 0;
else
  order = scaleOrder;
end

if isempty(it)
  it = getNT;
  fprintf('using last time step by default: %i\n',it)
end

if isempty(comp) || ~ischar(comp)
  error('table component must be given as string')
end

if ( exist('loadScale.dat','file') && ~isempty(it) )
  load loadScale.dat
  if ( size(loadScale,1) >= it && size(loadScale,2)>=2  ...
                               && isfinite(loadScale(it,2)) )
    scaleAll = loadScale(it,2);
    if ( scaleOrder > 0 )
      scale = scale * scaleAll;
    end
  end
end

global pxLW

if ( isempty(pxLW) )
  pxLW = .1;
end

%% initialize files

global gcoords
global gconn

readMesh

rank = size(gcoords,2);
u = zeros(length(gcoords),rank);

try
  % find pointers to beginning of time step in file

  dfile = findFile('disp',1);
  eval(['!grep -b new ' dfile ' > dpointers.dat'])
  load dpointers.dat

  !rm *pointers.dat

  % open displacement and variable files and jump to correct position

  dFile = fopen(dfile);
  [xit,it] = findXOutTimeStep(dfile,it);
  fseek(dFile,dpointers(xit),'bof'); fgetl(dFile);

  %% read data

  if rank == 2
    dispUnsrt = fscanf(dFile, '%g %g %g'   ,[3,inf]);
  else
    dispUnsrt = fscanf(dFile, '%g %g %g %g',[4,inf]);
  end
  u(dispUnsrt(1,:)+1,:) = dispUnsrt(2:end,:)';
catch
  fprintf('no displacement file found\n')
  xit = it;
end

% find data in table file
% NB: possibly not all nodes have values, particularly with multiple 
%     models; other nodes then get NaN

data = evalTableData('*.out',xit,comp);

% compute displaced coordinates and scaled nodal values

coords = gcoords + scale * u;
fulldata = NaN*zeros(size(gcoords,1),1);

if ( exist('scaleAll','var') )
  fulldata(data(:,1)) = data(:,2) * (scaleAll^order);
else
  fulldata(data(:,1)) = data(:,2);
end

tmp = makePatch(coords,fulldata,gconn);

if nargout > 0
  h = tmp;
end
