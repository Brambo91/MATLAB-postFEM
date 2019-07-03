function setCrackLW ( val )
% set line widht for crackPlotFunction (1.0 for print, 2.0 for display)

global crackLW;

if ( nargin < 1 )
  disp('crackLW set to default value');
  crackLW = '';
else
  crackLW = val;
end


