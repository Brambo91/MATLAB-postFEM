function h = postOTable(it,comp)
% plot mesh with nodal quantities from table in *.out
% Args: time step, component (index or name)

%% set default values for missing input

if nargin < 2
  comp = '';
end
if nargin < 1
  it = '';
end


clf

setLims

global VIEW;
if ~isempty(VIEW)
  view(VIEW)
end

set(gca,'dataaspectratio',[1 1 1])

tmp = addOutPlot(it,comp);

axis off

if nargout > 0
  h = tmp;
end



