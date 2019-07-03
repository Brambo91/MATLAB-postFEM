function h = addIsoLc(it,color)
% add iso Lc level set, where coordinates of segemnts are written
% to *.isoLc file
% optional arguments: it, color (as string)

global gconn
global gcoords
global gnn
global isoLW

if isempty ( isoLW )
  isoLW = 1
end

if ( isoLW == 0. ) 
  return; 
end

% read mesh

readMesh

% open data file

filename = findFile('isoLc');
lfile = fopen(filename);

% jump to right position 
% (use 'grep -b' to get byte offset and 'sed' to remove everything else)

eval(['!grep -b new ' filename ' > ipointers.dat'])
load ipointers.dat
!rm ipointers.dat
nt = size(ipointers,1);

if nargin < 2
  color = 'w';
end

if nargin < 1 || isempty(it) || strcmp(it,'nt')
  it = nt;
elseif it > nt
  disp('time step doesnt exist')
  disp(['nt = ', num2str(nt)])
  return;
end
fseek(lfile,ipointers(it),'bof'); fgetl(lfile);

% read data

fprintf('ADDISOLc, plotting time step %i\n',it)

np = 2;  % assuming two points are written
ncol = np*2;

data = fscanf(lfile, '%g',[ncol,inf])';

nd = size(data,1);

if ( nd == 0 ) 
  return;
end

x = data(:,1:2:ncol);
y = data(:,2:2:ncol);
z = ones(size(x));

% make plot

% line(x',y',z','color',color,'linewidth',isoLW);
hold on
tmp = line(x',y',z','color',color,'linewidth',isoLW);

if nargout > 0
  h = tmp;
end

fclose(lfile);

