function readGmsh(filename)

% reads mesh data from gmsh file
% argument: filename
% default: first file in this directory that matches *.msh

global gconn
global gcoords
global gnn
global gnel
global gmshphys
global lastMsh

if ( nargin < 1 )
  filename = findFile('msh');
end

D = dir(filename);

if ( ~isempty(lastMsh) && D.datenum == lastMsh && ~isempty(gconn) && ~isempty(gcoords) )
  return
else
  lastMsh = D.datenum;
end

mfile = fopen(filename);

% read leader 

              fgetl(mfile) ;   %   $MeshFormat
fmt = str2num(fgetl(mfile));   % three numbers
              fgetl(mfile) ;   %   $EndMeshFormat
              fgetl(mfile) ;   %   $Nodes
gnn = str2num(fgetl(mfile));   % number of nodes

iphysgroup = 4;  % at least in 2.2
if ( fmt(1) == 2.1 || fmt(1) == 2 )
  iconn0 = 7;
elseif ( fmt(1) == 2.2 )
  iconn0 = 6;
else
  warning(['unknown mesh format ' num2str(fmt(1))])
  iconn0 = 6;
end
% read nodal coordinates

gcoords = fscanf(mfile,'%g %g %g %g',[4,gnn]);
gcoords = gcoords(2:3,:)';
assert(size(gcoords,1)==gnn);

% read lines in between

               fgetl(mfile) ;   %   \n
               fgetl(mfile) ;   %   $EndNodes
               fgetl(mfile) ;   %   $Elements
gnel = str2num(fgetl(mfile));   % number of elements

% read element connectivity (only works for one type of element per mesh)

firstEl = str2num(fgetl(mfile));

nword = length(firstEl);

%BRAM
elType1 = [];%firstEl(1);
elType2 = [];%firstEl(2);

global Alphabet;
Alphabet = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ';
counts   = 0;

for i = 1:gnel-1
    tmp = str2num(fgetl(mfile));

    if( mean(tmp(2) == elType2) == 0 || counts == 0)
        counts  = counts + 1;
        
        elType1 = [ elType1; tmp(1) ];
        elType2 = [ elType2; tmp(2) ];
        
        struct.(Alphabet(counts)) = tmp;
    else
        struct.(Alphabet(counts)) = [ struct.(Alphabet(counts)); tmp ];
    end
    
end
  
% store informatino for making element groups

%gconn = zeros( gnel-1, 8);
cnt   = 2; %counts the next element in gconn matrix to be placed

% store information for making element groups
for i = 1:length(elType2)
    gmshphys  = [gmshphys; struct.(Alphabet(i))(:,iphysgroup) ];
    tags      = struct.(Alphabet(i))(1,3);
    startNode = tags + 4;
    
    struct.(Alphabet(i)) = struct.(Alphabet(i))(:,startNode:end);
    
%     lStruct = size(struct.(Alphabet(i)));
%     
%     switch( elType2(i) )
%         case 2
%             iNodes  = 3;
%         case 3
%             iNodes = 4;
%     end
%     lMatrix = 8 - iNodes - 1;
%     cnt2    = cnt + lStruct(1) - 1;
%     
%     if( i == 1)
%        gconn(1,:) = [iNodes, firstEl(startNode:end), zeros(1,lMatrix)];
%     end
%     
%     gconn(cnt:cnt2,:) = [                                   ...
%                             iNodes.*ones(lStruct(1),1)      ...
%                             struct.(Alphabet(i))            ...
%                             zeros(lStruct(1),lMatrix)       ...
%                         ];
%     cnt = cnt2 + 1;
end

gconn = struct;
%BRAM

%str = 'rest = fscanf(mfile,''';
%for i =1:nword 
%    str = [ str '%g ' ]; 
%end
%str = [ str ''',[' num2str(nword) ',gnel-1]);'];
%eval(str);
%gconn = [ firstEl ; rest' ];

%%%% exclude all elements starting from first element with other type
%%%% (basically, the data obtained with fscanf is rubbish from there on)

% iother = find(gconn(:,2)~=gconn(1,2),1,'first');
% if iother
%   disp('throwing out some elements because of unequal number of nodes')
%   gconn = gconn(1:(iother-1),:);  
% end
%   
%%%% store informatino for making element groups
% 
% gmshphys = gconn(:,iphysgroup);
% 
%%%% exclude information on element type, physical surface, etc
% 
% gconn = gconn ( : , iconn0:nword );
% 
% if ( nword+1-iconn0 == 6 )
%   reorder for 6-node element
% 
%   v = [ 1 4 2 5 3 6 ];
%   gconn(:,1:6) = gconn(:,v);
% end

fclose('all');
