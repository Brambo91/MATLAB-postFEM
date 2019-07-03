function readXMesh ( it )
% read additional mesh data from xelems.dat and xnodes.dat
% input: time step number it

global gconn
global gcoords

if nargin < 1
  error('readXMesh requires input time step number')
end

nodeCount = size(gconn,2);

v = 1:nodeCount;

if exist('xelems.dat','file')

  load xelems.dat
  nlines = size(xelems,1);
  if ( nlines>0 ) assert ( size(xelems,2) - size(gconn,2) == 2 ); end

  for i = 1:nlines
    if xelems(i,1) > it
      break
    end

    % overwrite or add this element
    % NB: increment elem and node numbers with one C++ -> matlab

    gconn(xelems(i,2)+1,v) = xelems(i,3:end)+1;
  end
end

if exist('xnodes.dat','file')

  load xnodes.dat
  nlines = size(xnodes,1);
  if ( nlines>0 ) assert ( size(xnodes,2) - size(gcoords,2) == 3 ); end
  
  for i = 1:nlines
    if xnodes(i,1) > it
      break
    end

    % overwrite or add node
    % NB: increment elem and node numbers with one C++ -> matlab

    gcoords(xnodes(i,2)+1,:) = xnodes(i,4:end);
  end
end



