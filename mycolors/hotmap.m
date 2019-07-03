function hotmap(ntotal)
% inverted hot colormap with darkest part removed. Arg: ntotal

if nargin < 1
  ntotal = 82
end

ntotal = max([ntotal,64]);

disp(ntotal)
colormap(hot(ntotal))
Cm=colormap;
for i=1:64
  Cmi(i,:)=Cm(ntotal+1-i,:);
end
colormap(Cmi);

