function postdefm

disp('Deformed mesh in 3D--movie')
disp('Rather use postdis for output per time step')
% deformed mesh in 3D
% uses file ix.dat, coord.dat from UOUT,INIT
%       and ndis.dat from UOUT,NDIS

% initialize
scale=1;
load ndis.dat
load coord.dat
load ix.dat
if size(ndis,2)==6 
  nrea=ndis(:,4:6);
end
ndis=ndis(:,1:3);

% matrix with local node nubers per face
face=([1 2 3 4;2 3 7 6;1 2 6 5;1 4 8 5;3 4 8 7;5 6 7 8]);

% which elements in postprocessing
nn=length(coord);
nel=size(ix,1);
nt=length(ndis)/nn;

% compute coordinates in deformed state
for it=1:nt
  r0=(it-1)*nn;
  coordd(r0+1:r0+nn,:)=coord+scale*ndis(r0+1:r0+nn,:);
end

% limit values
clims=[min([coord;coordd]);max([coord;coordd])];


% time stepping loop
it1=1;
for it=it1:nt
  r0=(it-1)*nn;
  flg1=1;

  % facewise assembly of information for shaded surfaces
  for iel=1:nel
    for iface=1:6

      facen=ix(iel,face(iface,:));
      facec=coord(facen,:);
      facecd=coordd(r0+facen,:);
%       if exist('nrea','var')
%         faceu=nrea(r0+facen,2);
%       else
        faceu=facecd(:,3)-facec(:,3);
%       end
      
      midpoint=mean(facec);

%       if ismember(iel,[1:14:71]) 

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

%       end

    end

  end

  % make and fancy up figure
  H=fill3(X,Y,Z,U,'Linewidth',.1);
  xlim(clims(:,1));
  ylim(clims(:,2));
  zlim(clims(:,3));
  set(gca,'dataaspectratio',[1 1 1])
  axis off
%   text(10,-1,num2str(max(max(abs(U)))));
%   text(18,-1,num2str(it));
  view([-130 30]);
  set(gca,'Fontsize',8)
  set(gca,'Position',[0 0 0.85 1])
  set(gcf,'Paperposition',[0.25 0.25 3 1.3])

  F(it-it1+1)=getframe;   %#ok<AGROW>

end

% %% reorder ndis
% for it=1:nt
%   r0=(it-1)*nn;
% %   cddr(:,:,it)=coord+scale*ndis(r0+1:r0+nn,:);
%   cddx(:,it)=ndis(r0+1:r0+nn,1);
%   cddy(:,it)=ndis(r0+1:r0+nn,2);
%   cddz(:,it)=ndis(r0+1:r0+nn,3);
% end
% 
% for it=1:nt-1
%   deltaux(:,it)=(cddx(:,it+1)-cddx(:,it))*1e6;
%   deltauy(:,it)=(cddy(:,it+1)-cddy(:,it))*1e6;
%   deltauz(:,it)=(cddz(:,it+1)-cddz(:,it))*1e6;
% end

% %% do st with reactions
% for it=1:nt
%   r0=(it-1)*nn;
%   react(:,:,it)=nrea(r0+1:r0+nn,:);
% end
% 
% clear rxt ryt rzt
% 
% rxt(:,:)=react(:,1,:);
% ryt(:,:)=react(:,2,:);
% rzt(:,:)=react(:,3,:);