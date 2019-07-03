function postintf(it,comp,iint)

% Postprocessing for interface damage. Args: it,comp,iint

% Reads from one of the files which name matches the search pattern
% interface*. These files are sorted alphabetically and number 'iint' 
% of this list is used.

disp('Postintf: Interface postprocessing')
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

% read first line which says 'coordinates' 
fgetl(fi);

% read second line which has the rank;
rank = str2double(fgetl(fi));

if nargin<2 || isempty(comp)
  comp = rank*2+1;
elseif comp > rank*2+3
  error(['Non-existing component, should be smaller than ' num2str(rank*2+3)]);
end

disp('Initialized files')
toc

%% read coordinates (hopefully newton-cotes integration!)

if rank == 2
  coords = fscanf(fi, '%g %g %g %g',[4,inf])';
elseif rank == 3
  coords = fscanf(fi, '%g %g %g %g %g',[5,inf])';
end

nel = max(coords(:,1))+1;
np = max(coords(:,2))+1;
if np*nel ~= length(coords)
  disp('something''s wrong! is number of ip''s per element constant?')
end
if np == 2
  disp('Sorry, postintf cannot deal with line interfaces.')
  return
end
x = reshape(coords(:,3),np,nel)';
y = reshape(coords(:,4),np,nel)';
disp('Coordinates have been read (dat). ')
toc

if np==3
  v = [1,2,3,1];  % to avoid confusion with rgb-values
elseif np == 6
  v=[1 2 6 1;3 4 2 3;5 6 4 5;2 4 6 2];
  v0 = 1:np;
elseif np==4
  v = [1 2 4 3];
else
  disp('unknown number of nodes/ips')
  return
end

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

disp('Figure has been prepared. ')
toc 

%% read data from correct time step

% find pointers to time step data and number of time steps

eval(['!grep -b new ' filename ' > ipointers.dat'])
load ipointers.dat
!rm ipointers.dat
nt = length(ipointers);

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
  timestepdata = fscanf(fi, '%g %g %g %g %g %g %g %g %g',[9,inf]);
else
  timestepdata = fscanf(fi, '%g %g %g %g %g %g %g %g %g %g %g',[11,inf]);
end

nip = max(timestepdata(2,:)) + 1;
if nip > 1
  compdata = reshape(timestepdata(comp+2,:),nip,nel)';
  vc = v;
else
  compdata = timestepdata(comp+2,:)';
  vc = ones(1,length(v));
end

% make plot

if np==6
  xv = reshape(x(:,v),nel*4,4);
  yv = reshape(y(:,v),nel*4,4);
  cv = reshape(compdata(:,v),nel*4,4);
  patch(xv',yv',cv','edgecolor','none');
  if ( piLW > 0 )
    patch(x(:,v0)',y(:,v0)',1,'linewidth',piLW,'facecolor','none');
  end
else
  if ( piLW > 0 )
    patch(x(:,v)',y(:,v)',compdata(:,vc)','linewidth',piLW);
  else
    patch(x(:,v)',y(:,v)',compdata(:,vc)','edgecolor','none');
  end
end

if comp == rank*2+3
  colorbar off
elseif comp ~= rank*2+1
  % recolb(colb);
end

fclose(fi);

disp('Done.')
toc

% nameFig;
