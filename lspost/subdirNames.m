function list = subdirNames(p)
% get names of subdirectories as a cell array
% optional argument: path (default: current path)

if nargin < 1
  p=pwd;
end

% get contents of path (as struct array)
lAll = dir(p);

% remove non-directories from list
lDir = lAll([lAll.isdir]);

% remove '.' and '..' from list
assert(strcmp(lDir(1).name,'.'))
assert(strcmp(lDir(2).name,'..'))
lDir = lDir(3:end);

% return directory names as cell array
list = {lDir.name};
for i = 1:length(list)
  list{i} = strcat(p,filesep,list{i});
end
