% draw circumference of spearing beaumont test (Wisnom and Chang 2000)

lw = 1.;

hold on

ll = 45.;
bb = 12.;
ln =  4.;
bn =  .2;

xs = [bn,bn,ll,ll,0,0];
ys = [ln-bn,0,0,bb,bb,ln];
line(xs,ys,'color','k','linewidth',lw);

ths=0:1:90;
xs=bn*cosd(ths);
ys=bn*sind(ths)+ln-bn;

line(xs,ys,'color','k','linewidth',lw);

