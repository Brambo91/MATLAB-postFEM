function ret = plot13(mat,varargin)
% plot12(mat) does plot(mat(:,1),mat(:,3),varargin) and returns handle

oldHold = ishold;

if ( ~oldHold )
  hold on
end
  

if nargin < 1
  error('argument required!')
else
  if ( size(mat,2) < 3 )
    error('cannot plot this matrix')
  end  
end

if nargin < 2 
  h = plot(mat(:,1),mat(:,3));
else
  plot(mat(:,1),mat(:,3),varargin{:})
end

if ( ~oldHold )
  hold off
end  

if nargout > 1
  ret = h;
end
