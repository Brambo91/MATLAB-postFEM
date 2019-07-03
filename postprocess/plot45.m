function ret = plot45(mat,varargin)
% plot45(mat) does plot(mat(:,4),mat(:,5),varargin) and returns handle

oldHold = ishold;

if ( ~oldHold )
  hold on
end
  

if nargin < 1
  error('argument required!')
else
  if ( size(mat,2) < 5 )
    error('cannot plot this matrix')
  end  
end

if nargin < 2 
  h = plot(mat(:,4),mat(:,5),'r');
else
  h = plot(mat(:,4),mat(:,5),varargin{:});
end

if ( ~oldHold )
  hold off
end  

if nargout > 0
  ret = h;
end
