function setMeshLW(val)

global meshLW

if ( nargin < 1 || isempty(val) )
  meshLW = 0.1
else
  meshLW = val;
end

