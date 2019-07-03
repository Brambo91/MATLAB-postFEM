function pg(it,comp)
% contour plot of gauss point output in 3D for single time step
% uses file hisv.dat generated with FEAP macro UOUT,HISV
%       and ix.dat, coord.dat from UOUT,INIT
%       and ndis.dat from UOUT,NDIS

disp('POSTGAUST: Contour plot of gauss point output in 3D for single time step')
disp(['Optional arguments: component, time step'])
% disp('Time step: Default is final time step')
% disp('Component: Default is 1')
% disp('           plas: [1:8]=>[1-h,kappa,epsp1:epsp6]')
% disp('           dam : [1:2]=>[d1:d2]')

%% initialize

figure(2)
clf

scale = 1;

tic

%% load data

fclose('all');

load ix.dat
load coord.dat
fh = fopen('hisv.dat');
fn = fopen('ndis.dat');

% number of nodes
nn = length(coord);

% bits and words per line in hisv
l1 = fgetl(fh);
nbh = length(l1)+1;
nwh = length(str2num(l1)); %#ok<ST2NM>
if nwh <7
  model='dama';
else
  model='plas';
end

% component
if nargin<2
  if strcmp(model,'plas')
    comp=3;   % default damage
  else
    comp=4;
  end
else
  comp=comp+2;
end

% number of lines in hisv
fseek(fh, 0, 'eof');
nlh = ftell(fh)/nbh;

% bits and words per line in ndis
l1 = fgetl(fn);
nbn = length(l1)+1;
nwn = length(str2num(l1)); %#ok<ST2NM>

% number of lines in ndis
fseek(fn, 0, 'eof');
nln = ftell(fn)/nbn;

% number of time steps
nt = nln/nn;
if nargin < 1
  it = nt;
  disp(['it = ',num2str(nt)]);
elseif ischar(it)
  it = str2double(it); 
end

% number of gauss points in hisv
np = nlh/nt;


% read hisv for time step it
hisv = zeros(np,nwh);
fseek( fh , nbh*np*(it-1) , 'bof' );
for i=1:np
  hisv(i,:) = str2num( fgetl(fh) ); %#ok<ST2NM>
  if strcmp(model,'plas')
    hisv(i,3) = 1 - hisv(i,3);
  end
end

% read ndis for time step it
ndis = zeros(nn,nwn);
fseek( fn , nbn*nn*(it-1) , 'bof' );
for i=1:nn
  ndis(i,:) = str2num( fgetl(fn) ); %#ok<ST2NM>
end

% close files
fclose(fh);
fclose(fn);

disp('Data has been read. ')
toc

%%  initialize figure

umin = min(hisv(:,comp));
umax = max(hisv(:,comp));

axis off
view([-50 35])
set(gca,'dataaspectratio',[1 1 1])

if umax-umin > 1e-10
  caxis([umin umax])
else
  disp('WARNING - zero difference')
  caxis([0 1])
end

colormap default
if comp==3 || strcmp(model,'dama')
  caxis([0 1]);
  bonemap
end
set(gcf,'Paperposition',[0.25 0.25 16 9])  % for slide
set(gcf,'Paperposition',[0 0 4.5 3])
set(gca,'Position',[0.05 0. 0.8 1])
colb = colorbar('Position',[0.9 0.3 0.02 0.4]);
set(colb,'Fontsize',8)

cbtitle = get(colb,'title');
set(cbtitle,'fontsize',8)
if strcmp(model,'dama')
  set(cbtitle,'string',['d' num2str(comp-2)]);
elseif comp==3
  set(cbtitle,'string','1-h');
end

ls = '-';

if exist('./postg_settings.m','file') 
  postg_settings
elseif exist('../postg_settings.m','file')
  addpath ../
  postg_settings
  rmpath ../
end

disp('Figure has been prepared. ')
toc 


%% process data

% matrix for projection from Gauss points to Nodes
N1d=[1+1/sqrt(3) 1-1/sqrt(3)]/2;
N3d=[N1d(1)^3 N1d(1)^2*N1d(2) N1d(1)*N1d(2)^2 N1d(2)^3];
ign=[1 2 3 2;2 1 2 3;3 2 1 2;2 3 2 1];
ign=[ign ign+1;ign+1 ign];
gn=N3d(ign);
gn=gn^(-1);

% matrix with local node nubers per face
face=([1 2 3 4;2 3 7 6;1 2 6 5;1 4 8 5;3 4 8 7;5 6 7 8]);

% which elements in postprocessing
nel=np/8;
elnums=zeros(1,nel);
for iel=1:nel
  elnums(iel)=hisv(iel*8,1);
end

% reorder relevant results in array
ug=zeros(nel,8);
for iel=1:nel
  r0=(iel-1)*8;
  ug(iel,:)=hisv(r0+1:r0+8,comp);
end
% coordd=coord+[scale*ndis(:,1:2) zeros(nn,1)];
% disp('no displacement in z-direction!')
coordd=coord+scale*ndis(:,1:3);

% project values to nodes: un(:,i) = sum ( Ni(xj) * ug(:,j) )
un=ug*gn;

% elements that will be plotted

els = 1:nel;

% nlayer = 3;
% nell = nel/nlayer;
% ilayer = 2;
% disp('single layer')
% els = (ilayer - 1) * nell + ( 1 : nell );

% facewise assembly of information for shaded surfaces

for iel=els
  for iface=1:6

    jel=elnums(iel);
    facen=ix(jel,face(iface,:));
    facecd=coordd(facen,:);
    faceu=un(iel,face(iface,:))';
    
    facec=coord(facen,:);
    
    if exist('dom','var')
      midpoint=mean(facec);       %#ok<NASGU>
%       eval(['draw = ' dom ';']);
      draw = eval(dom);
    else
      draw = 1;
    end

    if draw
      patch(facecd(:,1),facecd(:,2),facecd(:,3),faceu,'Linewidth',.1,'linestyle',ls);
    end

  end

end

disp('Figure has been made. ')
toc

