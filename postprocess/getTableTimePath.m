function out = getTableTimePath(filename,inode,comp)
% find data in table written by jemjive for a given node
% arguments: filename, node number and component name
% returns: vector with nodalValues for all time steps

if ( ~exist(filename,'file') )
  fname = findTableFor(comp);
  if ( isnumeric(fname) )
    error(sprintf('no file `%s'' found with table comp `%s''',...
           filename,comp));
  end
  filename = fname;
end

% find location of time step data headers

str = ['!grep -b ''column.*".*\<' comp '\>.*"'' ' filename ' > tpointers.dat '];
eval(str)
tmpf = dir('tpointers.dat');
if ( tmpf.bytes == 0 )
  error(sprintf('component `%s'' not found in file `%s''',comp,filename))
end
tmp = fopen('tpointers.dat');


line = fgetl(tmp);
locations = [];
while ischar(line)
  [i1,i2] = regexp(line,'\d*');
  locations = [locations;str2num(line(i1:i2))];
  line = fgetl(tmp);
end
fclose(tmp);

!rm tpointers.dat

% get component index (assuming this does not change)

fh = fopen(filename);
fseek(fh,locations(1),'bof');

header = strtrim(fgetl(fh));
[icomp,ncomp] = getColumn(header,comp);
if ~icomp
  error(sprintf('no data found with string `%s''',comp));
end

% get data block

iinode = -1;

nt = length(locations);
out = zeros(nt,1);

for i = 1:nt
  fseek(fh,locations(i),'bof');
  header = fgetl(fh);
  data = fscanf(fh,'%g',[ncomp+1,inf])';
  % str = 'data = fscanf(fh,''%g';
  % for ip = 1:ncomp, str = [str ' %g']; end
  % str = [str ''',[ncomp+1,inf])'';'];
  % eval(str)

  if i == 1
    iinode = find(data(:,1)==inode);
    if isempty(iinode)
      fprintf('looking for %i in:\n',in);
      disp(data(:,1));
      error('node number not found')
    end
  end

  out(i) = data(iinode,icomp);
end

fclose(fh);
