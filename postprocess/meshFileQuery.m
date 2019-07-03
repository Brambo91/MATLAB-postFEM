function meshFileQuery(flag)

fprintf('\n\n')

gmsh = dir('*.msh');
mesh = dir('*.mesh');
lmsh = dir('*.lmsh');

all = [gmsh;mesh;lmsh];
nfiles = length(all);

if ( nfiles > 1 )

  fprintf('********** meshFileQuery ********************************\n')

  if ( nargin > 0 )
    fprintf('  A problem has been encountered that might be related to\n')
    fprintf('  reading from the wrong mesh file.\n')
  else
    fprintf('  Do you want to read from another mesh file?\n')
  end

  fprintf('  %i mesh files have been found:\n',length(all))
  for i=1:nfiles
    fprintf('    [%i]: %s\n',i,all(i).name);
  end
  imsh = '';

  fprintf('  you can now set one of these as the mesh file\n');
  fprintf('  (or use control-C to exit)\n')

  while ( isempty(imsh) || imsh < 1 || imsh > nfiles )
    str = sprintf('  please give an integer between %i and %i\n',1,nfiles);
    imsh = input(str);
  end

  setMeshFile(all(imsh).name);
  fprintf('\n  mesh file set to %s\n',all(imsh).name);

  if ( nargin > 0 )
    fprintf('  now try to rerun your function\n\n')
  end
  fprintf('********** meshFileQuery ********************************\n\n')

else

  fprintf('********** meshFileQuery ********************************\n')
  fprintf('  no more than one mesh file found, you have got nothing \n')
  fprintf('  to choose\n')
  fprintf('********** meshFileQuery ********************************\n\n')

end


