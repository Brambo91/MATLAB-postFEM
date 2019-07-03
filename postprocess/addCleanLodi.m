function addCleanLodi(its)
% arg: its (time steps for markers)

% read variable lodi

global prepend
if ~isempty(prepend)
  load([prepend '.lodi.dat'])
  disp(prepend)
  eval(['lodi = ' prepend ';'])
else
  load lodi.dat
end

% add zeros

lodi = [zeros(1,size(lodi,2));lodi];

% remove discarded steps 
% (valid step is the first one with new istep)
% (obsolete since use of 'sampleWhen = accepted')

% nt = max(lodi(:,1));
% cleanLodi = zeros(nt,3);
% for i=1:nt
%   ir = find( lodi(:,1)==i, 1, 'first' );
%   cleanLodi(i,:) = lodi(ir,:);
% end
% lodi = cleanLodi;

% make plot

if nargin < 1
  plot(lodi(:,2),lodi(:,3),'color',dblue,'marker','.');
else
  hold on;
  plot(lodi( : ,2),lodi( : ,3),'color',dblue)
  plot(lodi(its+1,2),lodi(its+1,3),'r.','markersize',8); % correct for added zeros
  hold off;
  set(gca,'box','on')
end

% store in base workspace
if ~isempty(prepend)
  assignin('base',prepend,lodi)
else
  assignin('base','lodi',lodi)
end

set(gca,'tag','lodi')
