function out = getTableDisp(it,filename)
% find displacement data in table written by jemjive
% arguments: time step number, filename
% returns: n-by-(rank+1) matrix with [ nodeNumbers , ux, uy ]

str = ['!grep -b "disp\[' num2str(it-1) '\]" ' filename ' > tpointers.dat '];
eval(str)
tmpf = dir('tpointers.dat');
if ( tmpf.bytes == 0 )
  disp(str)
  error(sprintf(...
    'displacements for time step %i not found in file `%s'''...
    ,it,filename))
end
tmp = fopen('tpointers.dat');
line = fgetl(tmp);
[i1,i2] = regexp(line,'\d*');
location = str2num(line(i1:i2));
!rm tpointers.dat
fclose(tmp);

fh = fopen(filename);

fseek(fh,location,'bof');
fgetl(fh);
fgetl(fh);
header = strtrim(fgetl(fh));
[icomp,ncomp] = getColumn(header,'dummy');

% get data block

str = 'out = fscanf(fh,''%g';
for ip = 1:ncomp, str = [str ' %g']; end
str = [str ''',[ncomp+1,inf])'';'];
eval(str)
fclose(fh);

