function setMeshFile ( name )
% set gmsh file name to be used for postprocessing
% input: filename (or file index, numbering as in meshFileQuery

global meshFile;

if ( nargin < 1 )
  meshFileQuery
elseif ischar(name);
  meshFile = name;
else
  index = name;
  assert(isnumeric(index))

  gmsh = dir('*.msh');
  mesh = dir('*.mesh');
  lmsh = dir('*.lmsh');

  all = [gmsh;mesh;lmsh];
  nfiles = length(all);

  if ( index<1 || index>nfiles )
    disp('setMeshFile with invalid index, now calling meshFileQuery')
    meshFileQuery
  else
    setMeshFile(all(index).name);
  end
end

