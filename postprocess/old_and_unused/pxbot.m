function pxbot(it)

% postprocessing for jemjive with xfem. Arg: it
% plot of deformed mesh with fancy crack vizualization for single time step
% uses file hisv.dat generated with FEAP macro UOUT,HISV
%       and ix.dat, coord.dat from UOUT,INIT
%       and ndis.dat from UOUT,NDIS

disp('PX: deformed mesh with fancy crack vizualization for single time step')
disp('Optional argument: time step')
% disp('Time step: Default is final time step')

scale = 50;

%% initialize files

tic

fclose('all');

% find pointers to beginning of time step in files

!grep -b new displacements.dat > dpointers.dat
!grep -b new stress.dat > hpointers.dat

load dpointers.dat
load hpointers.dat

!rm *pointers.dat

% find number of time steps
nt = min( [ length(dpointers), length(hpointers) ] );
if nargin < 1
  it = nt-1
elseif it > nt
  disp('time step doesnt exist')
  disp(['nt = ', num2str(nt)])
  return;
end

% open files

eFile = fopen('elements.dat');
dFile = fopen('displacements.dat');
hFile = fopen('stress.dat');
load nodes.dat
u = zeros(length(nodes),2);

% jump to correct position

fseek(dFile,dpointers(it),'bof'); fgetl(dFile);
fseek(hFile,hpointers(it),'bof'); fgetl(hFile);

disp('Initialized files')
toc

%% initialize plot

figure(1)
clf

caxis([0 1])
xlim([-20 30])
ylim([-15 10])

contrastmap(2,150)

colb = colorbar('Position',[0.9 0.3 0.02 0.4]);
set(colb,'fontsize',8)
cbtitle = get(colb,'title');
set(cbtitle,'fontsize',8)
set(cbtitle,'string','\sigma^{eq}');

set(gca,'dataaspectratio',[1 1 1])
set(gcf,'Paperposition',[0 0 3 2])
set(gca,'Position',[0.1 0.05 0.8 0.9]);

axis off

disp('Initialized plot')
toc

%% read and process data

% read displacements

el = fscanf(dFile, '%g %g %g',[3,inf]);
u(el(1,:)+1,:) = el(2:3,:)';

% read and plot elements and nodal values

load elements.dat
nels = length(elements);
for i=1:nels
  elements(i,7) = sum(elements(i,2:6)~=-1);  % store number of nodes
end


iel = 0;
while 1
%   eLine = fgetl(eFile);
  hLine = fgetl(hFile);
  if hLine(1) == 'n',   break,   end
  c = str2num(hLine);    %#ok<ST2NM>
  iel = find( elements(:,1)==c(1),1,'last' );    % 1,'last' for when el 0 is cracked...
  el = elements( iel , 1 : elements(iel,7)+1 );
  if length(c)>1
    c = c(2:length(el));
    elnodes = el(2:length(el))+1;
    elxs = nodes(elnodes,2)+scale*u(elnodes,1);
    elys = nodes(elnodes,3)+scale*u(elnodes,2);
    if length(c)==3
      elxs = [elxs;elxs(1)];
      elys = [elys;elys(1)];
      c = [c,c(1)];
    end
    z = any(elnodes < (4872/2) ) * ones(1,length(elxs)) * 20;
    if z(1)>0 
      patch(elxs,elys,z,c,'Linewidth',.1);
    end
  end
end

disp('Done')
toc
