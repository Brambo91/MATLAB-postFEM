function drawXhole
% draw circumference of open hole test (efm09)

ll = 38.4 /2;
bb = 8 ;
rr = 3.2;

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

