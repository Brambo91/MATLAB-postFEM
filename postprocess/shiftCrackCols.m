function shiftCrackCols ( val )
% shift color order of cracks

global crackColShift;

if ( nargin < 1 )
  disp('crackColShift set to default value [0]');
  crackColShift = '';
else
  crackColShift = val;
end


