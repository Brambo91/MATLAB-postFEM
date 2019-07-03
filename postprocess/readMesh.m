function readMesh(it)
% read mesh from file, storing coordinates and connectivity as global variables

global meshFile

if ~isempty(meshFile)
  if ( strcmp(meshFile(end-3:end),'.msh') )
    customReadGmsh(meshFile)
    return
  elseif ( strcmp(meshFile(end-4:end),'.mesh') )
    readMMesh(meshFile)
    return
  elseif ( strcmp(meshFile(end-4:end),'.lmsh') )
    readLMesh(meshFile)
    return
  else
    disp('global meshFile ignored: unknown extension')
  end
end

try
  readOldMesh
catch  
  try
    readLMesh
  catch
    % try
      customReadGmsh
    % catch ex
      % readMMesh
    % end
  end
end

if exist('xelems.dat','file') && nargin > 0
  readXMesh(it);
end


function customReadGmsh(filename)

global gmshSlow

if ( nargin < 1 )
  filename = findFile('msh',1);
end

if gmshSlow
  readGmshSlow(filename)
else
  readGmsh(filename)
end


