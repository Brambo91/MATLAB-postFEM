function labelCracks( it, iplies, icracks )

% postprocessing for cracks. Arguments: it, iplies, icracks 

% Reads from one of the files which name matches the search pattern
% [ prepend.*.crack ] where prepend is a global variable. These files are
% sorted alphabetically and numbers 'iplies' of this list is used.

if isempty(findobj('tag','mesh'))
  plotMeshOld;
  doCracks = 1;
else
  setAxes mesh;
  doCracks = isempty ( findall(gca,'tag','crack') );
end

if nargin < 2
  iplies = [];
end

if nargin < 1 
  it = [];
end

if nargin < 3 
  crackPlotFunction( it, iplies, doCracks, 1 );
else
  crackPlotFunction( it, iplies, doCracks, 1, icracks );
end

