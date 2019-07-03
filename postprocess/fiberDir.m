function fiberDir(theta,x0,y0,r)
% indicate the fiber direction over the plot
% args: theta, x0, y0, r

global fibDirCol
global fibDirLW

if nargin < 4
  r = 1.;
end
if nargin < 2
  x0 = -10.;
  y0 = 6.;
end
if nargin < 1
  theta = 0
end

if ( isempty(fibDirCol) )
  fibDirCol = [.99 .99 .99];
end
if ( isempty(fibDirLW) )
  fibDirLW = 1;
end

ths = 0:1:360;
xs = x0 + cosd(ths);
ys = y0 + sind(ths);

dr = .1*r;

hold on
% line(xs,ys,'linewidth',fibDirLW,'color',fibDirCol)

vtheta = [ cosd(theta) sind(theta) ];
vperp  = [ -sind(theta) cosd(theta) ];
p0 = [x0 y0] + vperp * dr;
dd = vtheta * r;
seg = [ p0-dd ; p0+dd ];
line(seg(:,1),seg(:,2),'linewidth',fibDirLW,'color',fibDirCol)
pa = p0 + dd + 2 * vperp * dr - 4 * vtheta * dr; 
seg = [ p0+dd ; pa ];
line(seg(:,1),seg(:,2),'linewidth',fibDirLW,'color',fibDirCol)


p0 = [x0 y0] - vperp * dr;
dd = vtheta * r;
seg = [ p0-dd ; p0+dd ];
line(seg(:,1),seg(:,2),'linewidth',fibDirLW,'color',fibDirCol)
pa = p0 - dd - 2 * vperp * dr + 4 * vtheta * dr; 
seg = [ p0-dd ; pa ];
line(seg(:,1),seg(:,2),'linewidth',fibDirLW,'color',fibDirCol)




