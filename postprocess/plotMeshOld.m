 function plotMeshOld(iels,ins)

% plot mesh (white patches), args: iels, inodes
% use jemjive indices to label elements/nodes

%% initialize files (mesh)

tic

nfile = findFile('nodes',1);
efile = findFile('elems',1);
try
  sfile = findFile('stress',1);
catch
  sfile = '';
end

disp(['PlotMesh: plot the mesh based on ' nfile ' and ' efile])

if ~exist(nfile,'file')
  disp([nfile ' has not been found. Is your path correct?'])
  return
end

nodes = load(nfile);
elements = load(efile);

%% initialize plot

if ~ishold
  clf
end
  

set(gca,'dataaspectratio',[1 1 1])
set(gcf,'Paperposition',[0 0 3 2])
set(gca,'Position',[0.1 0.05 0.8 0.9]);
set(gca,'tag','mesh');

view([0 90])

setLims

axis off

%% get initial elements from stress-file 
% [doesn't work when cracking in 1st step]

if ~isempty(sfile)
  sFile = fopen(sfile);
  fgetl(sFile);

  np = size(elements,2)-1;

  str = 'stress = fscanf(sFile, ''%g';
  for ip = 1:np, str = [str ' %g']; end
  str = [str ''',[np+1,inf])'';'];
  eval(str);

  [bools,indices] = ismember(stress(:,1),elements(:,1));
  elements = elements(indices,:);
else
  % if no stress file was found, all elements are visualized
end

%% plot mesh

initElements = elements(elements(:,1)>=0,:);

np = size(elements,2)-2;

conn = initElements(:,2:np+2)+1;
conn(:,np+1) = conn(:,1);

x = reshape ( nodes(conn,2) , size(conn) );
y = reshape ( nodes(conn,3) , size(conn) );
z = -1 * ones ( size(conn) );

line(x',y',z','linewidth',.1,'color','k'); 

xm = mean(x,2);
ym = mean(y,2);
nels = length(xm);

if nargin > 0
  if isempty(iels)
    iels = 0:(nels-2);
  end
  iels = iels + 1;
  for i=iels
    text(xm(mod(i,nels)),ym(mod(i,nels)),num2str(i-1),...
         'HorizontalAlignment','center','color','y');
  end
end

if nargin > 1
  ins = ins + 1;
  for i = ins
    text(nodes(i,2),nodes(i,3),num2str(i-1),'color','r')
  end
end

disp('Plotted mesh')
toc

nameFig;
