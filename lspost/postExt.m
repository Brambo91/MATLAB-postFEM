function postExt(it,icomp)
% postprocessing for external force vector
% shell around doPostLS
% finds file defined as from *.ext
% arg: it

% set default values

if ( nargin < 1 )
  it = '';
end

if ( nargin < 2 )
  icomp = 1;
end

% find the file in the current directory

filename = findFile('fext');

% call doPostLS function with right arguments 

doPostLS ( ...
 icomp,        ... % component to be plotted
 1,        ... % number of components in file
 filename, ... % file name
 'new',    ... % header tag
 it        )   % time step number 

% plot zero level set for the same time step

addIso0(it)
