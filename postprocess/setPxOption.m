function setPxOption ( val )
% set option for addPxLayer

global pxOption;

if ( nargin < 1 )
  disp('pxOption set to 1');
  val = 1.;
end

if ischar(val)
  pxOption = val;
else
  pxOption = round(val);
end



