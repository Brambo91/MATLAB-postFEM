function labelLodi(lodi,its);

% add labels to load-displacement plot. Args: its, lodi
% indicating the specified time step numbers 

global prepend

% if no load displacement data specified:
%  first try to get from base
%  if not found, call cleanLodi

if ( nargin < 1 || isempty(lodi) )
  try
    if isempty(prepend)
      lodi = evalin('base','lodi');
    else
      lodi = evalin('base',prepend);
    end
    setAxes lodi;
  catch
    cleanLodi
  end
end

nt = length(lodi);
% i3 = size(lodi,2);
% i2 = i3-1;

% default: all time steps
if nargin < 2 || isempty(its)
  its = 1:nt;
else
  its = its+1; % correct for added zeros
end


for it = its
  if it <= nt
    text(lodi(it,2),lodi(it,3),num2str(it-1)); % correct for added zeros
  end
end

nots = find(its>nt);

if any(nots)
  its = its-1; % undo correct for added zeros
  disp('Time steps ')
  disp(num2str( its( nots ) ))
  disp('do not exist!')
end

