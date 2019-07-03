function h = postTable(it,comp)
% plot deformed mesh with nodal quantities
% Args: time step, component (index or name)

%% get global variables or default values

if nargin < 2
  comp = '<empty>';
end
if nargin < 1
  it = getNT;
end

%% initialize plot

clf

global VIEW;

setLims

if ~isempty(VIEW)
  view(VIEW)
end

set(gca,'dataaspectratio',[1 1 1])

axis off

tmp = addPostTable(it,comp);

if nargout > 0
  h = tmp;
end

