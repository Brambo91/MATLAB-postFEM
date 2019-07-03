function cleanLodiAlt(its)
% arg: its (time steps for markers)

setAxes lodi;

clf

% read variable lodi

global prepend
if ~isempty(prepend)
  load([prepend '.lodi.dat'])
  disp(prepend)
  eval(['lodi = ' prepend ';'])
else
  load lodi.dat
end

% remove discarded steps 
% (valid step is the first one with new istep)

nt = max(lodi(:,1));
cleanLodi = zeros(nt,3);
for i=1:nt
  ir = find( lodi(:,1)==i, 1, 'first' );
  cleanLodi(i,:) = lodi(ir,:);
end
lodi = cleanLodi;

% ALT: make oblique plot to visualize sharp snapbacks better

relaxsteps1 = find( lodi(:,2)<1e-8 );
relaxsteps2 = find( abs(lodi(:,3)<1e-8) );
if ~isempty(relaxsteps2)
  % force control
  i1 = max(relaxsteps2)+1;
  u0 = lodi(i1-1,2);
  lodi(:,2) = lodi(:,2) - u0;
  K0 = lodi(i1,3)/lodi(i1,2);
elseif ~isempty(relaxsteps1)
  % disp control
  i1 = max(relaxsteps1)+1;
  f0 = lodi(i1-1,3);
  K0 = (lodi(i1,3)-f0)/lodi(i1,2);
  u0 = - f0 / K0;
  lodi(:,2) = lodi(:,2) - u0;
else
  u0 = 0;
  K0 = lodi(2,3)/lodi(2,2);
end
lodi(:,2) = ( K0 - lodi(:,3)./lodi(:,2)-u0 ) / K0;
lodi(relaxsteps1,2) = 0;
lodi(relaxsteps2,2) = 0;

% if ~isempty(relaxsteps)
%   lodi(i0,2) = 0;
% end

% add zeros

% lodi = [zeros(1,size(lodi,2));lodi];

% make plot

if nargin < 1
  plot(lodi(:,2),lodi(:,3),'color',dblue,'marker','.');
else
  hold on;
  plot(lodi( : ,2),lodi( : ,3),'color',dblue)
  plot(lodi(its,2),lodi(its,3),'r.','markersize',8);
  hold off;
  set(gca,'box','on')
end

% layout
set(gcf,'paperposition',[0 0 3 2])
set(gca,'fontsize',8)
xlabel('(K0-K)/K0')
ylabel('F')

% store in base workspace
if ~isempty(prepend)
  assignin('base',prepend,lodi)
else
  assignin('base','lodi',lodi)
end

xl = xlim;
xl(1) = 0;
xl(2) = min(xl(2),1);
xlim(xl);

set(gca,'tag','lodi')
