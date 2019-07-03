function addArrow(x1,y1,dx,dy,col,lw,ddx,ddy)
% low level function to draw arrow
% arguments: x1, y1, dx, dy, col, lw, 
%  relative pointer length, relative pointer width

if nargin < 7
  ddx = 0.15;
  ddy = 0.07;
elseif nargin < 8
  ddy = 0.07/0.15*ddx;
end

phi = atan2(dy,dx);
c = cos(phi);
s = sin(phi);
dr = sqrt(dx*dx+dy*dy);

p1 = [x1,y1];
p2 = p1 + dr*[c,s];
p3 = p2 + dr*ddy*[-s,c] - dr*ddx*[c,s];
p4 = p2 - dr*ddy*[-s,c] - dr*ddx*[c,s];

plot([p1(1),p2(1)],[p1(2),p2(2)],':','color',col,'linewidth',lw)
plot([p3(1),p2(1)],[p3(2),p2(2)],'color',col,'linewidth',lw)
plot([p4(1),p2(1)],[p4(2),p2(2)],'color',col,'linewidth',lw)
