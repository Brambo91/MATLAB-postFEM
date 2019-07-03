function drawCircle(rr,lw,col,p0)
% draw a circle in the current plot
% arguments: r (, lw, col,p0)

xl = xlim;
yl = ylim;

if nargin < 4 || isempty(p0)
  p0 = [0,0];
end
if nargin < 3 || isempty(col)
  col = 'k';
end
if nargin < 2 || isempty(lw)
  lw = 2.;
end

hold on

ths=0:1:360;
xs=p0(1)+rr*cosd(ths);
ys=p0(2)+rr*sind(ths);
zs = ones(size(xs))*2.;
line(xs,ys,zs,'color',col,'linewidth',lw);

xlim(xl);
ylim(yl);

axis off
