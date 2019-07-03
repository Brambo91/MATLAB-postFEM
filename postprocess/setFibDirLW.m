function setFibDirLW ( val )
% set line width for fiberDir (1.0 for print, 2.0 for display)

global fibDirLW;

if ( nargin < 1 )
  disp('fibDirLW set to default value');
  fibDirLW = '';
else
  fibDirLW = val;
end


