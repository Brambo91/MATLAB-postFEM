function h = addPostTable(it,comp)
% plot deformed mesh with nodal quantities
% Args: time step, component (index or name)

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

global pxLW

if ( isempty(pxLW) )
  pxLW = .1;
end

%% initialize files

global gcoords
global gconn
global gu

tfile = 'xotable.dat';

if ~exist(tfile,'file')
  disp([tfile ' has not been found. Is your path correct?'])
  return
end

[xit,it] = findXOutTimeStep(tfile,it);

global skipMesh

if ( isempty(skipMesh) || ~skipMesh )
  readMesh(xit);
end

rank = size(gcoords,2);
u = zeros(length(gcoords),rank);

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

% find filename

dfile = findFile('disp',1);

% find pointers to beginning of time step in files

eval(['!grep -b new ' dfile ' > dpointers.dat'])
load dpointers.dat
!rm *pointers.dat

% open displacement and variable files and jump to correct position

dFile = fopen(dfile);

% jump to correct position

fseek(dFile,dpointers(xit,1),'bof'); fgetl(dFile);

%% read data

if rank == 2
  dispUnsrt = fscanf(dFile, '%g %g %g'   ,[3,inf]);
else
  dispUnsrt = fscanf(dFile, '%g %g %g %g',[4,inf]);
end
u(dispUnsrt(1,:)+1,:) = dispUnsrt(2:end,:)';

% eliminate interface elements (in 2D case)

if ( size(gconn,2) == 4 )
  compoundCondInd = ( gcoords(gconn(:,1),2)~=gcoords(gconn(:,3),2) ) ...
                  | ( gcoords(gconn(:,1),1)~=gcoords(gconn(:,3),1) );
  conn = gconn ( compoundCondInd, : );
else
  conn = gconn;
end

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
  % get data from written table
  data = evalTableData(tfile,xit,comp);
  fulldata = NaN*zeros(size(u,1),1);
  fulldata(data(:,1)) = data(:,2);
end

if exist('scaleAll','var')
  fulldata = fulldata * (scaleAll^order);
end

gu = u(1:size(gcoords,1),:);
coords = gcoords + scale * gu;

tmp = makePatch(coords,fulldata,conn);

if nargout > 0
  h = tmp;
end

