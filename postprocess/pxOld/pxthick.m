function pxthick(it)

% postprocessing for jemjive with xfem. Arg: it.
% plot of deformed mesh with fancy crack vizualization for single time step

% making a 3D plot including ply thickness for a 2D computation

disp('PXthick: deformed 3D-mesh with fancy crack vizualization for single time step')
disp('Optional argument: time step')
% disp('Time step: Default is final time step')

scale = 10;
thickness = .2;

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
if nargin < 1 || strcmp(it,'nt')
  it = nt;
  disp(['nt = ', num2str(nt)])
elseif it > nt
  disp('time step doesnt exist')
  disp(['nt = ', num2str(nt)])
  return;
end

% open files

dFile = fopen(dfile);
sFile = fopen(sfile);

load(nfile)
if ~isempty(prepend)
  eval(['nodes = ' prepend ';'])
  eval(['clear ' prepend])
end

u = zeros(length(nodes),2);

% jump to correct position

fseek(dFile,dpointers(it),'bof'); fgetl(dFile);
fseek(sFile,hpointers(it),'bof'); fgetl(sFile);

disp('Initialized files')
toc

%% initialize plot

figure(1)
clf

% caxis([0 1])

xlim([-20 22]); ylim([-11 11])

% set(gcf,'Paperposition',[0 0 9 4])
% set(gca,'Position',[0.05 0.05 0.8 0.9]);
set(gca,'position',[0 0 1 1]);
set(gca,'dataaspectratio',[1 1 1])
set(gca,'projection','perspective')

view([20 40])

axis off

% % transparant for poster
% set(gca,'color','none')
% set(gcf,'color','none')
% set(gcf,'inverthardcopy','off')

disp('Initialized plot')
toc

%% read and process data

% find node numbers which indicate the start of a new layer
% (depends on how the mesh is generated!)

node0s = find( nodes(:,2)==nodes(1,2) & nodes(:,3)==nodes(1,3)) - 2;
nz = length(node0s);

% read displacements

dispUnsrt = fscanf(dFile, '%g %g %g',[3,inf]);
if isempty(dispUnsrt)
  disp(['wrong time step number, try pxthick(' num2str(it-1) ')'])
  return
end
u(dispUnsrt(1,:)+1,:) = dispUnsrt(2:3,:)';

% read and plot elements and nodal values

load(efile)
if ~isempty(prepend)
  eval(['elements = ' prepend ';'])
  eval(['clear ' prepend])
end

nels = length(elements);
np = size(elements,2)-2;
for i=1:nels
  imin = min( elements( i , 2:np+2 ) );
  elements(i,np+3) = sum( imin > node0s );      % store layer index
end

str = 'stress = fscanf(sFile, ''%g %g';
for ip = 1:np, str = [str ' %g']; end
str = [str ''',[np+2,inf])'';'];
eval(str);

% find indices of elements for which output was written in this time step

[bools,indices] = ismember(stress(:,1),elements(:,1));
elements = elements(indices,:);

% iels = 1:length(elements);

conn = elements(:,2:np+2)+1;
x = reshape ( nodes(conn,2)+scale*u(conn,1) , size(conn) );
y = reshape ( nodes(conn,3)+scale*u(conn,2) , size(conn) );
z = -elements(:,np+3) * thickness *  ones(1,np+1) ;

disp('Read and ordered data')
toc

%% make plot

c = -elements(:,np+3);
colormap([0.2 0.6 1.0;1.0 0.45 0.45])

% c = -sign(stress(:,1));
% bonemap(200)

% c = elements(:,np+3) + 0.25*sign(stress(:,1));
% colormap([0.5 0.2 0.2;1.0 0.45 0.45;0.0 0.3 0.6;0.2 0.6 1.0])
% caxis([0.5 2.5])

% horizontal planes
patch(x',y',z',c','linewidth',.1);
z = z + thickness;
patch(x',y',z',c','linewidth',.1);

% vertical planes
z = [ z(:,1:2)-thickness z(:,3:4) ];
for iplane = 1:np+1
  jplane = mod(iplane,np+1)+1;
  in = [ iplane jplane jplane iplane ];
  if ip == 6
    patch(x(:,in)',y(:,in)',z',c','edgecolor','none')
  else
    patch(x(:,in)',y(:,in)',z',c','linewidth',.1)
  end    
end

% if ip == 6
%   for iplane = 1:2:5
%     jplane = mod(iplane+2,np);
%     in = [ iplane jplane jplane iplane ];
%     patch(x(:,in)',y(:,in)',z',c','linewidth',.1,'facecolor','none')
%   end
% end

disp('Done')
toc
      