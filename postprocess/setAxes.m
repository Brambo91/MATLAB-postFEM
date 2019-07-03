function done = setAxes( tag )

% set tag axes. Arg: tag

persistent dont

% don't set axes next time this function is called

if ( strcmp(tag,'dont') )
  dont = 1;
  done = 0;
  return;
end

% `dont' has been set before this function was called

if dont
  dont = 0;
  done = 0;
  return;
end

tagged = findobj('tag',tag);
if isempty(tagged)
  done = 0;
elseif strcmp( get(gca,'tag'), tag );
  done = 1;
else
  axes(tagged(1));
  done = 2;
end


