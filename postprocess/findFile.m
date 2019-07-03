function filename = findFile( extension, imodel )

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

global fPath %Bram
if( isempty(fPath) ) %Bram
   fPath = './'; 
end %Bram

% loop over filenames with this extension
str = ['!ls ' fPath prestring '*.' extension '> tmp.findFile 2> /dev/null'];
eval(str) %Bram added fPath

fi = fopen('tmp.findFile');

nmodels = 0;

for i = 1:imodel
  filename = fgetl(fi);
  
  if ~ischar(filename)
    !rm tmp.findFile
    error(['invalid model number: ' num2str(imodel), ...
           ', nmodels = ' num2str(nmodels)])
  else
    nmodels = nmodels + 1;
  end
end

fclose(fi);
!rm tmp.findFile

return 
