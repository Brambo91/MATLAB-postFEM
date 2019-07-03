function out = getTableValue(filename,inode,comp,it)
% find value in table written by jemjive for a given node and time step
% arguments: filename, node number, component name and time step
% returns: value from table

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

fseek(fh,locations(it),'bof');
header = fgetl(fh);
data = fscanf(fh,'%g',[ncomp+1,inf])';

% get value from block

iinode = find(data(:,1)==inode);
if isempty(iinode)
  fprintf('looking for %i in:\n',in);
  disp(data(:,1));
  fprintf('node number not found\n')
  out = nan;
else
  out = data(iinode,icomp);
end

fclose(fh);
