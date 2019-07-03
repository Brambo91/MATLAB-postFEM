function h = doPostLS(icomp,ncomp,filename,header,it)
% postprocessing for level set related fields
% reads base mesh from gmsh file
% and values on the nodes where they are defined from specified file
% this one is supposed to be called indirectly by other functions
% plotting only values in the band where it is defined
% required: icomp, ncomp, filename, header
% optional: it

global gconn
global gcoords
global gnn
global gnel

global XLIM
global YLIM
global pxLW

global postLsWrite
global bandOnly

% plot background mesh

clf;
if ( bandOnly )
  plotMesh
else
  readMesh(it)
end

% open data file

lfile = fopen(filename);

% jump to right position 
% (use 'grep -b' to get byte offset and 'sed' to remove everything else)

str = [' ! grep -b ' header ' ' filename ...
       ' | sed ''s/\([0-9]*\):.*/\1/'' ' ...
       ' > ipointers.dat'];

eval(str)
load ipointers.dat
!rm ipointers.dat
nt = size(ipointers,1);

if nargin < 5 || isempty(it) || strcmp(it,'nt')
  it = nt;
elseif it > nt
  disp('time step doesnt exist')
  disp(['nt = ', num2str(nt)])
  return;
end
fseek(lfile,ipointers(it),'bof'); fgetl(lfile);

% format figure

set(gca,'dataaspectratio',[1 1 1])
axis off

if ~isempty(XLIM)
  xlim(XLIM);
end

if ~isempty(YLIM)
  ylim(YLIM);
end

if isempty(pxLW)
  lw = .1;
else
  lw = pxLW;
end

% read data and make nodal vector

fprintf('DOPOSTLS, plotting time step %i, component %i of %i from file %s\n',...
  it,icomp,ncomp,filename)

data = fscanf(lfile, '%g',[ncomp+1,inf])';

% with icomp = ncomp + 1 the norm is plotted

ncol = ncomp+1;
if (icomp == ncol)
  data(:,ncol+1) = sqrt ( sum ( data(:,2:ncol).^2 , 2 ) );
end

compdata = zeros(gnn,1);
compdata(data(:,1)+1) = data(:,icomp+1);

tmp = makePatch ( gcoords, compdata, gconn );

if nargout > 0
  h = tmp;
end

