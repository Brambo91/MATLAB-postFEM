function plotMeshWithLabels(iels,ins)

% plot mesh (white patches), no args.
% use jemjive indices to label elements/nodes

disp('PlotMesh: plot the mesh based on nodes.dat and elements.dat')

%% initialize files (mesh)

tic

global prepend
if ~isempty(prepend)
  prestring = [prepend '.'];
else
  prestring = [];
end
nfile = [prestring 'nodes.dat'];
efile = [prestring 'elements.dat'];

if ~exist(nfile,'file')
  disp([nfile ' has not been found. Is your path correct?'])
  return
end

load(nfile)
if ~isempty(prepend)
  eval(['nodes = ' prepend ';'])
  eval(['clear ' prepend])
end

load(efile)
if ~isempty(prepend)
  eval(['elements = ' prepend ';'])
  eval(['clear ' prepend])
end

disp('Initialized files')
toc

%% initialize plot

clf

set(gca,'dataaspectratio',[1 1 1])
set(gcf,'Paperposition',[0 0 3 2])
set(gca,'Position',[0.1 0.05 0.8 0.9]);
set(gca,'tag','mesh');

view([0 90])

axis off

disp('Initialized plot')
toc

%% plot mesh

node0s = find( nodes(:,2)==nodes(1,2) & nodes(:,3)==nodes(1,3)) - 2;

if length(node0s) == 1
  node0s(2) = length(nodes);
end

initElements = elements(elements(:,1)>=0,:);

np = size(elements,2)-2;
imin = min( initElements( : , 2:np+2 ),[],2 );
layer1 = imin < node0s(2);

conn = initElements(layer1,2:np+2)+1;
conn(:,np+1) = conn(:,1);

x = reshape ( nodes(conn,2) , size(conn) );
y = reshape ( nodes(conn,3) , size(conn) );

line(x',y','linewidth',.1,'color','k'); 

xm = mean(x,2);
ym = mean(y,2);
nels = length(xm);

if nargin<1 || isempty(iels)
  iels = 1:nels-1; %highest element label not indicated
else
  iels = iels + 1;
end
  
for i=iels
  text(xm(mod(i,nels)),ym(mod(i,nels)),num2str(i-1),'HorizontalAlignment','center',...
    'color','y');
end

if nargin > 1
  ins = ins + 1;
  for i = ins
    text(nodes(i,2),nodes(i,3),num2str(i-1),'color','r')
  end
end

  

disp('Plotted mesh')
toc

