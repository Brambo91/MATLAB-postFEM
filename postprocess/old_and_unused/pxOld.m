function px(it,ilayers)

% postprocessing for jemjive with xfem. Args: it, ilayers
% plot of deformed mesh with fancy crack vizualization for single time step

disp('PX: deformed mesh with fancy crack vizualization for single time step')
disp('Optional arguments: time step, layer indices')
% disp('Time step: Default is final time step')

scale = 5;
thickness = 10;

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

u = zeros(length(nodes),2);

% jump to correct position

fseek(dFile,dpointers(it),'bof'); fgetl(dFile);
fseek(sFile,hpointers(it),'bof'); fgetl(sFile);

disp('Initialized files')
toc

%% initialize plot

clf

caxis([0 1])
% xlim([-8 12])
% ylim([-15 15])

contrastmap(2,150)

colb = colorbar('Position',[0.90 0.25 0.02 0.5]);
set(colb,'fontsize',8)
cbtitle = get(colb,'title');
set(cbtitle,'fontsize',8)
set(cbtitle,'string','f');

set(gca,'dataaspectratio',[1 1 1])
set(gcf,'Paperposition',[0 0 3 2])
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
nz = length(node0s);

% read displacements

el = fscanf(dFile, '%g %g %g',[3,inf]);
u(el(1,:)+1,:) = el(2:3,:)';

% read and plot elements and nodal values

load(efile)
if ~isempty(prepend)
  eval(['elements = ' prepend ';'])
  eval(['clear ' prepend])
end

nels = length(elements);
for i=1:nels
  elements(i,7) = sum(elements(i,2:6)~=-1);  % store number of nodes
  imin = min( elements( i , 1+(1:elements(i,7)) ) );
  elements(i,8) = sum( imin > node0s );      % store layer index
end


iel = 0;
while 1
%   eLine = fgetl(eFile);
  hLine = fgetl(sFile);
  if ~ischar(hLine) || hLine(1) == 'n',   break,   end
  c = str2num(hLine);    %#ok<ST2NM>
  iel = find( elements(:,1)==c(1),1,'last' );    % 1,'last' for when el 0 is cracked...
  if nargin < 2 || any( ilayers == elements(iel,8) )
    z0 = elements( iel, 8 ) * thickness ;
    el = elements( iel , 1 : elements(iel,7)+1 );
    if length(c)>1
      if length(c) ~= length(el)
        disp(['WARNING, skipping element ' num2str(iel)])
        continue
      end
      c = c(2:length(el));
      elnodes = el(2:length(el))+1;
      elxs = nodes(elnodes,2)+scale*u(elnodes,1);
      elys = nodes(elnodes,3)+scale*u(elnodes,2);
%       c = u(elnodes,1)';
      if length(c)==3
        elxs = [elxs;elxs(1)];
        elys = [elys;elys(1)];
        c = [c,c(1)];
      end
      z = z0 * ones(1,length(elxs));
      patch(elxs,elys,z,c,'Linewidth',.1);
    end
  end
end

disp('Done')
toc
