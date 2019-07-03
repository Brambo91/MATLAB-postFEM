function filename = findTableFor(tag)
% search in *.out files for tag 
% input: tag (must be a string)

assert(ischar(tag));

outlist = dir('*.out');
filename = -1;

for i = 1:length(outlist)
  fname = outlist(i).name;
  str = ['!grep ''column.*".*\<' tag '\>.*"'' ' fname ' > tmpfile '];
  eval(str)
  tmpf = dir('tmpfile');
  if ( tmpf.bytes > 0 ) 
    filename = fname;
  end
end

!rm tmpfile
