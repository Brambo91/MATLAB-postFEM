function setZLIM ( limits )
% set global ZLIM for postintf and px

global ZLIM;

if ( nargin < 1 )
  disp('ZLIM emtpied')
  ZLIM = '';
else
  if (length(limits)~=2)
    err(['invalid input for setZLIM' num2str(limits)])
  else
    ZLIM = limits;
    zlim(ZLIM);
  end
end

