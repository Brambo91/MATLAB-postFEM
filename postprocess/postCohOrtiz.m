function postCohOrtiz(it,cols)
% plot ortiz-style cohesive cracks with loading/unloading/broken information
% input: it [nt], cols [.7 .7 .7;tudblue;dred]

global crackLW

if ( nargin < 1 || isempty(it) )
  it = getNT;
end
if nargin < 2
  cols = [.7 .7 .7;tudblue;dred];
else
  assert(size(cols,1)==3);
  assert(size(cols,2)==3);
end


if ( isempty(crackLW) )
  lw = 1.;
else
  lw = crackLW;
end

% plotMesh on background (only if meshLW manually set to nonzero value!)

clf
global meshLW

if ~isempty(meshLW) && meshLW>0
  plotMesh
end

% find out edge information from global mesh data (set in plotMesh)

edges = drawOutline(1.,dgray);
axis off

% open file and jump to correct position

cfile = findFile('coh',1);

xit = findXOutTimeStep(cfile,it);

eval(['!grep -b new ' cfile ' > cpointers.dat'])

load cpointers.dat

!rm *pointers.dat

cFile = fopen(cfile);
fseek(cFile,cpointers(xit),'bof');fgetl(cFile);

% read data

cdat = fscanf(cFile,'%i %i',[2,inf])';

nlines = size(cdat,1);

% make plot

global gcoords

setLims
hold on
for i = 1:nlines

  iedge = cdat(i,1)+1;  % incremented for c++ to matlab
  state = cdat(i,2)+1;

  j0 = edges{iedge}(1);
  j2 = edges{iedge}(2);
  v  = [j0,iedge,j2];
  xs = gcoords ( v,1 );
  ys = gcoords ( v,2 );

  plot(xs,ys,'linewidth',lw,'color',cols(state,:));
end
  



