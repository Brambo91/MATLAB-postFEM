function go2mydir

% this function sets the current path to the directory where the function
% is located from which go2mydir is called

ST = dbstack('-completenames');

if size(ST) == 1
  error('go2mydir must be called from another file!')
end

% find full filename from which go2mydir was called

filename = ST(2).file;
slashes = findstr('/',filename);

dirname = filename(1:slashes(end)-1);

if ( ~strcmp(pwd,dirname) )
  fprintf('go2mydir: changing path to %s\n',dirname)
  cd(filename(1:slashes(end)))
end
