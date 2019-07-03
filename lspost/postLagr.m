function postLagr(it,iz,comp)
% postprocessing for lagrange multiplier field
% shell around doPostLS
% finds file defined as from *.lagr[iz]
% args: it, iz, comp

% set default values

if ( nargin < 3 )
  comp = 3;
if ( nargin < 2 )
  iz = 0;
end
end

extension = ['lagr' num2str(iz)];
filename = findFile(extension);

if ( nargin < 1 )
  it = getNT(extension);
end

% find the file in the current directory

% call doPostLS function with right arguments 

doPostLS ( ...
 comp,     ... % component to be plotted
 2,        ... % number of components in file
 filename, ... % file name
 'new',    ... % header tag
 it        )   % time step number 

addIso0(it)
