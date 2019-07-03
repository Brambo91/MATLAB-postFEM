function drawYang
% draw circumference of open hole test (Yang and Cox 2005)

ll = 50.8;
bb = 50.8;
rr = 12.7;

lw = .5;

hold on

xs = [rr ll ll 0 0];
ys = [0 0 bb bb rr];
zs = ones(size(xs))*2.;
line(xs,ys,zs,'color','k','linewidth',lw);

ths=0:1:90;
xs=rr*cosd(ths);
ys=rr*sind(ths);
zs = ones(size(xs))*2.;
line(xs,ys,zs,'color','k','linewidth',lw);

