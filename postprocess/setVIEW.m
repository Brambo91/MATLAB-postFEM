function setVIEW ( limits )
% set global VIEW for postintf and px

global VIEW;

if ( nargin < 1|| isempty(limits) )
  disp('VIEW emtpied')
  VIEW = '';
else
  if (length(limits)~=2)
    error('invalid input for setVIEW')
  else
    VIEW = limits;
    view(VIEW);
  end
end

