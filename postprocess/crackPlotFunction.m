function crackPlotFunction( it, iplies, doCracks, doLabels, icracks )

% postprocessing for cracks. Args: it, iplies, doCracks, doLabels, icracks.

% Reads from one of the files which name matches the search pattern
% [ prepend.*.crack ] where prepend is a global variable. These files are
% sorted alphabetically and numbers 'iplies' of this list is used.
% if doCracks = 1, crack lines are drawn
% if doLabels = 1, crack numbers are added

% linewidth, set to 2 for display, 1.5 or 1 for print
% can be set globally with global crackLW

global crackLW

if ( isempty(crackLW) )
  lw = 2;
else
  lw = crackLW;
end

global crackColShift


if isempty( iplies )
  iplies = 1:getNModels;
end

  
colors = get(gca,'colororder');

if ( colors(1,:) == [ 0 0 1. ] )
  colors(1,:) = dblue;    % use darker blue instead of default first color
end

if ( ~isempty(crackColShift) )
  colors = circshift(colors,-crackColShift);
end
  
for ip = 1:length(iplies)
  
  icol = mod ( iplies(ip)-1, size(colors,1) ) + 1;
  
  
  % load data in variable 'cracks'
  
  filename = findFile('cracks',iplies(ip));

  if ischar(filename)
    eval('cracks = load(filename);')
    disp(['reading from file ' filename ])
  else
    disp(['Invalid crack file number ' num2str(iplies(ip)) ]);
    disp('number of files recognized as crack files:');
    eval(['!ls -1 ' prestring '*.cracks | wc -l'])
    return
  end
  
  %% draw cracks

  if ( isempty(cracks) )
    disp(['no cracks in ' filename ])
    continue
  end

  if ~isempty( it ) && isnumeric( it )
    cracks = cracks( cracks(:,1)<=it,: );
  else
    disp(['nt = ' num2str(max(cracks(:,1)))])
  end

  if ( isempty(cracks) )
    disp(['no cracks in ' filename ])
    continue
  end

  if nargin < 5
    icracks = 0:max(cracks(:,2));
  end
  
  disp(['np = ' num2str(size(cracks,1))])
  
  for ic = icracks
    points = cracks( cracks(:,2)==ic, 4:5 );
    if doCracks
      line( points(:,1) , points(:,2) , 'linewidth',lw ,  'color', ...
            colors(icol,:) , 'tag','crack' ) 
%       line( points(:,1) , points(:,2) , 'color','r', 'linestyle','none',...
%             'marker','*' , 'tag','crack' )
    end
    if doLabels
      if size(points,1)>1
        labelP = ( points(1,:) + points(2,:) ) / 2;
      else
        labelP = points(1,:);
      end
      text( labelP(1,1) , labelP(1,2) , num2str(ic) , 'color', ...
          colors(icol,:) , 'tag','crack' , 'fontsize',12 )
    end
      
  end

end

disp('Done.')
