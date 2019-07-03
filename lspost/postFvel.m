function postFvel(it)
% postprocessing for front velocity field
% shell around doPostLS
% finds file defined as from *.vn
% arg: it

% set default values

if ( nargin < 1 )
  it = getNT('vn');
end

% find the file in the current directory

filename = findFile('vn');

% call doPostLS function with right arguments 

doPostLS ( ...
 1,        ... % component to be plotted
 1,        ... % number of components in file
 filename, ... % file name
 'new',    ... % header tag
 it        )   % time step number 

% plot zero level set for the same time step

addIso0(it,[.99 .99 .99])
