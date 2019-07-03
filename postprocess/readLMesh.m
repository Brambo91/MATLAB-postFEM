function readLMesh(filename)

% reads mesh data from mesh file written by LaminateMeshModule
% argument: filename
% default: first file in this directory that matches *.msh

global gconn
global gcoords
global gnn
global gnel

if ( nargin < 1 )
  filename = findFile('lmsh');
end

mfile = fopen(filename);

% read nodes

line = '';
while ( ~strcmpi(line,'Nodes') )
  line = fgetl(mfile) ;   % Nodes
  if ( line == -1 )
    error('node tag not found')
  end
end
ninfo = str2num(fgetl(mfile));   % two numbers

gnn = ninfo(1);
dim = ninfo(2);

str = '%i';
for i =1:dim; str = [ str ' %g' ]; end
str = [ str ';'];
coords = fscanf(mfile,str,[dim+1,gnn]);
gcoords = coords(2:end,:)';

% read elements

while ( ~strcmpi(line,'Elements') )
  line = fgetl(mfile) ;   % Nodes
  if ( line == -1 )
    error('element tag not found')
  end
end
einfo = str2num(fgetl(mfile));   % two numbers
gnel = einfo(1);
nodeCount = einfo(2);

str = '%i';
for i =1:nodeCount; str = [ str ' %i' ]; end
str = [ str ';'];
conn = fscanf(mfile,str,[nodeCount+1,gnel]);

gconn = conn ( 2:end , : )';

fclose('all');
