function postMitcThick(icol)

% plot deformation of mitc-element

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

dispUnsrt = fscanf(dfile,'%g %g %g %g %g %g',[6,inf]);

u(dispUnsrt(1,:)+1,:) = dispUnsrt(2:6,:)';

try
  thick = load(findFile('thick',1)); 
catch
  thick = [1 1 1];
end
zs = [ 0. -thick(3)/2 thick(2)/2 ];

elems = load(findFile('elems',1));
nodes = load(findFile('nodes',1));

nn = size(elems,2)-2;

assert( nn==9 || nn==8 );  % only for 8 and 9-node elements

ne = size(elems,1);

% v = [ 1,2,3,4,5,6,7,8,1 ];  % with middle node
% vsideb = [ 1,2,3 ; 3,4,5 ; 5,6,7 ; 7,8,1 ];
% vsidet = [ 3,2,1 ; 5,4,3 ; 7,6,5 ; 1,8,7 ];

v = [ 1,3,5,7,1 ];  % skip middle node
vsideb = [ 1,2 ; 2,3 ; 3,4 ; 4,1 ];
vsidet = [ 2,1 ; 3,2 ; 4,3 ; 1,4 ];

np = length(v);

clf

set(gca,'dataaspectratio',[1 1 1])
axis off

if ~isempty(VIEW)
  view(VIEW);
else
  view([30 40]);
end

for ie = 1:size(elems,1)

  inodes = elems(ie,v+2)+1;
  iz     = elems(ie,2)+1;
  dz     = thick(iz)/2;

  xtop = nodes(inodes,2) + scale * u(inodes,1) + scale * u(inodes,4) * dz;
  ytop = nodes(inodes,3) + scale * u(inodes,2) + scale * u(inodes,5) * dz;
  ztop = zs(iz) + dz     + scale * u(inodes,3);
  ctop = u(inodes,icol);

  xbot = nodes(inodes,2) + scale * u(inodes,1) - scale * u(inodes,4) * dz;
  ybot = nodes(inodes,3) + scale * u(inodes,2) - scale * u(inodes,5) * dz;
  zbot = zs(iz) - dz     + scale * u(inodes,3);
  cbot = ctop;

  patch(xtop,ytop,ztop,ctop,'linewidth',0.1);
  patch(xbot,ybot,zbot,cbot,'linewidth',0.1);

  for i = 1:4
    vb = vsideb(i,:);
    vt = vsidet(i,:);
    
    x  = [ xbot(vb);xtop(vt);xbot(vb(1)) ];
    y  = [ ybot(vb);ytop(vt);ybot(vb(1)) ];
    z  = [ zbot(vb);ztop(vt);zbot(vb(1)) ];
    c  = [ cbot(vb);ctop(vt);cbot(vb(1)) ];
    
    patch(x,y,z,c,'linewidth',0.1);
  end

end

fclose('all')
