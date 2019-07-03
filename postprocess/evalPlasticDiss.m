function out=evalPlasticDiss
% compute and plot plastic dissipation as function of displacement
% from the area under the load displacement curve
% assuming unloading with the stiffness from the first time step
% (first time step elastic, no damage)


lodi=load('lodi.dat');

nt = size(lodi,1);

% find elastic stiffness from first nonzero time step

refLoad = max(abs(lodi(:,3)));
i1 = find(abs(lodi(:,3))>.0000001*refLoad,1,'first');

k = lodi(i1,3)/lodi(i1,2);

diss = zeros(nt,2);
diss(:,1) = lodi(:,2);
work = 0.;

for i = 2:nt
  dwork = .5*(lodi(i,3)+lodi(i-1,3))*(lodi(i,2)-lodi(i-1,2));
  work = work + dwork;
  elas = .5 * lodi(i,3)*lodi(i,3)/k;
  diss(i,2) = work - elas;
end

if nargout > 0
  out = diss;
end





