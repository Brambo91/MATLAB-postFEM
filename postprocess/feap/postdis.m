function postdis(comp,scale,it)

% deformed mesh in 3D
% with nodal displacement contour
% uses file ix.dat, coord.dat from UOUT,INIT
%       and ndis.dat from UOUT,NDIS

disp('Deformed mesh with nodal displacement contour')
disp('Optional arguments: component, scale, time step')

% initialize
load ndis.dat
load coord.dat
load ix.dat
if size(ndis,2)==6
  nrea=ndis(:,4:6);
  ndis=ndis(:,1:3);
end
nn = length(coord);
nel = size(ix,1);
nt = length(ndis)/nn;

% default values
if nargin < 3, it = nt; end
if nargin < 2, scale = 1; end
if nargin < 1, comp = 1; end

% correct values
if comp < 1 || comp > 3 
  comp = 1;
  disp('Invalid comp. Component set to 1.')
end
if it < 1 || it > nt
  it = nt;
  disp('Invalid it. Time step number set to nt.')
end

% matrix with local node nubers per face
face=([1 2 3 4;2 3 7 6;1 2 6 5;1 4 8 5;3 4 8 7;5 6 7 8]);

% compute coordinates in deformed state
r0=(it-1)*nn;
if length(scale)==3
  for i=1:3
    coordd(r0+1:r0+nn,i) = coord(:,i)+scale(i)*ndis(r0+1:r0+nn,i);
  end
else
  coordd(r0+1:r0+nn,:)=coord+scale*ndis(r0+1:r0+nn,:);
end

% limit values
clims=[min([coord;coordd]);max([coord;coordd])];

% time stepping loop
r0=(it-1)*nn;
flg1=1;

% facewise assembly of information for shaded surfaces

for iel=1:nel
  
  % eleminitate possible interface elements
  
  n1 = ix(iel,1);
  n5 = ix(iel,5);
  
  if norm( coord(n1,:) - coord(n5,:) ) > 1e-5 

    for iface=1:6

      facen=ix(iel,face(iface,:));
      facec=coord(facen,:);
      facecd=coordd(r0+facen,:);
      faceu=facecd(:,comp)-facec(:,comp);

      midpoint=mean(facec);

  %     if midpoint(3)==0
      if flg1==1
        flg1=0;
        X=facecd(:,1);
        Y=facecd(:,2);
        Z=facecd(:,3);
        U=faceu;
      else
        X=[X facecd(:,1)];
        Y=[Y facecd(:,2)];
        Z=[Z facecd(:,3)];
        U=[U faceu];
      end
  %     end

    end

  end

end

% make and fancy up figure
H=fill3(X,Y,Z,U,'Linewidth',.1);
xlim(clims(:,1));
ylim(clims(:,2));
zlim(clims(:,3));
set(gca,'dataaspectratio',[1 1 1])
axis off
view(2)
set(gca,'Fontsize',8)
set(gca,'Position',[0 0 0.85 1])
set(gcf,'Paperposition',[0.25 0.25 3 1.3])


