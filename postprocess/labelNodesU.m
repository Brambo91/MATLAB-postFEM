function labelNodesU(it,ins,col)
% label nodes in existing plot with deformed mesh
% using readMesh and *.disp
% input: it, ins, col
% input node number are c++ numbers ranging from 0 to (gnn-1)

% read mesh info

global gcoords
global gnn

readMesh

rank = size(gcoords,2);

if nargin < 3
  col = 'r';
end
if nargin < 2 
  error('No node numbers (ins) specified. Input: it, ins, [col]')
elseif isempty(ins)
  ins = (1:gnn)-1;
end

% get deformed coordinates

global pxScale

if isempty(pxScale)
  error('pxScale not set'); 
end

dfile = findFile('disp',1);

xit = findXOutTimeStep(dfile,it);

eval(['!grep -b new ' dfile ' > dpointers.dat'])

load dpointers.dat
!rm *pointers.dat
dFile = fopen(dfile);

fseek(dFile,dpointers(xit),'bof'); fgetl(dFile);

if rank == 2
  u = fscanf(dFile, '%g %g %g'   ,[3,inf])';
else
  u = fscanf(dFile, '%g %g %g %g',[4,inf])';
end

% make plot

for i = 1:length(ins)
  in = ins(i);
  x  = gcoords(in+1,1) + pxScale*u(in+1,2);
  y  = gcoords(in+1,2) + pxScale*u(in+1,3);
  z  = ones(size(x));
  text(x,y,z,num2str(in),'color',col)
end
