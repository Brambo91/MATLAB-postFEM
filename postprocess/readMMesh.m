function readMMesh(filename)

% reads mesh data from mesh file
% argument: filename
% default: first file in this directory that matches *.mesh

global gconn
global gcoords
global gnn
global gnel

if ( nargin < 1 )
  filename = findFile('mesh');
end

mfile = fopen(filename);

% read mesh info (only works for 2d)

% nodes

fgetl(mfile) ;   %   <Nodes>
firstNd = str2num(fgetl(mfile));
nword = length(firstNd);
str = 'rest = fscanf(mfile,''';
for i =1:nword; str = [ str '%g ' ]; end
str = [ str ';'',[' num2str(nword) ',Inf]);'];
eval(str)

coords = [ firstNd ; rest' ]';
fgetl(mfile) ;   %   </Nodes>
fgetl(mfile) ;   %
fgetl(mfile) ;   %   </Elements>  

% elements

firstEl = str2num(fgetl(mfile));
nword = length(firstEl);

str = 'rest = fscanf(mfile,''';
for i =1:nword; str = [ str '%g ' ]; end
str = [ str ';'',[' num2str(nword) ',Inf]);'];
eval(str);

conn = [ firstEl ; rest' ];

% store global quantities, compatible with gmsh

gcoords = coords ( 2:end, : )';
gconn = conn ( :, 2:nword );
gnn = size(gcoords,1);
gnel = size(conn,1);

fclose('all');
