function h = postTLS(it)
% postprocessing for level set field
% shell around doPostLS
% finds file defined as from *.ls
% arg: it

% set default values

if ( nargin < 1 )
  it = getNT('ls');
end

% find the file in the current directory

filename = findFile('ls');

% call doPostLS function with right arguments 

tmp = ...
doPostLS ( ...
 1,        ... % component to be plotted
 1,        ... % number of components in file
 filename, ... % file name
 'new',    ... % header tag
 it        );  % time step number 

% colormap([softgray;ones(19,1)*lblue;lgold])
tlsmap

caxis([0,findInPro('lc')*1.05])

% plot zero and lc level sets for the same time step

addIso0(it,dred)
addIsoLc(it,dred)

if nargout > 0
  h = tmp;
end

nameFig
