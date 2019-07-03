function readGmshSlow(filename)

% reads mesh data from gmsh file
% slow version: also works for multiple element types in one mesh
% argument: filename
% default: first file in this directory that matches *.msh

global gconn
global gcoords
global gnn
global gnel
global gmshphys
global lastMsh

if ( nargin < 1 )
  filename = findFile('msh');
end

D = dir(filename);

if ( ~isempty(lastMsh) && D.datenum == lastMsh && ~isempty(gconn) && ~isempty(gcoords) )
  return
else
  lastMsh = D.datenum;
end

fprintf('readGmshSlow is used\n')

mfile = fopen(filename);

% read leader 

              fgetl(mfile) ;   %   $MeshFormat
fmt = str2num(fgetl(mfile));   % three numbers
              fgetl(mfile) ;   %   $EndMeshFormat
              fgetl(mfile) ;   %   $Nodes
gnn = str2num(fgetl(mfile));   % number of nodes

iphysgroup = 4;  % at least in 2.2
if ( fmt(1) == 2.1 || fmt(1) == 2 )
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

% read lines in between

               fgetl(mfile) ;   %   \n
               fgetl(mfile) ;   %   $EndNodes
               fgetl(mfile) ;   %   $Elements
gnel = str2num(fgetl(mfile));   % number of elements

% read element connectivity 

gconn = [];

for i = 1:gnel

  line = fgetl(mfile);
  nums = str2num(line);
  nword = length(nums);

  while ( size(gconn,2) > nword )
    nums(end+1) = nums(end);
    nword = length(nums);
  end
  while ( size(gconn,1) > 0 && size(gconn,2) < nword )
    gconn(:,end+1) = gconn(:,end);
  end  
  
  gconn = [gconn;nums];

end

% store information for making element groups

gmshphys = gconn(:,iphysgroup);

% exclude information on element type, physical surface, etc
  
gconn = gconn ( : , iconn0:end ); 

if ( nword+1-iconn0 == 6 )
  % reorder for 6-node element

  v = [ 1 4 2 5 3 6 ];
  gconn(:,1:6) = gconn(:,v);
end

fclose('all');
