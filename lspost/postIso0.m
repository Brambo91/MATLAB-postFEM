function postIso0 ( its )

plotMesh

if nargin < 1
  nt = getNT('iso0');
  its = 1:nt;
elseif length(its)==1 && its~=round(its)
  its = getIT(its);
end

for i=its
  addIso0(i,[0.7 0 0])
  drawnow
end
