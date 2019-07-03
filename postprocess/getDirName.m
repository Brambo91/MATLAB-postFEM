function str = getDirName(levels,p)
% get name of directory
% input: number of levels displayed

if nargin < 1
  levels = 2;
end
levels = max(1,levels);

if nargin < 2
  p = pwd;
end

s = regexp(p,'\/','split');

n = length(s);

i0 = max(1,n+1-levels);

str = s{i0};
for i=i0+1:n
  str = [ str '/' s{i} ];
end

