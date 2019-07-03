function postncintf(it,comp,iint)

% Postprocessing for ncinterface damage. Args: it,comp,iint

% Reads from one of the files which name matches the search pattern
% interface. These files are sorted alphabetically and number 'iint' 
% of this list is used.

disp('Postncintf: NCInterface postprocessing')
disp('input: time step number, component (default: nt-1, damage), interface number')
disp('components: [1:rank*2+3] = [ dui ti damage |t| loading ] i=1..rank')

%% initialize

tic

global piLW

if ( isempty(piLW) )
  piLW = .1;
end

eval(['!ls interface* > tmp.postintf'])

fi = fopen('tmp.postintf');
if nargin < 3
  iint = 1;
end

for i = 1:iint
  filename = fgetl(fi);
end

!rm tmp.postintf
fclose(fi);

if filename ~= -1
  disp(['Reading data from file: ' filename]);
  fi = fopen(filename);
else
  disp('number of files recognized as interface data files:');
  eval(['!ls -1 interface* | wc -l'])
  error(['Invalid interface file number ' num2str(iint) ]);
end

% read number of nodes and rank from first line
       fscanf(fi,'%s',2); % two words
np   = fscanf(fi,'%i',1);
rank = fscanf(fi,'%i',1);

% read connectivity
conn   = fscanf(fi,'%i',[np,inf])';
nel    = size(conn,1);

% get nodal coordinates
coords = load('all.nodes');
x = reshape(coords(conn+1,2),size(conn));
y = reshape(coords(conn+1,3),size(conn));

if nargin<2 || isempty(comp)
  comp = rank*2+1;
elseif comp > rank*2+3
  error(['Non-existing component, should be smaller than ' num2str(rank*2+3)]);
end

if np == 3
  v = [ 1 2 3 1 ];
elseif np == 6
  v = [1 2 6 1;3 4 2 3;5 6 4 5;2 4 6 2];
  v0 = 1:np;
elseif np==4
  v = 1:4;
%   v = [ 1 2 4 3];
elseif isempty(np)
  error(['no number of points specified: maybe use postintf instead'])
else
  error(['unknown number of nodes: ' np])
end
  
disp('Initialized files')
toc

%% initialize figure

clf

% setLims
% 
% colormap default
% 
% if comp == rank*2+1
%   contrastmap
%   caxis([0 1])
% elseif comp == rank*2+2
%   contrastmap
% elseif comp == rank*2+3
%   colormap([1 1 1;.8 .1 .1])
%   caxis([0 1])
% end


colb = colorbar('Position',[0.93 0.25 0.02 0.5]);
set(colb,'Fontsize',7)
cbtitle = get(colb,'title');
set(cbtitle,'fontsize',7)
if comp == rank*2+1
  set(cbtitle,'string','d');
end

set(gcf,'paperposition',[0 0 4 3])
set(gca,'dataaspectratio',[1 1 1])
set(gca,'Position',[0.1 0.05 0.8 0.9]);
set(gca,'tag','mesh');
axis off;
  
% % transparant for poster
% set(gcf,'paperPosition',[0 0 9 6]);
% set(gca,'color','none')
% set(gcf,'color','none')
% set(gcf,'inverthardcopy','off')

disp('Figure has been prepared. ')
toc 

%% read data from correct time step

% find pointers to time step data and number of time steps

eval(['!grep -b new ' filename ' > ipointers.dat'])
load ipointers.dat
!rm ipointers.dat
nt = size(ipointers,1);

if nargin < 1 || isempty(it) || strcmp(it,'nt')
  it = nt;
  disp(['nt = ', num2str(nt)])
elseif it > nt
  disp('time step doesnt exist')
  disp(['nt = ', num2str(nt)])
  return;
end

% jump to correct position and read data

fseek(fi,ipointers(it),'bof'); fgetl(fi);
if rank == 2
  timestepdata = fscanf(fi, '%g',[8,inf])';
else
  timestepdata = fscanf(fi, '%g',[10,inf])';
end

nn=size(timestepdata,1);

compdata = sparse(timestepdata(:,1)+1,ones(nn,1),timestepdata(:,comp+1));
eldata = reshape(compdata(conn+1,1),size(conn));

% make plot

if np==6
  xv = reshape(x(:,v),nel*4,4);
  yv = reshape(y(:,v),nel*4,4);
  cv = reshape(eldata(:,v),nel*4,4);
  patch(xv',yv',cv','edgecolor','none');
  if ( piLW > 0 )
    patch(x(:,v0)',y(:,v0)',1,'linewidth',piLW,'facecolor','none');
  end
else
  if ( piLW > 0 )
    patch(x(:,v)',y(:,v)',eldata(:,v)','linewidth',piLW);
  else
    patch(x(:,v)',y(:,v)',eldata(:,v)','edgecolor','none');
  end
end

if comp == rank*2+3
  colorbar off
elseif comp ~= rank*2+1
  recolb(colb);
end

fclose(fi);

disp('Done.')
toc

nameFig;
