function OUT = postG(ix,ig,it)

% postprocessing for g on front
% finds file defined as *.g
% args: ix in [1,2] (coordinate index for plotting), 
%       ig in [1,3] (pure mode contribution, 5 for total) 
%       it

% set default value

if ( nargin < 3 )
  it = 1;
end
if ( nargin < 2 )
  ig = 1:4;
end
if ( nargin < 1 )
  ix = 1;
else
  if ix > 2
    warning('not plotting a coordinate on the x-axis')
  end
end

% find the file in the current directory

filename = findFile('g');
fprintf('postG, reading G for time step %i from file %s\n',it,filename)
lfile = fopen(filename);

% find number of components
fgetl(lfile);
vals2 = str2num(fgetl(lfile));
nc = length(vals2);

% jump to right position 
% (use 'grep -b' to get byte offset and 'sed' to remove everything else)

str = [' ! grep -b newX ' filename ...
       ' | sed ''s/\([0-9]*\):.*/\1/'' ' ...
       ' > ipointers.dat'];

eval(str)
load ipointers.dat
!rm ipointers.dat
nt = size(ipointers,1);

if isempty(it) || strcmp(it,'nt')
  it = nt;
elseif it > nt
  disp('time step doesnt exist')
  disp(['nt = ', num2str(nt)])
  return;
end
fseek(lfile,ipointers(it),'bof'); fgetl(lfile);

% read data
% x, y, G1, G2, G3 (Gc)

data = fscanf(lfile, '%g',[nc,inf])';

% put total in additional column

data(:,nc+1) = sum(data(:,3:5)');
[b,iperm] = sort(data(:,ix));
data = data(iperm,:);

plot( data(:,ix), data(:,ig+2) );

% labels = ['G1';'G2';'G3';'GT'];
% gcl=legend(labels(ig,:));
% set(gcl,'box','off');

if nargout > 0
  OUT = data;
end
fclose('all');
