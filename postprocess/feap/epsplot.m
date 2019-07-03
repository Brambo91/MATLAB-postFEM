function epsplot(it,comp)

disp('Contour plot of strain')
disp('Inputs: time step [nt], component [1]')


%----------------
% initialize and check input
%----------------

tic 

scale=1;

if nargin<2
  comp = 1;
  if nargin < 1
    it = lzr;
  elseif ischar(it)
    it = str2double(it);
  end
end

%% run from here for debugging (set it and comp manually)

%----------------
% read data
%----------------

fclose('all');

load ix.dat
load coord.dat
fn = fopen('ndis.dat');

% number of nodes
nn = length(coord);

% number of elements
nel = length(ix);

% bits and words per line in ndis
l1 = fgetl(fn);
nbn = length(l1)+1;
nwn = length(str2num(l1)); %#ok<ST2NM>

% number of lines in ndis
fseek(fn, 0, 'eof');
nln = ftell(fn)/nbn;

% read ndis for time step it
ndis = zeros(nn,nwn);
fseek( fn , nbn*nn*(it-1) , 'bof' );
for i=1:nn
  ndis(i,:) = str2num( fgetl(fn) ); %#ok<ST2NM>
end

% close files
fclose(fn);

disp('Data has been read. ')
toc

%-----------------------
%  initialize figure
%-----------------------

clf
axis off
view([-50 35])
set(gca,'dataaspectratio',[1 1 1])

contrastmap
set(gcf,'Paperposition',[0.25 0.25 16 9])  % for slide
set(gcf,'Paperposition',[0 0 4.5 3])
set(gca,'Position',[0.05 0. 0.8 1])
colorbar('Position',[0.9 0.3 0.02 0.4]);
set(gca,'Fontsize',8)

if exist('./postg_settings.m','file') 
  postg_settings
elseif exist('../postg_settings.m','file')
  addpath ../
  postg_settings
  rmpath ../
end

disp('Figure has been prepared. ')
toc 


%----------------
% make plot
%----------------

xin = [ -1 1 1 -1 -1 1 1 -1 ; -1 -1 1 1 -1 -1 1 1 ; -1 -1 -1 -1 1 1 1 1];
xig = 1/sqrt(3) * xin;

% matrix for projection from Gauss points to Nodes
N1d=[1+1/sqrt(3) 1-1/sqrt(3)]/2;
N3d=[N1d(1)^3 N1d(1)^2*N1d(2) N1d(1)*N1d(2)^2 N1d(2)^3];
ign=[1 2 3 2;2 1 2 3;3 2 1 2;2 3 2 1];
ign=[ign ign+1;ign+1 ign];
gn=N3d(ign);
gn=gn^(-1);

% deformed mesh coordinates
coordd=coord+scale*ndis;

% initialize some stuff
epsg = zeros(6,8);
N = zeros(1,8);
dNdxi = zeros(8,3);

% matrix with local node nubers per face
face=([1 2 3 4;2 3 7 6;1 2 6 5;1 4 8 5;3 4 8 7;5 6 7 8]);

for iel=1:nel  % elements

  % get element displacements

  nodes = ix(iel,:);
  elcoord = coord(nodes,:);
  eldis = ndis(nodes,:);

  for ig = 1:8  % gauss points

    xi = xig(:,ig);

    % evaluate shape functions and derivatives

    for in = 1:8 

      N(in) = ( 1 +  xi(1)*xin(1,in) ) * (1 + xi(2)*xin(2,in) ) * ( 1 + xi(3)*xin(3,in) ) / 8;
      dNdxi(in,1) = xin(1,in) * (1 + xi(2)*xin(2,in) ) * ( 1 + xi(3)*xin(3,in) ) / 8;
      dNdxi(in,2) = xin(2,in) * (1 + xi(1)*xin(1,in) ) * ( 1 + xi(3)*xin(3,in) ) / 8;
      dNdxi(in,3) = xin(3,in) * (1 + xi(2)*xin(2,in) ) * ( 1 + xi(1)*xin(1,in) ) / 8;

    end

    jac = dNdxi' * elcoord;

    dNdx = (jac^(-1)*dNdxi')';

    % evaluate strain

    epsg(1,ig) = dot( dNdx(:,1) , eldis(:,1) );
    epsg(2,ig) = dot( dNdx(:,2) , eldis(:,2) );
    epsg(3,ig) = dot( dNdx(:,3) , eldis(:,3) );
    epsg(4,ig) = dot( dNdx(:,1) , eldis(:,2) ) + dot( dNdx(:,2) , eldis(:,1) );
    epsg(5,ig) = dot( dNdx(:,2) , eldis(:,3) ) + dot( dNdx(:,3) , eldis(:,2) );
    epsg(6,ig) = dot( dNdx(:,3) , eldis(:,1) ) + dot( dNdx(:,1) , eldis(:,3) );

  end  % gauss points
  
  epsn = epsg*gn;
  
  for iface=1:6  % element faces

    facen = nodes(face(iface,:));
    facecd = coordd(facen,:);
    faceu = epsn(comp,face(iface,:));
    
    facec=coord(facen, : );
    
    if exist('dom','var')
      midpoint=mean(facec);       %#ok<NASGU>
%       eval(['draw = ' dom ';']);
      draw = eval(dom);
    else
      draw = 1;
    end
    
    if draw
      patch(facecd(:,1),facecd(:,2),facecd(:,3),faceu,'Linewidth',.1);
    end

  end
  
end  % elements

recolb

disp('Figure has been made')
toc