function pxthick(it,dz,thick)

% postprocessing for jemjive with xfem. Args: it, dz , thick
% where dz and thick are for 2d analyses: distance between ply center,
% thickness for extrusion (dz = 0 for plane plot)

disp('PXthick: deformed 3D-mesh with fancy crack vizualization for single time step')
disp('Optional arguments: time step, layer index')

%% default values

if nargin < 1
  it = getNT;
  disp(['nt = ' num2str(it)])
end

if nargin < 2
  dz = .5;
end

if nargin < 3
  thick = dz;
end

%% initialize plot

clf

global XLIM;
global YLIM;
global VIEW;
global pxOption;

% zoomThis (can be overruled by XLIM, YLIM)

if exist('zoomThis.m','file')
  zoomThis
end

if ~isempty(XLIM)
  xlim(XLIM);
end

if ~isempty(YLIM)
  ylim(YLIM);
end

if ~isempty(VIEW)
  view(VIEW);
else
  view([-130 40]);
end

var = 'none';

if pxOption == 0
  global pxExtension
  colormap default
  var = pxExtension;
elseif pxOption == 1
  colormap default
  var = 'ux';
elseif pxOption == 2
  colormap default
  var = 'uy';
elseif pxOption == 3
  colormap default
  var = 'uz';
end

if ( ~ strcmp(var,'none') )
  colb = colorbar('Position',[0.92 0.25 0.02 0.5]);
  set(colb,'fontsize',8)
  cbtitle = get(colb,'title');
  set(cbtitle,'fontsize',8)
  set(cbtitle,'string',var);
end

set(gca,'dataaspectratio',[1 1 1])
set(gcf,'Paperposition',[0 0 6 3])
set(gca,'Position',[0 0 1 1]);
set(gca,'projection','perspective')

axis off

%% call function

for ilayer = 0:1
  addPxLayer(it,ilayer,ilayer*dz,thick);
end

nameFig;
