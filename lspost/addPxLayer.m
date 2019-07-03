function addPxLayer(it,ilayer,z0,thickness)

% Helper function for px.m and pxthick.m
% plot deformed xfem-mesh in existing figure
% Args: time step, z0, thickness
% In case of a 3D mesh, thickness input is ignored
% otherwise, if thickness ~=0, 2D mesh is extruded

% pxOption: 
%  0____plot data from file (with global pxExtension)
%  1____plot u_x
%  2____plot u_y
%  3____plot u_z
%  4____give each layer it's own color

%% get global variables or default values

global pxScale

if ( isempty(pxScale) )
  scale = 1;
else
  scale = pxScale;
end

global pxLW

if ( isempty(pxLW) )
  pxLW = .1;
end

global pxOption

if ( isempty(pxOption) )
  pxOption = 1;
end

global pxExtension;


%% initialize files

tic

fclose('all');

% read original mesh from gmsh file

global gcoords
global gconn

readMesh(it)

% find filenames

dfile = findFile('disp',1);
nfile = findFile('dbNodes',1);
pfile = findFile('phNodes',1);
efile = findFile('elems',1);

if ~exist(nfile,'file')
  disp([nfile ' has not been found. Is your path correct?'])
  return
end

if pxOption == 0 
  if isempty(pxExtension)
    error('Global pxExtension is required for pxOption 0!')
  end
  try
    cfile = findFile(pxExtension,1);
  catch
    error('file not found, try setPxOption(2) or change global pxExtension')
  end
end

% find pointers to beginning of time step in files

                      eval(['!grep -b new ' dfile ' > dpointers.dat'])
                      eval(['!grep -b new ' efile ' > epointers.dat'])
                      eval(['!grep -b new ' pfile ' > ppointers.dat'])
if ( pxOption == 0 ); eval(['!grep -b new ' cfile ' > cpointers.dat']); end

                      load dpointers.dat
                      load epointers.dat
                      load ppointers.dat
if ( pxOption == 0 ); load cpointers.dat; end

!rm *pointers.dat

% find number of time steps

nt = length(dpointers);
if isempty(it) || strcmp(it,'nt')
  it = nt;
  disp(['nt = ', num2str(nt)])
elseif it > nt
  disp('time step doesnt exist')
  disp(['nt = ', num2str(nt)])
  return;
end

% report some stuff

if pxOption == 0 
  disp(['addPxLayer it = ' num2str(it) ', reading from file ' cfile])
else
  disp(['addPxLayer it = ' num2str(it) ', pxOption ' num2str(pxOption)])
end

% open displacement and variable files and jump to correct position

                      dFile = fopen(dfile);
                      eFile = fopen(efile);
                      pFile = fopen(pfile);
if ( pxOption == 0 ); cFile = fopen(cfile); end

                      fseek(dFile,dpointers(it),'bof'); fgetl(dFile);
                      fseek(eFile,epointers(it),'bof'); fgetl(eFile);
                      fseek(pFile,ppointers(it),'bof'); fgetl(pFile);
if ( pxOption == 0 ); fseek(cFile,cpointers(it),'bof'); fgetl(cFile); end

% load additional coordinate data (doubled nodes)

rank = size(gcoords,2);

xcoords = load(nfile);

if ( ~isempty(xcoords) )  
  nodes = [ gcoords ; xcoords(:,(1:rank)+1) ];
else
  nodes = gcoords;
end

u = zeros(size(nodes));

% load additional coordinate data (related to phantom nodes)
% if necessary, overwrite (newer) doubled nodes

phNodes = fscanf(pFile, '%g %g %g' , [3,inf])';

if ( ~isempty(phNodes) )
  nodes(phNodes(:,1)+1,:) = phNodes(:,(1:rank)+1); % first +1 for c++ to matlab
end

u = zeros(size(nodes));

% load additional element data

np = size(gconn,2);

str = 'xelems = fscanf(eFile, ''%g %g %g';
for ip = 1:np, str = [str ' %g']; end
str = [str ''',[np+3,inf])'';'];
eval(str)
% xelems = fscanf(eFile, '%g %g %g %g %g %g',[np+3,inf])';  % only for np=3

% if ( np == 3 )
%   v = [ 1 2 3 1];
% elseif ( np == 6 )
%   v = [ 1 2 3 4 5 6 ];
% else
%   error('addPxLayer currently only works for 3-node triangles')
% end

% elements = [ gconn(:,v) ; xelems(:,3:6)+1 ];   % +1 for c++ to matlab
% ilayers  = [ zeros(size(gconn(:,1)))  ; xelems(:,2) ];
elements = [ xelems(:,3+(0:np)) + 1 ];   % +1 for c++ to matlab
ilayers  = [ xelems(:,2) ];

% take only elements from specified layer 

conn = elements(ilayers==ilayer,:);

%% read and process time step data

% read displacements

if rank == 2
  dispUnsrt = fscanf(dFile, '%g %g %g'   ,[3,inf]);
else
  dispUnsrt = fscanf(dFile, '%g %g %g %g',[4,inf]);
end

u(dispUnsrt(1,:)+1,:) = dispUnsrt(2:rank+1,:)';

if ( pxOption == 0 )
  if np == 3 
    ncol = 1;
  else
    ncol = np+1;
  end
  str = 'stress = fscanf(cFile, ''%g';
  for ip = 1:ncol, str = [str ' %g']; end
  str = [str ''',[ncol+1,inf])'';'];
  eval(str);
end

iels = find(ilayers==ilayer);

if rank == 3

  % subconnectivity of faces (for 3d)

  np2 = np/2;
  vbot = 1:np2;
  vtop = np2+1:np;
  for iface = 1:np2;
    n1 = mod(iface,np2)+1;
    vside(iface,:) = [ iface , n1 , n1+np2 , iface+np2  ];
  end
  
end

% make plot

x = reshape ( nodes(conn,1)+scale*u(conn,1) , size(conn) );
y = reshape ( nodes(conn,2)+scale*u(conn,2) , size(conn) );

if pxOption == 0
  c = stress  ( iels, 2:(ncol+1) );
elseif ( any ( pxOption == 1:rank ) )
  c = reshape ( u(conn,pxOption) , size(conn) );
elseif pxOption == 4
  c = ilayer;
else
  error(['unknown pxOption ' num2str(pxOption)])
end
  
if rank == 2
  z = ones( size(conn) ) * z0;
else
  z = reshape ( nodes(conn,4)+scale*u(conn,3) , size(conn) );
  
  if ( length(c) == 1)
    c = c * ones ( size(conn) );
  end
    
end

if rank == 2 && ~thickness 
  
  % 2D PLOT OF 2D LAYER
  
  if ( pxLW )
    patch(x',y',z',c','linewidth',pxLW);
  else
    patch(x',y',z',c','edgecolor','none');
  end
    
  
elseif rank == 2 && thickness
  
  % 3D PLOT OF 2D LAYER

  % horizontal planes
  if ( pxLW )
    patch(x',y',z',c','linewidth',pxLW);
    z = z + thickness;
    patch(x',y',z',c','linewidth',pxLW);
  else
    patch(x',y',z',c','edgecolor','none');
    z = z + thickness;
    patch(x',y',z',c','edgecolor','none');
  end

  % vertical planes
  z = [ z(:,1:2)-thickness z(:,3:4) ];
  nplane = size(x,2);
  for iplane = 1:nplane
    jplane = mod(iplane,nplane)+1;
    in = [ iplane jplane jplane iplane ];
    if np == 6
      patch(x(:,in)',y(:,in)',z',c(:,in)','edgecolor','none')
    else
      if ( pxLW )
        patch(x(:,in)',y(:,in)',z',c(:,in)','linewidth',pxLW)
      else
        patch(x(:,in)',y(:,in)',z',c(:,in)','edgecolor','none')
      end
    end    
  end

%   patch(x(:,:)',y(:,:)',z(:,:)',c(:,:)','linewidth',.1);
  
elseif rank == 3
  
  % 3D PLOT OF 3D LAYER 

  patch(x(:,vbot)',y(:,vbot)',z(:,vbot)',c(:,vbot)','linewidth',pxLW);
  patch(x(:,vtop)',y(:,vtop)',z(:,vtop)',c(:,vtop)','linewidth',pxLW);
  for iface = 1:length(vside)
    v = vside(iface,:);
    patch(x(:,v)',y(:,v)',z(:,v)',c(:,v)','linewidth',pxLW);
  end   
  
else
  
  warn('addPxLayer doesn''t know what to do')
  
end

% disp('Done')
% toc


