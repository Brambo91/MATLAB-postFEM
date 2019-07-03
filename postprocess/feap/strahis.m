function EH = strahis(iel)
disp('Strain evolution within an element')
% output: eps ( time step , gauss point , component )

% initialize


if nargin<1
  disp('Input number of element as argument')
  return
end

load coord.dat
load ix.dat
nodes = ix(iel,:);
elcoord = coord(nodes,:);

% get nodal displacements

DH = disphis(iel);
nt = size(DH,1);
DH = reshape(DH,[nt,8,3]);

xin = [ -1 1 1 -1 -1 1 1 -1 ; -1 -1 1 1 -1 -1 1 1 ; -1 -1 -1 -1 1 1 1 1];
xig = 1/sqrt(3) * xin;

EH = zeros(nt,8,6);
N = zeros(1,8);
dNdxi = zeros(8,3);

for ig = 1:8  % gauss points
  
  xi = xig(:,ig);

  % evaluate shape functions and derivatives
  
  for in = 1:8  
    
    N(in) = ( 1 +  xi(1)*xin(1,in) ) * (1 + xi(2)*xin(2,in) ) * ( 1 + xi(3)*xin(3,in) ) / 8;
    dNdxi(in,1) = xin(1,in) * (1 + xi(2)*xin(2,in) ) * ( 1 + xi(3)*xin(3,in) ) / 8;
    dNdxi(in,2) = xin(2,in) * (1 + xi(1)*xin(1,in) ) * ( 1 + xi(3)*xin(3,in) ) / 8;
    dNdxi(in,3) = xin(3,in) * (1 + xi(2)*xin(2,in) ) * ( 1 + xi(1)*xin(1,in) ) / 8;

  end

  jac = dNdxi' * elcoord;
  
  dNdx = (jac^(-1)*dNdxi')';
  
  % evaluate strain for each time step
  
  for it=1:nt

    eps(1) = dot( dNdx(:,1) , DH(it,:,1) );
    eps(2) = dot( dNdx(:,2) , DH(it,:,2) );
    eps(3) = dot( dNdx(:,3) , DH(it,:,3) );
    eps(4) = dot( dNdx(:,1) , DH(it,:,2) ) + dot( dNdx(:,2) , DH(it,:,1) );
    eps(5) = dot( dNdx(:,2) , DH(it,:,3) ) + dot( dNdx(:,3) , DH(it,:,2) );
    eps(6) = dot( dNdx(:,3) , DH(it,:,1) ) + dot( dNdx(:,1) , DH(it,:,3) );

    EH(it,ig,:) = eps;

  end

end

% plot epsilon1 in each gauss point
plot(EH(:,:,1))