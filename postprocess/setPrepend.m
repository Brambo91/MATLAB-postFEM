function setPrepend(str)

% set global variable prepend. Arg: str

global prepend

if nargin>0 && ischar(str) && length(str)>0
  prepend = str;
  disp(['Global variable prepend set to ''' str '''.'])
else
  clear global prepend
  disp(['Global variable prepend has been cleared.'])
end


