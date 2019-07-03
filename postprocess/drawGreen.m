function drawGreen(scale)
% draw circumference of open hole test (Green et al. 2007)
% arg: in plane scaling factor

if nargin<1
  scale = 1;
end

ll = 32 * scale;
bb = 8 * scale;
rr = 3.175/2 * scale;

lw = .5;

hold on

xs = [-ll ll ll -ll -ll];
ys = [-bb -bb bb bb -bb];
zs = ones(size(xs))*2.;
line(xs,ys,zs,'color','k','linewidth',lw);

ths=0:1:360;
xs=rr*cosd(ths);
ys=rr*sind(ths);
zs = ones(size(xs))*2.;
line(xs,ys,zs,'color','k','linewidth',lw);

