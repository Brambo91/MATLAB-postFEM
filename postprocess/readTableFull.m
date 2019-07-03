function [data,words] = readTableFull(filename)
% read all data from table file
% output data(it,inode,icomp),columns
% it is assumed that there is only one data block written per time step
% implying that the table is completely filled
% (also check getTableTimePath for single component history)

if nargin < 1
  filename = 'xotable.dat';
end

fh = fopen(filename);

str = ['!grep -b ''column.*"'' ' filename ' > tpointers.dat '];
eval(str)
tmpf = dir('tpointers.dat');
if ( tmpf.bytes == 0 )
  error(sprintf('file %s is not a table file',filename))
end
tmp = fopen('tpointers.dat');

nt = getNT;
for it = 1:nt;
  line = fgetl(tmp);
  [i1,i2] = regexp(line,'\d*');
  location = str2num(line(i1:i2));
  fseek(fh,location,'bof');
  header = strtrim(fgetl(fh));
  words = getColumnItems(header);
  ncomp = length(words);
  str = 'timestepdata = fscanf(fh,''%g';
  for ip = 1:ncomp, str = [str ' %g']; end
  str = [str ''',[ncomp+1,inf])'';'];
  eval(str)
  nn = size(timestepdata,1);

  if ( it == 1 )
    data = zeros(nt,nn,ncomp+1);
  end

  data(it,:,:) = timestepdata;

end

!rm tpointers.dat
fclose(tmp);
fclose(fh);

