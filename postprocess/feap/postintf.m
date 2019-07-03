function postintf(it,comp)

% postprocessing for interface damage

%% initialize

clf

if nargin<2
  comp=10;   % default damage
else
  comp=comp+3;
end

tic

%% load data

load coord.dat
load ix.dat

fclose('all');

fi = fopen('intf.dat');

% bits and words per line in intf
l1 = fgetl(fi);
nbi = length(l1)+1;
nwi = length(str2num(l1)); %#ok<ST2NM>

% number of elements
fseek(fi,0,'bof');
nels = 0;
iel1 = str2double(l1(15:18));
while ~feof(fi)
  li = fgetl(fi);
  fseek(fi, 3*nbi, 'cof');
  iel=str2double(li(15:18));
  if iel==iel1 && nels~=0
    break
  else
    nels = nels+1;
    els(nels) = iel;
  end
end
    
% number of lines in intf
fseek(fi, 0, 'eof');
nli = ftell(fi)/nbi;

% number of time steps
nr=nels*4;
nt=nli/nr;
if nargin<1
  it = nt
end

% read intf for time step it
if it>nt
  disp(['no information for it = ' num2str(it) ', nt = ' num2str(nt)])
  return
end
intf = zeros(nr,10);
fseek( fi , nbi*nr*(it-1) , 'bof' );
for i=1:nr
  lin = str2num( fgetl(fi) ); %#ok<ST2NM>
  intf(i,:) = lin(1:10);
end

% close files
fclose(fi);

disp('Data has been read. ')
toc

%% initialize figure

umin = min(intf(:,comp));
umax = max(intf(:,comp));

% xlim([50 71])

set(gca,'dataaspectratio',[1 1 1])
% set(gca,'dataAspectRatioMode','auto')

caxis([umin umax])

% nice print view: default with white minimum  
colormap default

if comp==10
  % nice print view: inverse bone
  bonemap
  caxis([0 1]);
end

set(gcf,'paperPosition',[0 0 3.6 2.4]);
set(gca,'Position',[0.1 0.05 0.8 0.9]);

% colb = colorbar('Position',[0.90 0.05 0.0333 0.5],'ytick',[0 0.5 1]);
colb = colorbar('Position',[0.93 0.25 0.02 0.5]);
set(colb,'Fontsize',10)
cbtitle = get(colb,'title');
set(cbtitle,'fontsize',10)
if (comp-3) < 4
  set(cbtitle,'string','\delta');
elseif (comp-3) < 7
  set(cbtitle,'string','t');
else
  set(cbtitle,'string','d');
end

% xlim([0 10])
% ylim([0 10])

axis off
  
disp('Figure has been prepared. ')
toc 

%% make plot

% loop over elements

for iel=1:nels

  r1=iel*4-3;
  nodes=ix(els(iel),1:4);

  facecd = coord(nodes,:);
  faceu = intf(r1:r1+3,comp);
  edgec = 'black';
  
%   %    correct if outside curve
  
%   [rs,bs]=testp(facecd);
% 
%   if sum(bs)>=1  % at least one point inside plot region
% 
%     if sum(bs)==1     % one node inside boundary
% 
%       while bs(1)==0  % make sure that node 1 is inside boundary
%         bs([1 2 3 4])       = bs([2 3 4 1]);
%         rs([1 2 3 4])       = rs([2 3 4 1]);
%         facecd([1 2 3 4],:) = facecd([2 3 4 1],:);
%         faceu([1 2 3 4])    = faceu([2 3 4 1]);
%       end
% 
%       [u2,c2]=findp(faceu([1 2]),facecd([1 2],:),rs([1 2]));
%       [u3,c3]=findp(faceu([1 4]),facecd([1 4],:),rs([1 4]));
%       faceu=([faceu(1);u2;u3]);
%       facecd=([facecd(1,:);c2;c3]);
%       edgec='none';
%       line(facecd([3,1,2],1),facecd([3,1,2],2),'color','k','linewidth',0.1);
%       line(facecd([2,3],1),facecd([2,3],2),'color','k','linewidth',0.5,'linestyle',':');
% 
%     elseif sum(bs)==2 % two nodes inside boundary
% 
%       while bs(1)+bs(2)<2  % make sure that nodes 1 and 2 are inside boundary
%         bs([1 2 3 4])       = bs([2 3 4 1]);
%         rs([1 2 3 4])       = rs([2 3 4 1]);
%         facecd([1 2 3 4],:) = facecd([2 3 4 1],:);
%         faceu([1 2 3 4])    = faceu([2 3 4 1]);
%       end
% 
%       [u3,c3]=findp(faceu([2 3]),facecd([2 3],:),rs([2 3]));
%       [u4,c4]=findp(faceu([1 4]),facecd([1 4],:),rs([1 4]));
%       faceu=([faceu(1:2);u3;u4]);
%       facecd=([facecd(1:2,:);c3;c4]);
%       edgec='none';
%       line(facecd([4,1,2,3],1),facecd([4,1,2,3],2),'color','k','linewidth',0.1);
%       line(facecd([3,4],1),facecd([3,4],2),'color','k','linewidth',0.5,'linestyle',':');
% 
%     elseif sum(bs)==3 % three nodes inside boundary
% 
%       while bs(4)==1  % make sure that node 4 is outside boundary
%         bs([1 2 3 4])       = bs([2 3 4 1]);
%         rs([1 2 3 4])       = rs([2 3 4 1]);
%         facecd([1 2 3 4],:) = facecd([2 3 4 1],:);
%         faceu([1 2 3 4])    = faceu([2 3 4 1]);
%       end
% 
%       [u4,c4]=findp(faceu([3 4]),facecd([3 4],:),rs([3 4]));
%       [u5,c5]=findp(faceu([1 4]),facecd([1 4],:),rs([1 4]));
%       faceu=([faceu(1:3);u4;u5]);
%       facecd=([facecd(1:3,:);c4;c5]);
%       edgec='none';
%       line(facecd([5,1,2,3,4],1),facecd([5,1,2,3,4],2),'color','k','linewidth',0.1);
%       line(facecd([4,5],1),facecd([4,5],2),'color','k','linewidth',0.5,'linestyle',':');
% 
%     end
% 
    patch(facecd(:,1),facecd(:,2),facecd(:,3),faceu,'Linewidth',.1,'Edgecolor',edgec);
    
%   end

end  % elements

disp('Figure has been made. ')
toc

%% ________________________________________________________________________
% FUNCTIONS FOR CROPPING
%% ________________________________________________________________________

function [ratios,booles]=testp(cs)

% function that checks whether points are inside boundary
% bs(i) is true (i.e. 1) if point i inside boundary

ths=atan(cs(:,2)./(cs(:,1)+1e-9));
% xb=12.2*(cos(ths)).^(1)+2*sin(2*ths).^2+sin(18*ths)/6;
% yb=13.2*(sin(ths)).^(1)+2*sin(2*ths).^2+sin(18*ths)/10;
xb=min(12.2,13.2./tan(ths))+sin(16*ths)/6;
yb=min(13.2,12.2./tan(pi/2-ths))+sin(18*ths)/6;
rb=sqrt(xb.^2+yb.^2);
rp=sqrt(cs(:,1).^2+cs(:,2).^2);

ratios = (rp-rb)./rb;
booles = rb>rp;

%% ________________________________________________________________________

function [unew,cnew] =  findp(uold,cold,rs)

% compute intersection between element boundary and plot domain boundary

fac = abs(rs(1)) / ( abs(rs(1)) + abs(rs(2)) );
cnew = cold(1,:) + fac * ( cold(2,:) - cold(1,:) );
unew = uold(1) + fac * ( uold(2) - uold(1) );
