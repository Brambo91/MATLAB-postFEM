function pxthick(it)

% postprocessing for jemjive with xfem. Arg: it.
% plot of deformed mesh with fancy crack vizualization for single time step

% making a 3D plot including ply thickness for a 2D computation

disp('PXthick: deformed 3D-mesh with fancy crack vizualization for single time step')
disp('Optional argument: time step')
% disp('Time step: Default is final time step')

scale = 5;
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

% find pointers to beginning of time step in files

eval(['!grep -b new ' dfile ' > dpointers.dat'])
eval(['!grep -b new ' sfile ' > hpointers.dat'])

load dpointers.dat
load hpointers.dat

!rm *pointers.dat

% find number of time steps
nt = min( [ length(dpointers), length(hpointers) ] );
if nargin < 1
  it = nt-1
elseif it > nt
  disp('time step doesnt exist')
  disp(['nt = ', num2str(nt)])
  return;
end

% open files

dFile = fopen(dfile);
hFile = fopen(sfile);
load(nfile)
if ~isempty(prepend)
  eval(['nodes = ' prepend ';'])
  eval(['clear ' prepend])
end

u = zeros(length(nodes),2);

% jump to correct position

fseek(dFile,dpointers(it),'bof'); fgetl(dFile);
fseek(hFile,hpointers(it),'bof'); fgetl(hFile);

disp('Initialized files')
toc

%% initialize plot

figure(1)
clf

% caxis([0 1])

% xlim([-20 22]); ylim([-11 11])
xlim([-10 10]);

pastelmap(2)

% colb = colorbar('Position',[0.87 0.3 0.02 0.4]);
% set(colb,'fontsize',8)
% cbtitle = get(colb,'title');
% set(cbtitle,'fontsize',8)
% set(cbtitle,'string','u_x');

set(gca,'dataaspectratio',[1 1 1])
set(gcf,'Paperposition',[0 0 9 4])
set(gca,'Position',[0.05 0.05 0.8 0.9]);

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

el = fscanf(dFile, '%g %g %g',[3,inf]);
u(el(1,:)+1,:) = el(2:3,:)';

% read elements and find 

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

% read and plot and nodal values

while 1
%   eLine = fgetl(eFile);
  hLine = fgetl(hFile);
  if hLine(1) == 'n',   break,   end
  c = str2num(hLine);    %#ok<ST2NM>
  iel = find( elements(:,1)==c(1),1,'last' );    % 1,'last' for when el 0 is cracked...
  z0 = -elements( iel, 8 ) * thickness ;

  el = elements( iel , 1 : elements(iel,7)+1 );
  if length(c)>1
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

    % horizontal planes
    z = z0 * ones(1,length(elxs)) ;
    c = z;
    patch(elxs,elys,z,c,'Linewidth',.1);
    z = z + thickness;
    patch(elxs,elys,z,c,'Linewidth',.1);    
    
    % vertical planes
    z = ones(1,4)*z(1);
    z(1:2) = z(1:2) - thickness;
    nnel = length(c);
    for iplane = 1:nnel
      jplane = mod(iplane,nnel)+1;
      in = [ iplane jplane jplane iplane ];
      patch(elxs(in),elys(in),z,c(in),'linewidth',.1)
    end
      
    
  end
end

% recolb(colb)

disp('Done')
toc
