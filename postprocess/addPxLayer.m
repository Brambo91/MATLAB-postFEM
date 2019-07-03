function addPxLayer(it,imodel,z0,thickness)
% plot deformed xfem-mesh in existing figure
% Args: time step, model indes, z0, thickness
% all arguments are required, but empty string for it is allowed
% Helper function for px.m and pxthick.m
% In case of a 3D mesh, thickness input is ignored
% otherwise, if thickness ~=0, 2D mesh is extruded

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

% pxOption: 
%  0____plot shear damage
%  1____plot fiber damage
% [2]___plot equivalent matrix stress
%  3____give each layer it's own color
%  4____give each layer it's own color and make cracked elems darker
%  5____plot u_z (only for 3d)
%  6____plot matrix damage
%  7____plot u_x
%  8____plot u_y
%  9____plot lagrange multiplier

%% initialize files

tic

fclose('all');

% find filenames

dfile = findFile('disp',imodel);

if pxOption == 1 || ( pxOption == 13 && imodel == 1 )
  try
    sfile = findFile('damage',imodel);
  catch
    error('damage file not found, try setPxOption(2)')
  end
elseif pxOption == 0 || ( pxOption == 13 && imodel == 2 )
  try
    sfile = findFile('shear',imodel);
  catch
    error('shear file not found, change option with setPxOption')
  end
elseif pxOption == 6
  try 
    sfile = findFile('mDamage',imodel);
  catch
    error('matrix damage file not found, change option with setPxOption')
  end
elseif pxOption == 9
  try 
    sfile = findFile('lagr',imodel);
  catch
    error('lagrange file not found, change option with setPxOption')
  end 
else
  % default (for backward compatibility)
  sfile = findFile('stress',imodel);
end

nfile = findFile('nodes',1);
efile = findFile('elems',imodel);

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

nt = length(dpointers);
if isempty(it) || strcmp(it,'nt')
  it = nt;
  disp(['nt = ', num2str(nt)])
elseif it > nt
  disp('time step doesnt exist')
  disp(['nt = ', num2str(nt)])
  return;
end

% open displacement and variable files and jump to correct position

dFile = fopen(dfile);

sFile = fopen(sfile);

% load coordinate date

nodes = load(nfile);
rank = size(nodes,2) - 1;
u = zeros(length(nodes),rank);

% jump to correct position

disp('Initialized files')
toc

%% get original number of elements 

% pretty dirty but fast way to get the number of elements form the msh-file 
% for pxOption 4 only

if pxOption == 4
  !grep -n Elements *msh > meshinfo.dat
  load meshinfo.dat
  if (length(meshinfo)==2)
    nel0    = meshinfo(2) - meshinfo(1) - 2;
    ielmax0 = imodel * nel0;
  end
  !rm meshinfo.dat
end

%% read and process data

% read displacements

fseek(dFile,dpointers(it),'bof'); fgetl(dFile);

if rank == 2
  dispUnsrt = fscanf(dFile, '%g %g %g'   ,[3,inf]);
else
  dispUnsrt = fscanf(dFile, '%g %g %g %g',[4,inf]);
end

u(dispUnsrt(1,:)+1,:) = dispUnsrt(2:rank+1,:)';

% read and plot elements and nodal values

elements = load(efile);

np = size(elements,2)-1;

fseek(sFile,hpointers(it),'bof'); fgetl(sFile);

str = 'stress = fscanf(sFile, ''%g';
for ip = 1:np, str = [str ' %g']; end
str = [str ''',[np+1,inf])'';'];
eval(str);

[bools,indices] = ismember(stress(:,1),elements(:,1));
elements = elements(indices,:);

iels = 1:size(elements,1);

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

conn = elements(iels,2:np+1)+1;
x = reshape ( nodes(conn,2)+scale*u(conn,1) , size(conn) );
y = reshape ( nodes(conn,3)+scale*u(conn,2) , size(conn) );

if any(pxOption == [0 1 2 6 9]) || ( pxOption == 13 && imodel == 1 )
  c = stress  ( iels,2:np+1 );
elseif pxOption == 13 && imodel == 2
  c = stress ( iels,2:np+1 ) + 1;
elseif pxOption == 3
  c = imodel;
%   colormap([0.2 0.6 1.0;1.0 0.45 0.45])
elseif pxOption == 4
  c = imodel + 0.5*(stress(:,1)>=ielmax0);
%   colormap([0.5 0.2 0.2;1.0 0.45 0.45;0.0 0.3 0.6;0.2 0.6 1.0])
%   caxis([0.5 2.5])
elseif pxOption == 5
  if rank == 3; 
    c = reshape ( u(conn,3) , size(conn) );
  else
    error('pxOption 5 only for 3d!'); 
  end  
elseif pxOption == 7
  c = reshape ( u(conn,1) , size(conn) );
elseif pxOption == 8
  c = reshape ( u(conn,2) , size(conn) );
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

if ( pxLW )
  set(gca,'defaultpatchlinewidth',pxLW);
else
  set(gca,'defaultpatchedgecolor','none');
end

if rank == 2 && ~thickness 
  
  % 2D PLOT OF 2D LAYER
  
  patch(x',y',z',c');
  
elseif rank == 2 && thickness
  
  % 3D PLOT OF 2D LAYER

  % horizontal planes
  patch(x',y',z',c');
  z = z + thickness;
  patch(x',y',z',c');

  % vertical planes
  z = [ z(:,1:2)-thickness z(:,3:4) ];
  for iplane = 1:np
    jplane = mod(iplane,np)+1;
    in = [ iplane jplane jplane iplane ];
    if ip == 6
      patch(x(:,in)',y(:,in)',z',c','edgecolor','none')
    else
      patch(x(:,in)',y(:,in)',z',c')
    end    
  end
  
elseif rank == 3
  
  % 3D PLOT OF 3D LAYER 

  patch(x(:,vbot)',y(:,vbot)',z(:,vbot)',c(:,vbot)');
  patch(x(:,vtop)',y(:,vtop)',z(:,vtop)',c(:,vtop)');
  for iface = 1:length(vside)
    v = vside(iface,:);
    patch(x(:,v)',y(:,v)',z(:,v)',c(:,v)');
  end   
  
else
  
  warn('addPxLayer doesn''t know what to do')
  
end

disp('Done')
toc


