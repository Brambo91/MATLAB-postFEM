function [iout,ncomp] = getColumn(header,comp)
% find column number in table written by jemjive
% arguments: table header and component name

% if a number is given, increment with 1 (for node number column)

words = getColumnItems(header);
ncomp = length(words);
if ncomp == 0
  error('table is empty')
end

iout = 0;

if ( isnumeric(comp) )
  iout = comp+1;
  if ( comp > ncomp || comp < 1 )
    iout = [];
  else 
    fprintf('component number %g corresponds to ''%s'' data\n\n',comp,words{comp})
  end
else
  for i = 1:ncomp
    if strcmp(comp,words{i})
      iout = i+1;
      break
    end
  end
end

