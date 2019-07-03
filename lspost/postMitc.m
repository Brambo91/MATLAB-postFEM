function postMitc(icol)

% plot deformation of mitc-element
% for the time being without thickness

global pxScale
global pxLW

if nargin < 1
  icol = 3;
end

if ( isempty(pxScale) )
  scale = 1;
else
  scale = pxScale;
end

if ( isempty(pxLW) )
  pxLW = .1;
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
zs = [ 0. -thick(3)/2 thick(2)/3 ];

elems = load(findFile('elems',1));
nodes = load(findFile('nodes',1));

nn = size(elems,2)-2;

assert( nn==9 || nn==8 );  % only for 8 and 9-node elements

ne = size(elems,1);

v  = [ 1,2,3,4,5,6,7,8,1 ];
v0 = [ 1,2,3,4,5,6,7,8,9 ];
v1 = [ 1:8 ; mod(1:8,8)+1 ; 9*ones(1,8) ];

np = length(v0);

X = zeros(ne,np);
Y = zeros(ne,np);
Z = zeros(ne,np);
C = zeros(ne,np);

clf

for ie = 1:size(elems,1)

  inodes = elems(ie,v0+2)+1;

  x = nodes(inodes,2)   + scale * u(inodes,1);
  y = nodes(inodes,3)   + scale * u(inodes,2);
  z = zs(elems(ie,2)+1) + scale * u(inodes,3);

  c = u(inodes,icol);

  patch(x(v1),y(v1),z(v1),c(v1),'linestyle','none')

  if ( pxLW > 0. ) 
    line(x(v),y(v),z(v),'linewidth',pxLW,'color','k')
  end

end

  
% if ( pxLW > 0. )
%   patch(X',Y',Z',C','linewidth',pxLW)
% else
%   patch(X',Y',Z',C','linestyle','none')
% end

set(gca,'dataaspectratio',[1 1 1])
axis off

fclose('all')
