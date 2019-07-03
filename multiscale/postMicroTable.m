function h = postMicroTable(it,imicro,comp)
% plot mesh with nodal quantities from table in *micro.out
% Args: time step, component (index or name)

%% set default values for missing input

if nargin < 3
  comp = '';
end
if nargin < 2
  imicro = 1;
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

% find file with data corresponding to imicro

filename = getMicroFilename(imicro);

tmp = addMicroTablePlot(it,filename,comp);

axis off

if nargout > 0
  h = tmp;
end



