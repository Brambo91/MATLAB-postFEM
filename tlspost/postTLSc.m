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

% plot zero and lc level sets for the same time step

addIsoLc(it,dred)

tlsmap;
caxis([0,findInPro('lc')*1.05])

if nargout > 0
  h = tmp;
end

nameFig
