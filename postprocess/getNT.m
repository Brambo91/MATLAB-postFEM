function nt = getNT(extension)

% open data file

if ( nargin < 1 )
  load lodi.dat
  nt = max(lodi(:,1));
else
  filename = findFile(extension);
  lfile = fopen(filename);

  eval(['!grep -b new ' filename ' > ipointers.dat'])
  load ipointers.dat
  nt = size(ipointers,1);
  !rm ipointers.dat
end

