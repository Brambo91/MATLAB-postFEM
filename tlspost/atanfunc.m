function out = atanfunc(c1,c3,xs)

if nargin < 3
  xs = 0.:.01:1;
end

c2 = 1./( atan(c1*(1-c3))-atan(-c1*c3) );
c4 = -c2*atan(-c1*c3);

fs = c2*atan(c1*(xs-c3))+c4;

plot(xs,fs);

if nargout > 0
  out = fs;
end
