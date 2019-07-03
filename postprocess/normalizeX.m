function out = normalizeX(in,dx0)
% for an trajectory (x,y), interpolate along line, such that
% the same data set with normalized x-coordinates is obtained
% second argument gives precision (default: 0.01)

if nargin < 2
  dx0 = .01;
end

x = 0.;
x0 = 0.;
nt = size(in,1);
nc = size(in,2);

out = zeros(1,nc);
in = [ out ; in ];

for it = 2:nt

  x0 = in(it-1,1);
  x1 = in(it  ,1);

  sgn = sign(x1-x);

  if sgn == 0
    out = [ out ; in(it,:) ];
    continue
  end

  dx = sgn * dx0;

  while ( sign(x1-(x+dx)) == sgn )

    x = x + dx;
    f1 = (x-x0)/(x1-x0);
    f0 = 1 - f1;
    val = f1 * in(it,:) + f0 * in(it-1,:);
    out = [ out ; val ];

  end

end

out(:,1) = round(out(:,1)/dx0)*dx0;
