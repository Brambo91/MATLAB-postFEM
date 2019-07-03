function setPxLW ( val )
% set color for plotMesh (can be string or rgb vector)

global meshCol;

if ( nargin < 1 )
  disp('meshCol set to ''k''')
  val = 'k'
end

meshCol = val;


