function h = quiverITraction(it,iint)
% plot cohesive tractions from interface as arrow field (quiver)
% current implementation only works for a single interface
% Args: time step, iint

% default arguments 

if nargin < 2
  iint = 1;
end
if nargin < 1
  it = '';
end

% find filename

eval(['!ls interface* > tmp.postintf'])

fi = fopen('tmp.postintf');

for i = 1:iint
  tfile = fgetl(fi);
end

!rm tmp.postintf
fclose(fi);

% open file and read ip coordinates

tFile = fopen(tfile);
fgetl(fi);
rank = str2double(fgetl(fi));

if rank == 2
  coords = fscanf(fi, '%g %g %g %g',[4,inf])';
elseif rank == 3
  coords = fscanf(fi, '%g %g %g %g %g',[5,inf])';
end
coords = coords(:,3:end);
np = size(coords,1);

% find pointers and jump to correct position in file

eval(['!grep -b new ' tfile ' > tpointers.dat'])

load tpointers.dat

!rm *pointers.dat

xit = findXOutTimeStep(tfile,it);

fseek(tFile,tpointers(xit),'bof'); fgetl(tFile);

% read data

if rank == 2
  data = fscanf(fi, '%g %g %g %g %g %g %g %g %g',[9,inf])';
else
  data = fscanf(fi, '%g %g %g %g %g %g %g %g %g %g %g',[11,inf])';
end
ii = (data(:,end)==1);

assert ( np == size(data,1) );

x = coords(:,1);
y = coords(:,2);
if ( rank == 3 ); z = coords(:,3); end
u = NaN*zeros(size(x));
v = NaN*zeros(size(x));
w = NaN*zeros(size(x));

% read and reorder tractions

for i = 1:np
  v(i) = data(i,4);
  u(i) = data(i,6);
  if ( rank == 3 ); w(i) = data(i,8); end
end
lmax = sqrt(max(u.*u+v.*v));
u = .5*u/lmax;
v = .5*v/lmax;
if ( rank == 3 ); w = w/lmax; end

% make figure

if rank == 2
%   h1 = quiver(x,y,u,v,'color',dblue);
  % h2 = quiver(x(ii),y(ii),u(ii),v(ii),'color','r','autoscale','off');
  myquiver(x,y,u,v,ii,'scale',1)
else
  h1 = quiver3(x,y,z,u,v,w,'color',dblue);
end

set(gca,'dataaspectratio',[1 1 1])

fclose('all');

if nargout > 0 
  h = h1;
end

