function filename = findFileQuiet( extension, imodel )

% find imodel^th file with given extension 

% disp(['entering findFile: ' extension])

% default values

if nargin < 2
  imodel = 1;
  if nargin < 1
    disp('findFile.m needs extension (string) as argument')
    filename = [];
    return;
  end
end

global prepend
if ~isempty(prepend)
  prestring = [prepend '.'];
else
  prestring = [];
end

% loop over filenames with this extension
eval(['!ls ' prestring '*.' extension '> tmp.findFile 2> /dev/null'])

fi = fopen('tmp.findFile');

for i = 1:imodel
  filename = fgetl(fi);
end

fclose(fi);
!rm tmp.findFile

return 
