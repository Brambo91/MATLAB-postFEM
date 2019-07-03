function pxthick(it,dz,thick)

% postprocessing for jemjive with xfem. Args: it, dz , thick
% where dz and thick are for 2d analyses: distance between ply center,
% thickness for extrusion (dz = 0 for plane plot)

% making a 3D plot including ply thickness for a 2D computation

disp('PXthick: deformed 3D-mesh with fancy crack vizualization for single time step')
disp('Optional arguments: time step, dz, thickness')
% disp('Time step: Default is final time step')

if nargin < 1
  it = '';
end

if nargin < 2
  dz = .5;
end

if nargin < 3
  thick = dz;
end

nz = getNModels;

%% initialize plot

clf

global VIEW;
global pxOption;

setLims

if ~isempty(VIEW)
  view(VIEW);
else
  view([-48 38])
end


set(gcf,'Paperposition',[0 0 9 4])
set(gca,'position',[0 0 1 1]);
set(gca,'dataaspectratio',[1 1 1])
set(gca,'projection','perspective')


if pxOption == 3
  if nz == 2
    colormap([0.2 0.6 1.0;1.0 0.45 0.45])
  else
    matCols = get(gca,'colororder');
    colormap(matCols(1:nz,:));
  end
elseif pxOption == 4
  if nz == 2
    colormap([0.0 0.3 0.6;0.2 0.6 1.0;0.5 0.2 0.2;1.0 0.45 0.45])
  else
    matCols = get(gca,'colororder');
    for i = 1:nz
      cmap(i*2-1,:) = matCols(i,:);
      cmap(i*2  ,:) = ( matCols(i,:) + [1,1,1] ) / 2;
    end
    colormap(cmap);
  end
  caxis([1 nz+.5])
elseif pxOption == 13
  cdammap
  caxis([0 1])
  var = 'df';
end

axis off

% % transparant for poster
% set(gca,'color','none')
% set(gcf,'color','none')
% set(gcf,'inverthardcopy','off')

disp('Initialized plot')

for imodel = 1:nz
  addPxLayer(it,imodel,imodel*dz,thick)
end

nameFig;
