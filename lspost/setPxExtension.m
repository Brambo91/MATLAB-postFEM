function setPxExtension ( str )
% set option for addPxLayer

global pxExtension;

if ( nargin < 1 )
  str = 'stress';
end

if ~ischar(str)
  error('extension should be a string') 
end


pxExtension = str;

setPxOption(0);

disp(['pxExtension set to ' str])
disp(['pxOption set to 0'])


