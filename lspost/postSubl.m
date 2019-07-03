function postSubl(icol,axh)
% plot deformation of SublamMesh output
% args: icol (u component for shading), axh (existing axes handle)

global pxScale
global VIEW

if nargin < 1
  icol = 3;
end

if ( isempty(pxScale) )
  scale = 1;
else
  scale = pxScale;
end

dfilename = findFile ('disp',1);
dfile = fopen ( dfilename );

fgetl(dfile);
dispUnsrt = fscanf(dfile,'%g %g %g %g',[4,inf]);
u(dispUnsrt(1,:)+1,:) = scale*dispUnsrt(2:4,:)';

elems = load(findFile('elems',1));
nodes = load(findFile('nodes',1));

elems = elems(:,3:end);
nodes = nodes(:,2:end);

nn = size(elems,2);
nbase = nn/2;

assert( any(nbase==[6,8,9]) );  % only for 6 and 9-node elements

ne = size(elems,1);

% skip middle nodes

if ( any(nbase==[8,9]) )
  vbot = [ 1,3,5,7 ];
elseif ( nbase == 6 )
  vbot = [ 1 3 5 1 ];
end

vtop = vbot + nbase;

nside = floor(nbase/2);
vside = zeros(nside,4);

for i = 1:nside
  j = mod(i,nside)+1;
  vside(i,:) = [ vbot(i) vbot(j) vtop(j) vtop(i) ];
end

if nargin > 1
  try
    axis(axh);
  catch err
    warn('POSTSUBL: check second argument!')
    rethrow(err)
  end
else
  clf
end

set(gca,'dataaspectratio',[1 1 1])
axis off

if ~isempty(VIEW)
  view(VIEW);
else
  view([30 40]);
end

for ie = 1:ne

  inodes = elems(ie,:)+1;

  xe = nodes(inodes,1) + u(inodes,1);
  ye = nodes(inodes,2) + u(inodes,2);
  ze = nodes(inodes,3) + u(inodes,3);
  ce = u(inodes,icol);

  patch(xe(vbot), ye(vbot), ze(vbot), ce(vbot), 'linewidth',0.1);
  patch(xe(vtop), ye(vtop), ze(vtop), ce(vtop), 'linewidth',0.1);
  patch(xe(vside'),ye(vside'),ze(vside'),ce(vside'),'linewidth',0.1);

end

fclose('all')
