function px(it,imodel)

% postprocessing for jemjive with xfem. Args: it, imodel
% initialize figure and call addPxLayer

disp('PX: deformed mesh with fancy crack vizualization for single time step')
disp('Optional arguments: time step, model index')

%% default values

if nargin < 2
  imodel = 1;
end

if nargin < 1
  it = '';
end

%% initialize plot

clf

global pxOption;

setLims

if ( isempty(pxOption) )
  pxOption = 2;
end

if ( any ( pxOption == [ 0 1 6 ] ) )
  caxis([0 1])   % NB: should also be on for 2 with PhD code 
end

var = 'none';
if pxOption == 1
  cdammap
  var = 'df';
elseif pxOption == 0
  colormap default
  var = 'sdam';
elseif pxOption == 6
  % dredmap(64,[1 1 1])
  summermap
  var = 'dm';
elseif pxOption == 2
  contrastmap
  var = 'fm';
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
set(gca,'Position',[0.1 0.05 0.8 0.9]);

view([0 90])

axis off

%% call function

addPxLayer(it,imodel,0,0);

nameFig;
