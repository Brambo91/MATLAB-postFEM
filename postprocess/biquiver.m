function biquiver(x,y,u,v,ii,varargin)
% make 2d quiver plot with two color arrows based on fifth argument
% args: x,y,u,v,ii,varargin
% where ii is a boolean vector same size as x, y, u and v

hold on
p = inputParser;
p.addParamValue('colElas',dblue);
p.addParamValue('colCoh','r');
p.addParamValue('scale',1);
p.addParamValue('linewidth',.5);
p.parse(varargin{:})
colE  = p.Results.colElas;
colC  = p.Results.colCoh;
scale = p.Results.scale;
lw    = p.Results.linewidth;

x2 = x+scale*u;
y2 = y+scale*v;

n = length(x);
for i = 1:n
  if ii(i)
    col = colC;
  else
    col = colE;
  end
  addArrow(x(i),y(i),scale*u,scale*v,col,lw);
end

