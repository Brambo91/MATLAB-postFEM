function pspr(it,comp,imodel)

% postprocessing for jemjive with SpringModel. Args: it, component, imodel

disp('pspr: visualization for spring model for single time step')
disp('Optional arguments: time step, model index')

%% default values

if nargin < 3
  imodel = 1;
end

if nargin < 2
  comp = 3;
elseif comp > 4 || comp < 1
  error('invalid component, must be in [1,4]');
end

if nargin < 1
  it = '';
end

%% initialize plot

clf

setLims

colb = colorbar('Position',[0.92 0.25 0.02 0.5]);
set(colb,'fontsize',8)

if comp == 3
  caxis([0 1])
  contrastmap
elseif comp ==4
  caxis([0 1])
  colormap([1 1 1;.8 .1 .1])
  colorbar off
end
  

set(gca,'dataaspectratio',[1 1 1])
set(gcf,'Paperposition',[0 0 6 3])
set(gca,'Position',[0.1 0.05 0.8 0.9]);

view([0 90])

axis off

%% initialize files

tic

fclose('all');

% find filenames

sfile = findFile('springs',imodel);

nfile = findFile('nodes',1);
efile = findFile('elems',imodel);

if ~exist(nfile,'file')
  error([nfile ' has not been found. Is your path correct?'])
end

% find pointers to beginning of time step in files

eval(['!grep -b new ' sfile ' > spointers.dat'])

load spointers.dat

!rm *pointers.dat

% find number of time steps

nt = length(spointers);
if isempty(it) || strcmp(it,'nt')
  it = nt;
  disp(['nt = ', num2str(nt)])
elseif it > nt
  error(['time step doesnt exist, nt = ', num2str(nt)])
end

% open displacement and variable files and jump to correct position

sFile = fopen(sfile);

% load coordinate date

nodes = load(nfile);
nn    = size(nodes,1);

% jump to correct position

disp('Initialized files')
toc

%% read and process data

% read elements 

elements = load(efile);

nel = size(elements,1);
np  = size(elements,2)-1;

% read nodal values

nodevals = zeros ( 1, nn );

fseek(sFile,spointers(it),'bof');

       fscanf(sFile,'%s',1);
it   = fscanf(sFile,'%i',1);
nspr = fscanf(sFile,'%i',1);

vals = fscanf(sFile,'%g %g %g %g %g',[5,inf])';

nodevals ( vals(:,1)+1 ) = vals(:,comp+1);

% make plot

conn = elements(:,2:np+1)+1;
x = reshape ( nodes(conn,2) , size(conn) );
y = reshape ( nodes(conn,3) , size(conn) );
c = nodevals(conn);
  
patch(x',y',c','linewidth',.1);
  
disp('Done')
toc

