function postXSubl(it)

% postprocessing for ShellDelamModel
% plot deformed xfem-mesh 
% Args: time step

tic
% disp('Initializing')

if nargin < 1
  it = '';
end

%% initialize figure

% TODO: make wrapper function for figure layout

global VIEW
global XLIM
global YLIM
global ZLIM

clf
set(gca,'dataaspectratio',[1 1 1])

if ~isempty(VIEW)
  view(VIEW)
else
  view([30 40])
end

axis off

%% get global variables or default values

global pxScale

if ( isempty(pxScale) )
  scale = 1;
else
  scale = pxScale;
end

global pxLW

if ( isempty(pxLW) )
  lw = .1;
else
  lw = pxLW;
end

%% initialize files

% read original mesh from gmsh file

global gcoords
global gconn

readMesh(it)

% find filenames

tfile = findFile('thick',1);
dfile = findFile('disp',1);
nfile = findFile('dbNodes',1);
pfile = findFile('phNodes',1);
efile = findFile('elems',1);

if ~exist(nfile,'file')
  disp([nfile ' has not been found. Is your path correct?'])
  return
end

% find pointers to beginning of time step in files

eval(['!grep -b new ' dfile ' > dpointers.dat'])
eval(['!grep -b new ' efile ' > epointers.dat'])
eval(['!grep -b new ' pfile ' > ppointers.dat'])

load dpointers.dat
load epointers.dat
load ppointers.dat

!rm *pointers.dat

% find number of time steps

nt = length(dpointers);
if isempty(it) || strcmp(it,'nt')
  it = nt;
  % disp(['nt = ', num2str(nt)])
elseif it > nt
  disp('time step doesnt exist')
  disp(['nt = ', num2str(nt)])
  return;
end

% report some stuff

disp(['postXSubl it = ' num2str(it)]);

% open displacement and variable files and jump to correct position

dFile = fopen(dfile);
eFile = fopen(efile);
pFile = fopen(pfile);

fseek(dFile,dpointers(it),'bof'); fgetl(dFile);
fseek(eFile,epointers(it),'bof'); fgetl(eFile);
fseek(pFile,ppointers(it),'bof'); fgetl(pFile);

% load additional coordinate data (doubled nodes)
% you may also read newer doubled nodes (if it<nt) but those will not be used

rank = size(gcoords,2);
assert ( rank==2 );

xcoords = load(nfile);

if ( ~isempty(xcoords) )  
  nodes = [ gcoords ; xcoords(:,(1:rank)+1) ];
else
  nodes = gcoords;
end

% load additional coordinate data (related to phantom nodes)
% if necessary, overwrite (newer) doubled nodes

phNodes = fscanf(pFile, '%g %g %g' , [3,inf])';

if ( ~isempty(phNodes) )
  nodes(phNodes(:,1)+1,:) = phNodes(:,(1:rank)+1); % first +1 for c++ to matlab
end

u = zeros(size(nodes,1),5);

% load additional element data

np  = size(gconn,2);
npx = np+1;

str = 'xelems = fscanf(eFile, ''%g %g %g';
for ip = 1:np, str = [str ' %g']; end
str = [str ''',[np+3,inf])'';'];
eval(str);
% xelems = fscanf(eFile, '%g %g %g %g %g %g',[np+3,inf])';  % only for np=3

conn = [ xelems(:,3+(0:np)) + 1 ];   % +1 for c++ to matlab
izs  = [ xelems(:,2) + 1 ];

% load thickness and determine mid-plane z's

thick = load(tfile)';
zmids = [0;-thick(3)/2;thick(2)/2];

%% read and process time step data

% read displacements

% toc
% disp('Computing coordinates')

dispUnsrt = fscanf(dFile, '%g %g %g %g %g %g',[6,inf]);

u(dispUnsrt(1,:)+1,:) = scale*dispUnsrt(2:6,:)';

% store in arrays suitable for a single 'patch' command

xmid = reshape ( nodes(conn,1)+u(conn,1) , size(conn) );
ymid = reshape ( nodes(conn,2)+u(conn,2) , size(conn) );
zmid = zmids(izs)*ones(1,np+1) + reshape(u(conn,3) , size(conn) );
dz   = 0.5*thick(izs)*ones(1,np+1);
dx   = dz.*reshape(u(conn,4), size(conn));
dy   = dz.*reshape(u(conn,5), size(conn));

xbot = xmid - dx;
xtop = xmid + dx;
ybot = ymid - dy;
ytop = ymid + dy;
zbot = zmid - dz;
ztop = zmid + dz;

x = [xbot, xtop];
y = [ybot, ytop];
z = [zbot, ztop];


%% make plot

% toc
% disp('Making plot')

% subconnectivity of faces (for 3d)

vbot = 1:npx;
vtop = (npx+1):(2*npx);
for iface = 1:npx
  i1 = iface;
  i2 = mod(i1,npx)+1;
  vside(iface,:) = [ i1, i2, i2+npx, i1+npx ];
end

if lw
  vararg{1} = 'linewidth';
  vararg{2} = lw;
else
  vararg{1} = 'edgecolor';
  vararg{2} = 'none';
end

patch(x(:,vbot)',y(:,vbot)',z(:,vbot)',1,vararg{:})
patch(x(:,vtop)',y(:,vtop)',z(:,vtop)',1,vararg{:})

for iface = 1:npx
  v = vside(iface,:);
  patch(x(:,v)',y(:,v)',z(:,v)',1,vararg{:},'edgecolor','none')
end
if lw
  for icorner = 1:npx
%   for icorner = 1:2:npx-1
    v = vside(icorner,[1,4]);
    line(x(:,v)',y(:,v)',z(:,v)','color','k','linewidth',lw)
  end
end  


if ~isempty(XLIM)
  xlim(XLIM);
end

if ~isempty(YLIM)
  ylim(YLIM);
end

if ~isempty(ZLIM)
  zlim(ZLIM);
end

fclose('all');

% toc
% disp('Done')


