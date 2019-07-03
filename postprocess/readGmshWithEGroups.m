function readGmshWithEGroups(filename)

global gmshphys
global gmshegroups

if nargin < 1
  filename = findFile('msh');
end

readGmsh(filename)

iphys = unique(gmshphys);

for i = 1:length(iphys)
  gmshegroups{i} = find(gmshphys==iphys(i));
  nel = length(gmshegroups{i});
  fprintf('%i found elementgroup with id %i, (%i elems)\n',i,iphys(i),nel);
end


