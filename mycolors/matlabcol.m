function rgb = matlabcol(i)

if ( nargin < 1 )
  i = 1;
end

co = get(gcf,'defaultaxescolororder');

ncol = size(co,1);
icol = mod(i-1,ncol)+1;

rgb = co(icol,:);
