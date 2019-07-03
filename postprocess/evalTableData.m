function out = evalTableData(filename,xit,expression)
% evaluate data in table written by jemjive
% arguments: filename, time step number and component expression
% returns: nx2 matrix with [ nodeNumbers , nodalValues ]

vars = symvar(expression);
nv = length(vars);

if ( nv == 1 && strcmp(vars{1},expression) )
  % direct evaluation
  out = getTableData(filename,xit,expression);
  return
end

% for each component do:

for i = 1:nv

  % 1. get table data

  tmp = getTableData(filename,xit,vars{i});

  % 2. check size

  if ( i == 1 )
    out(:,1) = tmp(:,1);
  else
    if ( size(tmp,1) ~= size(out,1) )
      out = altImplementation(filename,xit,expression);
      return
    end
  end

  % 3. store under its name

  eval([vars{i} ' = tmp(:,2);'])

end

% finally evaluate the user defined expression

eval(['out(:,2) = ' expression ';']);

%-----------------------------------------------------------------
%  altImplementation
%-----------------------------------------------------------------

function out = altImplementation(filename,xit,expression)
% alternative implementation that can deal with variables defined
% on non-matching domains

vars = symvar(expression);
nv = length(vars);

% for each component do:

global gcoords

out(:,1) = 1:size(gcoords,1);

for i = 1:nv

  % 1. get table data

  tmp = getTableData(filename,xit,vars{i});

  % 2. assume zero values for undefined nodes

  idata = zeros(size(out,1),1);
  idata(tmp(:,1)) = tmp(:,2);

  % 3. store under its name

  eval([vars{i} ' = idata;'])

end

% finally evaluate the user defined expression

eval(['out(:,2) = ' expression ';']);


