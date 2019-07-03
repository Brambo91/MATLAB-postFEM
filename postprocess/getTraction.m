function [x,y,tn,ts,loading] = getTraction(it,iint)
% get cohesive tractions for time step it and interface number iint
% current implementation only works for 2D
% Args: time step, iint
% Output: x,y,tn,ts,[loading]

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

assert ( rank == 2 );
coords = fscanf(fi, '%g %g %g %g',[4,inf])';
coords = coords(:,3:end);
np = size(coords,1);
[coords,indices] = sortrows(coords);

% find pointers and jump to correct position in file

eval(['!grep -b new ' tfile ' > tpointers.dat'])

load tpointers.dat

!rm *pointers.dat

xit = findXOutTimeStep(tfile,it);

fseek(tFile,tpointers(xit),'bof'); fgetl(tFile);

% read data

data  = fscanf(fi, '%g %g %g %g %g %g %g %g %g',[9,inf])';
data  = data(indices,:);
iload = (data(:,end)==1);

assert ( np == size(data,1) );

x = coords(:,1);
y = coords(:,2);
tn = NaN*zeros(size(x));
ts = NaN*zeros(size(x));

% read and reorder tractions

for i = 1:np
  tn(i) = data(i,4);
  ts(i) = data(i,6);
end

fclose('all');

if nargout > 4 
  loading = iload;
end

