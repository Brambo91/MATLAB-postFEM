% function disps = nodesdisp(nodes,it,comp)

% plot nodal displacements for specified set of nodes
% uses file ix.dat, coord.dat from UOUT,INIT
%       and ndis.dat from UOUT,NDIS

disp('Nodal displacements for specified set of nodes')
disp('Optional arguments: time step, component')

% initialize
load ndis.dat
load coord.dat
load ix.dat
if size(ndis,2)==6
  ndis=ndis(:,1:3);
end
nn = length(coord);
nt = length(ndis)/nn;

% % default values
% if nargin < 1, disp('input nodes!'); return; end
% if nargin < 2, its = 1:nt; end
% if nargin < 3, comp = 1; end

% correct values
if comp < 1 || comp > 3 
  comp = 1;
  disp('Invalid comp. Component set to 1.')
end
if length(its) == 1 && ( its < 1 || its > nt )
  its = 1:nt;
  disp('Invalid it.')
end

% time stepping loop
disps = zeros( length(its), length(nodes) );
jt = 0;
coords = coord( nodes, comp );
for it = its
  r0 = (it-1)*nn;
  jt = jt + 1;
  disps( jt, : ) = ndis( r0+nodes, comp )';
end
  
plot(coords, disps)
