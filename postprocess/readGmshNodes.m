function readGmshNodes(filename)

% reads nodal coordinates from gmsh file
% argument: filename
% default: first file in this directory that matches *.msh

global gcoords
global gnn

if ( nargin < 1 )
  filename = findFile('msh');
end

mfile = fopen(filename);

% read leader 

              fgetl(mfile) ;   %   $MeshFormat
fmt = str2num(fgetl(mfile));   % three numbers
              fgetl(mfile) ;   %   $EndMeshFormat
              fgetl(mfile) ;   %   $Nodes
gnn = str2num(fgetl(mfile));   % number of nodes

if ( fmt(1) == 2.1 )
  iconn0 = 7;
elseif ( fmt(1) == 2.2 )
  iconn0 = 6;
else
  warning(['unknown mesh format ' num2str(fmt(1))])
  iconn0 = 6;
end
% read nodal coordinates

gcoords = fscanf(mfile,'%g %g %g %g',[4,gnn]);;
gcoords = gcoords(2:3,:)';
assert(size(gcoords,1)==gnn);

fclose(mfile);
