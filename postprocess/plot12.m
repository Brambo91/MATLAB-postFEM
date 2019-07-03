function ret = plot12(mat,varargin)
% plot12(mat) does plot(mat(:,1),mat(:,2),varargin) and returns handle

oldHold = ishold;

if ( ~oldHold )
  hold on
end
  

if nargin < 1
  error('argument required!')
else
  if ( size(mat,2) < 2 )
    error('cannot plot this matrix')
  end  
end

if nargin < 2 
  h = plot(mat(:,1),mat(:,2));
else
  h = plot(mat(:,1),mat(:,2),varargin{:});
end

if ( ~oldHold )
  hold off
end  

if nargout > 0
  ret = h;
end
