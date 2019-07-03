function postXvel(it)
% postprocessing for extended velocity field
% shell around doPostLS
% finds file defined as from *.xvn
% arg: it

% set default values

if ( nargin < 1 )
  it = getNT('xvn');
end

% find the file in the current directory

filename = findFile('xvn');

% call doPostLS function with right arguments 

doPostLS ( ...
 1,        ... % component to be plotted
 1,        ... % number of components in file
 filename, ... % file name
 'new',    ... % header tag
 it        )   % time step number 

if ( findFile('iso0') )
  addIso0(it,[.99 .99 .99]);
end
if ( findFile('isoLc') ) 
  addIsoLc(it,[.99 .99 .99]);
end

colormap(jet(12))