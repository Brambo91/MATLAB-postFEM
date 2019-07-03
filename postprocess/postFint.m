function postFint(it,ii,scale)
% plot internal force vectors in (deformed) mesh
% input arguments: it, ii, [scale] 
% (where scale is for the size of the vectors, pxScale is used for deformation)

global pxScale;
global gconn;

%% get data

ffile = findFile('fint',1);

eval(['!grep -b internal ' ffile ' > fpointers.dat'])

load fpointers.dat
! rm *pointers.dat

iit = find(fpointers(:,2)==it);
iii = find(fpointers(iit,3)==ii);

if ( isempty(iii) ); error('not data found for this step and iteration'); end
assert ( length(iii) == 1 );

fFile = fopen(ffile);

fseek(fFile,fpointers(iit(iii),1),'bof'); fgetl(fFile);

fintDat = fscanf(fFile,'%g %g %g %g %g %g %g',[7,inf])';

%% intermezzo: plot mesh

clf
if ( isempty(pxScale) || pxScale == 0 )
  plotMesh
  xdef = fintDat(:,2);
  ydef = fintDat(:,3);
else
  % plot deformed mesh with *.fiEl

  xdef = fintDat(:,2) + pxScale * fintDat(:,4);
  ydef = fintDat(:,3) + pxScale * fintDat(:,5);

  readMesh(it-1)
  lconn = gconn;
  efile = findFile('fiEl',1);
  eval(['!grep -b newElems ' efile ' > epointers.dat'])
  eFile = fopen(efile);
  load epointers.dat;
  iit = find(epointers(:,2)==it);
  iii = find(epointers(iit,3)==ii);

  if ( isempty(iii) ); error('not data found for this step and iteration'); end
  assert ( length(iii) == 1 );
  fseek(eFile,epointers(iit(iii),1),'bof'); fgetl(eFile);
  elDat = fscanf(eFile,'%i %i %i %i %i %i %i',[7,inf])';
  nodeCount = size(lconn,2);
  if ( nodeCount == 6 )
    v = [1 4 2 5 3 6];
  else
    v = 1:nodeCount;
  end

  if ~isempty(elDat)
    lconn(elDat(:,1)+1,v) = elDat(:,2:end)+1;
  end

  ne = size(lconn,1);

  conn = lconn(:,v);

  x = reshape ( xdef(conn), size(conn) );
  y = reshape ( ydef(conn), size(conn) );
  z = zeros(size(conn));
  c = ones(size(conn));
  patch(x',y',z',c');
end

setLims

axis off
set(gca,'dataaspectratio',[1 1 1])

%% plot forces

fabs = sqrt ( fintDat(:,6).^2 + fintDat(:,7).^2 );
if nargin < 3
  ssize = max ( max(fintDat(:,2:3))-min(fintDat(:,2:3)) );
  fmax  = max(fabs);
  scale = ssize / 100 / fmax
end

vx = -scale * fintDat(:,6);
vy = -scale * fintDat(:,7);

for j = 1:size(fintDat,1)
  hold on
  if fabs(j) > 1.e-8
    addArrow(xdef(j),ydef(j),vx(j),vy(j),'r',0.5);
  end
end

fclose('all');
