function px(it,ilayer)

% postprocessing for jemjive with xfem. Args: it, ilayer
% initialize figure and call addPxLayer

disp('PX: deformed mesh with fancy crack vizualization for single time step')
disp('Optional arguments: time step, layer index')

%% default values

if nargin < 2
  ilayer = 1;
end

if nargin < 1
  it = '';
end

%% initialize plot

clf

global XLIM;
global YLIM;
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
% set(gca,'Position',[0.1 0.05 0.8 0.9]);

view([0 90])

axis off

%% call function

addPxLayer(it,ilayer,0,0);

nameFig;
