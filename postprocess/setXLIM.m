function setXLIM ( limits )
% set global XLIM for postintf and px

global XLIM;

if ( nargin < 1 )
  disp('XLIM emtpied')
  XLIM = '';
else
  if (length(limits)~=2)
    err(['invalid input for setXLIM' num2str(limits)])
  else
    XLIM = limits;
    xlim(XLIM);
  end
end

