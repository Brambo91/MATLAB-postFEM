function labelElems(ies,varargin)
% label elements in existing plot
% using readGmsh and *.msh
% input element numbers are c++ numbers ranging from 0 to (nel-1)
% second argument: varargin for 'text' command

global gcoords
global gconn
global gnel

readMesh

if nargin < 2
  varargin{1} = 'color';
  varargin{2} = 'r';
end

if nargin < 1 || isempty(ies)
  ies = 0:gnel-1;
end

for i = 1:length(ies)
  ie = ies(i);
  inodes = gconn(ie+1,:);
  x  = mean(gcoords(inodes,1));
  y  = mean(gcoords(inodes,2));
  z  = ones(size(x));
  text(x,y,z,num2str(ie),varargin{:})
end
