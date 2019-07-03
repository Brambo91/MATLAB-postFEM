function px(it,ilayers)

% postprocessing for jemjive with xfem. Args: it, ilayers
% plot of deformed mesh with fancy crack vizualization for single time step

disp('PX: deformed mesh with fancy crack vizualization for single time step')
disp('Optional arguments: time step, layer indices')
% disp('Time step: Default is final time step')

scale = 10;
thickness = .4;

%% initialize files

tic

fclose('all');

% make filenames with global variable 'prepend'

global prepend
if ~isempty(prepend)
  prestring = [prepend '.'];
else
  prestring = [];
end
dfile = [prestring 'displacements.dat'];
sfile = [prestring 'stress.dat'];
nfile = [prestring 'nodes.dat'];
efile = [prestring 'elements.dat'];

matSFile = [sfile(1:length(sfile)-4) '.mat'];
matDFile = [dfile(1:length(sfile)-4) '.mat'];

if ~exist(nfile,'file')
  disp([nfile ' has not been found. Is your path correct?'])
  return
end

% find pointers to beginning of time step in files

eval(['!grep -b new ' dfile ' > dpointers.dat'])
eval(['!grep -b new ' sfile ' > hpointers.dat'])

load dpointers.dat
load hpointers.dat

!rm *pointers.dat

% find number of time steps

nt = min( [ length(dpointers), length(hpointers) ] );
if nargin < 1 || isempty(it) || strcmp(it,'nt')
  it = nt;
  disp(['nt = ', num2str(nt)])
elseif it > nt
  disp('time step doesnt exist')
  disp(['nt = ', num2str(nt)])
  return;
end

% when no layers input: do layer 1

if nargin < 2
  ilayers = 1;
end

% open files

dFile = fopen(dfile);
sFile = fopen(sfile);

load(nfile)
if ~isempty(prepend)
  eval(['nodes = ' prepend ';'])
  eval(['clear ' prepend])
end

rank = size(nodes,2) - 1;

u = zeros(length(nodes),rank);

% jump to correct position

fseek(dFile,dpointers(it),'bof'); fgetl(dFile);
fseek(sFile,hpointers(it),'bof'); fgetl(sFile);

disp('Initialized files')
toc

%% initialize plot

clf

caxis([0 1])
% xlim([40 81])
% ylim([-30 10])
% ylim([-15 15])

contrastmap%(2,150)

colb = colorbar('Position',[0.92 0.25 0.02 0.5]);
set(colb,'fontsize',8)
cbtitle = get(colb,'title');
set(cbtitle,'fontsize',8)
set(cbtitle,'string','f');

set(gca,'dataaspectratio',[1 1 1])
set(gcf,'Paperposition',[0 0 6 3])
set(gca,'Position',[0.1 0.05 0.8 0.9]);

% view([20 40])
view([0 90])

axis off

disp('Initialized plot')
toc

%% read and process data

% find node numbers which indicate the start of a new layer
% (depends on how the mesh is generated!)

node0s = find( nodes(:,2)==nodes(1,2) & nodes(:,3)==nodes(1,3)) - 2;
if rank == 3
  node0s = node0s(1:2:length(node0s));
end
nz = length(node0s);
if isempty ( ilayers )
  ilayers = 1:nz;
end

% read displacements

if rank == 2
  dispUnsrt = fscanf(dFile, '%g %g %g'   ,[3,inf]);
else
  dispUnsrt = fscanf(dFile, '%g %g %g %g',[4,inf]);
end

u(dispUnsrt(1,:)+1,:) = dispUnsrt(2:rank+1,:)';

% read and plot elements and nodal values

load(efile)
if ~isempty(prepend)
  eval(['elements = ' prepend ';'])
  eval(['clear ' prepend])
end

nels = size(elements,1);
np = size(elements,2)-1;
for i=1:nels
  imin = min( elements( i , 2:np+1 ) );
  elements(i,np+2) = sum( imin > node0s );      % store layer index
end

str = 'stress = fscanf(sFile, ''%g';
for ip = 1:np, str = [str ' %g']; end
str = [str ''',[np+1,inf])'';'];
eval(str);

[bools,indices] = ismember(stress(:,1),elements(:,1));
elements = elements(indices,:);

if strcmp(ilayers,'all')
  iels = 1:length(elements);
else
  iels = find(elements(:,np+2)==ilayers(1));
  for iply = 2:length(ilayers)
    iels = [ iels ; find(elements(:,np+2)==ilayers(iply)) ];
  end
end

% subconnectivity of faces (for 3d)

np2 = np/2;
vbot = 1:np2;
vtop = np2+1:np;
for iface = 1:np2;
  n1 = mod(iface,np2)+1;
  vside(iface,:) = [ iface , n1 , n1+np2 , iface+np2  ];
end

% make plot

conn = elements(iels,2:np+1)+1;
x = reshape ( nodes(conn,2)+scale*u(conn,1) , size(conn) );
y = reshape ( nodes(conn,3)+scale*u(conn,2) , size(conn) );
c = stress ( iels,2:np+1 );
if rank == 2
  z = elements(iels,np+2)*thickness * ones(1,np);
else
  z = reshape ( nodes(conn,4)+10*scale*u(conn,3) , size(conn) );
  disp('WARNING: extra scaled z deformation');
  c = reshape (                     u(conn,3) , size(conn) );
end

if rank == 2
  patch(x(:,:)',y(:,:)',z(:,:)',c(:,:)','linewidth',.1);
else
%   patch(x(:,vbot)',y(:,vbot)',z(:,vbot)',stress(iels,vbot+1)','linewidth',.1);
%   patch(x(:,vtop)',y(:,vtop)',z(:,vtop)',stress(iels,vtop+1)','linewidth',.1);
%   for iface = 1:length(vside)
%     patch(x(:,vside(iface,:))',y(:,vside(iface,:))',z(:,vside(iface,:))',stress(iels,vside(iface,:)+1)','linewidth',.1);
%   end   
  patch(x(:,vbot)',y(:,vbot)',z(:,vbot)',c(:,vbot)','linewidth',.1);
  patch(x(:,vtop)',y(:,vtop)',z(:,vtop)',c(:,vtop)','linewidth',.1);
  for iface = 1:length(vside)
    v = vside(iface,:);
    patch(x(:,v)',y(:,v)',z(:,v)',c(:,v)','linewidth',.1);
  end   
end

disp('Done')
toc
