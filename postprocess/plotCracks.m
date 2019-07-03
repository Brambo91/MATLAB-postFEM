function plotCracks( it, iplies, icracks )

% postprocessing for cracks. Args: it, iplies, icracks

% Reads from one of the files which name matches the search pattern
% [ prepend.*.crack ] where prepend is a global variable. These files are
% sorted alphabetically and numbers 'iplies' of this list is used.

if isempty(findobj('tag','mesh'))
  % plotMeshOld
  plotMesh
else
  setAxes mesh;
  oldcracks = findall(gca,'tag','crack');
  set(oldcracks,'visible','off')
end

disp('PlotCracks: Crack postprocessing')
disp('input: time step number, ply number(s)')

if nargin < 2
  iplies = [];
end

if nargin < 1 
  it = [];
end

if nargin < 3 
  crackPlotFunction ( it, iplies, 1, 0 );
else
  crackPlotFunction ( it, iplies, 1, 0, icracks );
end
