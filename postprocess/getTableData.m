function out = getTableData(filename,xit,comp)
% find data in table written by jemjive for a given time step
% arguments: filename, time step number and component name
% returns: nx2 matrix with [ nodeNumbers , nodalValues ]

if ( ~exist(filename,'file') )
  fname = findTableFor(comp);
  if ( isnumeric(fname) )
    error(sprintf('no file `%s'' found with table comp `%s''',...
           filename,comp));
  end
  filename = fname;
end

str = ['!grep -b ''column.*".*\<' comp '\>.*"'' ' filename ' > tpointers.dat '];
eval(str)
tmpf = dir('tpointers.dat');
if ( tmpf.bytes == 0 )
  error(sprintf('component `%s'' not found in file `%s''',comp,filename))
end
tmp = fopen('tpointers.dat');


for i = 1:xit
  line = fgetl(tmp);
end
if isnumeric(line)
  error('getTableData reached end of file, time step does not exist')
end
[i1,i2] = regexp(line,'\d*');
location = str2num(line(i1:i2));

!rm tpointers.dat

fh = fopen(filename);

fseek(fh,location,'bof');

header = strtrim(fgetl(fh));
[icomp,ncomp] = getColumn(header,comp);

% get data block

str = 'data = fscanf(fh,''%g';
for ip = 1:ncomp, str = [str ' %g']; end
str = [str ''',[ncomp+1,inf])'';'];
eval(str)

if icomp 
  % return data
  out = data(:,[1,icomp]);
else
  error(sprintf('no data found with string `%s''',comp));
end

