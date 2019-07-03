function h = plotDots(xs,ys,col)
% make a better looking dotted plot
% NB: first set xlim, ylim, gca.position and gcf.paperposition
% args: xs, ys, color

DIST = 0.025;
LDOT = 0.02;

if nargin < 3
  col = 'r';
end

assert(length(xs)==length(ys))

pos = get(gcf,'paperposition') .* get(gca,'position');

XLIM = xlim;
YLIM = ylim;

dx = diff(XLIM);
dy = diff(YLIM);

dxds = dx / pos(3);
dyds = dy / pos(4);

% get cumulative distance (per inch)

sx = zeros(size(xs));
sy = zeros(size(ys));

dxs = diff(xs);
dys = diff(ys);

for i = 2:length(xs)
  sx(i) = sx(i-1) + abs(dxs(i-1)) / dxds;
  sy(i) = sy(i-1) + abs(dys(i-1)) / dyds;
end
sp = sqrt( sx.^2 + sy.^2 );

% get coordinates of dot center

totalP = sp(end);
ndot = floor(totalP/DIST)+2;
s = 0;

xp = zeros(ndot,1);
yp = zeros(ndot,1);
j = 2;

for i = 1:length(xs)

  while s < sp(i)
    frac = ( s - sp(i-1) ) / ( sp(i) - sp(i-1) );
    xp(j) = xs(i-1) + (xs(i)-xs(i-1)) * frac;
    yp(j) = ys(i-1) + (ys(i)-ys(i-1)) * frac;

    s = s + DIST;
    j = j + 1;
  end

end


% plot as dots

% hold on
% H = plot(xp,yp,'.','color',col,'markersize',6);

% get directions

dsx = zeros(size(xp));
dsy = zeros(size(yp));

dsx(1) = ( xp(2)-xp(1) ) / dxds;
dsy(1) = ( yp(2)-yp(1) ) / dyds;
for i = 2:(ndot-1)
  dsx(i) = (xp(i+1)-xp(i-1)) / dxds;
  dsy(i) = (yp(i+1)-yp(i-1)) / dyds;
end
dsx(ndot) = ( xp(end)-xp(end-1) ) / dxds;
dsy(ndot) = ( yp(end)-yp(end-1) ) / dyds;

phis = atan2(dsy,dsx);

xL = fig2ax ( XLIM, ax2fig(XLIM,xp,dxds) + sin(phis)*LDOT/2, dxds );
xR = fig2ax ( XLIM, ax2fig(XLIM,xp,dxds) - sin(phis)*LDOT/2, dxds );
yL = fig2ax ( XLIM, ax2fig(YLIM,yp,dyds) - cos(phis)*LDOT/2, dyds );
yR = fig2ax ( XLIM, ax2fig(YLIM,yp,dyds) + cos(phis)*LDOT/2, dyds );

hold on
H = plot([xL,xR]',[yL,yR]','r');

xlim(XLIM)
ylim(YLIM)

if nargout > 0
  h = H;
end

%=======================================================

function xf = ax2fig ( XLIM, xa, dxds )
% convert axis coordinates to figure coordinates
xf = ( xa - XLIM(1) ) / dxds;

%=======================================================

function [xa,ya] = fig2ax ( XLIM, xf, dxds )
% convert figure coordinates to axis coordinates
xa = dxds * xf + XLIM(1);


