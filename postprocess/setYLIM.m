function setYLIM ( limits )
% set global YLIM for postintf and px

global YLIM;

if ( nargin < 1 )
  disp('YLIM emtpied')
  YLIM = '';
else
  if (length(limits)~=2)
    err(['invalid input for setYLIM' num2str(limits)])
  else
    YLIM = limits;
    ylim(YLIM);
  end
end

